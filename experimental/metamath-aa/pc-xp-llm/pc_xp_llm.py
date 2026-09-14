#!/usr/bin/env python3
"""
pc_xp_llm.py  -  LLM sub-theory predictor bridge for pc-xp-llm.metta
================================================================

Given a GOALtheorem, predict a SMALL relevant sub-theory (a set of axiom/lemma labels) so
the backward chainer searches only within it instead of the whole knowledge
base. Over-prediction is fine (recall >> precision): a few extra labels only
slightly enlarge a still-small space, but a missing label makes the proof
unfindable -- so the MeTTa side always falls back to the hot/full KB on a miss.

The MeTTa side talks to this module through three functions exposed on
`builtins`:

    _registerLabel(label, type_str)   # called from add-to-kbs for every label
    _predictTheory(goal_str, model, timeout) -> int   # predicts & caches a set
    _inPredicted(label) -> 1 | 0       # membership test used to build the bases

Backends (pick with the model arg or the LLM_BACKEND env var):
    "claude"/"anthropic"     -> Anthropic Messages API   (needs ANTHROPIC_API_KEY)
    "minimax"/"snet"         -> SingularityNet gateway    (minimax/minimax-m3,
                                OpenAI-compatible; SNET_API_KEY / SNET_MODEL /
                                SNET_BASE_URL)
    "gemini"/"google"        -> Google Gemini             (needs GEMINI_API_KEY;
                                GEMINI_MODEL, default gemini-2.5-flash)
    "openai"/"gpt"           -> OpenAI Chat Completions   (needs OPENAI_API_KEY)
    "ollama:<model>"         -> local Ollama              (no key)
The default is Anthropic; 
set LLM_BACKEND=ollama to stay fully local.
Only the Python standard library is required (urllib).
"""

import builtins
import difflib
import json
import os
import re
import subprocess
import sys

# --------------------------------------------------------------------------- #
# State: a mirror of the MeTTa knowledge base + the last predicted set
# --------------------------------------------------------------------------- #
_KB = {}                      # label -> type string (insertion order preserved)
_PREDICTED = set()            # labels predicted relevant for the current goal
_CORE_AXIOMS = ("ax-mp", "ax-1", "ax-2", "ax-3")


# --------------------------------------------------------------------------- #
# Training data: worked (goal theorem -> minimal label set) examples mined from
# obc-found proofs.  The lean file deliberately contains only LABEL, SMALLEST
# and THEOREM, so the prompt cannot leak the full available theory tuple or
# the literal proof term.
# Current default covers corpus iterations 6..183, 
# which includes the ~4.5h pm2.61iii proof at 182).
# Any LLM evaluation on theorems <= 183 is contaminated (answer in prompt);
# the clean out-of-training range starts at 184.
# --------------------------------------------------------------------------- #
_DEFAULT_TRAIN_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                                   "pc-xp-llm-trace-obc-log-to-183-lean.metta")
_TRAIN_FILE = os.environ.get("LLM_THEORY_TRAIN_FILE", _DEFAULT_TRAIN_FILE)
_TRAIN_EXAMPLES = []          # [(theorem_str, [smallest_labels...]), ...]


def _sexpr_tokenize(s):
    return re.findall(r'\(|\)|[^\s()]+', s)


def _sexpr_parse(tokens, pos):
    tok = tokens[pos]
    if tok == '(':
        lst = []
        pos += 1
        while tokens[pos] != ')':
            node, pos = _sexpr_parse(tokens, pos)
            lst.append(node)
        return lst, pos + 1
    return tok, pos + 1


def _sexpr_serialize(node):
    if isinstance(node, list):
        return '(' + ' '.join(_sexpr_serialize(c) for c in node) + ')'
    return node


def _load_training_examples(path):
    examples = []
    try:
        text = open(path, encoding="utf-8").read()
    except OSError:
        return examples
    text = re.sub(r';.*', '', text)          # strip ;; comments before parsing
    toks = _sexpr_tokenize(text)
    pos = 0
    while pos < len(toks):
        node, pos = _sexpr_parse(toks, pos)
        if isinstance(node, list) and node[:1] == ["TraceSmallest"]:
            # Preferred lean format:
            #   (TraceSmallest LABEL SMALLEST THEOREM)
            # Legacy format, kept readable for compatibility:
            #   (TraceSmallest LABEL THEORY SMALLEST PROOF THEOREM)
            if len(node) == 4:
                _label, smallest, theorem = node[1:4]
            elif len(node) == 6:
                _label, _theory, smallest, _proof, theorem = node[1:6]
            else:
                continue
            examples.append((_sexpr_serialize(theorem), smallest))
    return examples


_TRAIN_EXAMPLES = _load_training_examples(_TRAIN_FILE)

# Cap how many label:type lines we put in the prompt. The most-recently-added
# labels are the most likely to be relevant; older ones are still listed by
# name so the model knows they exist.
MAX_TYPED_LINES = int(os.environ.get("LLM_THEORY_MAX_TYPED", "400"))


def _clean_atom(s):
    """MeTTa passes atom reprs; strip surrounding quotes/whitespace."""
    if s is None:
        return ""
    s = str(s).strip()
    if len(s) >= 2 and s[0] == '"' and s[-1] == '"':
        s = s[1:-1]
    return s.strip()


# --------------------------------------------------------------------------- #
# Called from MeTTa: register every label as it enters the KB
# --------------------------------------------------------------------------- #
def _registerLabel(label, type_str):
    lab = _clean_atom(label)
    if lab:
        _KB[lab] = _clean_atom(type_str)
    return 1


# --------------------------------------------------------------------------- #
# Prompt construction
# --------------------------------------------------------------------------- #
SYSTEM = (
    "You prune the search space for an automated theorem prover working in a "
    "Hilbert-style propositional calculus. Given a GOAL theorem and the list of "
    "AVAILABLE labels (axioms and previously proved lemmas, with their types), "
    "predict the SUBSET of labels whose proofs are likely needed to prove the "
    "goal.\n"
    "A label is needed only if it (or an application of it) appears DIRECTLY in "
    "the goal's proof term -- you do NOT need a lemma's own internal "
    "dependencies, since the prover treats every label as an already-proved "
    "fact it can apply as-is without re-deriving it. The WORKED EXAMPLES below "
    "are real (goal -> minimal label set) pairs mined from verified proofs "
    "earlier in this same theory: use them to learn this pattern and to gauge "
    "which kinds of lemmas tend to combine for similar goal shapes. Do not "
    "assume their set sizes bound the answer -- those examples happen to be "
    "from simpler, earlier goals; a goal with more/deeper connectives may "
    "legitimately need a larger or different set of directly-applied labels.\n"
    "RECALL MATTERS MORE THAN PRECISION: the proof is searched ONLY within your "
    "set, so when unsure, INCLUDE a label. Missing one needed label makes the "
    "proof unfindable; a few extra labels only slightly enlarge a still-small "
    "space.\n"
    "Prefer lemmas whose conclusion shape matches the goal's connectives and "
    "structure. The core axioms ax-mp, ax-1, ax-2, ax-3 are needed by almost "
    "everything and are added automatically.\n"
    "COPY LABEL NAMES VERBATIM: every name you output must be an EXACT, "
    "character-for-character copy of a name from the AVAILABLE LABELS list -- "
    "same spelling, same case, same digits, same suffixes and punctuation. "
    "These names are opaque identifiers, NOT descriptions: do not 'correct', "
    "abbreviate, expand, re-case, pluralize, or otherwise normalize them, and "
    "do not assume any name contains a typo. Related lemmas often differ only "
    "by a trailing character (e.g. pm2.61, pm2.61i, pm2.61ii, pm2.61d1 are "
    "FOUR DIFFERENT labels) -- pick the exact one you mean and never emit a "
    "shortened stem like 'pm2.61' hoping it matches. If you are not certain a "
    "label exists verbatim in the list, either find the exact one there or "
    "omit it; never invent a plausible-looking name.\n"
    "OUTPUT: only the label names, separated by spaces. No types, no prose, no "
    "punctuation, no code fences."
)


def _build_examples_block():
    if not _TRAIN_EXAMPLES:
        return []
    lines = ["WORKED EXAMPLES (verified goal -> minimal label set):"]
    for theorem, smallest in _TRAIN_EXAMPLES:
        lines.append(f"GOAL: {theorem}")
        lines.append(f"LABELS: {' '.join(smallest)}")
    lines.append("")
    return lines


def _build_prompt_parts(goal, size=0):
    """Return (static_prefix, dynamic_suffix) for the prediction prompt.

    The static prefix (the worked-examples block) is byte-identical for the
    whole run, so the anthropic backend marks it as a prompt-cache breakpoint
    (~0.1x input price on every call after the first).  Everything that varies
    per call -- the growing AVAILABLE LABELS list, the GOAL, the BUDGET --
    lives in the dynamic suffix, placed AFTER the cache breakpoint so it never
    invalidates the cached prefix.  Other backends just concatenate the two.
    """
    static_prefix = "\n".join(_build_examples_block())

    items = list(_KB.items())
    # newest labels are the most informative; show their types, then list the
    # rest by name only to bound prompt size.
    typed = items[-MAX_TYPED_LINES:]
    typed_names = {l for l, _ in typed}
    older = [l for l, _ in items if l not in typed_names]

    parts = []
    if older:
        parts.append("AVAILABLE LABELS (names only):")
        parts.append(" ".join(older))
        parts.append("")
    parts.append("AVAILABLE LABELS (label : type):")
    for lab, typ in typed:
        parts.append(f"{lab} : {typ}")
    parts.append("")
    parts.append("GOAL:")
    parts.append(goal)
    parts.append("")
    # Budget hint: the number of DIRECTLY-APPLIED labels in a proof is bounded
    # by the proof's term size, so the goal's proof size is a safe upper bound
    # on how many labels to name.  We ask the model to fill that budget (recall
    # matters more than precision), which counters chronic under-prediction.
    if size and size > 0:
        parts.append(
            f"BUDGET: this goal's proof has size about {size}; a proof of that "
            f"size uses AT MOST {size} directly-applied labels (usually fewer, "
            f"and often with repeats). Name up to {size} labels -- when in "
            f"doubt include a plausible label rather than omit it, since the "
            f"proof is searched ONLY within your set. Do not pad with clearly "
            f"irrelevant labels, but do not stop at 3-4 if more could apply.")
        parts.append("")
    parts.append("Labels likely needed (space-separated):")
    return static_prefix, "\n".join(parts)


def _build_prompt(goal, size=0):
    """Full prompt as one string (for backends without prompt caching)."""
    static_prefix, dynamic = _build_prompt_parts(goal, size)
    return (static_prefix + "\n" + dynamic) if static_prefix else dynamic


# --------------------------------------------------------------------------- #
# Backends
# --------------------------------------------------------------------------- #
def _http_json(url, payload, headers, timeout):
    # Shell out to curl rather than using urllib: blocking socket I/O done
    # in-process via urllib has been observed to crash SWI-Prolog's embedded
    # CPython (janus) after a number of py-call round-trips. A subprocess
    # keeps the network I/O entirely outside the embedded interpreter.
    args = ["curl", "-s", "--max-time", str(timeout), "-X", "POST"]
    for k, v in headers.items():
        args += ["-H", f"{k}: {v}"]
    args += ["-d", "@-", url]
    proc = subprocess.run(args, input=json.dumps(payload).encode("utf-8"),
                           stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                           timeout=timeout + 5)
    if proc.returncode != 0:
        raise RuntimeError(f"curl failed (rc={proc.returncode}): "
                            f"{proc.stderr.decode('utf-8', 'replace').strip()}")
    return json.loads(proc.stdout.decode("utf-8"))


# --- SingularityNet LLM gateway (OpenAI-compatible) -> minimax-m3 ----------- #
# The gateway speaks the OpenAI Chat Completions API, so we reuse the same
# request/response shape as OpenAI.  All three are env-overridable; the
# defaults let it run out of the box.
SNET_BASE_URL = os.environ.get(
    "SNET_BASE_URL", "https://llm.c.singularitynet.io/v1/chat/completions")
SNET_API_KEY = os.environ.get(
    "SNET_API_KEY", "sk-key")
SNET_MODEL = os.environ.get("SNET_MODEL", "minimax/minimax-m3")


# Prompt-cache TTL for the anthropic backend: "1h" (default), "5m", or "off".
# The SYSTEM text + worked-examples block are identical on every call of a run
# (and across re-runs of the experiment), so they are sent as system content
# blocks with a cache_control breakpoint on the last one: the first call pays
# the cache write (2x for 1h TTL, 1.25x for 5m), every later call reads it at
# ~0.1x input price.  1h (no beta header required) also survives the gaps
# between LLM calls (slow full-KB searches) and back-to-back experiment runs.
# The per-call parts (labels list, goal, budget) go in the user message, after
# the breakpoint, so they never invalidate the cached prefix.
ANTHROPIC_CACHE_TTL = os.environ.get("ANTHROPIC_CACHE_TTL", "1h")


# Reasoning capture: on claude-fable-5 the raw chain of thought is never
# returned by the API, but `thinking: {display: "summarized"}` returns a
# readable SUMMARY of the model's reasoning as `thinking` content blocks.
# _call_anthropic stashes it here; _predictTheory appends it (plus the goal,
# prediction and raw answer) to LLM_REASONING_LOG after every call.
# Note: thinking happens and is billed the same whether or not we ask for
# the summary -- display only controls visibility.
_LAST_THINKING = ""


def _call_anthropic(system, static_prefix, dynamic, timeout):
    global _LAST_THINKING
    key = os.environ["ANTHROPIC_API_KEY"]
    model = os.environ.get("ANTHROPIC_MODEL", "claude-fable-5")
    sys_blocks = [{"type": "text", "text": system}]
    if static_prefix:
        block = {"type": "text", "text": static_prefix}
        if ANTHROPIC_CACHE_TTL != "off":
            cc = {"type": "ephemeral"}
            if ANTHROPIC_CACHE_TTL == "1h":
                cc["ttl"] = "1h"
            block["cache_control"] = cc
        sys_blocks.append(block)
    out = _http_json(
        "https://api.anthropic.com/v1/messages",
        # max_tokens raised from 512: it caps thinking + answer together,
        # and asking for the summarized reasoning needs the extra headroom.
        {"model": model, "max_tokens": 4096,
         "thinking": {"type": "adaptive", "display": "summarized"},
         "system": sys_blocks,
         "messages": [{"role": "user", "content": dynamic}]},
        {"content-type": "application/json", "x-api-key": key,
         "anthropic-version": "2023-06-01"},
        timeout)
    usage = out.get("usage") or {}
    wrote = usage.get("cache_creation_input_tokens") or 0
    read = usage.get("cache_read_input_tokens") or 0
    if wrote or read:
        sys.stderr.write(
            f"[llm-theory] prompt cache: wrote {wrote}, read {read} tokens\n")
        sys.stderr.flush()
    content = out.get("content") or []
    _LAST_THINKING = "\n".join(
        b.get("thinking", "") for b in content
        if b.get("type") == "thinking" and b.get("thinking"))
    return "".join(b.get("text", "") for b in content if b.get("type") == "text")


def _call_openai_compat(url, key, model, system, prompt, timeout):
    """Call any OpenAI Chat Completions-compatible endpoint (OpenAI itself,
    the SingularityNet gateway, vLLM, LM Studio, etc.)."""
    out = _http_json(
        url,
        {"model": model, "max_tokens": 512,
         "messages": [{"role": "system", "content": system},
                      {"role": "user", "content": prompt}]},
        {"content-type": "application/json",
         "authorization": f"Bearer {key}"},
        timeout)
    return out["choices"][0]["message"]["content"]


def _call_openai(system, prompt, timeout):
    key = os.environ["OPENAI_API_KEY"]
    model = os.environ.get("OPENAI_MODEL", "gpt-4o")
    return _call_openai_compat("https://api.openai.com/v1/chat/completions",
                               key, model, system, prompt, timeout)


def _call_minimax(system, prompt, timeout):
    return _call_openai_compat(SNET_BASE_URL, SNET_API_KEY, SNET_MODEL,
                               system, prompt, timeout)


# --- Google Gemini (OpenAI-compatible endpoint) ------------------------------ #
# Uses Gemini's OpenAI-compatibility layer, so the request/response shape is
# the same as OpenAI.
GEMINI_BASE_URL = os.environ.get(
    "GEMINI_BASE_URL",
    "https://generativelanguage.googleapis.com/v1beta/openai/chat/completions")
GEMINI_MODEL = os.environ.get("GEMINI_MODEL", "gemini-2.5-flash")


def _call_gemini(system, prompt, timeout):
    key = os.environ["GEMINI_API_KEY"]
    return _call_openai_compat(GEMINI_BASE_URL, key, GEMINI_MODEL,
                               system, prompt, timeout)


def _call_ollama(model_name, system, prompt, timeout):
    url = os.environ.get("OLLAMA_URL", "http://localhost:11434/api/generate")
    out = _http_json(
        url,
        {"model": model_name, "system": system, "prompt": prompt,
         "stream": False, "keep_alive": "10m",
         "options": {"temperature": 0.0, "num_predict": 256}},
        {"content-type": "application/json"},
        timeout)
    return out.get("response", "")


def _dispatch(model, system, prompt, timeout):
    # `prompt` is either a plain string or a (static_prefix, dynamic) tuple
    # from _build_prompt_parts.  Only the anthropic backend uses the split
    # (for prompt caching); every other backend gets the joined string.
    if isinstance(prompt, tuple):
        static_prefix, dynamic = prompt
    else:
        static_prefix, dynamic = "", prompt
    joined = (static_prefix + "\n" + dynamic) if static_prefix else dynamic
    backend = (model or os.environ.get("LLM_BACKEND") or "claude").strip()
    low = backend.lower()
    prompt = joined
    if low.startswith("ollama:"):
        return _call_ollama(backend.split(":", 1)[1], system, prompt, timeout)
    if low in ("claude", "anthropic"):
        return _call_anthropic(system, static_prefix, dynamic, timeout)
    if low in ("minimax", "minimax-m3", "singularitynet", "snet"):
        return _call_minimax(system, prompt, timeout)
    if low in ("gemini", "google"):
        return _call_gemini(system, prompt, timeout)
    if low in ("openai", "gpt"):
        return _call_openai(system, prompt, timeout)
    if low == "ollama":
        return _call_ollama(os.environ.get("OLLAMA_MODEL", "llama3.1:8b"),
                            system, prompt, timeout)
    # unknown -> treat as an ollama model name
    return _call_ollama(backend, system, prompt, timeout)


# --------------------------------------------------------------------------- #
# Parse + filter the model's answer into a valid label set
# --------------------------------------------------------------------------- #
def _parse_labels(text):
    if not text:
        return []
    text = re.sub(r"```[a-zA-Z]*", " ", text).replace("```", " ")
    # tokens are label-like: letters, digits, and the punctuation used in labels
    toks = re.findall(r"[A-Za-z0-9_.\-]+", text)
    return toks


# Minimum token length before we attempt fuzzy matching -- 1-char tokens carry
# too little signal and match too many labels.
_FUZZY_MIN_LEN = 2
# difflib similarity floor for accepting a near-miss match.
_FUZZY_CUTOFF = 0.85


def _fuzzy_match(token, kb_labels, kb_lower):
    """Map an unknown token to the single most plausible real KB label, or
    None.  Conservative and deterministic: tries, in order,
      1. case-insensitive exact match,
      2. a UNIQUE prefix relationship (token is a prefix of exactly one label,
         or exactly one label is a prefix of the token),
      3. a clearly-best close edit-distance match (>= _FUZZY_CUTOFF, and, when
         there is a runner-up, meaningfully better than it).
    Ambiguous cases return None so we never silently inject the wrong lemma."""
    if len(token) < _FUZZY_MIN_LEN:
        return None
    # 1. case-insensitive exact
    hit = kb_lower.get(token.lower())
    if hit is not None:
        return hit
    # 2. unique prefix relationship
    pref = [l for l in kb_labels
            if l.startswith(token) or token.startswith(l)]
    if len(pref) == 1:
        return pref[0]
    # 3. closest by similarity, but only if there is a clear winner
    close = difflib.get_close_matches(token, kb_labels, n=2, cutoff=_FUZZY_CUTOFF)
    if len(close) == 1:
        return close[0]
    if len(close) >= 2:
        r0 = difflib.SequenceMatcher(None, token, close[0]).ratio()
        r1 = difflib.SequenceMatcher(None, token, close[1]).ratio()
        if r0 - r1 >= 0.08:
            return close[0]
    return None


def _resolve(tokens):
    """Turn the model's tokens into a valid label set.

    Exact KB labels are kept as-is; each unknown token is fuzzy-matched to a
    near-by real label (misspellings / hallucinated variants); the core axioms
    are always appended.  Returns (labels, remaps) where remaps is a list of
    (original_token, matched_label) pairs, for logging."""
    kb_labels = list(_KB.keys())
    kb_lower = {}
    for l in kb_labels:
        kb_lower.setdefault(l.lower(), l)   # first (oldest) label wins on clash
    keep = []
    seen = set()
    remaps = []
    for t in tokens:
        if t in _KB:
            lab = t
        else:
            lab = _fuzzy_match(t, kb_labels, kb_lower)
            if lab is None:
                continue
            remaps.append((t, lab))
        if lab not in seen:
            keep.append(lab)
            seen.add(lab)
    for ax in _CORE_AXIOMS:
        if ax in _KB and ax not in seen:
            keep.append(ax)
            seen.add(ax)
    return keep, remaps


# --------------------------------------------------------------------------- #
# Per-call reasoning log: one appended entry per LLM invocation, containing
# the goal, the model's summarized reasoning (claude backend only), its raw
# answer, and the final resolved prediction.  Kept in its own file because
# stderr is not captured in pc-xp-llm.log.
# --------------------------------------------------------------------------- #
REASONING_LOG = os.environ.get("LLM_REASONING_LOG", "pc-xp-llm-reasoning.log")


def _log_reasoning(label, goal, size, model, raw, labels, error=None):
    try:
        import datetime
        with open(REASONING_LOG, "a", encoding="utf-8") as f:
            f.write("=" * 70 + "\n")
            f.write(f"[{datetime.datetime.now().isoformat(timespec='seconds')}] "
                    f"theorem: {label or '?'}   (model {model}, budget {size})\n")
            f.write(f"GOAL: {goal}\n")
            if error is not None:
                f.write(f"CALL FAILED: {error}\n\n")
                return
            if _LAST_THINKING:
                f.write("--- reasoning (summarized by the API) ---\n")
                f.write(_LAST_THINKING.strip() + "\n")
            else:
                f.write("--- reasoning: (none returned; non-claude backend "
                        "or empty summary) ---\n")
            f.write("--- raw answer ---\n")
            f.write(raw.strip() + "\n")
            f.write(f"--- resolved prediction ({len(labels)}) ---\n")
            f.write(" ".join(labels) + "\n\n")
    except Exception:
        pass                                  # logging must never break prediction


# --------------------------------------------------------------------------- #
# Called from MeTTa: predict + cache the set for one goal
# --------------------------------------------------------------------------- #
def _predictTheory(goal, model="claude", timeout=60, size=0, label=""):
    global _PREDICTED, _LAST_THINKING
    goal = _clean_atom(goal)
    model = _clean_atom(model)
    label = _clean_atom(label)
    _LAST_THINKING = ""
    try:
        timeout = float(timeout)
    except Exception:
        timeout = 60.0
    try:
        size = int(float(_clean_atom(size))) if size not in (None, "") else 0
    except Exception:
        size = 0
    try:
        raw = _dispatch(model, SYSTEM, _build_prompt_parts(goal, size), timeout)
        tokens = _parse_labels(raw)
        labels, remaps = _resolve(tokens)
        # Tokens the model named that neither matched a KB label exactly nor
        # fuzzy-matched one are dropped.  When everything drops the prediction
        # collapses to the 4 core axioms (looks like a tiny/failed prediction
        # even though the API call succeeded).  Common cause: names too far off
        # to safely map.
        remapped = {o for o, _ in remaps}
        dropped = [t for t in tokens if t not in _KB and t not in remapped]
        if not labels:                       # empty answer -> at least core
            labels = [a for a in _CORE_AXIOMS if a in _KB]
        _PREDICTED = set(labels)
        non_core = _PREDICTED - set(_CORE_AXIOMS)
        sys.stderr.write(
            f"[llm-theory] goal predicted {len(_PREDICTED)} / {len(_KB)} labels "
            f"(budget {size}, {len(non_core)} non-core)\n")
        if remaps:
            sys.stderr.write(
                "[llm-theory] fuzzy-matched " + ", ".join(
                    f"{o}->{m}" for o, m in remaps[:20]) + "\n")
        if dropped:
            sys.stderr.write(
                f"[llm-theory] dropped {len(dropped)} unknown token(s): "
                f"{' '.join(dropped[:20])}\n")
        if not non_core:
            sys.stderr.write(
                f"[llm-theory] WARNING: no KB labels matched; obc will search "
                f"core axioms only. raw answer: {raw.strip()[:200]!r}\n")
        sys.stderr.flush()
        _log_reasoning(label, goal, size, model, raw, labels)
    except Exception as e:                   # any failure -> core only, MeTTa falls back
        _PREDICTED = {a for a in _CORE_AXIOMS if a in _KB}
        sys.stderr.write(f"[llm-theory] prediction failed ({e}); using core axioms\n")
        sys.stderr.flush()
        _log_reasoning(label, goal, size, model, "", [], error=e)
    return len(_PREDICTED)


def _inPredicted(label):
    return 1 if _clean_atom(label) in _PREDICTED else 0


# expose on builtins so MeTTa's (py-call (builtins._...)) can reach them
builtins._registerLabel = _registerLabel
builtins._predictTheory = _predictTheory
builtins._inPredicted = _inPredicted
