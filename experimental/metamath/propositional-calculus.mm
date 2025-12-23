$( This is the Metamath database set.mm. $)

$( Metamath is a formal language and associated computer program for
   archiving, verifying, and studying mathematical proofs, created by Norman
   Dwight Megill (1950--2021).  For more information, visit
   https://us.metamath.org and
   https://github.com/metamath/set.mm, and feel free to ask questions at
   https://groups.google.com/g/metamath. $)

$( New users may want to read https://us.metamath.org/mpeuni/conventions.html
   to understand the label naming conventions used in set.mm.  See also the
   Metamath program command "MM> HELP VERIFY MARKUP" for markup conventions. $)

$( To break this file into smaller modules, in the Metamath program type
   "MM> READ set.mm" followed by "MM> WRITE SOURCE set.mm / SPLIT".  To
   recombine, omit "/ SPLIT". $)

$( The database set.mm was created by Norman Megill on 30-Sep-1992 and has
   been continuously enriched since then (list of contributors below). $)


$( !
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#
  Metamath source file for logic and set theory
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#

                           ~~ PUBLIC DOMAIN ~~
This work is waived of all rights, including copyright, according to the CC0
Public Domain Dedication.  https://creativecommons.org/publicdomain/zero/1.0/

Currently active maintainers: See the list in the CONTRIBUTING.md file of
https://github.com/metamath/set.mm.

Contributor list:

DA  David Abernethy
SA  Stefan Allan
TA  Thierry Arnoux
JA  Juha Arpiainen
JB  Jonathan Ben-Naim
GB  Gregory Bush
MC  Mario Carneiro
FC  Filip Cernatescu
PC  Paul Chapman
DF  Drahflow
AD  Adrian Ducourtial
GD  Georgy Dunaev
SF  Scott Fenton
GG  Gino Giotto
JGH Jeff Hankins
AH  Anthony Hart
DH  David Harvey
CH  Chen-Pang He
JH  Jeff Hoffman
II  Igor Ieskov
AI  Asger C. Ipsen
JJ  Jerry James
SJ  Szymon Jaroszewicz
BJ  Benoit Jubin
JK  Jim Kingdon
ML  M L
WL  Wolf Lammen
GL  Gerard Lang
BL  Brendan Leahy
LL  Larry Lesyna
RL  Raph Levien
FL  Frederic Line
RFL Roy F. Longton
JPM Jeffrey P. Machado
JM  Jeff Madsen
GM  Giovanni Mascellani
PM  Peter Mazsa
RM  Rodolfo Medina
NM  Norman Megill
MKU metakunt
DM  David Moews
MM  Mykola Mostovenko
SN  Steven Nguyen
MO  Mel L. O'Cat
OAI OpenAI
SO  Stefan O'Rear
JO  Jason Orendorff
KP  K P
NP  Noam Pasman
JPP Jon Pennant
RP  Richard Penner
SP  Stanislas Polu
JP  Josh Purinton
RMI Remi
RR  Rohan Ridenour
SR  Steve Rodriguez
ATS Andrew Salmon
AS  Alan Sare
ES  Eric Schmidt
GS  Glauco Siliprandi
SS  Saveliy Skresanov
BT  BTernaryTau
ET  Ender Ting
JU  Jarvin Udandy
ADH Stijn "Adhemar" Vandamme
AV  Alexander van der Vekens
JV  Jannik Vierling
ZW  Zhi Wang
EW  Emmett Weisz
DAW David A. Wheeler
RW  Roger Witte
KW  Kyle Wyonch
JY  Jonathan Yan
FZ  Fan Zheng
KZ  Kunhao Zheng

HTML code for accented names:
  BJ Beno&icirc;t Jubin
  GL G&eacute;rard Lang
  FL Fr&eacute;d&eacute;ric Lin&eacute;

$)


$( See "MM> HELP VERIFY MARKUP" for help with modularization tags. $)
$( Begin $[ set-header.mm $] $)
$( !
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Contents of this header
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

* Quick "How To"
* Bibliography
* Metamath syntax summary
* Other notes


=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Quick "How To"
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

How to use this file under Windows 95/98/NT/2K/XP/Vista/7/10:

1. Download the Metamath program metamath.exe following the instructions on the
   Metamath home page (https://us.metamath.org) and put it in the same
   directory as this file.
2. In Windows Explorer, double-click on metamath.exe.
3. Type "read set.mm" and press Enter.
4. Type "help" for a list of help topics, and "help demo" for some
   command examples.


=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Bibliography
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

Bibliographical references are made by bracketing an identifier in a theorem's
comment, such as [RussellWhitehead].  These refer to HTML tags on the following
web pages:

  Logic and set theory - see https://us.metamath.org/mpeuni/mmset.html#bib
  Hilbert space - see https://us.metamath.org/mpeuni/mmhil.html#ref

A bracketed reference must be preceded by a theorem number, etc. and followed
by a page number.  See "MM> HELP WRITE BIBLIOGRAPHY" for details.


=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Metamath syntax summary
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

The HELP LANGUAGE command in the Metamath program will give you a quick
overview of Metamath.  The specification is found on pp. 111--114 of the
Metamath book.  The following syntax summary is provided for convenience
but may omit some details.

A Metamath database (set of one or more ASCII source files) is a sequence of
_tokens_, which are normally separated by spaces or line breaks.  The only
tokens that are built into the Metamath language are those (two-character
sequences) beginning with $, shown in the following. These tokens are called
_keywords_:

          $c ... $. - Constant declaration
          $v ... $. - Variable declaration
          $d ... $. - Disjoint (distinct) variable restriction
  <label> $f ... $. - "Floating" hypothesis (i.e. variable type declaration)
  <label> $e ... $. - "Essential" hypothesis (i.e. a logical assumption for a
                      theorem or axiom)
  <label> $a ... $. - Axiom or definition or syntax construction
  <label> $p ... $= ... $. - Theorem and its proof
          ${ ... $} - Block for defining the scope of the above statements
                      (except $a, $p which are forever active)
$)        $( ... $)
$(                  - Comments (may not be nested); see HELP LANGUAGE
                      for markup features.
          $[ ... $] - Include a file

The above two-character sequences beginning with "$" are the only primitives
built into the Metamath language.  The only "logic" Metamath uses in its proof
verification algorithm is the substitution of expressions for variables while
checking for distinct variable violations.  Everything else, including the
axioms for logic, is defined in this database file.

All other tokens are user-defined, and their names are arbitrary.  There are
two kinds of user-defined tokens, called math symbols (or just symbols) and
labels.  A _symbol_ may contain any non-whitespace printable character except
"$".  A _label_ may contain only alphanumeric characters and the characters "."
(period), "-" (hyphen), and "_" (underscore).  Symbols and labels are
case-sensitive.  All labels (except in proofs) must be distinct.  A label may
not have the same name as a symbol (to simplify the coding of certain parsers
and translators).

Here is some more detail about the syntax:

  $c <symbollist> $.
      <symbollist> is a (whitespace-separated) list of distinct symbols that
      haven't been used before.
  $v <symbollist> $.
      <symbollist> is a list of distinct symbols that haven't been used yet
      in the current scope (see ${ ... $} below).
  $d <symbollist> $.
      <symbollist> is a (whitespace-separated) list of distinct symbols
      previously declared with $v in current scope.  It means that
      substitutions into these symbols may not have variables in common.
  <label> $f <symbollist> $.
      <symbollist> is a list of 2 symbols, the first of which must be
      previously declared with $c in the current scope.
  <label> $e <symbollist> $.
      <symbollist> is a list of 2 or more symbols, the first of which must be
      previously declared with $c in the current scope.
  <label> $a <symbollist> $.
      <symbollist> is a list of 2 or more symbols, the first of which must be
      previously declared with $c in the current scope.
  <label> $p <symbollist> $= <proof> $.
      <symbollist> is a list of 2 or more symbols, the first of which must be
      previously declared with $c in the current scope.  <proof> is either a
      whitespace-delimited sequence of previous labels (created by
      SAVE PROOF <label> /NORMAL) or a compressed proof (created by
      SAVE PROOF <label> /COMPRESSED).  After using SAVE PROOF, use
      WRITE SOURCE to save the database file to disk.
  ${ ... $}
      Block for scoping the above statements (except $a, $p which are forever
      active).  Currently, $c may not occur inside of a block.
$)
  $( <any text> $)
$(    Comment.  Note: <any text> may not contain adjacent "$" and ")"
      characters.  The comment opening and closing delimiters must be
      surrounded by whitespace (space, tab, CR, LF, or FF).
  $[ <filename> $]
      Insert contents of <filename> at this point.  If <filename> is current
      file or has been already been inserted, it will not be inserted again.

Inside of comments, it is recommended that labels be preceded with a tilde (~)
and math symbol tokens be enclosed in grave accents, also known as backticks
(` `). These tildes, tokens, math symbols and backticks should be surrounded by
spaces.  This way the LaTeX and HTML rendition of comments will be accurate,
and tools to globally change labels and math symbols will also change them in
comments.  Note that inside of backticks a pair of backticks is interpreted as
a single backtick.  A special comment containing $ t (with no space after the
dollar sign) defines LaTeX and HTML symbols.  See HELP LANGUAGE and HELP HTML
for other markup features in comments.

The proofs in this file are in "compressed" format for storage efficiency.  The
Metamath program reads the compressed format directly.  This format is
described in Appendix B of the Metamath book.  It is not intended to be read by
humans.  For viewing proofs you should use the various SHOW PROOF commands
described in the Metamath book (or the online HELP).

The Metamath program does not normally affect any content of this file other
than proofs, i.e., the text between "$=" and "$." (and some rewrapping).  All
other content is user-created.  Proofs are created or modified with the PROVE
command.


=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Other notes
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

1.  It is recommended that you be familiar with Chapters 2 and 4 of the
Metamath book to understand the Metamath language.  Chapters 2, 3 and 5 explain
how to use the Metamath program.  Chapter 3 gives an informal overview of what
this source file is all about.  Appendix A gives the standard mathematical
symbols corresponding to some of the ASCII tokens used in this file.

The ASCII tokens may seem cryptic at first, even if you are familiar with set
theory, but a review of the definition summary in Chapter 3 should quickly
enable you to see the correspondence to standard mathematical notation.  To
easily find the definition of a token, search for the first occurrences of the
token surrounded by spaces.  Some odd-looking ones include "-." for "not", and
"C_" for "is a subset of".  The Metamath program "MM> HELP TEX" command
explains how to obtain a LaTeX output to see the real mathematical symbols.
Let us know if you have better suggestions for naming ASCII tokens.

2.  Theorems can be written in different forms, including "closed form",
"deduction form", and "inference form" (for details, see ~ conventions ).  For
basic theorems, all three forms are generally given, but for more advanced
theorems, we prefer to use the deduction form, since it permits to write proofs
in the "deduction style", and we do not add theorems in inference form unless
there are reasonable grounds for it (for instance, shortening sufficiently many
proofs to counterbalance their addition).

3.  On providing new definitions and theorems, the conventions provided in the
comment of ~ conventions should be obeyed.

4.  For a chronological list of changes to label names and label deletions, see
the changes-set.txt file.  This should help if you have a proof not checked
into the main repository and want to update it for recent changes.

$)

$( End $[ set-header.mm $] $)



$( The following header is the first to appear in the Theorem List contents,
   because higher-level headers suppress all previous same-level or
   lower-level headers in the same comment area between $a and $p statements.
   See "MM> HELP WRITE THEOREM_LIST" for information about headers. $)


$(
###############################################################################
  CLASSICAL FIRST-ORDER LOGIC WITH EQUALITY
###############################################################################

  Logic can be defined as the "study of the principles of correct reasoning"
  (Merrilee H. Salmon's 1991 "Informal Reasoning and Informal Logic" in
  _Informal Reasoning and Education_) or as "a formal system using symbolic
  techniques and mathematical methods to establish truth-values" (the Oxford
  English Dictionary).

  This section formally defines the logic system we will use.  In particular,
  it defines symbols for declaring truthful statements, along with rules for
  deriving truthful statements from other truthful statements.  The system
  defined here is classical first-order logic (often abbreviated as FOL) with
  equality and no terms (the most common logic system used by mathematicians).

  We begin with a few housekeeping items in pre-logic, and then introduce
  propositional calculus (both its axioms and important theorems that can be
  derived from them).  Propositional calculus deals with general truths about
  well-formed formulas (wffs) regardless of how they are constructed.  This is
  followed by proofs that other axiomatizations of classical propositional
  calculus can be derived from the axioms we have chosen to use.

  We then define predicate calculus, which adds additional symbols and rules
  useful for discussing objects (beyond simply true or false).  In particular,
  it introduces the symbols ` = ` ("equals"), ` e. ` ("is a member of"), and
  ` A. ` ("for all").  The first two are called "predicates".  A predicate
  specifies a true or false relationship between its two arguments.

$)


$(
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#
  Pre-logic
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#

  This section includes a few "housekeeping" mechanisms before we begin
  defining the basics of logic.

$)

  $( Declare the primitive constant symbols for propositional calculus. $)
  $c ( $.  $( Left parenthesis $)
  $c ) $.  $( Right parenthesis $)
  $c -> $.  $( Right arrow (read:  "implies") $)
  $c -. $.  $( Right handle (read:  "not") $)
  $c wff $.  $( Well-formed formula symbol (read:  "the following symbol
                sequence is a wff") $)
  $c |- $.  $( Turnstile (read:  "the following symbol sequence is provable" or
               "a proof exists for") $)

  $( Define the syntax and logical typecodes, and declare that our grammar is
     unambiguous (verifiable using the KLR parser, with compositing depth 5).
     (This $ j comment need not be read by verifiers, but is useful for parsers
     like mmj2.) $)
  $( $j
    syntax 'wff';
    syntax '|-' as 'wff';
    unambiguous 'klr 5';
  $)

  $( Declare the color of wff variables. $)
  $( $j
    varcolorcode "wff" as "0000FF";
    altvarcolorcode "wff" as "337DFF";
  $)

  $( Declare typographical constant symbols that are not directly used in the
     formalism but are useful to explain it in comments. $)

  $c & $.  $( Ampersand (read: "and"). $)
  $c => $.  $( Double right arrow (read: "implies"). $)

  $( wff variable sequence:  ph ps ch th ta et ze si rh mu la ka $)
  $( Introduce some variable names we will use to represent well-formed
     formulas (wff's). $)
  $v ph $.  $( Greek phi $)
  $v ps $.  $( Greek psi $)
  $v ch $.  $( Greek chi $)
  $v th $.  $( Greek theta $)
  $v ta $.  $( Greek tau $)
  $v et $.  $( Greek eta $)
  $v ze $.  $( Greek zeta $)
  $v si $.  $( Greek sigma $)
  $v rh $.  $( Greek rho $)
  $v mu $.  $( Greek mu $)
  $v la $.  $( Greek lambda $)
  $v ka $.  $( Greek kappa $)

  $( Specify some variables that we will use to represent wff's.
     The fact that a variable represents a wff is relevant only to a theorem
     referring to that variable, so we may use $f hypotheses.  The symbol
     ` wff ` specifies that the variable that follows it represents a wff. $)
  $( Let variable ` ph ` be a wff. $)
  wph $f wff ph $.
  $( Let variable ` ps ` be a wff. $)
  wps $f wff ps $.
  $( Let variable ` ch ` be a wff. $)
  wch $f wff ch $.
  $( Let variable ` th ` be a wff. $)
  wth $f wff th $.
  $( Let variable ` ta ` be a wff. $)
  wta $f wff ta $.
  $( Let variable ` et ` be a wff. $)
  wet $f wff et $.
  $( Let variable ` ze ` be a wff. $)
  wze $f wff ze $.
  $( Let variable ` si ` be a wff. $)
  wsi $f wff si $.
  $( Let variable ` rh ` be a wff. $)
  wrh $f wff rh $.
  $( Let variable ` mu ` be a wff. $)
  wmu $f wff mu $.
  $( Let variable ` la ` be a wff. $)
  wla $f wff la $.
  $( Let variable ` ka ` be a wff. $)
  wka $f wff ka $.


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Inferences for assisting proof development
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  The inference rules in this section will normally never appear in a completed
  proof.  They can be ignored if you are using this database to assist learning
  logic - please start with the statement ~ wn instead.

$)

  ${
    idi.1 $e |- ph $.
    $( (_Note_:  This inference rule and the next one, ~ a1ii , will normally
       never appear in a completed proof.  They can be ignored if you are using
       this database to assist learning logic; please start with the statement
       ~ wn instead.)

       This inference says "if ` ph ` is true then ` ph ` is true".  This
       inference requires no axioms for its proof, and is useful as a
       copy-paste mechanism during proof development in mmj2.  It is normally
       not referenced in the final version of a proof, since it is always
       redundant.  You can remove this using the metamath-exe (Metamath
       program) Proof Assistant using the "MM-PA> MINIMIZE__WITH *" command.
       This is the inference associated with ~ id , hence its name.
       (Contributed by Alan Sare, 31-Dec-2011.)
       (Proof modification is discouraged.)  (New usage is discouraged.) $)
    idi $p |- ph $=
      idi.1 $.
  $}

  ${
    a1ii.1 $e |- ph $.
    a1ii.2 $e |- ps $.
    $( (_Note_:  This inference rule and the previous one, ~ idi , will
       normally never appear in a completed proof.)

       This is a technical inference to assist proof development.  It provides
       a temporary way to add an independent subproof to a proof under
       development, for later assignment to a normal proof step.

       The Metamath (Metamath-exe) program Proof Assistant requires proofs to
       be developed backwards from the conclusion with no gaps, and it has no
       mechanism that lets the user work on isolated subproofs.  This inference
       provides a workaround for this limitation.  It can be inserted at any
       point in a proof to allow an independent subproof to be developed on the
       side, for later use as part of the final proof.

       _Instructions_:
       <HTML><ol><li>Assign this inference to any unknown step in the proof.
       Typically, the last unknown step is the most convenient, since
       <code>MM-PA&gt; ASSIGN LAST</code> can be used.  This step will be
       replicated in hypothesis a1ii.1, from where the development of the main
       proof can continue.</li><li>Develop the independent subproof backwards
       from hypothesis a1ii.2.  If desired, use a
       <code>MM-PA&gt; LET STEP</code>
       command to pre-assign the conclusion of the independent subproof to
       a1ii.2.</li><li>After the independent subproof is complete, use
       <code>MM-PA&gt; IMPROVE ALL</code>
       to assign it automatically to an unknown
       step in the main proof that matches it.</li><li>After the entire proof
       is complete, use <code>MM-PA> MINIMIZE_WITH *</code> to clean up
       (discard) all ~ a1ii references automatically.</ol></HTML>

       This can also be used to apply subproofs from other theorems.  In step
       2, simply assign the theorem to a1ii.2, and run
       <HTML><code>MM-PA&gt; EXPAND &lt;theorem&gt;</code></HTML>
       to "import" a subproof
       from another theorem.

       This inference was originally designed to assist importing partially
       completed Proof Worksheets from the mmj2 Proof Assistant GUI, but it can
       also be useful on its own.  Interestingly, no axioms are required for
       its proof.  It is the inference associated with ~ a1i .  (Contributed by
       NM, 7-Feb-2006.)  (Proof modification is discouraged.)
       (New usage is discouraged.) $)
    a1ii $p |- ph $=
      a1ii.1 $.
  $}


$(
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#
  Propositional calculus
#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#

  Propositional calculus deals with general truths about well-formed formulas
  (wffs) regardless of how they are constructed.  The simplest propositional
  truth is ` ( ph -> ph ) ` , which can be read "if something is true, then it
  is true" - rather trivial and obvious, but nonetheless it must be proved from
  the axioms (see Theorem ~ id ).

  Our system of propositional calculus consists of three basic axioms and
  another axiom that defines the modus-ponens inference rule.  It is attributed
  to Jan Lukasiewicz (pronounced woo-kah-SHAY-vitch) and was popularized by
  Alonzo Church, who called it system P2.  (Thanks to Ted Ulrich for this
  information.)  These axioms are ~ ax-1 , ~ ax-2 , ~ ax-3 , and (for modus
  ponens) ~ ax-mp . Some closely followed texts include [Margaris] for the
  axioms and [WhiteheadRussell] for the theorems.

  The propositional calculus used here is the classical system widely used by
  mathematicians.  In particular, this logic system accepts the "law of the
  excluded middle" as proven in ~ exmid , which says that a logical statement
  is either true or not true.  This is an essential distinction of classical
  logic and is not a theorem of intuitionistic logic.

  All 194 axioms, definitions, and theorems for propositional calculus in
  _Principia Mathematica_ (specifically *1.2 through *5.75) are axioms or
  formally proven.  See the Bibliographic Cross-References at ~ mmbiblio.html
  for a complete cross-reference from sources used to its formalization in the
  Metamath Proof Explorer.

$)


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Recursively define primitive wffs for propositional calculus
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
$)

  $( If ` ph ` is a wff, so is ` -. ph ` or "not ` ph ` ".  Part of the
     recursive definition of a wff (well-formed formula).  In classical logic
     (which is our logic), a wff is interpreted as either true or false.  So if
     ` ph ` is true, then ` -. ph ` is false; if ` ph ` is false, then
     ` -. ph ` is true.  Traditionally, Greek letters are used to represent
     wffs, and we follow this convention.  In propositional calculus, we define
     only wffs built up from other wffs, i.e. there is no starting or "atomic"
     wff.  Later, in predicate calculus, we will extend the basic wff
     definition by including atomic wffs ( ~ weq and ~ wel ). $)
  wn $a wff -. ph $.

  $( Register negation '-.' as a primitive expression (lacking a
     definition). $)
  $( $j primitive 'wn'; $)

  $( If ` ph ` and ` ps ` are wff's, so is ` ( ph -> ps ) ` or " ` ph ` implies
     ` ps ` ".  Part of the recursive definition of a wff.  The resulting wff
     is (interpreted as) false when ` ph ` is true and ` ps ` is false; it is
     true otherwise.  Think of the truth table for an OR gate with input ` ph `
     connected through an inverter.  After we state the axioms of propositional
     calculus ( ~ ax-1 , ~ ax-2 , ~ ax-3 , and ~ ax-mp ) and define the
     biconditional ( ~ df-bi ), the constant true ` T. ` ( ~ df-tru ), and the
     constant false ` F. ` ( ~ df-fal ), we will be able to prove these truth
     table values: ` ( ( T. -> T. ) <-> T. ) ` ( ~ truimtru ),
     ` ( ( T. -> F. ) <-> F. ) ` ( ~ truimfal ), ` ( ( F. -> T. ) <-> T. ) `
     ( ~ falimtru ), and ` ( ( F. -> F. ) <-> T. ) ` ( ~ falimfal ).  These
     have straightforward meanings, for example, ` ( ( T. -> T. ) <-> T. ) `
     just means "the value of ` ( T. -> T. ) ` is ` T. ` ".

     The left-hand wff is called the antecedent, and the right-hand wff is
     called the consequent.  In the case of ` ( ph -> ( ps -> ch ) ) ` , the
     middle ` ps ` may be informally called either an antecedent or part of the
     consequent depending on context.  Contrast with ` <-> ` ( ~ df-bi ),
     ` /\ ` ( ~ df-an ), and ` \/ ` ( ~ df-or ).

     This is called "material implication" and the arrow is usually read as
     "implies".  However, material implication is not identical to the meaning
     of "implies" in natural language.  For example, the word "implies" may
     suggest a causal relationship in natural language.  Material implication
     does not require any causal relationship.  Also, note that in material
     implication, if the consequent is true then the wff is always true (even
     if the antecedent is false).  Thus, if "implies" means material
     implication, it is true that "if the moon is made of green cheese that
     implies that 5=5" (because 5=5).  Similarly, if the antecedent is false,
     the wff is always true.  Thus, it is true that, "if the moon is made of
     green cheese that implies that 5=7" (because the moon is not actually made
     of green cheese).  A contradiction implies anything ( ~ pm2.21i ).  In
     short, material implication has a very specific technical definition, and
     misunderstandings of it are sometimes called "paradoxes of logical
     implication". $)
  wi $a wff ( ph -> ps ) $.

  $( Register implication '->' as a primitive expression (lacking a
     definition). $)
  $( $j primitive 'wi'; $)


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  The axioms of propositional calculus
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  Propositional calculus (Axioms ~ ax-1 through ~ ax-3 and rule ~ ax-mp ) can
  be thought of as asserting formulas that are universally "true" when their
  variables are replaced by any combination of "true" and "false".
  Propositional calculus was first formalized by Frege in 1879, using as his
  axioms (in addition to rule ~ ax-mp ) the wffs ~ ax-1 , ~ ax-2 , ~ pm2.04 ,
  ~ con3 , ~ notnot , and ~ notnotr .  Around 1930, Lukasiewicz simplified the
  system by eliminating the third (which follows from the first two, as you can
  see by looking at the proof of ~ pm2.04 ) and replacing the last three with
  our ~ ax-3 .  (Thanks to Ted Ulrich for this information.)

  The theorems of propositional calculus are also called _tautologies_.
  Tautologies can be proved very simply using truth tables, based on the
  true/false interpretation of propositional calculus.  To do this, we assign
  all possible combinations of true and false to the wff variables and verify
  that the result (using the rules described in ~ wi and ~ wn ) always
  evaluates to true.  This is called the _semantic_ approach.  Our approach is
  called the _syntactic_ approach, in which everything is derived from axioms.
  A metatheorem called the Completeness Theorem for Propositional Calculus
  shows that the two approaches are equivalent and even provides an algorithm
  for automatically generating syntactic proofs from a truth table.  Those
  proofs, however, tend to be long, since truth tables grow exponentially with
  the number of variables, and the much shorter proofs that we show here were
  found manually.

$)

  ${
    $( Minor premise for modus ponens. $)
    min $e |- ph $.
    $( Major premise for modus ponens. $)
    maj $e |- ( ph -> ps ) $.
    $( Rule of Modus Ponens.  The postulated inference rule of propositional
       calculus.  See, e.g., Rule 1 of [Hamilton] p. 73.  The rule says, "if
       ` ph ` is true, and ` ph ` implies ` ps ` , then ` ps ` must also be
       true".  This rule is sometimes called "detachment", since it detaches
       the minor premise from the major premise.  "Modus ponens" is short for
       "modus ponendo ponens", a Latin phrase that means "the mode that by
       affirming affirms" - remark in [Sanford] p. 39.  This rule is similar to
       the rule of modus tollens ~ mto .

       Note:  In some web page displays such as the Statement List, the
       symbols " ` & ` " and " ` => ` " informally indicate the relationship
       between the hypotheses and the assertion (conclusion), abbreviating the
       English words "and" and "implies".  They are not part of the formal
       language.  (Contributed by NM, 30-Sep-1992.) $)
    ax-mp $a |- ps $.
  $}

  $( Axiom _Simp_.  Axiom A1 of [Margaris] p. 49.  One of the 3 axioms of
     propositional calculus.  The 3 axioms are also given as Definition 2.1 of
     [Hamilton] p. 28.  This axiom is called _Simp_ or "the principle of
     simplification" in _Principia Mathematica_ (Theorem *2.02 of
     [WhiteheadRussell] p. 100) because "it enables us to pass from the joint
     assertion of ` ph ` and ` ps ` to the assertion of ` ph ` simply".  It is
     Proposition 1 of [Frege1879] p. 26, its first axiom.  (Contributed by NM,
     30-Sep-1992.) $)
  ax-1 $a |- ( ph -> ( ps -> ph ) ) $.

  $( Axiom _Frege_.  Axiom A2 of [Margaris] p. 49.  One of the 3 axioms of
     propositional calculus.  It "distributes" an antecedent over two
     consequents.  This axiom was part of Frege's original system and is known
     as _Frege_ in the literature; see Proposition 2 of [Frege1879] p. 26.  It
     is also proved as Theorem *2.77 of [WhiteheadRussell] p. 108.  The other
     direction of this axiom also turns out to be true, as demonstrated by
     ~ pm5.41 .  (Contributed by NM, 30-Sep-1992.) $)
  ax-2 $a |- ( ( ph -> ( ps -> ch ) ) -> ( ( ph -> ps ) -> ( ph -> ch ) ) ) $.

  $( Axiom _Transp_.  Axiom A3 of [Margaris] p. 49.  One of the 3 axioms of
     propositional calculus.  It swaps or "transposes" the order of the
     consequents when negation is removed.  An informal example is that the
     statement "if there are no clouds in the sky, it is not raining" implies
     the statement "if it is raining, there are clouds in the sky".  This axiom
     is called _Transp_ or "the principle of transposition" in _Principia
     Mathematica_ (Theorem *2.17 of [WhiteheadRussell] p. 103).  We will also
     use the term "contraposition" for this principle, although the reader is
     advised that in the field of philosophical logic, "contraposition" has a
     different technical meaning.  (Contributed by NM, 30-Sep-1992.)  Use its
     alias ~ con4 instead.  (New usage is discouraged.) $)
  ax-3 $a |- ( ( -. ph -> -. ps ) -> ( ps -> ph ) ) $.


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Logical implication
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  The results in this section are based on implication only, and avoid ~ ax-3 ,
  so are intuitionistic.  The system { ~ ax-mp , ~ ax-1 , ~ ax-2 } axiomatizes
  what is sometimes called "intuitionistic implicational calculus" or "minimal
  implicational calculus".

  In an implication, the wff before the arrow is called the "antecedent" and
  the wff after the arrow is called the "consequent".

$)

  ${
    mp2.1 $e |- ph $.
    mp2.2 $e |- ps $.
    mp2.3 $e |- ( ph -> ( ps -> ch ) ) $.
    $( A double modus ponens inference.  (Contributed by NM, 5-Apr-1994.) $)
    mp2 $p |- ch $=
      wps wch mp2.2 wph wps wch wi mp2.1 mp2.3 ax-mp ax-mp $.
  $}

  ${
    mp2b.1 $e |- ph $.
    mp2b.2 $e |- ( ph -> ps ) $.
    mp2b.3 $e |- ( ps -> ch ) $.
    $( A double modus ponens inference.  (Contributed by Mario Carneiro,
       24-Jan-2013.) $)
    mp2b $p |- ch $=
      wps wch wph wps mp2b.1 mp2b.2 ax-mp mp2b.3 ax-mp $.
  $}

  ${
    a1i.1 $e |- ph $.
    $( Inference introducing an antecedent.  Inference associated with ~ ax-1 .
       Its associated inference is ~ a1ii .  See ~ conventions for a definition
       of "associated inference".  (Contributed by NM, 29-Dec-1992.) $)
    a1i $p |- ( ps -> ph ) $=
      wph wps wph wi a1i.1 wph wps ax-1 ax-mp $.
  $}

  ${
    2a1i.1 $e |- ph $.
    $( Inference introducing two antecedents.  Two applications of ~ a1i .
       Inference associated with ~ 2a1 .  (Contributed by Jeff Hankins,
       4-Aug-2009.) $)
    2a1i $p |- ( ps -> ( ch -> ph ) ) $=
      wch wph wi wps wph wch 2a1i.1 a1i a1i $.
  $}

  ${
    mp1i.1 $e |- ph $.
    mp1i.2 $e |- ( ph -> ps ) $.
    $( Inference detaching an antecedent and introducing a new one.
       (Contributed by Stefan O'Rear, 29-Jan-2015.) $)
    mp1i $p |- ( ch -> ps ) $=
      wps wch wph wps mp1i.1 mp1i.2 ax-mp a1i $.
  $}

  ${
    a2i.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Inference distributing an antecedent.  Inference associated with
       ~ ax-2 .  Its associated inference is ~ mpd .  (Contributed by NM,
       29-Dec-1992.) $)
    a2i $p |- ( ( ph -> ps ) -> ( ph -> ch ) ) $=
      wph wps wch wi wi wph wps wi wph wch wi wi a2i.1 wph wps wch ax-2 ax-mp
      $.
  $}

  ${
    mpd.1 $e |- ( ph -> ps ) $.
    mpd.2 $e |- ( ph -> ( ps -> ch ) ) $.
    $( A modus ponens deduction.  A translation of natural deduction rule
       ` -> ` E ( ` -> ` elimination), see ~ natded .  Deduction form of
       ~ ax-mp .  Inference associated with ~ a2i .  Commuted form of ~ mpcom .
       (Contributed by NM, 29-Dec-1992.) $)
    mpd $p |- ( ph -> ch ) $=
      wph wps wi wph wch wi mpd.1 wph wps wch mpd.2 a2i ax-mp $.
  $}

  ${
    imim2i.1 $e |- ( ph -> ps ) $.
    $( Inference adding common antecedents in an implication.  Inference
       associated with ~ imim2 .  Its associated inference is ~ syl .
       (Contributed by NM, 28-Dec-1992.) $)
    imim2i $p |- ( ( ch -> ph ) -> ( ch -> ps ) ) $=
      wch wph wps wph wps wi wch imim2i.1 a1i a2i $.
  $}

  ${
    $( First of 2 premises for ~ syl . $)
    syl.1 $e |- ( ph -> ps ) $.
    $( Second of 2 premises for ~ syl . $)
    syl.2 $e |- ( ps -> ch ) $.
    $( An inference version of the transitive laws for implication ~ imim2 and
       ~ imim1 (and ~ imim1i and ~ imim2i ), which Russell and Whitehead call
       "the principle of the syllogism ... because ... the syllogism in Barbara
       is derived from [[ ~ syl ]" (quote after Theorem *2.06 of
       [WhiteheadRussell] p. 101).  Some authors call this law a "hypothetical
       syllogism".  Its associated inference is ~ mp2b .

       (A bit of trivia: this is the most commonly referenced assertion in our
       database (13449 times as of 22-Jul-2021).  In second place is ~ eqid
       (9597 times), followed by ~ adantr (8861 times), ~ syl2anc (7421 times),
       ~ adantl (6403 times), and ~ simpr (5829 times).  The Metamath program
       command 'show usage' shows the number of references.)

       (Contributed by NM, 30-Sep-1992.)  (Proof shortened by Mel L. O'Cat,
       20-Oct-2011.)  (Proof shortened by Wolf Lammen, 26-Jul-2012.) $)
    syl $p |- ( ph -> ch ) $=
      wph wps wch syl.1 wps wch wi wph syl.2 a1i mpd $.
  $}

  ${
    3syl.1 $e |- ( ph -> ps ) $.
    3syl.2 $e |- ( ps -> ch ) $.
    3syl.3 $e |- ( ch -> th ) $.
    $( Inference chaining two syllogisms ~ syl .  Inference associated with
       ~ imim12i .  (Contributed by NM, 28-Dec-1992.) $)
    3syl $p |- ( ph -> th ) $=
      wph wch wth wph wps wch 3syl.1 3syl.2 syl 3syl.3 syl $.
  $}

  ${
    4syl.1 $e |- ( ph -> ps ) $.
    4syl.2 $e |- ( ps -> ch ) $.
    4syl.3 $e |- ( ch -> th ) $.
    4syl.4 $e |- ( th -> ta ) $.
    $( Inference chaining three syllogisms ~ syl .  (Contributed by BJ,
       14-Jul-2018.)  The use of this theorem is marked "discouraged" because
       it can cause the Metamath program "MM-PA> MINIMIZE__WITH *" command to
       have very long run times.  However, feel free to use "MM-PA>
       MINIMIZE__WITH 4syl / OVERRIDE" if you wish.  Remember to update the
       "discouraged" file if it gets used.  (New usage is discouraged.) $)
    4syl $p |- ( ph -> ta ) $=
      wph wth wta wph wps wch wth 4syl.1 4syl.2 4syl.3 3syl 4syl.4 syl $.
  $}

  ${
    mpi.1 $e |- ps $.
    mpi.2 $e |- ( ph -> ( ps -> ch ) ) $.
    $( A nested modus ponens inference.  Inference associated with ~ com12 .
       (Contributed by NM, 29-Dec-1992.)  (Proof shortened by Stefan Allan,
       20-Mar-2006.) $)
    mpi $p |- ( ph -> ch ) $=
      wph wps wch wps wph mpi.1 a1i mpi.2 mpd $.
  $}

  ${
    mpisyl.1 $e |- ( ph -> ps ) $.
    mpisyl.2 $e |- ch $.
    mpisyl.3 $e |- ( ps -> ( ch -> th ) ) $.
    $( A syllogism combined with a modus ponens inference.  (Contributed by
       Alan Sare, 25-Jul-2011.) $)
    mpisyl $p |- ( ph -> th ) $=
      wph wps wth mpisyl.1 wps wch wth mpisyl.2 mpisyl.3 mpi syl $.
  $}

  $( Principle of identity.  Theorem *2.08 of [WhiteheadRussell] p. 101.  For
     another version of the proof directly from axioms, see ~ idALT .  Its
     associated inference, ~ idi , requires no axioms for its proof, contrary
     to ~ id .  Note that the second occurrences of ` ph ` in Steps 1 and 2 may
     be simultaneously replaced by any wff ` ps ` , which may ease the
     understanding of the proof.  (Contributed by NM, 29-Dec-1992.)  (Proof
     shortened by Stefan Allan, 20-Mar-2006.) $)
  id $p |- ( ph -> ph ) $=
    wph wph wph wi wph wph wph ax-1 wph wph wph wi ax-1 mpd $.

  $( Alternate proof of ~ id .  This version is proved directly from the axioms
     for demonstration purposes.  This proof is a popular example in the
     literature and is identical, step for step, to the proofs of Theorem 1 of
     [Margaris] p. 51, Example 2.7(a) of [Hamilton] p. 31, Lemma 10.3 of
     [BellMachover] p. 36, and Lemma 1.8 of [Mendelson] p. 36.  It is also "Our
     first proof" in Hirst and Hirst's _A Primer for Logic and Proof_ p. 17
     (PDF p. 23) at ~ http://www.appstate.edu/~~hirstjl/primer/hirst.pdf .
     Note that the second occurrences of ` ph ` in Steps 1 to 4 and the sixth
     in Step 3 may be simultaneously replaced by any wff ` ps ` , which may
     ease the understanding of the proof.  For a shorter version of the proof
     that takes advantage of previously proved theorems, see ~ id .
     (Contributed by NM, 30-Sep-1992.)  (Proof modification is discouraged.)
     Use ~ id instead.  (New usage is discouraged.) $)
  idALT $p |- ( ph -> ph ) $=
    wph wph wph wi wi wph wph wi wph wph ax-1 wph wph wph wi wph wi wi wph wph
    wph wi wi wph wph wi wi wph wph wph wi ax-1 wph wph wph wi wph ax-2 ax-mp
    ax-mp $.

  $( Principle of identity ~ id with antecedent.  (Contributed by NM,
     26-Nov-1995.) $)
  idd $p |- ( ph -> ( ps -> ps ) ) $=
    wps wps wi wph wps id a1i $.

  ${
    a1d.1 $e |- ( ph -> ps ) $.
    $( Deduction introducing an embedded antecedent.  Deduction form of ~ ax-1
       and ~ a1i .  (Contributed by NM, 5-Jan-1993.)  (Proof shortened by
       Stefan Allan, 20-Mar-2006.) $)
    a1d $p |- ( ph -> ( ch -> ps ) ) $=
      wph wps wch wps wi a1d.1 wps wch ax-1 syl $.
  $}

  ${
    2a1d.1 $e |- ( ph -> ps ) $.
    $( Deduction introducing two antecedents.  Two applications of ~ a1d .
       Deduction associated with ~ 2a1 and ~ 2a1i .  (Contributed by BJ,
       10-Aug-2020.) $)
    2a1d $p |- ( ph -> ( ch -> ( th -> ps ) ) ) $=
      wph wth wps wi wch wph wps wth 2a1d.1 a1d a1d $.
  $}

  ${
    a1i13.1 $e |- ( ps -> th ) $.
    $( Add two antecedents to a wff.  (Contributed by Jeff Hankins,
       4-Aug-2009.) $)
    a1i13 $p |- ( ph -> ( ps -> ( ch -> th ) ) ) $=
      wps wch wth wi wi wph wps wth wch a1i13.1 a1d a1i $.
  $}

  $( A double form of ~ ax-1 .  Its associated inference is ~ 2a1i .  Its
     associated deduction is ~ 2a1d .  (Contributed by BJ, 10-Aug-2020.)
     (Proof shortened by Wolf Lammen, 1-Sep-2020.) $)
  2a1 $p |- ( ph -> ( ps -> ( ch -> ph ) ) ) $=
    wph wph wps wch wph id 2a1d $.

  ${
    a2d.1 $e |- ( ph -> ( ps -> ( ch -> th ) ) ) $.
    $( Deduction distributing an embedded antecedent.  Deduction form of
       ~ ax-2 .  (Contributed by NM, 23-Jun-1994.) $)
    a2d $p |- ( ph -> ( ( ps -> ch ) -> ( ps -> th ) ) ) $=
      wph wps wch wth wi wi wps wch wi wps wth wi wi a2d.1 wps wch wth ax-2 syl
      $.
  $}

  ${
    sylcom.1 $e |- ( ph -> ( ps -> ch ) ) $.
    sylcom.2 $e |- ( ps -> ( ch -> th ) ) $.
    $( Syllogism inference with commutation of antecedents.  (Contributed by
       NM, 29-Aug-2004.)  (Proof shortened by Mel L. O'Cat, 2-Feb-2006.)
       (Proof shortened by Stefan Allan, 23-Feb-2006.) $)
    sylcom $p |- ( ph -> ( ps -> th ) ) $=
      wph wps wch wi wps wth wi sylcom.1 wps wch wth sylcom.2 a2i syl $.
  $}

  ${
    syl5com.1 $e |- ( ph -> ps ) $.
    syl5com.2 $e |- ( ch -> ( ps -> th ) ) $.
    $( Syllogism inference with commuted antecedents.  (Contributed by NM,
       24-May-2005.) $)
    syl5com $p |- ( ph -> ( ch -> th ) ) $=
      wph wch wps wth wph wps wch syl5com.1 a1d syl5com.2 sylcom $.
  $}

  ${
    com12.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Inference that swaps (commutes) antecedents in an implication.
       Inference associated with ~ pm2.04 .  Its associated inference is
       ~ mpi .  (Contributed by NM, 29-Dec-1992.)  (Proof shortened by Wolf
       Lammen, 4-Aug-2012.) $)
    com12 $p |- ( ps -> ( ph -> ch ) ) $=
      wps wps wph wch wps id com12.1 syl5com $.
  $}

  ${
    syl11.1 $e |- ( ph -> ( ps -> ch ) ) $.
    syl11.2 $e |- ( th -> ph ) $.
    $( A syllogism inference.  Commuted form of an instance of ~ syl .
       (Contributed by BJ, 25-Oct-2021.) $)
    syl11 $p |- ( ps -> ( th -> ch ) ) $=
      wth wps wch wth wph wps wch wi syl11.2 syl11.1 syl com12 $.
  $}

  ${
    syl5.1 $e |- ( ph -> ps ) $.
    syl5.2 $e |- ( ch -> ( ps -> th ) ) $.
    $( A syllogism rule of inference.  The first premise is used to replace the
       second antecedent of the second premise.  (Contributed by NM,
       27-Dec-1992.)  (Proof shortened by Wolf Lammen, 25-May-2013.) $)
    syl5 $p |- ( ch -> ( ph -> th ) ) $=
      wph wch wth wph wps wch wth syl5.1 syl5.2 syl5com com12 $.
  $}

  ${
    syl6.1 $e |- ( ph -> ( ps -> ch ) ) $.
    syl6.2 $e |- ( ch -> th ) $.
    $( A syllogism rule of inference.  The second premise is used to replace
       the consequent of the first premise.  (Contributed by NM, 5-Jan-1993.)
       (Proof shortened by Wolf Lammen, 30-Jul-2012.) $)
    syl6 $p |- ( ph -> ( ps -> th ) ) $=
      wph wps wch wth syl6.1 wch wth wi wps syl6.2 a1i sylcom $.
  $}

  ${
    syl56.1 $e |- ( ph -> ps ) $.
    syl56.2 $e |- ( ch -> ( ps -> th ) ) $.
    syl56.3 $e |- ( th -> ta ) $.
    $( Combine ~ syl5 and ~ syl6 .  (Contributed by NM, 14-Nov-2013.) $)
    syl56 $p |- ( ch -> ( ph -> ta ) ) $=
      wph wps wch wta syl56.1 wch wps wth wta syl56.2 syl56.3 syl6 syl5 $.
  $}

  ${
    syl6com.1 $e |- ( ph -> ( ps -> ch ) ) $.
    syl6com.2 $e |- ( ch -> th ) $.
    $( Syllogism inference with commuted antecedents.  (Contributed by NM,
       25-May-2005.) $)
    syl6com $p |- ( ps -> ( ph -> th ) ) $=
      wph wps wth wph wps wch wth syl6com.1 syl6com.2 syl6 com12 $.
  $}

  ${
    mpcom.1 $e |- ( ps -> ph ) $.
    mpcom.2 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Modus ponens inference with commutation of antecedents.  Commuted form
       of ~ mpd .  (Contributed by NM, 17-Mar-1996.) $)
    mpcom $p |- ( ps -> ch ) $=
      wps wph wch mpcom.1 wph wps wch mpcom.2 com12 mpd $.
  $}

  ${
    syli.1 $e |- ( ps -> ( ph -> ch ) ) $.
    syli.2 $e |- ( ch -> ( ph -> th ) ) $.
    $( Syllogism inference with common nested antecedent.  (Contributed by NM,
       4-Nov-2004.) $)
    syli $p |- ( ps -> ( ph -> th ) ) $=
      wps wph wch wth syli.1 wch wph wth syli.2 com12 sylcom $.
  $}

  ${
    syl2im.1 $e |- ( ph -> ps ) $.
    syl2im.2 $e |- ( ch -> th ) $.
    syl2im.3 $e |- ( ps -> ( th -> ta ) ) $.
    $( Replace two antecedents.  Implication-only version of ~ syl2an .
       (Contributed by Wolf Lammen, 14-May-2013.) $)
    syl2im $p |- ( ph -> ( ch -> ta ) ) $=
      wph wps wch wta wi syl2im.1 wch wth wps wta syl2im.2 syl2im.3 syl5 syl $.

    $( A commuted version of ~ syl2im .  Implication-only version of
       ~ syl2anr .  (Contributed by BJ, 20-Oct-2021.) $)
    syl2imc $p |- ( ch -> ( ph -> ta ) ) $=
      wph wch wta wph wps wch wth wta syl2im.1 syl2im.2 syl2im.3 syl2im com12
      $.
  $}

  $( This theorem, sometimes called "Assertion" or "Pon" (for "ponens"), can be
     thought of as a closed form of modus ponens ~ ax-mp .  Theorem *2.27 of
     [WhiteheadRussell] p. 104.  (Contributed by NM, 15-Jul-1993.) $)
  pm2.27 $p |- ( ph -> ( ( ph -> ps ) -> ps ) ) $=
    wph wps wi wph wps wph wps wi id com12 $.

  ${
    mpdd.1 $e |- ( ph -> ( ps -> ch ) ) $.
    mpdd.2 $e |- ( ph -> ( ps -> ( ch -> th ) ) ) $.
    $( A nested modus ponens deduction.  Double deduction associated with
       ~ ax-mp .  Deduction associated with ~ mpd .  (Contributed by NM,
       12-Dec-2004.) $)
    mpdd $p |- ( ph -> ( ps -> th ) ) $=
      wph wps wch wi wps wth wi mpdd.1 wph wps wch wth mpdd.2 a2d mpd $.
  $}

  ${
    mpid.1 $e |- ( ph -> ch ) $.
    mpid.2 $e |- ( ph -> ( ps -> ( ch -> th ) ) ) $.
    $( A nested modus ponens deduction.  Deduction associated with ~ mpi .
       (Contributed by NM, 14-Dec-2004.) $)
    mpid $p |- ( ph -> ( ps -> th ) ) $=
      wph wps wch wth wph wch wps mpid.1 a1d mpid.2 mpdd $.
  $}

  ${
    mpdi.1 $e |- ( ps -> ch ) $.
    mpdi.2 $e |- ( ph -> ( ps -> ( ch -> th ) ) ) $.
    $( A nested modus ponens deduction.  (Contributed by NM, 16-Apr-2005.)
       (Proof shortened by Mel L. O'Cat, 15-Jan-2008.) $)
    mpdi $p |- ( ph -> ( ps -> th ) ) $=
      wph wps wch wth wps wch wi wph mpdi.1 a1i mpdi.2 mpdd $.
  $}

  ${
    mpii.1 $e |- ch $.
    mpii.2 $e |- ( ph -> ( ps -> ( ch -> th ) ) ) $.
    $( A doubly nested modus ponens inference.  (Contributed by NM,
       31-Dec-1993.)  (Proof shortened by Wolf Lammen, 31-Jul-2012.) $)
    mpii $p |- ( ph -> ( ps -> th ) ) $=
      wph wps wch wth wch wps mpii.1 a1i mpii.2 mpdi $.
  $}

  ${
    syld.1 $e |- ( ph -> ( ps -> ch ) ) $.
    syld.2 $e |- ( ph -> ( ch -> th ) ) $.
    $( Syllogism deduction.  Deduction associated with ~ syl .  See
       ~ conventions for the meaning of "associated deduction" or "deduction
       form".  (Contributed by NM, 5-Aug-1993.)  (Proof shortened by Mel L.
       O'Cat, 19-Feb-2008.)  (Proof shortened by Wolf Lammen, 3-Aug-2012.) $)
    syld $p |- ( ph -> ( ps -> th ) ) $=
      wph wps wch wth syld.1 wph wch wth wi wps syld.2 a1d mpdd $.

    $( Syllogism deduction.  Commuted form of ~ syld .  (Contributed by BJ,
       25-Oct-2021.) $)
    syldc $p |- ( ps -> ( ph -> th ) ) $=
      wph wps wth wph wps wch wth syld.1 syld.2 syld com12 $.
  $}

  ${
    mp2d.1 $e |- ( ph -> ps ) $.
    mp2d.2 $e |- ( ph -> ch ) $.
    mp2d.3 $e |- ( ph -> ( ps -> ( ch -> th ) ) ) $.
    $( A double modus ponens deduction.  Deduction associated with ~ mp2 .
       (Contributed by NM, 23-May-2013.)  (Proof shortened by Wolf Lammen,
       23-Jul-2013.) $)
    mp2d $p |- ( ph -> th ) $=
      wph wps wth mp2d.1 wph wps wch wth mp2d.2 mp2d.3 mpid mpd $.
  $}

  ${
    a1dd.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Double deduction introducing an antecedent.  Deduction associated with
       ~ a1d .  Double deduction associated with ~ ax-1 and ~ a1i .
       (Contributed by NM, 17-Dec-2004.)  (Proof shortened by Mel L. O'Cat,
       15-Jan-2008.) $)
    a1dd $p |- ( ph -> ( ps -> ( th -> ch ) ) ) $=
      wph wps wch wth wch wi a1dd.1 wch wth ax-1 syl6 $.
  $}

  ${
    2a1dd.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Double deduction introducing two antecedents.  Two applications of
       ~ 2a1dd .  Deduction associated with ~ 2a1d .  Double deduction
       associated with ~ 2a1 and ~ 2a1i .  (Contributed by Jeff Hankins,
       5-Aug-2009.) $)
    2a1dd $p |- ( ph -> ( ps -> ( th -> ( ta -> ch ) ) ) ) $=
      wph wps wta wch wi wth wph wps wch wta 2a1dd.1 a1dd a1dd $.
  $}

  ${
    pm2.43i.1 $e |- ( ph -> ( ph -> ps ) ) $.
    $( Inference absorbing redundant antecedent.  Inference associated with
       ~ pm2.43 .  (Contributed by NM, 10-Jan-1993.)  (Proof shortened by Mel
       L. O'Cat, 28-Nov-2008.) $)
    pm2.43i $p |- ( ph -> ps ) $=
      wph wph wps wph id pm2.43i.1 mpd $.
  $}

  ${
    pm2.43d.1 $e |- ( ph -> ( ps -> ( ps -> ch ) ) ) $.
    $( Deduction absorbing redundant antecedent.  Deduction associated with
       ~ pm2.43 and ~ pm2.43i .  (Contributed by NM, 18-Aug-1993.)  (Proof
       shortened by Mel L. O'Cat, 28-Nov-2008.) $)
    pm2.43d $p |- ( ph -> ( ps -> ch ) ) $=
      wph wps wps wch wps id pm2.43d.1 mpdi $.
  $}

  ${
    pm2.43a.1 $e |- ( ps -> ( ph -> ( ps -> ch ) ) ) $.
    $( Inference absorbing redundant antecedent.  (Contributed by NM,
       7-Nov-1995.)  (Proof shortened by Mel L. O'Cat, 28-Nov-2008.) $)
    pm2.43a $p |- ( ps -> ( ph -> ch ) ) $=
      wps wph wps wch wps id pm2.43a.1 mpid $.
  $}

  ${
    pm2.43b.1 $e |- ( ps -> ( ph -> ( ps -> ch ) ) ) $.
    $( Inference absorbing redundant antecedent.  (Contributed by NM,
       31-Oct-1995.) $)
    pm2.43b $p |- ( ph -> ( ps -> ch ) ) $=
      wps wph wch wph wps wch pm2.43b.1 pm2.43a com12 $.
  $}

  $( Absorption of redundant antecedent.  Also called the "Contraction" or
     "Hilbert" axiom.  Theorem *2.43 of [WhiteheadRussell] p. 106.
     (Contributed by NM, 10-Jan-1993.)  (Proof shortened by Mel L. O'Cat,
     15-Aug-2004.) $)
  pm2.43 $p |- ( ( ph -> ( ph -> ps ) ) -> ( ph -> ps ) ) $=
    wph wph wps wi wps wph wps pm2.27 a2i $.

  ${
    imim2d.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Deduction adding nested antecedents.  Deduction associated with ~ imim2
       and ~ imim2i .  (Contributed by NM, 10-Jan-1993.) $)
    imim2d $p |- ( ph -> ( ( th -> ps ) -> ( th -> ch ) ) ) $=
      wph wth wps wch wph wps wch wi wth imim2d.1 a1d a2d $.
  $}

  $( A closed form of syllogism (see ~ syl ).  Theorem *2.05 of
     [WhiteheadRussell] p. 100.  Its associated inference is ~ imim2i .  Its
     associated deduction is ~ imim2d .  An alternate proof from more basic
     results is given by ~ ax-1 followed by ~ a2d .  (Contributed by NM,
     29-Dec-1992.)  (Proof shortened by Wolf Lammen, 6-Sep-2012.) $)
  imim2 $p |- ( ( ph -> ps ) -> ( ( ch -> ph ) -> ( ch -> ps ) ) ) $=
    wph wps wi wph wps wch wph wps wi id imim2d $.

  ${
    embantd.1 $e |- ( ph -> ps ) $.
    embantd.2 $e |- ( ph -> ( ch -> th ) ) $.
    $( Deduction embedding an antecedent.  (Contributed by Wolf Lammen,
       4-Oct-2013.) $)
    embantd $p |- ( ph -> ( ( ps -> ch ) -> th ) ) $=
      wph wps wch wi wps wth embantd.1 wph wch wth wps embantd.2 imim2d mpid $.
  $}

  ${
    3syld.1 $e |- ( ph -> ( ps -> ch ) ) $.
    3syld.2 $e |- ( ph -> ( ch -> th ) ) $.
    3syld.3 $e |- ( ph -> ( th -> ta ) ) $.
    $( Triple syllogism deduction.  Deduction associated with ~ 3syld .
       (Contributed by Jeff Hankins, 4-Aug-2009.) $)
    3syld $p |- ( ph -> ( ps -> ta ) ) $=
      wph wps wth wta wph wps wch wth 3syld.1 3syld.2 syld 3syld.3 syld $.
  $}

  ${
    sylsyld.1 $e |- ( ph -> ps ) $.
    sylsyld.2 $e |- ( ph -> ( ch -> th ) ) $.
    sylsyld.3 $e |- ( ps -> ( th -> ta ) ) $.
    $( A double syllogism inference.  (Contributed by Alan Sare,
       20-Apr-2011.) $)
    sylsyld $p |- ( ph -> ( ch -> ta ) ) $=
      wph wch wth wta sylsyld.2 wph wps wth wta wi sylsyld.1 sylsyld.3 syl syld
      $.
  $}

  ${
    imim12i.1 $e |- ( ph -> ps ) $.
    imim12i.2 $e |- ( ch -> th ) $.
    $( Inference joining two implications.  Inference associated with
       ~ imim12 .  Its associated inference is ~ 3syl .  (Contributed by NM,
       12-Mar-1993.)  (Proof shortened by Mel L. O'Cat, 29-Oct-2011.) $)
    imim12i $p |- ( ( ps -> ch ) -> ( ph -> th ) ) $=
      wph wps wps wch wi wth imim12i.1 wch wth wps imim12i.2 imim2i syl5 $.
  $}

  ${
    imim1i.1 $e |- ( ph -> ps ) $.
    $( Inference adding common consequents in an implication, thereby
       interchanging the original antecedent and consequent.  Inference
       associated with ~ imim1 .  Its associated inference is ~ syl .
       (Contributed by NM, 28-Dec-1992.)  (Proof shortened by Wolf Lammen,
       4-Aug-2012.) $)
    imim1i $p |- ( ( ps -> ch ) -> ( ph -> ch ) ) $=
      wph wps wch wch imim1i.1 wch id imim12i $.
  $}

  ${
    imim3i.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Inference adding three nested antecedents.  (Contributed by NM,
       19-Dec-2006.) $)
    imim3i $p |- ( ( th -> ph ) -> ( ( th -> ps ) -> ( th -> ch ) ) ) $=
      wth wph wi wth wps wch wph wps wch wi wth imim3i.1 imim2i a2d $.
  $}

  ${
    sylc.1 $e |- ( ph -> ps ) $.
    sylc.2 $e |- ( ph -> ch ) $.
    sylc.3 $e |- ( ps -> ( ch -> th ) ) $.
    $( A syllogism inference combined with contraction.  (Contributed by NM,
       4-May-1994.)  (Revised by NM, 13-Jul-2013.) $)
    sylc $p |- ( ph -> th ) $=
      wph wth wph wps wph wch wth sylc.1 sylc.2 sylc.3 syl2im pm2.43i $.
  $}

  ${
    syl3c.1 $e |- ( ph -> ps ) $.
    syl3c.2 $e |- ( ph -> ch ) $.
    syl3c.3 $e |- ( ph -> th ) $.
    syl3c.4 $e |- ( ps -> ( ch -> ( th -> ta ) ) ) $.
    $( A syllogism inference combined with contraction.  (Contributed by Alan
       Sare, 7-Jul-2011.) $)
    syl3c $p |- ( ph -> ta ) $=
      wph wth wta syl3c.3 wph wps wch wth wta wi syl3c.1 syl3c.2 syl3c.4 sylc
      mpd $.
  $}

  ${
    syl6mpi.1 $e |- ( ph -> ( ps -> ch ) ) $.
    syl6mpi.2 $e |- th $.
    syl6mpi.3 $e |- ( ch -> ( th -> ta ) ) $.
    $( A syllogism inference.  (Contributed by Alan Sare, 8-Jul-2011.)  (Proof
       shortened by Wolf Lammen, 13-Sep-2012.) $)
    syl6mpi $p |- ( ph -> ( ps -> ta ) ) $=
      wph wps wch wta syl6mpi.1 wch wth wta syl6mpi.2 syl6mpi.3 mpi syl6 $.
  $}

  ${
    mpsyl.1 $e |- ph $.
    mpsyl.2 $e |- ( ps -> ch ) $.
    mpsyl.3 $e |- ( ph -> ( ch -> th ) ) $.
    $( Modus ponens combined with a syllogism inference.  (Contributed by Alan
       Sare, 20-Apr-2011.) $)
    mpsyl $p |- ( ps -> th ) $=
      wps wph wch wth wph wps mpsyl.1 a1i mpsyl.2 mpsyl.3 sylc $.
  $}

  ${
    mpsylsyld.1 $e |- ph $.
    mpsylsyld.2 $e |- ( ps -> ( ch -> th ) ) $.
    mpsylsyld.3 $e |- ( ph -> ( th -> ta ) ) $.
    $( Modus ponens combined with a double syllogism inference.  (Contributed
       by Alan Sare, 22-Jul-2012.) $)
    mpsylsyld $p |- ( ps -> ( ch -> ta ) ) $=
      wps wph wch wth wta wph wps mpsylsyld.1 a1i mpsylsyld.2 mpsylsyld.3
      sylsyld $.
  $}

  ${
    syl6c.1 $e |- ( ph -> ( ps -> ch ) ) $.
    syl6c.2 $e |- ( ph -> ( ps -> th ) ) $.
    syl6c.3 $e |- ( ch -> ( th -> ta ) ) $.
    $( Inference combining ~ syl6 with contraction.  (Contributed by Alan Sare,
       2-May-2011.) $)
    syl6c $p |- ( ph -> ( ps -> ta ) ) $=
      wph wps wth wta syl6c.2 wph wps wch wth wta wi syl6c.1 syl6c.3 syl6 mpdd
      $.
  $}

  ${
    syl6ci.1 $e |- ( ph -> ( ps -> ch ) ) $.
    syl6ci.2 $e |- ( ph -> th ) $.
    syl6ci.3 $e |- ( ch -> ( th -> ta ) ) $.
    $( A syllogism inference combined with contraction.  (Contributed by Alan
       Sare, 18-Mar-2012.) $)
    syl6ci $p |- ( ph -> ( ps -> ta ) ) $=
      wph wps wch wth wta syl6ci.1 wph wth wps syl6ci.2 a1d syl6ci.3 syl6c $.
  $}

  ${
    syldd.1 $e |- ( ph -> ( ps -> ( ch -> th ) ) ) $.
    syldd.2 $e |- ( ph -> ( ps -> ( th -> ta ) ) ) $.
    $( Nested syllogism deduction.  Deduction associated with ~ syld .  Double
       deduction associated with ~ syl .  (Contributed by NM, 12-Dec-2004.)
       (Proof shortened by Wolf Lammen, 11-May-2013.) $)
    syldd $p |- ( ph -> ( ps -> ( ch -> ta ) ) ) $=
      wph wps wth wta wi wch wth wi wch wta wi syldd.2 syldd.1 wth wta wch
      imim2 syl6c $.
  $}

  ${
    syl5d.1 $e |- ( ph -> ( ps -> ch ) ) $.
    syl5d.2 $e |- ( ph -> ( th -> ( ch -> ta ) ) ) $.
    $( A nested syllogism deduction.  Deduction associated with ~ syl5 .
       (Contributed by NM, 14-May-1993.)  (Proof shortened by Josh Purinton,
       29-Dec-2000.)  (Proof shortened by Mel L. O'Cat, 2-Feb-2006.) $)
    syl5d $p |- ( ph -> ( th -> ( ps -> ta ) ) ) $=
      wph wth wps wch wta wph wps wch wi wth syl5d.1 a1d syl5d.2 syldd $.
  $}

  ${
    syl7.1 $e |- ( ph -> ps ) $.
    syl7.2 $e |- ( ch -> ( th -> ( ps -> ta ) ) ) $.
    $( A syllogism rule of inference.  The first premise is used to replace the
       third antecedent of the second premise.  (Contributed by NM,
       12-Jan-1993.)  (Proof shortened by Wolf Lammen, 3-Aug-2012.) $)
    syl7 $p |- ( ch -> ( th -> ( ph -> ta ) ) ) $=
      wch wph wps wth wta wph wps wi wch syl7.1 a1i syl7.2 syl5d $.
  $}

  ${
    syl6d.1 $e |- ( ph -> ( ps -> ( ch -> th ) ) ) $.
    syl6d.2 $e |- ( ph -> ( th -> ta ) ) $.
    $( A nested syllogism deduction.  Deduction associated with ~ syl6 .
       (Contributed by NM, 11-May-1993.)  (Proof shortened by Josh Purinton,
       29-Dec-2000.)  (Proof shortened by Mel L. O'Cat, 2-Feb-2006.) $)
    syl6d $p |- ( ph -> ( ps -> ( ch -> ta ) ) ) $=
      wph wps wch wth wta syl6d.1 wph wth wta wi wps syl6d.2 a1d syldd $.
  $}

  ${
    syl8.1 $e |- ( ph -> ( ps -> ( ch -> th ) ) ) $.
    syl8.2 $e |- ( th -> ta ) $.
    $( A syllogism rule of inference.  The second premise is used to replace
       the consequent of the first premise.  (Contributed by NM, 1-Aug-1994.)
       (Proof shortened by Wolf Lammen, 3-Aug-2012.) $)
    syl8 $p |- ( ph -> ( ps -> ( ch -> ta ) ) ) $=
      wph wps wch wth wta syl8.1 wth wta wi wph syl8.2 a1i syl6d $.
  $}

  ${
    syl9.1 $e |- ( ph -> ( ps -> ch ) ) $.
    syl9.2 $e |- ( th -> ( ch -> ta ) ) $.
    $( A nested syllogism inference with different antecedents.  (Contributed
       by NM, 13-May-1993.)  (Proof shortened by Josh Purinton,
       29-Dec-2000.) $)
    syl9 $p |- ( ph -> ( th -> ( ps -> ta ) ) ) $=
      wph wps wch wth wta syl9.1 wth wch wta wi wi wph syl9.2 a1i syl5d $.
  $}

  ${
    syl9r.1 $e |- ( ph -> ( ps -> ch ) ) $.
    syl9r.2 $e |- ( th -> ( ch -> ta ) ) $.
    $( A nested syllogism inference with different antecedents.  (Contributed
       by NM, 14-May-1993.) $)
    syl9r $p |- ( th -> ( ph -> ( ps -> ta ) ) ) $=
      wph wth wps wta wi wph wps wch wth wta syl9r.1 syl9r.2 syl9 com12 $.
  $}

  ${
    syl10.1 $e |- ( ph -> ( ps -> ch ) ) $.
    syl10.2 $e |- ( ph -> ( ps -> ( th -> ta ) ) ) $.
    syl10.3 $e |- ( ch -> ( ta -> et ) ) $.
    $( A nested syllogism inference.  (Contributed by Alan Sare,
       17-Jul-2011.) $)
    syl10 $p |- ( ph -> ( ps -> ( th -> et ) ) ) $=
      wph wps wth wta wet syl10.2 wph wps wch wta wet wi syl10.1 syl10.3 syl6
      syldd $.
  $}

  ${
    a1ddd.1 $e |- ( ph -> ( ps -> ( ch -> ta ) ) ) $.
    $( Triple deduction introducing an antecedent to a wff.  Deduction
       associated with ~ a1dd .  Double deduction associated with ~ a1d .
       Triple deduction associated with ~ ax-1 and ~ a1i .  (Contributed by
       Jeff Hankins, 4-Aug-2009.) $)
    a1ddd $p |- ( ph -> ( ps -> ( ch -> ( th -> ta ) ) ) ) $=
      wph wps wch wta wth wta wi a1ddd.1 wta wth ax-1 syl8 $.
  $}

  ${
    imim12d.1 $e |- ( ph -> ( ps -> ch ) ) $.
    imim12d.2 $e |- ( ph -> ( th -> ta ) ) $.
    $( Deduction combining antecedents and consequents.  Deduction associated
       with ~ imim12 and ~ imim12i .  (Contributed by NM, 7-Aug-1994.)  (Proof
       shortened by Mel L. O'Cat, 30-Oct-2011.) $)
    imim12d $p |- ( ph -> ( ( ch -> th ) -> ( ps -> ta ) ) ) $=
      wph wps wch wch wth wi wta imim12d.1 wph wth wta wch imim12d.2 imim2d
      syl5d $.
  $}

  ${
    imim1d.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Deduction adding nested consequents.  Deduction associated with ~ imim1
       and ~ imim1i .  (Contributed by NM, 3-Apr-1994.)  (Proof shortened by
       Wolf Lammen, 12-Sep-2012.) $)
    imim1d $p |- ( ph -> ( ( ch -> th ) -> ( ps -> th ) ) ) $=
      wph wps wch wth wth imim1d.1 wph wth idd imim12d $.
  $}

  $( A closed form of syllogism (see ~ syl ).  Theorem *2.06 of
     [WhiteheadRussell] p. 100.  Its associated inference is ~ imim1i .
     (Contributed by NM, 29-Dec-1992.)  (Proof shortened by Wolf Lammen,
     25-May-2013.) $)
  imim1 $p |- ( ( ph -> ps ) -> ( ( ps -> ch ) -> ( ph -> ch ) ) ) $=
    wph wps wi wph wps wch wph wps wi id imim1d $.

  $( Theorem *2.83 of [WhiteheadRussell] p. 108.  Closed form of ~ syld .
     (Contributed by NM, 3-Jan-2005.) $)
  pm2.83 $p |- ( ( ph -> ( ps -> ch ) )
      -> ( ( ph -> ( ch -> th ) ) -> ( ph -> ( ps -> th ) ) ) ) $=
    wps wch wi wch wth wi wps wth wi wph wps wch wth imim1 imim3i $.

  $( Over minimal implicational calculus, Peirce's axiom ~ peirce implies an
     axiom sometimes called "Roll",
     ` ( ( ( ph -> ps ) -> ch ) -> ( ( ch -> ph ) -> ph ) ) ` , of which
     ~ looinv is a special instance.  The converse also holds: substitute
     ` ( ph -> ps ) ` for ` ch ` in Roll and use ~ id and ~ ax-mp .
     (Contributed by BJ, 15-Jun-2021.) $)
  peirceroll $p |- ( ( ( ( ph -> ps ) -> ph ) -> ph )
                   -> ( ( ( ph -> ps ) -> ch ) -> ( ( ch -> ph ) -> ph ) ) ) $=
    wph wps wi wch wi wch wph wi wph wps wi wph wi wph wps wi wph wi wph wi wph
    wph wps wi wch wph imim1 wph wps wi wph wi wph wi id syl9r $.

  ${
    com3.1 $e |- ( ph -> ( ps -> ( ch -> th ) ) ) $.
    $( Commutation of antecedents.  Swap 2nd and 3rd.  Deduction associated
       with ~ com12 .  (Contributed by NM, 27-Dec-1992.)  (Proof shortened by
       Wolf Lammen, 4-Aug-2012.) $)
    com23 $p |- ( ph -> ( ch -> ( ps -> th ) ) ) $=
      wph wps wch wth wi wch wth com3.1 wch wth pm2.27 syl9 $.

    $( Commutation of antecedents.  Rotate right.  (Contributed by NM,
       25-Apr-1994.) $)
    com3r $p |- ( ch -> ( ph -> ( ps -> th ) ) ) $=
      wph wch wps wth wi wph wps wch wth com3.1 com23 com12 $.

    $( Commutation of antecedents.  Swap 1st and 3rd.  (Contributed by NM,
       25-Apr-1994.)  (Proof shortened by Wolf Lammen, 28-Jul-2012.) $)
    com13 $p |- ( ch -> ( ps -> ( ph -> th ) ) ) $=
      wch wph wps wth wph wps wch wth com3.1 com3r com23 $.

    $( Commutation of antecedents.  Rotate left.  (Contributed by NM,
       25-Apr-1994.)  (Proof shortened by Wolf Lammen, 28-Jul-2012.) $)
    com3l $p |- ( ps -> ( ch -> ( ph -> th ) ) ) $=
      wch wph wps wth wph wps wch wth com3.1 com3r com3r $.
  $}

  $( Swap antecedents.  Theorem *2.04 of [WhiteheadRussell] p. 100.  This was
     the third axiom in Frege's logic system, specifically Proposition 8 of
     [Frege1879] p. 35.  Its associated inference is ~ com12 .  (Contributed by
     NM, 27-Dec-1992.)  (Proof shortened by Wolf Lammen, 12-Sep-2012.) $)
  pm2.04 $p |- ( ( ph -> ( ps -> ch ) ) -> ( ps -> ( ph -> ch ) ) ) $=
    wph wps wch wi wi wph wps wch wph wps wch wi wi id com23 $.

  ${
    com4.1 $e |- ( ph -> ( ps -> ( ch -> ( th -> ta ) ) ) ) $.
    $( Commutation of antecedents.  Swap 3rd and 4th.  Deduction associated
       with ~ com23 .  Double deduction associated with ~ com12 .  (Contributed
       by NM, 25-Apr-1994.) $)
    com34 $p |- ( ph -> ( ps -> ( th -> ( ch -> ta ) ) ) ) $=
      wph wps wch wth wta wi wi wth wch wta wi wi com4.1 wch wth wta pm2.04
      syl6 $.

    $( Commutation of antecedents.  Rotate left.  (Contributed by NM,
       25-Apr-1994.)  (Proof shortened by Mel L. O'Cat, 15-Aug-2004.) $)
    com4l $p |- ( ps -> ( ch -> ( th -> ( ph -> ta ) ) ) ) $=
      wps wch wph wth wta wph wps wch wth wta wi com4.1 com3l com34 $.

    $( Commutation of antecedents.  Rotate twice.  (Contributed by NM,
       25-Apr-1994.) $)
    com4t $p |- ( ch -> ( th -> ( ph -> ( ps -> ta ) ) ) ) $=
      wps wch wth wph wta wph wps wch wth wta com4.1 com4l com4l $.

    $( Commutation of antecedents.  Rotate right.  (Contributed by NM,
       25-Apr-1994.) $)
    com4r $p |- ( th -> ( ph -> ( ps -> ( ch -> ta ) ) ) ) $=
      wch wth wph wps wta wph wps wch wth wta com4.1 com4t com4l $.

    $( Commutation of antecedents.  Swap 2nd and 4th.  Deduction associated
       with ~ com13 .  (Contributed by NM, 25-Apr-1994.)  (Proof shortened by
       Wolf Lammen, 28-Jul-2012.) $)
    com24 $p |- ( ph -> ( th -> ( ch -> ( ps -> ta ) ) ) ) $=
      wch wth wph wps wta wi wph wps wch wth wta com4.1 com4t com13 $.

    $( Commutation of antecedents.  Swap 1st and 4th.  (Contributed by NM,
       25-Apr-1994.)  (Proof shortened by Wolf Lammen, 28-Jul-2012.) $)
    com14 $p |- ( th -> ( ps -> ( ch -> ( ph -> ta ) ) ) ) $=
      wps wch wth wph wta wi wph wps wch wth wta com4.1 com4l com3r $.
  $}

  ${
    com5.1 $e |- ( ph -> ( ps -> ( ch -> ( th -> ( ta -> et ) ) ) ) ) $.
    $( Commutation of antecedents.  Swap 4th and 5th.  Deduction associated
       with ~ com34 .  Double deduction associated with ~ com23 .  Triple
       deduction associated with ~ com12 .  (Contributed by Jeff Hankins,
       28-Jun-2009.) $)
    com45 $p |- ( ph -> ( ps -> ( ch -> ( ta -> ( th -> et ) ) ) ) ) $=
      wph wps wch wth wta wet wi wi wta wth wet wi wi com5.1 wth wta wet pm2.04
      syl8 $.

    $( Commutation of antecedents.  Swap 3rd and 5th.  Deduction associated
       with ~ com24 .  Double deduction associated with ~ com13 .  (Contributed
       by Jeff Hankins, 28-Jun-2009.) $)
    com35 $p |- ( ph -> ( ps -> ( ta -> ( th -> ( ch -> et ) ) ) ) ) $=
      wph wps wth wta wch wet wi wph wps wth wch wta wet wph wps wch wth wta
      wet wi com5.1 com34 com45 com34 $.

    $( Commutation of antecedents.  Swap 2nd and 5th.  Deduction associated
       with ~ com14 .  (Contributed by Jeff Hankins, 28-Jun-2009.) $)
    com25 $p |- ( ph -> ( ta -> ( ch -> ( th -> ( ps -> et ) ) ) ) ) $=
      wph wth wch wta wps wet wi wph wth wch wps wta wet wph wps wch wth wta
      wet wi com5.1 com24 com45 com24 $.

    $( Commutation of antecedents.  Rotate left.  (Contributed by Jeff Hankins,
       28-Jun-2009.)  (Proof shortened by Wolf Lammen, 29-Jul-2012.) $)
    com5l $p |- ( ps -> ( ch -> ( th -> ( ta -> ( ph -> et ) ) ) ) ) $=
      wps wch wth wph wta wet wph wps wch wth wta wet wi com5.1 com4l com45 $.

    $( Commutation of antecedents.  Swap 1st and 5th.  (Contributed by Jeff
       Hankins, 28-Jun-2009.)  (Proof shortened by Wolf Lammen,
       29-Jul-2012.) $)
    com15 $p |- ( ta -> ( ps -> ( ch -> ( th -> ( ph -> et ) ) ) ) ) $=
      wps wch wth wta wph wet wi wph wps wch wth wta wet com5.1 com5l com4r $.

    $( Commutation of antecedents.  Rotate left twice.  (Contributed by Jeff
       Hankins, 28-Jun-2009.) $)
    com52l $p |- ( ch -> ( th -> ( ta -> ( ph -> ( ps -> et ) ) ) ) ) $=
      wps wch wth wta wph wet wph wps wch wth wta wet com5.1 com5l com5l $.

    $( Commutation of antecedents.  Rotate right twice.  (Contributed by Jeff
       Hankins, 28-Jun-2009.) $)
    com52r $p |- ( th -> ( ta -> ( ph -> ( ps -> ( ch -> et ) ) ) ) ) $=
      wch wth wta wph wps wet wph wps wch wth wta wet com5.1 com52l com5l $.

    $( Commutation of antecedents.  Rotate right.  (Contributed by Wolf Lammen,
       29-Jul-2012.) $)
    com5r $p |- ( ta -> ( ph -> ( ps -> ( ch -> ( th -> et ) ) ) ) ) $=
      wch wth wta wph wps wet wph wps wch wth wta wet com5.1 com52l com52l $.
  $}

  $( Closed form of ~ imim12i and of ~ 3syl .  (Contributed by BJ,
     16-Jul-2019.) $)
  imim12 $p |- ( ( ph -> ps ) ->
                      ( ( ch -> th ) -> ( ( ps -> ch ) -> ( ph -> th ) ) ) ) $=
    wch wth wi wps wch wi wps wth wi wph wps wi wph wth wi wch wth wps imim2
    wph wps wth imim1 syl9r $.

  $( Elimination of a nested antecedent.  Sometimes called "Syll-Simp" since it
     is a syllogism applied to ~ ax-1 ("Simplification").  (Contributed by Wolf
     Lammen, 9-May-2013.) $)
  jarr $p |- ( ( ( ph -> ps ) -> ch ) -> ( ps -> ch ) ) $=
    wps wph wps wi wch wps wph ax-1 imim1i $.

  ${
    jarri.1 $e |- ( ( ph -> ps ) -> ch ) $.
    $( Inference associated with ~ jarr .  Partial converse of ~ ja (the other
       partial converse being ~ jarli ).  (Contributed by Wolf Lammen,
       20-Sep-2013.) $)
    jarri $p |- ( ps -> ch ) $=
      wps wph wps wi wch wps wph ax-1 jarri.1 syl $.
  $}

  ${
    pm2.86d.1 $e |- ( ph -> ( ( ps -> ch ) -> ( ps -> th ) ) ) $.
    $( Deduction associated with ~ pm2.86 .  (Contributed by NM, 29-Jun-1995.)
       (Proof shortened by Wolf Lammen, 3-Apr-2013.) $)
    pm2.86d $p |- ( ph -> ( ps -> ( ch -> th ) ) ) $=
      wph wch wps wth wch wps wch wi wph wps wth wi wch wps ax-1 pm2.86d.1 syl5
      com23 $.
  $}

  $( Converse of Axiom ~ ax-2 .  Theorem *2.86 of [WhiteheadRussell] p. 108.
     (Contributed by NM, 25-Apr-1994.)  (Proof shortened by Wolf Lammen,
     3-Apr-2013.) $)
  pm2.86 $p |- ( ( ( ph -> ps ) -> ( ph -> ch ) ) ->
                                                    ( ph -> ( ps -> ch ) ) ) $=
    wph wps wi wph wch wi wi wph wps wch wph wps wi wph wch wi wi id pm2.86d $.

  ${
    pm2.86i.1 $e |- ( ( ph -> ps ) -> ( ph -> ch ) ) $.
    $( Inference associated with ~ pm2.86 .  (Contributed by NM, 5-Aug-1993.)
       (Proof shortened by Wolf Lammen, 3-Apr-2013.) $)
    pm2.86i $p |- ( ph -> ( ps -> ch ) ) $=
      wps wph wch wph wps wph wch wi pm2.86i.1 jarri com12 $.
  $}

  $( The Linearity Axiom of the infinite-valued sentential logic (L-infinity)
     of Lukasiewicz.  See ~ loowoz for an alternate axiom.  (Contributed by Mel
     L. O'Cat, 12-Aug-2004.) $)
  loolin $p |- ( ( ( ph -> ps ) -> ( ps -> ph ) ) -> ( ps -> ph ) ) $=
    wph wps wi wps wph wi wi wps wph wph wps wps wph wi jarr pm2.43d $.

  $( An alternate for the Linearity Axiom of the infinite-valued sentential
     logic (L-infinity) of Lukasiewicz ~ loolin , due to Barbara Wozniakowska,
     _Reports on Mathematical Logic_ 10, 129-137 (1978).  (Contributed by Mel
     L. O'Cat, 8-Aug-2004.) $)
  loowoz $p |- ( ( ( ph -> ps ) -> ( ph -> ch ) )
      -> ( ( ps -> ph ) -> ( ps -> ch ) ) ) $=
    wph wps wi wph wch wi wi wps wph wch wph wps wph wch wi jarr a2d $.


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Logical negation
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  This section makes our first use of the third axiom of propositional
  calculus, ~ ax-3 .  It introduces logical negation.

$)

  $( Alias for ~ ax-3 to be used instead of it for labeling consistency.  Its
     associated inference is ~ con4i and its associated deduction is ~ con4d .
     (Contributed by BJ, 24-Dec-2020.) $)
  con4 $p |- ( ( -. ph -> -. ps ) -> ( ps -> ph ) ) $=
    wph wps ax-3 $.

  ${
    con4i.1 $e |- ( -. ph -> -. ps ) $.
    $( Inference associated with ~ con4 .  Its associated inference is ~ mt4 .

       Remark: this can also be proved using ~ notnot followed by ~ nsyl2 ,
       giving a shorter proof but depending on more axioms (namely, ~ ax-1 and
       ~ ax-2 ).  (Contributed by NM, 29-Dec-1992.) $)
    con4i $p |- ( ps -> ph ) $=
      wph wn wps wn wi wps wph wi con4i.1 wph wps con4 ax-mp $.
    $( $j usage 'con4i' avoids 'ax-1' 'ax-2'; $)
  $}

  ${
    con4d.1 $e |- ( ph -> ( -. ps -> -. ch ) ) $.
    $( Deduction associated with ~ con4 .  (Contributed by NM, 26-Mar-1995.) $)
    con4d $p |- ( ph -> ( ch -> ps ) ) $=
      wph wps wn wch wn wi wch wps wi con4d.1 wps wch con4 syl $.
  $}

  ${
    mt4.1 $e |- ph $.
    mt4.2 $e |- ( -. ps -> -. ph ) $.
    $( The rule of modus tollens.  Inference associated with ~ con4i .
       (Contributed by Wolf Lammen, 12-May-2013.) $)
    mt4 $p |- ps $=
      wph wps mt4.1 wps wph mt4.2 con4i ax-mp $.
  $}

  ${
    mt4d.1 $e |- ( ph -> ps ) $.
    mt4d.2 $e |- ( ph -> ( -. ch -> -. ps ) ) $.
    $( Modus tollens deduction.  Deduction form of ~ mt4 .  (Contributed by NM,
       9-Jun-2006.) $)
    mt4d $p |- ( ph -> ch ) $=
      wph wps wch mt4d.1 wph wch wps mt4d.2 con4d mpd $.
  $}

  ${
    mt4i.1 $e |- ch $.
    mt4i.2 $e |- ( ph -> ( -. ps -> -. ch ) ) $.
    $( Modus tollens inference.  (Contributed by Wolf Lammen, 12-May-2013.) $)
    mt4i $p |- ( ph -> ps ) $=
      wph wch wps wch wph mt4i.1 a1i mt4i.2 mt4d $.
  $}

  ${
    pm2.21i.1 $e |- -. ph $.
    $( A contradiction implies anything.  Inference associated with ~ pm2.21 .
       Its associated inference is ~ pm2.24ii .  (Contributed by NM,
       16-Sep-1993.) $)
    pm2.21i $p |- ( ph -> ps ) $=
      wps wph wph wn wps wn pm2.21i.1 a1i con4i $.
  $}

  ${
    pm2.24ii.1 $e |- ph $.
    pm2.24ii.2 $e |- -. ph $.
    $( A contradiction implies anything.  Inference associated with ~ pm2.21i
       and ~ pm2.24i .  (Contributed by NM, 27-Feb-2008.) $)
    pm2.24ii $p |- ps $=
      wph wps pm2.24ii.1 wph wps pm2.24ii.2 pm2.21i ax-mp $.
    $( $j usage 'pm2.24ii' avoids 'ax-2'; $)
  $}

  ${
    pm2.21d.1 $e |- ( ph -> -. ps ) $.
    $( A contradiction implies anything.  Deduction associated with ~ pm2.21 .
       (Contributed by NM, 10-Feb-1996.) $)
    pm2.21d $p |- ( ph -> ( ps -> ch ) ) $=
      wph wch wps wph wps wn wch wn pm2.21d.1 a1d con4d $.
  $}

  ${
    pm2.21ddALT.1 $e |- ( ph -> ps ) $.
    pm2.21ddALT.2 $e |- ( ph -> -. ps ) $.
    $( Alternate proof of ~ pm2.21dd .  (Contributed by Mario Carneiro,
       9-Feb-2017.)  (Proof modification is discouraged.)
       (New usage is discouraged.) $)
    pm2.21ddALT $p |- ( ph -> ch ) $=
      wph wps wch pm2.21ddALT.1 wph wps wch pm2.21ddALT.2 pm2.21d mpd $.
  $}

  $( From a wff and its negation, anything follows.  Theorem *2.21 of
     [WhiteheadRussell] p. 104.  Also called the Duns Scotus law.  Its commuted
     form is ~ pm2.24 and its associated inference is ~ pm2.21i .  (Contributed
     by NM, 29-Dec-1992.)  (Proof shortened by Wolf Lammen, 14-Sep-2012.) $)
  pm2.21 $p |- ( -. ph -> ( ph -> ps ) ) $=
    wph wn wph wps wph wn id pm2.21d $.

  $( Theorem *2.24 of [WhiteheadRussell] p. 104.  Its associated inference is
     ~ pm2.24i .  Commuted form of ~ pm2.21 .  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.24 $p |- ( ph -> ( -. ph -> ps ) ) $=
    wph wn wph wps wph wps pm2.21 com12 $.

  $( Elimination of a nested antecedent.  (Contributed by Wolf Lammen,
     10-May-2013.) $)
  jarl $p |- ( ( ( ph -> ps ) -> ch ) -> ( -. ph -> ch ) ) $=
    wph wn wph wps wi wch wph wps pm2.21 imim1i $.

  ${
    jarli.1 $e |- ( ( ph -> ps ) -> ch ) $.
    $( Inference associated with ~ jarl .  Partial converse of ~ ja (the other
       partial converse being ~ jarri ).  (Contributed by Wolf Lammen,
       4-Oct-2013.) $)
    jarli $p |- ( -. ph -> ch ) $=
      wph wn wph wps wi wch wph wps pm2.21 jarli.1 syl $.
  $}

  ${
    pm2.18d.1 $e |- ( ph -> ( -. ps -> ps ) ) $.
    $( Deduction form of the Clavius law ~ pm2.18 .  (Contributed by FL,
       12-Jul-2009.)  (Proof shortened by Andrew Salmon, 7-May-2011.)  Shorten
       ~ pm2.18 .  (Revised by Wolf Lammen, 17-Nov-2023.) $)
    pm2.18d $p |- ( ph -> ps ) $=
      wph wph wps wph id wph wps wn wps wph wn pm2.18d.1 wps wph wn pm2.21
      sylcom mt4d $.
  $}

  $( Clavius law, or "consequentia mirabilis" ("admirable consequence").  If a
     formula is implied by its negation, then it is true.  Can be used in
     proofs by contradiction.  Theorem *2.18 of [WhiteheadRussell] p. 103.  See
     also the weak Clavius law ~ pm2.01 .  (Contributed by NM, 29-Dec-1992.)
     (Proof shortened by Wolf Lammen, 17-Nov-2023.) $)
  pm2.18 $p |- ( ( -. ph -> ph ) -> ph ) $=
    wph wn wph wi wph wph wn wph wi id pm2.18d $.

  ${
    pm2.18i.1 $e |- ( -. ph -> ph ) $.
    $( Inference associated with the Clavius law ~ pm2.18 .  (Contributed by
       BJ, 30-Mar-2020.) $)
    pm2.18i $p |- ph $=
      wph wn wph wi wph pm2.18i.1 wph pm2.18 ax-mp $.
  $}

  $( Double negation elimination.  Converse of ~ notnot and one implication of
     ~ notnotb .  Theorem *2.14 of [WhiteheadRussell] p. 102.  This was the
     fifth axiom of Frege, specifically Proposition 31 of [Frege1879] p. 44.
     In classical logic (our logic) this is always true.  In intuitionistic
     logic this is not always true, and formulas for which it is true are
     called "stable".  (Contributed by NM, 29-Dec-1992.)  (Proof shortened by
     David Harvey, 5-Sep-1999.)  (Proof shortened by Josh Purinton,
     29-Dec-2000.) $)
  notnotr $p |- ( -. -. ph -> ph ) $=
    wph wn wph wph wph pm2.18 jarli $.

  ${
    notnotri.1 $e |- -. -. ph $.
    $( Inference associated with ~ notnotr .  For a shorter proof using
       ~ ax-2 , see ~ notnotriALT .  (Contributed by NM, 27-Feb-2008.)  (Proof
       shortened by Wolf Lammen, 15-Jul-2021.)  Remove dependency on ~ ax-2 .
       (Revised by Steven Nguyen, 27-Dec-2022.) $)
    notnotri $p |- ph $=
      wph wn wn wph notnotri.1 wph wn wph wn wn wn notnotri.1 pm2.21i mt4 $.
    $( $j usage 'notnotri' avoids 'ax-2'; $)

    $( Alternate proof of ~ notnotri .  The proof via ~ notnotr and ~ ax-mp
       also has three essential steps, but has a total number of steps equal to
       8, instead of the present 7, because it has to construct the formula
       ` ph ` twice and the formula ` -. -. ph ` once, whereas the present
       proof has to construct the formula ` ph ` twice and the formula
       ` -. ph ` once, and therefore makes only one use of ~ wn instead of two.
       This can be checked by running the Metamath command "MM> SHOW PROOF
       notnotri / NORMAL".  (Contributed by NM, 27-Feb-2008.)  (Proof shortened
       by Wolf Lammen, 15-Jul-2021.)  (Proof modification is discouraged.)
       (New usage is discouraged.) $)
    notnotriALT $p |- ph $=
      wph wph wn wph notnotri.1 pm2.21i pm2.18i $.
  $}

  ${
    notnotrd.1 $e |- ( ph -> -. -. ps ) $.
    $( Deduction associated with ~ notnotr and ~ notnotri .  Double negation
       elimination rule.  A translation of the natural deduction rule ` -. -. `
       C , ` _G |- -. -. ps => _G |- ps ` ; see ~ natded .  This is Definition
       NNC in [Pfenning] p. 17.  This rule is valid in classical logic (our
       logic), but not in intuitionistic logic.  (Contributed by DAW,
       8-Feb-2017.) $)
    notnotrd $p |- ( ph -> ps ) $=
      wph wps wn wn wps notnotrd.1 wps notnotr syl $.
  $}

  ${
    con2d.1 $e |- ( ph -> ( ps -> -. ch ) ) $.
    $( A contraposition deduction.  (Contributed by NM, 19-Aug-1993.) $)
    con2d $p |- ( ph -> ( ch -> -. ps ) ) $=
      wph wps wn wch wps wn wn wps wph wch wn wps notnotr con2d.1 syl5 con4d $.
  $}

  $( Contraposition.  Theorem *2.03 of [WhiteheadRussell] p. 100.  (Contributed
     by NM, 29-Dec-1992.)  (Proof shortened by Wolf Lammen, 12-Feb-2013.) $)
  con2 $p |- ( ( ph -> -. ps ) -> ( ps -> -. ph ) ) $=
    wph wps wn wi wph wps wph wps wn wi id con2d $.

  ${
    mt2d.1 $e |- ( ph -> ch ) $.
    mt2d.2 $e |- ( ph -> ( ps -> -. ch ) ) $.
    $( Modus tollens deduction.  (Contributed by NM, 4-Jul-1994.) $)
    mt2d $p |- ( ph -> -. ps ) $=
      wph wch wps wn mt2d.1 wph wps wch mt2d.2 con2d mpd $.
  $}

  ${
    mt2i.1 $e |- ch $.
    mt2i.2 $e |- ( ph -> ( ps -> -. ch ) ) $.
    $( Modus tollens inference.  (Contributed by NM, 26-Mar-1995.)  (Proof
       shortened by Wolf Lammen, 15-Sep-2012.) $)
    mt2i $p |- ( ph -> -. ps ) $=
      wph wps wch wch wph mt2i.1 a1i mt2i.2 mt2d $.
  $}

  ${
    nsyl3.1 $e |- ( ph -> -. ps ) $.
    nsyl3.2 $e |- ( ch -> ps ) $.
    $( A negated syllogism inference.  (Contributed by NM, 1-Dec-1995.) $)
    nsyl3 $p |- ( ch -> -. ph ) $=
      wch wph wps nsyl3.2 wph wps wn wi wch nsyl3.1 a1i mt2d $.
  $}

  ${
    con2i.a $e |- ( ph -> -. ps ) $.
    $( A contraposition inference.  Its associated inference is ~ mt2 .
       (Contributed by NM, 10-Jan-1993.)  (Proof shortened by Mel L. O'Cat,
       28-Nov-2008.)  (Proof shortened by Wolf Lammen, 13-Jun-2013.) $)
    con2i $p |- ( ps -> -. ph ) $=
      wph wps wps con2i.a wps id nsyl3 $.
  $}

  ${
    nsyl.1 $e |- ( ph -> -. ps ) $.
    nsyl.2 $e |- ( ch -> ps ) $.
    $( A negated syllogism inference.  (Contributed by NM, 31-Dec-1993.)
       (Proof shortened by Wolf Lammen, 2-Mar-2013.) $)
    nsyl $p |- ( ph -> -. ch ) $=
      wch wph wph wps wch nsyl.1 nsyl.2 nsyl3 con2i $.
  $}

  ${
    nsyl2.1 $e |- ( ph -> -. ps ) $.
    nsyl2.2 $e |- ( -. ch -> ps ) $.
    $( A negated syllogism inference.  (Contributed by NM, 26-Jun-1994.)
       (Proof shortened by Wolf Lammen, 14-Nov-2023.) $)
    nsyl2 $p |- ( ph -> ch ) $=
      wch wph wph wps wch wn nsyl2.1 nsyl2.2 nsyl3 con4i $.
  $}

  $( Double negation introduction.  Converse of ~ notnotr and one implication
     of ~ notnotb .  Theorem *2.12 of [WhiteheadRussell] p. 101.  This was the
     sixth axiom of Frege, specifically Proposition 41 of [Frege1879] p. 47.
     (Contributed by NM, 28-Dec-1992.)  (Proof shortened by Wolf Lammen,
     2-Mar-2013.) $)
  notnot $p |- ( ph -> -. -. ph ) $=
    wph wn wph wph wn id con2i $.

  ${
    notnoti.1 $e |- ph $.
    $( Inference associated with ~ notnot .  (Contributed by NM,
       27-Feb-2008.) $)
    notnoti $p |- -. -. ph $=
      wph wph wn wn notnoti.1 wph notnot ax-mp $.
  $}

  ${
    notnotd.1 $e |- ( ph -> ps ) $.
    $( Deduction associated with ~ notnot and ~ notnoti .  (Contributed by
       Jarvin Udandy, 2-Sep-2016.)  Avoid biconditional.  (Revised by Wolf
       Lammen, 27-Mar-2021.) $)
    notnotd $p |- ( ph -> -. -. ps ) $=
      wph wps wps wn wn notnotd.1 wps notnot syl $.
  $}

  ${
    con1d.1 $e |- ( ph -> ( -. ps -> ch ) ) $.
    $( A contraposition deduction.  (Contributed by NM, 27-Dec-1992.) $)
    con1d $p |- ( ph -> ( -. ch -> ps ) ) $=
      wph wps wch wn wph wps wn wch wch wn wn con1d.1 wch notnot syl6 con4d $.
  $}

  $( Contraposition.  Theorem *2.15 of [WhiteheadRussell] p. 102.  Its
     associated inference is ~ con1i .  (Contributed by NM, 29-Dec-1992.)
     (Proof shortened by Wolf Lammen, 12-Feb-2013.) $)
  con1 $p |- ( ( -. ph -> ps ) -> ( -. ps -> ph ) ) $=
    wph wn wps wi wph wps wph wn wps wi id con1d $.

  ${
    con1i.1 $e |- ( -. ph -> ps ) $.
    $( A contraposition inference.  Inference associated with ~ con1 .  Its
       associated inference is ~ mt3 .  (Contributed by NM, 3-Jan-1993.)
       (Proof shortened by Mel L. O'Cat, 28-Nov-2008.)  (Proof shortened by
       Wolf Lammen, 19-Jun-2013.) $)
    con1i $p |- ( -. ps -> ph ) $=
      wps wn wps wph wps wn id con1i.1 nsyl2 $.
  $}

  ${
    mt3d.1 $e |- ( ph -> -. ch ) $.
    mt3d.2 $e |- ( ph -> ( -. ps -> ch ) ) $.
    $( Modus tollens deduction.  (Contributed by NM, 26-Mar-1995.) $)
    mt3d $p |- ( ph -> ps ) $=
      wph wch wn wps mt3d.1 wph wps wch mt3d.2 con1d mpd $.
  $}

  ${
    mt3i.1 $e |- -. ch $.
    mt3i.2 $e |- ( ph -> ( -. ps -> ch ) ) $.
    $( Modus tollens inference.  (Contributed by NM, 26-Mar-1995.)  (Proof
       shortened by Wolf Lammen, 15-Sep-2012.) $)
    mt3i $p |- ( ph -> ps ) $=
      wph wps wch wch wn wph mt3i.1 a1i mt3i.2 mt3d $.
  $}

  ${
    pm2.24i.1 $e |- ph $.
    $( Inference associated with ~ pm2.24 .  Its associated inference is
       ~ pm2.24ii .  (Contributed by NM, 20-Aug-2001.) $)
    pm2.24i $p |- ( -. ph -> ps ) $=
      wps wph wph wps wn pm2.24i.1 a1i con1i $.
  $}

  ${
    pm2.24d.1 $e |- ( ph -> ps ) $.
    $( Deduction form of ~ pm2.24 .  (Contributed by NM, 30-Jan-2006.) $)
    pm2.24d $p |- ( ph -> ( -. ps -> ch ) ) $=
      wph wch wps wph wps wch wn pm2.24d.1 a1d con1d $.
  $}

  ${
    con3d.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( A contraposition deduction.  Deduction form of ~ con3 .  (Contributed by
       NM, 10-Jan-1993.) $)
    con3d $p |- ( ph -> ( -. ch -> -. ps ) ) $=
      wph wps wn wch wps wn wn wps wph wch wps notnotr con3d.1 syl5 con1d $.
  $}

  $( Contraposition.  Theorem *2.16 of [WhiteheadRussell] p. 103.  This was the
     fourth axiom of Frege, specifically Proposition 28 of [Frege1879] p. 43.
     Its associated inference is ~ con3i .  (Contributed by NM, 29-Dec-1992.)
     (Proof shortened by Wolf Lammen, 13-Feb-2013.) $)
  con3 $p |- ( ( ph -> ps ) -> ( -. ps -> -. ph ) ) $=
    wph wps wi wph wps wph wps wi id con3d $.

  ${
    con3i.a $e |- ( ph -> ps ) $.
    $( A contraposition inference.  Inference associated with ~ con3 .  Its
       associated inference is ~ mto .  (Contributed by NM, 3-Jan-1993.)
       (Proof shortened by Wolf Lammen, 20-Jun-2013.) $)
    con3i $p |- ( -. ps -> -. ph ) $=
      wps wn wps wph wps wn id con3i.a nsyl $.
  $}

  ${
    con3rr3.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Rotate through consequent right.  (Contributed by Wolf Lammen,
       3-Nov-2013.) $)
    con3rr3 $p |- ( -. ch -> ( ph -> -. ps ) ) $=
      wph wch wn wps wn wph wps wch con3rr3.1 con3d com12 $.
  $}

  ${
    nsyld.1 $e |- ( ph -> ( ps -> -. ch ) ) $.
    nsyld.2 $e |- ( ph -> ( ta -> ch ) ) $.
    $( A negated syllogism deduction.  (Contributed by NM, 9-Apr-2005.) $)
    nsyld $p |- ( ph -> ( ps -> -. ta ) ) $=
      wph wps wch wn wta wn nsyld.1 wph wta wch nsyld.2 con3d syld $.
  $}

  ${
    nsyli.1 $e |- ( ph -> ( ps -> ch ) ) $.
    nsyli.2 $e |- ( th -> -. ch ) $.
    $( A negated syllogism inference.  (Contributed by NM, 3-May-1994.) $)
    nsyli $p |- ( ph -> ( th -> -. ps ) ) $=
      wth wch wn wph wps wn nsyli.2 wph wps wch nsyli.1 con3d syl5 $.
  $}

  ${
    nsyl4.1 $e |- ( ph -> ps ) $.
    nsyl4.2 $e |- ( -. ph -> ch ) $.
    $( A negated syllogism inference.  (Contributed by NM, 15-Feb-1996.) $)
    nsyl4 $p |- ( -. ch -> ps ) $=
      wch wn wph wps wph wch nsyl4.2 con1i nsyl4.1 syl $.

    $( A negated syllogism inference.  (Contributed by Wolf Lammen,
       20-May-2024.) $)
    nsyl5 $p |- ( -. ps -> ch ) $=
      wch wps wph wps wch nsyl4.1 nsyl4.2 nsyl4 con1i $.
  $}

  $( Theorem *3.2 of [WhiteheadRussell] p. 111, expressed with primitive
     connectives (see ~ pm3.2 ).  (Contributed by NM, 29-Dec-1992.)  (Proof
     shortened by Josh Purinton, 29-Dec-2000.) $)
  pm3.2im $p |- ( ph -> ( ps -> -. ( ph -> -. ps ) ) ) $=
    wph wph wps wn wi wps wph wps wn pm2.27 con2d $.

  ${
    jc.1 $e |- ( ph -> ps ) $.
    jc.2 $e |- ( ph -> ch ) $.
    $( Deduction joining the consequents of two premises.  A deduction
       associated with ~ pm3.2im .  (Contributed by NM, 28-Dec-1992.) $)
    jc $p |- ( ph -> -. ( ps -> -. ch ) ) $=
      wph wps wch wps wch wn wi wn jc.1 jc.2 wps wch pm3.2im sylc $.
  $}

  $( Theorem joining the consequents of two premises.  Theorem 8 of [Margaris]
     p. 60.  (Contributed by NM, 5-Aug-1993.)  (Proof shortened by Josh
     Purinton, 29-Dec-2000.) $)
  jcn $p |- ( ph -> ( -. ps -> -. ( ph -> ps ) ) ) $=
    wph wph wps wi wps wph wps pm2.27 con3d $.

  ${
    jcnd.1 $e |- ( ph -> ps ) $.
    jcnd.2 $e |- ( ph -> -. ch ) $.
    $( Deduction joining the consequents of two premises.  (Contributed by
       Glauco Siliprandi, 11-Dec-2019.)  (Proof shortened by Wolf Lammen,
       10-Apr-2024.) $)
    jcnd $p |- ( ph -> -. ( ps -> ch ) ) $=
      wph wps wch wn wps wch wi wn jcnd.1 jcnd.2 wps wch jcn sylc $.
  $}

  ${
    impi.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( An importation inference.  (Contributed by NM, 29-Dec-1992.)  (Proof
       shortened by Wolf Lammen, 20-Jul-2013.) $)
    impi $p |- ( -. ( ph -> -. ps ) -> ch ) $=
      wch wph wps wn wi wph wps wch impi.1 con3rr3 con1i $.
  $}

  ${
    expi.1 $e |- ( -. ( ph -> -. ps ) -> ch ) $.
    $( An exportation inference.  (Contributed by NM, 29-Dec-1992.)  (Proof
       shortened by Mel L. O'Cat, 28-Nov-2008.) $)
    expi $p |- ( ph -> ( ps -> ch ) ) $=
      wph wps wph wps wn wi wn wch wph wps pm3.2im expi.1 syl6 $.
  $}

  $( Simplification.  Similar to Theorem *3.27 (Simp) of [WhiteheadRussell]
     p. 112.  (Contributed by NM, 3-Jan-1993.)  (Proof shortened by Wolf
     Lammen, 13-Nov-2012.) $)
  simprim $p |- ( -. ( ph -> -. ps ) -> ps ) $=
    wph wps wps wph wps idd impi $.

  $( Simplification.  Similar to Theorem *3.26 (Simp) of [WhiteheadRussell]
     p. 112.  (Contributed by NM, 3-Jan-1993.)  (Proof shortened by Wolf
     Lammen, 21-Jul-2012.) $)
  simplim $p |- ( -. ( ph -> ps ) -> ph ) $=
    wph wph wps wi wph wps pm2.21 con1i $.

  $( General instance of Theorem *2.5 of [WhiteheadRussell] p. 107.
     (Contributed by NM, 3-Jan-2005.)  (Proof shortened by Wolf Lammen,
     9-Oct-2012.) $)
  pm2.5g $p |- ( -. ( ph -> ps ) -> ( -. ph -> ch ) ) $=
    wph wps wi wn wph wch wph wps simplim pm2.24d $.

  $( Theorem *2.5 of [WhiteheadRussell] p. 107.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.5 $p |- ( -. ( ph -> ps ) -> ( -. ph -> ps ) ) $=
    wph wps wps pm2.5g $.

  $( Contrapositive of ~ ax-1 .  (Contributed by BJ, 28-Oct-2023.) $)
  conax1 $p |- ( -. ( ph -> ps ) -> -. ps ) $=
    wps wph wps wi wps wph ax-1 con3i $.

  $( Weakening of ~ conax1 .  General instance of ~ pm2.51 and of ~ pm2.52 .
     (Contributed by BJ, 28-Oct-2023.) $)
  conax1k $p |- ( -. ( ph -> ps ) -> ( ch -> -. ps ) ) $=
    wph wps wi wn wps wn wch wph wps conax1 a1d $.

  $( Theorem *2.51 of [WhiteheadRussell] p. 107.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.51 $p |- ( -. ( ph -> ps ) -> ( ph -> -. ps ) ) $=
    wph wps wph conax1k $.

  $( Theorem *2.52 of [WhiteheadRussell] p. 107.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 8-Oct-2012.) $)
  pm2.52 $p |- ( -. ( ph -> ps ) -> ( -. ph -> -. ps ) ) $=
    wph wps wph wn conax1k $.

  $( A general instance of Theorem *2.521 of [WhiteheadRussell] p. 107.
     (Contributed by BJ, 28-Oct-2023.) $)
  pm2.521g $p |- ( -. ( ph -> ps ) -> ( ps -> ch ) ) $=
    wph wps wi wn wps wch wph wps conax1 pm2.21d $.

  $( A general instance of Theorem *2.521 of [WhiteheadRussell] p. 107.
     (Contributed by NM, 3-Jan-2005.)  (Proof shortened by Wolf Lammen,
     8-Oct-2012.) $)
  pm2.521g2 $p |- ( -. ( ph -> ps ) -> ( ch -> ph ) ) $=
    wph wps wi wn wph wch wph wps simplim a1d $.

  $( Theorem *2.521 of [WhiteheadRussell] p. 107.  Instance of ~ pm2.521g and
     of ~ pm2.521g2 .  (Contributed by NM, 3-Jan-2005.) $)
  pm2.521 $p |- ( -. ( ph -> ps ) -> ( ps -> ph ) ) $=
    wph wps wph pm2.521g $.

  $( Exportation theorem ~ pm3.3 (closed form of ~ ex ) expressed with
     primitive connectives.  (Contributed by NM, 28-Dec-1992.) $)
  expt $p |- ( ( -. ( ph -> -. ps ) -> ch ) -> ( ph -> ( ps -> ch ) ) ) $=
    wph wph wps wn wi wn wch wi wps wch wi wph wps wph wps wn wi wn wch wph wps
    pm3.2im imim1d com12 $.

  $( Importation theorem ~ pm3.1 (closed form of ~ imp ) expressed with
     primitive connectives.  (Contributed by NM, 25-Apr-1994.)  (Proof
     shortened by Wolf Lammen, 20-Jul-2013.) $)
  impt $p |- ( ( ph -> ( ps -> ch ) ) -> ( -. ( ph -> -. ps ) -> ch ) ) $=
    wph wps wch wi wi wph wps wn wi wn wps wch wph wps simprim wph wps wn wi wn
    wph wps wch wi wph wps wn simplim imim1i mpdi $.

  ${
    pm2.61d.1 $e |- ( ph -> ( ps -> ch ) ) $.
    pm2.61d.2 $e |- ( ph -> ( -. ps -> ch ) ) $.
    $( Deduction eliminating an antecedent.  (Contributed by NM, 27-Apr-1994.)
       (Proof shortened by Wolf Lammen, 12-Sep-2013.) $)
    pm2.61d $p |- ( ph -> ch ) $=
      wph wch wph wch wn wps wch wph wps wch pm2.61d.2 con1d pm2.61d.1 syld
      pm2.18d $.
  $}

  ${
    pm2.61d1.1 $e |- ( ph -> ( ps -> ch ) ) $.
    pm2.61d1.2 $e |- ( -. ps -> ch ) $.
    $( Inference eliminating an antecedent.  (Contributed by NM,
       15-Jul-2005.) $)
    pm2.61d1 $p |- ( ph -> ch ) $=
      wph wps wch pm2.61d1.1 wps wn wch wi wph pm2.61d1.2 a1i pm2.61d $.
  $}

  ${
    pm2.61d2.1 $e |- ( ph -> ( -. ps -> ch ) ) $.
    pm2.61d2.2 $e |- ( ps -> ch ) $.
    $( Inference eliminating an antecedent.  (Contributed by NM,
       18-Aug-1993.) $)
    pm2.61d2 $p |- ( ph -> ch ) $=
      wph wps wch wps wch wi wph pm2.61d2.2 a1i pm2.61d2.1 pm2.61d $.
  $}

  ${
    pm2.61i.1 $e |- ( ph -> ps ) $.
    pm2.61i.2 $e |- ( -. ph -> ps ) $.
    $( Inference eliminating an antecedent.  (Contributed by NM, 5-Apr-1994.)
       (Proof shortened by Wolf Lammen, 19-Nov-2023.) $)
    pm2.61i $p |- ps $=
      wps wph wps wps pm2.61i.1 pm2.61i.2 nsyl4 pm2.18i $.
  $}

  ${
    pm2.61ii.1 $e |- ( -. ph -> ( -. ps -> ch ) ) $.
    pm2.61ii.2 $e |- ( ph -> ch ) $.
    pm2.61ii.3 $e |- ( ps -> ch ) $.
    $( Inference eliminating two antecedents.  (Contributed by NM, 4-Jan-1993.)
       (Proof shortened by Josh Purinton, 29-Dec-2000.) $)
    pm2.61ii $p |- ch $=
      wph wch pm2.61ii.2 wph wn wps wch pm2.61ii.1 pm2.61ii.3 pm2.61d2 pm2.61i
      $.
  $}

  ${
    pm2.61nii.1 $e |- ( ph -> ( ps -> ch ) ) $.
    pm2.61nii.2 $e |- ( -. ph -> ch ) $.
    pm2.61nii.3 $e |- ( -. ps -> ch ) $.
    $( Inference eliminating two antecedents.  (Contributed by NM,
       13-Jul-2005.)  (Proof shortened by Andrew Salmon, 25-May-2011.)  (Proof
       shortened by Wolf Lammen, 13-Nov-2012.) $)
    pm2.61nii $p |- ch $=
      wph wch wph wps wch pm2.61nii.1 pm2.61nii.3 pm2.61d1 pm2.61nii.2 pm2.61i
      $.
  $}

  ${
    pm2.61iii.1 $e |- ( -. ph -> ( -. ps -> ( -. ch -> th ) ) ) $.
    pm2.61iii.2 $e |- ( ph -> th ) $.
    pm2.61iii.3 $e |- ( ps -> th ) $.
    pm2.61iii.4 $e |- ( ch -> th ) $.
    $( Inference eliminating three antecedents.  (Contributed by NM,
       2-Jan-2002.)  (Proof shortened by Wolf Lammen, 22-Sep-2013.) $)
    pm2.61iii $p |- th $=
      wch wth pm2.61iii.4 wph wps wch wn wth wi pm2.61iii.1 wph wth wch wn
      pm2.61iii.2 a1d wps wth wch wn pm2.61iii.3 a1d pm2.61ii pm2.61i $.
  $}

  ${
    ja.1 $e |- ( -. ph -> ch ) $.
    ja.2 $e |- ( ps -> ch ) $.
    $( Inference joining the antecedents of two premises.  For partial
       converses, see ~ jarri and ~ jarli .  (Contributed by NM, 24-Jan-1993.)
       (Proof shortened by Mel L. O'Cat, 19-Feb-2008.) $)
    ja $p |- ( ( ph -> ps ) -> ch ) $=
      wph wps wi wph wch wps wch wph ja.2 imim2i ja.1 pm2.61d1 $.
  $}

  ${
    jad.1 $e |- ( ph -> ( -. ps -> th ) ) $.
    jad.2 $e |- ( ph -> ( ch -> th ) ) $.
    $( Deduction form of ~ ja .  (Contributed by Scott Fenton, 13-Dec-2010.)
       (Proof shortened by Andrew Salmon, 17-Sep-2011.) $)
    jad $p |- ( ph -> ( ( ps -> ch ) -> th ) ) $=
      wps wch wi wph wth wps wch wph wth wi wph wps wn wth jad.1 com12 wph wch
      wth jad.2 com12 ja com12 $.
  $}

  $( Weak Clavius law.  If a formula implies its negation, then it is false.  A
     form of "reductio ad absurdum", which can be used in proofs by
     contradiction.  Theorem *2.01 of [WhiteheadRussell] p. 100.  Provable in
     minimal calculus, contrary to the Clavius law ~ pm2.18 .  (Contributed by
     NM, 18-Aug-1993.)  (Proof shortened by Mel L. O'Cat, 21-Nov-2008.)  (Proof
     shortened by Wolf Lammen, 31-Oct-2012.) $)
  pm2.01 $p |- ( ( ph -> -. ph ) -> -. ph ) $=
    wph wph wn wph wn wph wn id wph wn id ja $.

  ${
    pm2.01i.1 $e |- ( ph -> -. ph ) $.
    $( Inference associated with the weak Clavius law ~ pm2.01 .  (Contributed
       by BJ, 30-Mar-2020.) $)
    pm2.01i $p |- -. ph $=
      wph wph wn wi wph wn pm2.01i.1 wph pm2.01 ax-mp $.
  $}

  ${
    pm2.01d.1 $e |- ( ph -> ( ps -> -. ps ) ) $.
    $( Deduction based on reductio ad absurdum.  (Contributed by NM,
       18-Aug-1993.)  (Proof shortened by Wolf Lammen, 5-Mar-2013.) $)
    pm2.01d $p |- ( ph -> -. ps ) $=
      wph wps wps wn pm2.01d.1 wps wn id pm2.61d1 $.
  $}

  $( Theorem *2.6 of [WhiteheadRussell] p. 107.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.6 $p |- ( ( -. ph -> ps ) -> ( ( ph -> ps ) -> ps ) ) $=
    wph wn wps wi wph wps wps wph wn wps wi id wph wn wps wi wps idd jad $.

  $( Theorem *2.61 of [WhiteheadRussell] p. 107.  Useful for eliminating an
     antecedent.  (Contributed by NM, 4-Jan-1993.)  (Proof shortened by Wolf
     Lammen, 22-Sep-2013.) $)
  pm2.61 $p |- ( ( ph -> ps ) -> ( ( -. ph -> ps ) -> ps ) ) $=
    wph wn wps wi wph wps wi wps wph wps pm2.6 com12 $.

  $( Theorem *2.65 of [WhiteheadRussell] p. 107.  Proof by contradiction.
     (Contributed by NM, 21-Jun-1993.)  (Proof shortened by Wolf Lammen,
     8-Mar-2013.) $)
  pm2.65 $p |- ( ( ph -> ps ) -> ( ( ph -> -. ps ) -> -. ph ) ) $=
    wph wps wi wph wps wn wph wn wph wps wi wph wn idd wph wps con3 jad $.

  ${
    pm2.65i.1 $e |- ( ph -> ps ) $.
    pm2.65i.2 $e |- ( ph -> -. ps ) $.
    $( Inference for proof by contradiction.  (Contributed by NM, 18-May-1994.)
       (Proof shortened by Wolf Lammen, 11-Sep-2013.) $)
    pm2.65i $p |- -. ph $=
      wps wph wn wph wps pm2.65i.2 con2i wph wps pm2.65i.1 con3i pm2.61i $.
  $}

  ${
    pm2.21dd.1 $e |- ( ph -> ps ) $.
    pm2.21dd.2 $e |- ( ph -> -. ps ) $.
    $( A contradiction implies anything.  Deduction from ~ pm2.21 .
       (Contributed by Mario Carneiro, 9-Feb-2017.)  (Proof shortened by Wolf
       Lammen, 22-Jul-2019.) $)
    pm2.21dd $p |- ( ph -> ch ) $=
      wph wch wph wps pm2.21dd.1 pm2.21dd.2 pm2.65i pm2.21i $.
  $}

  ${
    pm2.65d.1 $e |- ( ph -> ( ps -> ch ) ) $.
    pm2.65d.2 $e |- ( ph -> ( ps -> -. ch ) ) $.
    $( Deduction for proof by contradiction.  (Contributed by NM, 26-Jun-1994.)
       (Proof shortened by Wolf Lammen, 26-May-2013.) $)
    pm2.65d $p |- ( ph -> -. ps ) $=
      wph wps wph wps wch wps pm2.65d.2 pm2.65d.1 nsyld pm2.01d $.
  $}

  ${
    mto.1 $e |- -. ps $.
    mto.2 $e |- ( ph -> ps ) $.
    $( The rule of modus tollens.  The rule says, "if ` ps ` is not true, and
       ` ph ` implies ` ps ` , then ` ph ` must also be not true".  Modus
       tollens is short for "modus tollendo tollens", a Latin phrase that means
       "the mode that by denying denies" - remark in [Sanford] p. 39.  It is
       also called denying the consequent.  Modus tollens is closely related to
       modus ponens ~ ax-mp .  Note that this rule is also valid in
       intuitionistic logic.  Inference associated with ~ con3i .  (Contributed
       by NM, 19-Aug-1993.)  (Proof shortened by Wolf Lammen, 11-Sep-2013.) $)
    mto $p |- -. ph $=
      wph wps mto.2 wps wn wph mto.1 a1i pm2.65i $.
  $}

  ${
    mtod.1 $e |- ( ph -> -. ch ) $.
    mtod.2 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Modus tollens deduction.  (Contributed by NM, 3-Apr-1994.)  (Proof
       shortened by Wolf Lammen, 11-Sep-2013.) $)
    mtod $p |- ( ph -> -. ps ) $=
      wph wps wch mtod.2 wph wch wn wps mtod.1 a1d pm2.65d $.
  $}

  ${
    mtoi.1 $e |- -. ch $.
    mtoi.2 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Modus tollens inference.  (Contributed by NM, 5-Jul-1994.)  (Proof
       shortened by Wolf Lammen, 15-Sep-2012.) $)
    mtoi $p |- ( ph -> -. ps ) $=
      wph wps wch wch wn wph mtoi.1 a1i mtoi.2 mtod $.
  $}

  ${
    mt2.1 $e |- ps $.
    mt2.2 $e |- ( ph -> -. ps ) $.
    $( A rule similar to modus tollens.  Inference associated with ~ con2i .
       (Contributed by NM, 19-Aug-1993.)  (Proof shortened by Wolf Lammen,
       10-Sep-2013.) $)
    mt2 $p |- -. ph $=
      wph wps wps wph mt2.1 a1i mt2.2 pm2.65i $.
  $}

  ${
    mt3.1 $e |- -. ps $.
    mt3.2 $e |- ( -. ph -> ps ) $.
    $( A rule similar to modus tollens.  Inference associated with ~ con1i .
       (Contributed by NM, 18-May-1994.)  (Proof shortened by Wolf Lammen,
       11-Sep-2013.) $)
    mt3 $p |- ph $=
      wph wph wn wps mt3.1 mt3.2 mto notnotri $.
  $}

  $( Peirce's axiom.  A non-intuitionistic implication-only statement.  Added
     to intuitionistic (implicational) propositional calculus, it gives
     classical (implicational) propositional calculus.  For another
     non-intuitionistic positive statement, see ~ curryax .  When ` F. ` is
     substituted for ` ps ` , then this becomes the Clavius law ~ pm2.18 .
     (Contributed by NM, 29-Dec-1992.)  (Proof shortened by Wolf Lammen,
     9-Oct-2012.) $)
  peirce $p |- ( ( ( ph -> ps ) -> ph ) -> ph ) $=
    wph wps wi wph wph wph wps simplim wph id ja $.

  $( The Inversion Axiom of the infinite-valued sentential logic (L-infinity)
     of Lukasiewicz.  Using ~ dfor2 , we can see that this essentially
     expresses "disjunction commutes".  Theorem *2.69 of [WhiteheadRussell]
     p. 108.  It is a special instance of the axiom "Roll", see ~ peirceroll .
     (Contributed by NM, 12-Aug-2004.) $)
  looinv $p |- ( ( ( ph -> ps ) -> ps ) -> ( ( ps -> ph ) -> ph ) ) $=
    wph wps wi wps wi wps wph wi wph wps wi wph wi wph wph wps wi wps wph imim1
    wph wps peirce syl6 $.

  $( A self-implication (see ~ id ) does not imply its own negation.  The
     justification theorem ~ bijust is one of its instances.  (Contributed by
     NM, 11-May-1999.)  (Proof shortened by Josh Purinton, 29-Dec-2000.)
     Extract ~ bijust0 from proof of ~ bijust .  (Revised by BJ,
     19-Mar-2020.) $)
  bijust0 $p |- -. ( ( ph -> ph ) -> -. ( ph -> ph ) ) $=
    wph wph wi wph wph wi wn wi wph wph wi wph id wph wph wi pm2.01 mt2 $.

  $( Theorem used to justify the definition of the biconditional ~ df-bi .
     Instance of ~ bijust0 .  (Contributed by NM, 11-May-1999.) $)
  bijust $p |- -. ( ( -. ( ( ph -> ps ) -> -. ( ps -> ph ) )
                   -> -. ( ( ph -> ps ) -> -. ( ps -> ph ) ) )
              -> -. ( -. ( ( ph -> ps ) -> -. ( ps -> ph ) )
                   -> -. ( ( ph -> ps ) -> -. ( ps -> ph ) ) ) ) $=
    wph wps wi wps wph wi wn wi wn bijust0 $.


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Logical equivalence
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  Definition ~ df-bi in this section is our first definition, which
  introduces and defines the biconditional connective ` <-> ` used to denote
  logical equivalence.  We define a wff of the form ` ( ph <-> ps ) ` as an
  abbreviation for ` -. ( ( ph -> ps ) -> -. ( ps -> ph ) ) ` .

  Unlike most traditional developments, we have chosen not to have a separate
  symbol such as "Df." to mean "is defined as".  Instead, we will later use the
  biconditional connective for this purpose ( ~ df-an is its first use), as it
  allows to use logic to manipulate definitions directly.  This greatly
  simplifies many proofs since it eliminates the need for a separate mechanism
  for introducing and eliminating definitions.

  A note on definitions: definitions are required to be eliminable (that is, a
  theorem stated in terms of the defined symbol can also be stated without it)
  and conservative (that is, a theorem whose statement does not contain the
  defined symbol can be proved without using that definition).  This means that
  a definition does not increase the expressive power nor the deductive power,
  respectively, of a theory.  On the other hand, definitions are often useful
  to write shorter proofs, so in (i)set.mm we will generally not try to avoid
  them.  This is why, for instance, some theorems which do not contain
  disjunction in their statement are placed after the section on disjunction
  because a shorter proof using disjunction is possible.

$)

  $( Declare the biconditional connective. $)
  $c <-> $.  $( Bidirectional arrow (read:  "if and only if" or
                "is logically equivalent to") $)

  $( Extend wff definition to include the biconditional connective. $)
  wb $a wff ( ph <-> ps ) $.

  $( Define the biconditional (logical "iff" or "if and only if"), also called
     biimplication.

     Definition ~ df-bi in this section is our first definition, which
     introduces and defines the biconditional connective ` <-> ` .  We define a
     wff of the form ` ( ph <-> ps ) ` as an abbreviation for
     ` -. ( ( ph -> ps ) -> -. ( ps -> ph ) ) ` .

     Unlike most traditional developments, we have chosen not to have a
     separate symbol such as "Df." to mean "is defined as".  Instead, we will
     later use the biconditional connective for this purpose ( ~ df-or is its
     first use), as it allows to use logic to manipulate definitions directly.
     This greatly simplifies many proofs since it eliminates the need for a
     separate mechanism for introducing and eliminating definitions.  Of
     course, we cannot use this mechanism to define the biconditional itself,
     since it hasn't been introduced yet.  Instead, we use a more general form
     of definition, described as follows.

     In its most general form, a definition is simply an assertion that
     introduces a new symbol (or a new combination of existing symbols, as in
     ~ df-3an ) that is eliminable and does not strengthen the existing
     language.  The latter requirement means that the set of provable
     statements not containing the new symbol (or new combination) should
     remain exactly the same after the definition is introduced.  Our
     definition of the biconditional may look unusual compared to most
     definitions, but it strictly satisfies these requirements.

     The justification for our definition is that if we mechanically replace
     ` ( ph <-> ps ) ` (the definiendum i.e. the thing being defined) with
     ` -. ( ( ph -> ps ) -> -. ( ps -> ph ) ) ` (the definiens i.e. the
     defining expression) in the definition, the definition becomes the
     previously proved theorem ~ bijust .  It is impossible to use ~ df-bi to
     prove any statement expressed in the original language that can't be
     proved from the original axioms, because if we simply replace each
     instance of ~ df-bi in the proof with the corresponding ~ bijust instance,
     we will end up with a proof from the original axioms.

     Note that from Metamath's point of view, a definition is just another
     axiom - i.e. an assertion we claim to be true - but from our high level
     point of view, we are not strengthening the language.  To indicate this
     fact, we prefix definition labels with "df-" instead of "ax-".  (This
     prefixing is an informal convention that means nothing to the Metamath
     proof verifier; it is just a naming convention for human readability.)

     After we define the constant true ` T. ` ( ~ df-tru ) and the constant
     false ` F. ` ( ~ df-fal ), we will be able to prove these truth table
     values: ` ( ( T. <-> T. ) <-> T. ) ` ( ~ trubitru ),
     ` ( ( T. <-> F. ) <-> F. ) ` ( ~ trubifal ), ` ( ( F. <-> T. ) <-> F. ) `
     ( ~ falbitru ), and ` ( ( F. <-> F. ) <-> T. ) ` ( ~ falbifal ).

     See ~ dfbi1 , ~ dfbi2 , and ~ dfbi3 for theorems suggesting typical
     textbook definitions of ` <-> ` , showing that our definition has the
     properties we expect.  Theorem ~ dfbi1 is particularly useful if we want
     to eliminate ` <-> ` from an expression to convert it to primitives.
     Theorem ~ dfbi shows this definition rewritten in an abbreviated form
     after conjunction is introduced, for easier understanding.

     Contrast with ` \/ ` ( ~ df-or ), ` -> ` ( ~ wi ), ` -/\ ` ( ~ df-nan ),
     and ` \/_ ` ( ~ df-xor ).  In some sense ` <-> ` returns true if two truth
     values are equal; ` = ` ( ~ df-cleq ) returns true if two classes are
     equal.  (Contributed by NM, 27-Dec-1992.) $)
  df-bi $a |- -. ( ( ( ph <-> ps ) -> -. ( ( ph -> ps ) -> -. ( ps -> ph ) ) )
        -> -. ( -. ( ( ph -> ps ) -> -. ( ps -> ph ) ) -> ( ph <-> ps ) ) ) $.

  $( $j justification 'bijust' for 'df-bi'; $)

  $( Property of the biconditional connective.  (Contributed by NM,
     11-May-1999.) $)
  impbi $p |- ( ( ph -> ps ) -> ( ( ps -> ph ) -> ( ph <-> ps ) ) ) $=
    wph wps wi wps wph wi wph wps wb wph wps wb wph wps wi wps wph wi wn wi wn
    wi wph wps wi wps wph wi wn wi wn wph wps wb wi wn wi wn wph wps wi wps wph
    wi wn wi wn wph wps wb wi wph wps df-bi wph wps wb wph wps wi wps wph wi wn
    wi wn wi wph wps wi wps wph wi wn wi wn wph wps wb wi simprim ax-mp expi $.

  ${
    impbii.1 $e |- ( ph -> ps ) $.
    impbii.2 $e |- ( ps -> ph ) $.
    $( Infer an equivalence from an implication and its converse.  Inference
       associated with ~ impbi .  (Contributed by NM, 29-Dec-1992.) $)
    impbii $p |- ( ph <-> ps ) $=
      wph wps wi wps wph wi wph wps wb impbii.1 impbii.2 wph wps impbi mp2 $.
  $}

  ${
    impbidd.1 $e |- ( ph -> ( ps -> ( ch -> th ) ) ) $.
    impbidd.2 $e |- ( ph -> ( ps -> ( th -> ch ) ) ) $.
    $( Deduce an equivalence from two implications.  Double deduction
       associated with ~ impbi and ~ impbii .  Deduction associated with
       ~ impbid .  (Contributed by Rodolfo Medina, 12-Oct-2010.) $)
    impbidd $p |- ( ph -> ( ps -> ( ch <-> th ) ) ) $=
      wph wps wch wth wi wth wch wi wch wth wb impbidd.1 impbidd.2 wch wth
      impbi syl6c $.
  $}

  ${
    impbid21d.1 $e |- ( ps -> ( ch -> th ) ) $.
    impbid21d.2 $e |- ( ph -> ( th -> ch ) ) $.
    $( Deduce an equivalence from two implications.  (Contributed by Wolf
       Lammen, 12-May-2013.) $)
    impbid21d $p |- ( ph -> ( ps -> ( ch <-> th ) ) ) $=
      wps wch wth wi wph wth wch wi wch wth wb impbid21d.1 impbid21d.2 wch wth
      impbi syl2imc $.
  $}

  ${
    impbid.1 $e |- ( ph -> ( ps -> ch ) ) $.
    impbid.2 $e |- ( ph -> ( ch -> ps ) ) $.
    $( Deduce an equivalence from two implications.  Deduction associated with
       ~ impbi and ~ impbii .  (Contributed by NM, 24-Jan-1993.)  Prove it from
       ~ impbid21d .  (Revised by Wolf Lammen, 3-Nov-2012.) $)
    impbid $p |- ( ph -> ( ps <-> ch ) ) $=
      wph wps wch wb wph wph wps wch impbid.1 impbid.2 impbid21d pm2.43i $.
  $}

  $( Relate the biconditional connective to primitive connectives.  See
     ~ dfbi1ALT for an unusual version proved directly from axioms.
     (Contributed by NM, 29-Dec-1992.) $)
  dfbi1 $p |- ( ( ph <-> ps ) <-> -. ( ( ph -> ps ) -> -. ( ps -> ph ) ) ) $=
    wph wps wb wph wps wi wps wph wi wn wi wn wb wph wps wb wph wps wi wps wph
    wi wn wi wn wi wph wps wi wps wph wi wn wi wn wph wps wb wi wn wi wph wps
    df-bi wph wps wb wph wps wi wps wph wi wn wi wn wi wph wps wi wps wph wi wn
    wi wn wph wps wb wi wph wps wb wph wps wi wps wph wi wn wi wn wb wph wps wb
    wph wps wi wps wph wi wn wi wn impbi con3rr3 mt3 $.

  $( Alternate proof of ~ dfbi1 .  This proof, discovered by Gregory Bush on
     8-Mar-2004, has several curious properties.  First, it has only 17 steps
     directly from the axioms and ~ df-bi , compared to over 800 steps were the
     proof of ~ dfbi1 expanded into axioms.  Second, step 2 demands only the
     property of "true"; any axiom (or theorem) could be used.  It might be
     thought, therefore, that it is in some sense redundant, but in fact no
     proof is shorter than this (measured by number of steps).  Third, it
     illustrates how intermediate steps can "blow up" in size even in short
     proofs.  Fourth, the compressed proof is only 182 bytes (or 17 bytes in
     D-proof notation), but the generated web page is over 200kB with
     intermediate steps that are essentially incomprehensible to humans (other
     than Gregory Bush).  If there were an obfuscated code contest for proofs,
     this would be a contender.  This "blowing up" and incomprehensibility of
     the intermediate steps vividly demonstrate the advantages of using many
     layered intermediate theorems, since each theorem is easier to understand.
     (Contributed by Gregory Bush, 10-Mar-2004.)  (New usage is discouraged.)
     (Proof modification is discouraged.) $)
  dfbi1ALT $p |-
                ( ( ph <-> ps ) <-> -. ( ( ph -> ps ) -> -. ( ps -> ph ) ) ) $=
    wph wps wb wph wps wi wps wph wi wn wi wn wi wph wps wi wps wph wi wn wi wn
    wph wps wb wi wn wi wn wph wps wb wph wps wi wps wph wi wn wi wn wb wph wps
    df-bi wch wth wch wi wi wph wps wb wph wps wi wps wph wi wn wi wn wi wph
    wps wi wps wph wi wn wi wn wph wps wb wi wn wi wn wph wps wb wph wps wi wps
    wph wi wn wi wn wb wi wch wth ax-1 wph wps wb wph wps wi wps wph wi wn wi
    wn wi wph wps wi wps wph wi wn wi wn wph wps wb wi wn wi wn wph wps wb wph
    wps wi wps wph wi wn wi wn wb wi wn wch wth wch wi wi wn wi wch wth wch wi
    wi wph wps wb wph wps wi wps wph wi wn wi wn wi wph wps wi wps wph wi wn wi
    wn wph wps wb wi wn wi wn wph wps wb wph wps wi wps wph wi wn wi wn wb wi
    wi wph wps wb wph wps wi wps wph wi wn wi wn wi wph wps wi wps wph wi wn wi
    wn wph wps wb wi wn wi wn wph wps wb wph wps wi wps wph wi wn wi wn wb wi
    wn wph wps wb wph wps wi wps wph wi wn wi wn wb wph wps wb wph wps wi wps
    wph wi wn wi wn wi wph wps wi wps wph wi wn wi wn wph wps wb wi wn wi wn wi
    wph wps wb wph wps wi wps wph wi wn wi wn wi wph wps wi wps wph wi wn wi wn
    wph wps wb wi wn wi wn wph wps wb wph wps wi wps wph wi wn wi wn wb wi wn
    wi wi wph wps wb wph wps wi wps wph wi wn wi wn wi wph wps wi wps wph wi wn
    wi wn wph wps wb wi wn wi wn wph wps wb wph wps wi wps wph wi wn wi wn wb
    wi wn wch wth wch wi wi wn wi wph wps wb wph wps wi wps wph wi wn wi wn wi
    wph wps wi wps wph wi wn wi wn wph wps wb wi wn wi wn wph wps wb wph wps wi
    wps wph wi wn wi wn wb wi wn wph wps wb wph wps wi wps wph wi wn wi wn wb
    wph wps wb wph wps wi wps wph wi wn wi wn wi wph wps wi wps wph wi wn wi wn
    wph wps wb wi wn wi wn wi ax-1 wph wps wb wph wps wi wps wph wi wn wi wn wi
    wph wps wi wps wph wi wn wi wn wph wps wb wi wn wi wn wph wps wb wph wps wi
    wps wph wi wn wi wn wb wi wn wph wps wb wph wps wi wps wph wi wn wi wn wb
    wph wps wb wph wps wi wps wph wi wn wi wn wi wph wps wi wps wph wi wn wi wn
    wph wps wb wi wn wi wn wi wph wps wb wph wps wi wps wph wi wn wi wn wi wph
    wps wi wps wph wi wn wi wn wph wps wb wi wn wi wn wph wps wb wph wps wi wps
    wph wi wn wi wn wb wi wn wi wch wth wch wi wi wn wi wi wph wps wb wph wps
    wi wps wph wi wn wi wn wi wph wps wi wps wph wi wn wi wn wph wps wb wi wn
    wi wn wph wps wb wph wps wi wps wph wi wn wi wn wb wi wn wph wps wb wph wps
    wi wps wph wi wn wi wn wb wph wps wb wph wps wi wps wph wi wn wi wn wi wph
    wps wi wps wph wi wn wi wn wph wps wb wi wn wi wn wi wph wps wb wph wps wi
    wps wph wi wn wi wn wi wph wps wi wps wph wi wn wi wn wph wps wb wi wn wi
    wn wph wps wb wph wps wi wps wph wi wn wi wn wb wi wn wi wi wph wps wb wph
    wps wi wps wph wi wn wi wn wi wph wps wi wps wph wi wn wi wn wph wps wb wi
    wn wi wn wph wps wb wph wps wi wps wph wi wn wi wn wb wi wn wch wth wch wi
    wi wn wi wi wph wps wb wph wps wi wps wph wi wn wi wn wb wph wps wb wph wps
    wi wps wph wi wn wi wn wi wph wps wi wps wph wi wn wi wn wph wps wb wi wn
    wi wn wi wph wps wb wph wps wi wps wph wi wn wi wn wi wph wps wi wps wph wi
    wn wi wn wph wps wb wi wn wi wn wph wps wb wph wps wi wps wph wi wn wi wn
    wb wi wn wi wch wth wch wi wi wn wi wph wps wb wph wps wi wps wph wi wn wi
    wn wi wph wps wi wps wph wi wn wi wn wph wps wb wi wn wi wn wph wps wb wph
    wps wi wps wph wi wn wi wn wb wi wn wph wps wb wph wps wi wps wph wi wn wi
    wn wb wph wps wb wph wps wi wps wph wi wn wi wn wi wph wps wi wps wph wi wn
    wi wn wph wps wb wi wn wi wn wi wph wps wb wph wps wi wps wph wi wn wi wn
    wi wph wps wi wps wph wi wn wi wn wph wps wb wi wn wi wn wph wps wb wph wps
    wi wps wph wi wn wi wn wb wi wn wi wch wth wch wi wi wn wi wi wch wth wch
    wi wi wn wn wph wps wb wph wps wi wps wph wi wn wi wn wb wph wps wb wph wps
    wi wps wph wi wn wi wn wi wph wps wi wps wph wi wn wi wn wph wps wb wi wn
    wi wn wi wph wps wb wph wps wi wps wph wi wn wi wn wi wph wps wi wps wph wi
    wn wi wn wph wps wb wi wn wi wn wph wps wb wph wps wi wps wph wi wn wi wn
    wb wi wn wi wn wi wph wps wb wph wps wi wps wph wi wn wi wn wb wph wps wb
    wph wps wi wps wph wi wn wi wn wi wph wps wi wps wph wi wn wi wn wph wps wb
    wi wn wi wn wi wph wps wb wph wps wi wps wph wi wn wi wn wi wph wps wi wps
    wph wi wn wi wn wph wps wb wi wn wi wn wph wps wb wph wps wi wps wph wi wn
    wi wn wb wi wn wi wch wth wch wi wi wn wi wph wps wb wph wps wi wps wph wi
    wn wi wn wb wph wps wb wph wps wi wps wph wi wn wi wn wi wph wps wi wps wph
    wi wn wi wn wph wps wb wi wn wi wn wi wph wps wb wph wps wi wps wph wi wn
    wi wn wi wph wps wi wps wph wi wn wi wn wph wps wb wi wn wi wn wph wps wb
    wph wps wi wps wph wi wn wi wn wb wi wn wi wn wch wth wch wi wi wn wn wph
    wps wb wph wps wi wps wph wi wn wi wn wb wph wps wb wph wps wi wps wph wi
    wn wi wn wi wph wps wi wps wph wi wn wi wn wph wps wb wi wn wi wn wi wph
    wps wb wph wps wi wps wph wi wn wi wn wi wph wps wi wps wph wi wn wi wn wph
    wps wb wi wn wi wn wph wps wb wph wps wi wps wph wi wn wi wn wb wi wn wi wn
    wi wph wps wb wph wps wi wps wph wi wn wi wn df-bi wph wps wb wph wps wi
    wps wph wi wn wi wn wb wph wps wb wph wps wi wps wph wi wn wi wn wi wph wps
    wi wps wph wi wn wi wn wph wps wb wi wn wi wn wi wph wps wb wph wps wi wps
    wph wi wn wi wn wi wph wps wi wps wph wi wn wi wn wph wps wb wi wn wi wn
    wph wps wb wph wps wi wps wph wi wn wi wn wb wi wn wi wn wch wth wch wi wi
    wn wn ax-1 ax-mp wch wth wch wi wi wn wph wps wb wph wps wi wps wph wi wn
    wi wn wb wph wps wb wph wps wi wps wph wi wn wi wn wi wph wps wi wps wph wi
    wn wi wn wph wps wb wi wn wi wn wi wph wps wb wph wps wi wps wph wi wn wi
    wn wi wph wps wi wps wph wi wn wi wn wph wps wb wi wn wi wn wph wps wb wph
    wps wi wps wph wi wn wi wn wb wi wn wi ax-3 ax-mp wph wps wb wph wps wi wps
    wph wi wn wi wn wb wph wps wb wph wps wi wps wph wi wn wi wn wi wph wps wi
    wps wph wi wn wi wn wph wps wb wi wn wi wn wi wph wps wb wph wps wi wps wph
    wi wn wi wn wi wph wps wi wps wph wi wn wi wn wph wps wb wi wn wi wn wph
    wps wb wph wps wi wps wph wi wn wi wn wb wi wn wi wch wth wch wi wi wn wi
    wph wps wb wph wps wi wps wph wi wn wi wn wi wph wps wi wps wph wi wn wi wn
    wph wps wb wi wn wi wn wph wps wb wph wps wi wps wph wi wn wi wn wb wi wn
    ax-1 ax-mp wph wps wb wph wps wi wps wph wi wn wi wn wi wph wps wi wps wph
    wi wn wi wn wph wps wb wi wn wi wn wph wps wb wph wps wi wps wph wi wn wi
    wn wb wi wn wph wps wb wph wps wi wps wph wi wn wi wn wb wph wps wb wph wps
    wi wps wph wi wn wi wn wi wph wps wi wps wph wi wn wi wn wph wps wb wi wn
    wi wn wi wph wps wb wph wps wi wps wph wi wn wi wn wi wph wps wi wps wph wi
    wn wi wn wph wps wb wi wn wi wn wph wps wb wph wps wi wps wph wi wn wi wn
    wb wi wn wi wch wth wch wi wi wn ax-2 ax-mp ax-mp wph wps wb wph wps wi wps
    wph wi wn wi wn wi wph wps wi wps wph wi wn wi wn wph wps wb wi wn wi wn
    wph wps wb wph wps wi wps wph wi wn wi wn wb wi wch wth wch wi wi ax-3
    ax-mp ax-mp ax-mp $.

  $( Property of the biconditional connective.  (Contributed by NM,
     11-May-1999.) $)
  biimp $p |- ( ( ph <-> ps ) -> ( ph -> ps ) ) $=
    wph wps wb wph wps wi wps wph wi wn wi wn wph wps wi wph wps wb wph wps wi
    wps wph wi wn wi wn wi wph wps wi wps wph wi wn wi wn wph wps wb wi wn wi
    wn wph wps wb wph wps wi wps wph wi wn wi wn wi wph wps df-bi wph wps wb
    wph wps wi wps wph wi wn wi wn wi wph wps wi wps wph wi wn wi wn wph wps wb
    wi wn simplim ax-mp wph wps wi wps wph wi wn simplim syl $.

  ${
    biimpi.1 $e |- ( ph <-> ps ) $.
    $( Infer an implication from a logical equivalence.  Inference associated
       with ~ biimp .  (Contributed by NM, 29-Dec-1992.) $)
    biimpi $p |- ( ph -> ps ) $=
      wph wps wb wph wps wi biimpi.1 wph wps biimp ax-mp $.
  $}

  ${
    sylbi.1 $e |- ( ph <-> ps ) $.
    sylbi.2 $e |- ( ps -> ch ) $.
    $( A mixed syllogism inference from a biconditional and an implication.
       Useful for substituting an antecedent with a definition.  (Contributed
       by NM, 3-Jan-1993.) $)
    sylbi $p |- ( ph -> ch ) $=
      wph wps wch wph wps sylbi.1 biimpi sylbi.2 syl $.
  $}

  ${
    sylib.1 $e |- ( ph -> ps ) $.
    sylib.2 $e |- ( ps <-> ch ) $.
    $( A mixed syllogism inference from an implication and a biconditional.
       (Contributed by NM, 3-Jan-1993.) $)
    sylib $p |- ( ph -> ch ) $=
      wph wps wch sylib.1 wps wch sylib.2 biimpi syl $.
  $}

  ${
    sylbb.1 $e |- ( ph <-> ps ) $.
    sylbb.2 $e |- ( ps <-> ch ) $.
    $( A mixed syllogism inference from two biconditionals.  (Contributed by
       BJ, 30-Mar-2019.) $)
    sylbb $p |- ( ph -> ch ) $=
      wph wps wch sylbb.1 wps wch sylbb.2 biimpi sylbi $.
  $}

  $( Property of the biconditional connective.  (Contributed by NM,
     11-May-1999.)  (Proof shortened by Wolf Lammen, 11-Nov-2012.) $)
  biimpr $p |- ( ( ph <-> ps ) -> ( ps -> ph ) ) $=
    wph wps wb wph wps wi wps wph wi wn wi wn wps wph wi wph wps dfbi1 wph wps
    wi wps wph wi simprim sylbi $.

  $( Commutative law for the biconditional.  (Contributed by Wolf Lammen,
     10-Nov-2012.) $)
  bicom1 $p |- ( ( ph <-> ps ) -> ( ps <-> ph ) ) $=
    wph wps wb wps wph wph wps biimpr wph wps biimp impbid $.

  $( Commutative law for the biconditional.  Theorem *4.21 of
     [WhiteheadRussell] p. 117.  (Contributed by NM, 11-May-1993.) $)
  bicom $p |- ( ( ph <-> ps ) <-> ( ps <-> ph ) ) $=
    wph wps wb wps wph wb wph wps bicom1 wps wph bicom1 impbii $.

  ${
    bicomd.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    $( Commute two sides of a biconditional in a deduction.  (Contributed by
       NM, 14-May-1993.) $)
    bicomd $p |- ( ph -> ( ch <-> ps ) ) $=
      wph wps wch wb wch wps wb bicomd.1 wps wch bicom sylib $.
  $}

  ${
    bicomi.1 $e |- ( ph <-> ps ) $.
    $( Inference from commutative law for logical equivalence.  (Contributed by
       NM, 3-Jan-1993.) $)
    bicomi $p |- ( ps <-> ph ) $=
      wph wps wb wps wph wb bicomi.1 wph wps bicom1 ax-mp $.
  $}

  ${
    impbid1.1 $e |- ( ph -> ( ps -> ch ) ) $.
    impbid1.2 $e |- ( ch -> ps ) $.
    $( Infer an equivalence from two implications.  (Contributed by NM,
       6-Mar-2007.) $)
    impbid1 $p |- ( ph -> ( ps <-> ch ) ) $=
      wph wps wch impbid1.1 wch wps wi wph impbid1.2 a1i impbid $.
  $}

  ${
    impbid2.1 $e |- ( ps -> ch ) $.
    impbid2.2 $e |- ( ph -> ( ch -> ps ) ) $.
    $( Infer an equivalence from two implications.  (Contributed by NM,
       6-Mar-2007.)  (Proof shortened by Wolf Lammen, 27-Sep-2013.) $)
    impbid2 $p |- ( ph -> ( ps <-> ch ) ) $=
      wph wch wps wph wch wps impbid2.2 impbid2.1 impbid1 bicomd $.
  $}

  ${
    impcon4bid.1 $e |- ( ph -> ( ps -> ch ) ) $.
    impcon4bid.2 $e |- ( ph -> ( -. ps -> -. ch ) ) $.
    $( A variation on ~ impbid with contraposition.  (Contributed by Jeff
       Hankins, 3-Jul-2009.) $)
    impcon4bid $p |- ( ph -> ( ps <-> ch ) ) $=
      wph wps wch impcon4bid.1 wph wps wch impcon4bid.2 con4d impbid $.
  $}

  ${
    biimpri.1 $e |- ( ph <-> ps ) $.
    $( Infer a converse implication from a logical equivalence.  Inference
       associated with ~ biimpr .  (Contributed by NM, 29-Dec-1992.)  (Proof
       shortened by Wolf Lammen, 16-Sep-2013.) $)
    biimpri $p |- ( ps -> ph ) $=
      wps wph wph wps biimpri.1 bicomi biimpi $.
  $}

  ${
    biimpd.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    $( Deduce an implication from a logical equivalence.  Deduction associated
       with ~ biimp and ~ biimpi .  (Contributed by NM, 11-Jan-1993.) $)
    biimpd $p |- ( ph -> ( ps -> ch ) ) $=
      wph wps wch wb wps wch wi biimpd.1 wps wch biimp syl $.
  $}

  ${
    mpbi.min $e |- ph $.
    mpbi.maj $e |- ( ph <-> ps ) $.
    $( An inference from a biconditional, related to modus ponens.
       (Contributed by NM, 11-May-1993.) $)
    mpbi $p |- ps $=
      wph wps mpbi.min wph wps mpbi.maj biimpi ax-mp $.
  $}

  ${
    mpbir.min $e |- ps $.
    mpbir.maj $e |- ( ph <-> ps ) $.
    $( An inference from a biconditional, related to modus ponens.
       (Contributed by NM, 28-Dec-1992.) $)
    mpbir $p |- ph $=
      wps wph mpbir.min wph wps mpbir.maj biimpri ax-mp $.
  $}

  ${
    mpbid.min $e |- ( ph -> ps ) $.
    mpbid.maj $e |- ( ph -> ( ps <-> ch ) ) $.
    $( A deduction from a biconditional, related to modus ponens.  (Contributed
       by NM, 21-Jun-1993.) $)
    mpbid $p |- ( ph -> ch ) $=
      wph wps wch mpbid.min wph wps wch mpbid.maj biimpd mpd $.
  $}

  ${
    mpbii.min $e |- ps $.
    mpbii.maj $e |- ( ph -> ( ps <-> ch ) ) $.
    $( An inference from a nested biconditional, related to modus ponens.
       (Contributed by NM, 16-May-1993.)  (Proof shortened by Wolf Lammen,
       25-Oct-2012.) $)
    mpbii $p |- ( ph -> ch ) $=
      wph wps wch wps wph mpbii.min a1i mpbii.maj mpbid $.
  $}

  ${
    sylibr.1 $e |- ( ph -> ps ) $.
    sylibr.2 $e |- ( ch <-> ps ) $.
    $( A mixed syllogism inference from an implication and a biconditional.
       Useful for substituting a consequent with a definition.  (Contributed by
       NM, 3-Jan-1993.) $)
    sylibr $p |- ( ph -> ch ) $=
      wph wps wch sylibr.1 wch wps sylibr.2 biimpri syl $.
  $}

  ${
    sylbir.1 $e |- ( ps <-> ph ) $.
    sylbir.2 $e |- ( ps -> ch ) $.
    $( A mixed syllogism inference from a biconditional and an implication.
       (Contributed by NM, 3-Jan-1993.) $)
    sylbir $p |- ( ph -> ch ) $=
      wph wps wch wps wph sylbir.1 biimpri sylbir.2 syl $.
  $}

  ${
    sylbbr.1 $e |- ( ph <-> ps ) $.
    sylbbr.2 $e |- ( ps <-> ch ) $.
    $( A mixed syllogism inference from two biconditionals.

       Note on the various syllogism-like statements in set.mm.  The
       hypothetical syllogism ~ syl infers an implication from two implications
       (and there are ~ 3syl and ~ 4syl for chaining more inferences).  There
       are four inferences inferring an implication from one implication and
       one biconditional: ~ sylbi , ~ sylib , ~ sylbir , ~ sylibr ; four
       inferences inferring an implication from two biconditionals: ~ sylbb ,
       ~ sylbbr , ~ sylbb1 , ~ sylbb2 ; four inferences inferring a
       biconditional from two biconditionals: ~ bitri , ~ bitr2i , ~ bitr3i ,
       ~ bitr4i (and more for chaining more biconditionals).  There are also
       closed forms and deduction versions of these, like, among many others,
       ~ syld , ~ syl5 , ~ syl6 , ~ mpbid , ~ bitrd , ~ bitrid , ~ bitrdi and
       variants.  (Contributed by BJ, 21-Apr-2019.) $)
    sylbbr $p |- ( ch -> ph ) $=
      wch wps wph wps wch sylbbr.2 biimpri sylbbr.1 sylibr $.
  $}

  ${
    sylbb1.1 $e |- ( ph <-> ps ) $.
    sylbb1.2 $e |- ( ph <-> ch ) $.
    $( A mixed syllogism inference from two biconditionals.  (Contributed by
       BJ, 21-Apr-2019.) $)
    sylbb1 $p |- ( ps -> ch ) $=
      wps wph wch wph wps sylbb1.1 biimpri sylbb1.2 sylib $.
  $}

  ${
    sylbb2.1 $e |- ( ph <-> ps ) $.
    sylbb2.2 $e |- ( ch <-> ps ) $.
    $( A mixed syllogism inference from two biconditionals.  (Contributed by
       BJ, 21-Apr-2019.) $)
    sylbb2 $p |- ( ph -> ch ) $=
      wph wps wch sylbb2.1 wch wps sylbb2.2 biimpri sylbi $.
  $}

  ${
    sylibd.1 $e |- ( ph -> ( ps -> ch ) ) $.
    sylibd.2 $e |- ( ph -> ( ch <-> th ) ) $.
    $( A syllogism deduction.  (Contributed by NM, 3-Aug-1994.) $)
    sylibd $p |- ( ph -> ( ps -> th ) ) $=
      wph wps wch wth sylibd.1 wph wch wth sylibd.2 biimpd syld $.
  $}

  ${
    sylbid.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    sylbid.2 $e |- ( ph -> ( ch -> th ) ) $.
    $( A syllogism deduction.  (Contributed by NM, 3-Aug-1994.) $)
    sylbid $p |- ( ph -> ( ps -> th ) ) $=
      wph wps wch wth wph wps wch sylbid.1 biimpd sylbid.2 syld $.
  $}

  ${
    mpbidi.min $e |- ( th -> ( ph -> ps ) ) $.
    mpbidi.maj $e |- ( ph -> ( ps <-> ch ) ) $.
    $( A deduction from a biconditional, related to modus ponens.  (Contributed
       by NM, 9-Aug-1994.) $)
    mpbidi $p |- ( th -> ( ph -> ch ) ) $=
      wth wph wps wch mpbidi.min wph wps wch mpbidi.maj biimpd sylcom $.
  $}

  ${
    biimtrid.1 $e |- ( ph <-> ps ) $.
    biimtrid.2 $e |- ( ch -> ( ps -> th ) ) $.
    $( A mixed syllogism inference from a nested implication and a
       biconditional.  Useful for substituting an embedded antecedent with a
       definition.  (Contributed by NM, 12-Jan-1993.) $)
    biimtrid $p |- ( ch -> ( ph -> th ) ) $=
      wph wps wch wth wph wps biimtrid.1 biimpi biimtrid.2 syl5 $.
  $}

  ${
    biimtrrid.1 $e |- ( ps <-> ph ) $.
    biimtrrid.2 $e |- ( ch -> ( ps -> th ) ) $.
    $( A mixed syllogism inference from a nested implication and a
       biconditional.  (Contributed by NM, 21-Jun-1993.) $)
    biimtrrid $p |- ( ch -> ( ph -> th ) ) $=
      wph wps wch wth wps wph biimtrrid.1 biimpri biimtrrid.2 syl5 $.
  $}

  ${
    imbitrid.1 $e |- ( ph -> ps ) $.
    imbitrid.2 $e |- ( ch -> ( ps <-> th ) ) $.
    $( A mixed syllogism inference.  (Contributed by NM, 12-Jan-1993.) $)
    imbitrid $p |- ( ch -> ( ph -> th ) ) $=
      wph wps wch wth imbitrid.1 wch wps wth imbitrid.2 biimpd syl5 $.

    $( A mixed syllogism inference.  (Contributed by NM, 19-Jun-2007.) $)
    syl5ibcom $p |- ( ph -> ( ch -> th ) ) $=
      wch wph wth wph wps wch wth imbitrid.1 imbitrid.2 imbitrid com12 $.
  $}

  ${
    imbitrrid.1 $e |- ( ph -> th ) $.
    imbitrrid.2 $e |- ( ch -> ( ps <-> th ) ) $.
    $( A mixed syllogism inference.  (Contributed by NM, 3-Apr-1994.) $)
    imbitrrid $p |- ( ch -> ( ph -> ps ) ) $=
      wph wth wch wps imbitrrid.1 wch wps wth imbitrrid.2 bicomd imbitrid $.

    $( A mixed syllogism inference.  (Contributed by NM, 20-Jun-2007.) $)
    syl5ibrcom $p |- ( ph -> ( ch -> ps ) ) $=
      wch wph wps wph wps wch wth imbitrrid.1 imbitrrid.2 imbitrrid com12 $.
  $}

  ${
    biimprd.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    $( Deduce a converse implication from a logical equivalence.  Deduction
       associated with ~ biimpr and ~ biimpri .  (Contributed by NM,
       11-Jan-1993.)  (Proof shortened by Wolf Lammen, 22-Sep-2013.) $)
    biimprd $p |- ( ph -> ( ch -> ps ) ) $=
      wch wps wph wch wch id biimprd.1 imbitrrid $.
  $}

  ${
    biimpcd.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    $( Deduce a commuted implication from a logical equivalence.  (Contributed
       by NM, 3-May-1994.)  (Proof shortened by Wolf Lammen, 22-Sep-2013.) $)
    biimpcd $p |- ( ps -> ( ph -> ch ) ) $=
      wps wps wph wch wps id biimpcd.1 syl5ibcom $.

    $( Deduce a converse commuted implication from a logical equivalence.
       (Contributed by NM, 3-May-1994.)  (Proof shortened by Wolf Lammen,
       20-Dec-2013.) $)
    biimprcd $p |- ( ch -> ( ph -> ps ) ) $=
      wch wps wph wch wch id biimpcd.1 syl5ibrcom $.
  $}

  ${
    imbitrdi.1 $e |- ( ph -> ( ps -> ch ) ) $.
    imbitrdi.2 $e |- ( ch <-> th ) $.
    $( A mixed syllogism inference from a nested implication and a
       biconditional.  (Contributed by NM, 21-Jun-1993.) $)
    imbitrdi $p |- ( ph -> ( ps -> th ) ) $=
      wph wps wch wth imbitrdi.1 wch wth imbitrdi.2 biimpi syl6 $.
  $}

  ${
    imbitrrdi.1 $e |- ( ph -> ( ps -> ch ) ) $.
    imbitrrdi.2 $e |- ( th <-> ch ) $.
    $( A mixed syllogism inference from a nested implication and a
       biconditional.  Useful for substituting an embedded consequent with a
       definition.  (Contributed by NM, 5-Aug-1993.) $)
    imbitrrdi $p |- ( ph -> ( ps -> th ) ) $=
      wph wps wch wth imbitrrdi.1 wth wch imbitrrdi.2 biimpri syl6 $.
  $}

  ${
    biimtrdi.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    biimtrdi.2 $e |- ( ch -> th ) $.
    $( A mixed syllogism inference.  (Contributed by NM, 2-Jan-1994.) $)
    biimtrdi $p |- ( ph -> ( ps -> th ) ) $=
      wph wps wch wth wph wps wch biimtrdi.1 biimpd biimtrdi.2 syl6 $.
  $}

  ${
    biimtrrdi.1 $e |- ( ph -> ( ch <-> ps ) ) $.
    biimtrrdi.2 $e |- ( ch -> th ) $.
    $( A mixed syllogism inference.  (Contributed by NM, 18-May-1994.) $)
    biimtrrdi $p |- ( ph -> ( ps -> th ) ) $=
      wph wps wch wth wph wch wps biimtrrdi.1 biimprd biimtrrdi.2 syl6 $.
  $}

  ${
    syl7bi.1 $e |- ( ph <-> ps ) $.
    syl7bi.2 $e |- ( ch -> ( th -> ( ps -> ta ) ) ) $.
    $( A mixed syllogism inference from a doubly nested implication and a
       biconditional.  (Contributed by NM, 14-May-1993.) $)
    syl7bi $p |- ( ch -> ( th -> ( ph -> ta ) ) ) $=
      wph wps wch wth wta wph wps syl7bi.1 biimpi syl7bi.2 syl7 $.
  $}

  ${
    syl8ib.1 $e |- ( ph -> ( ps -> ( ch -> th ) ) ) $.
    syl8ib.2 $e |- ( th <-> ta ) $.
    $( A syllogism rule of inference.  The second premise is used to replace
       the consequent of the first premise.  (Contributed by NM,
       1-Aug-1994.) $)
    syl8ib $p |- ( ph -> ( ps -> ( ch -> ta ) ) ) $=
      wph wps wch wth wta syl8ib.1 wth wta syl8ib.2 biimpi syl8 $.
  $}

  ${
    mpbird.min $e |- ( ph -> ch ) $.
    mpbird.maj $e |- ( ph -> ( ps <-> ch ) ) $.
    $( A deduction from a biconditional, related to modus ponens.  (Contributed
       by NM, 5-Aug-1993.) $)
    mpbird $p |- ( ph -> ps ) $=
      wph wch wps mpbird.min wph wps wch mpbird.maj biimprd mpd $.
  $}

  ${
    mpbiri.min $e |- ch $.
    mpbiri.maj $e |- ( ph -> ( ps <-> ch ) ) $.
    $( An inference from a nested biconditional, related to modus ponens.
       (Contributed by NM, 21-Jun-1993.)  (Proof shortened by Wolf Lammen,
       25-Oct-2012.) $)
    mpbiri $p |- ( ph -> ps ) $=
      wph wps wch wch wph mpbiri.min a1i mpbiri.maj mpbird $.
  $}

  ${
    sylibrd.1 $e |- ( ph -> ( ps -> ch ) ) $.
    sylibrd.2 $e |- ( ph -> ( th <-> ch ) ) $.
    $( A syllogism deduction.  (Contributed by NM, 3-Aug-1994.) $)
    sylibrd $p |- ( ph -> ( ps -> th ) ) $=
      wph wps wch wth sylibrd.1 wph wth wch sylibrd.2 biimprd syld $.
  $}

  ${
    sylbird.1 $e |- ( ph -> ( ch <-> ps ) ) $.
    sylbird.2 $e |- ( ph -> ( ch -> th ) ) $.
    $( A syllogism deduction.  (Contributed by NM, 3-Aug-1994.) $)
    sylbird $p |- ( ph -> ( ps -> th ) ) $=
      wph wps wch wth wph wch wps sylbird.1 biimprd sylbird.2 syld $.
  $}

  $( Principle of identity for logical equivalence.  Theorem *4.2 of
     [WhiteheadRussell] p. 117.  This is part of Frege's eighth axiom per
     Proposition 54 of [Frege1879] p. 50; see also ~ eqid .  (Contributed by
     NM, 2-Jun-1993.) $)
  biid $p |- ( ph <-> ph ) $=
    wph wph wph id wph id impbii $.

  $( Principle of identity with antecedent.  (Contributed by NM,
     25-Nov-1995.) $)
  biidd $p |- ( ph -> ( ps <-> ps ) ) $=
    wps wps wb wph wps biid a1i $.

  $( Two propositions are equivalent if they are both true.  Closed form of
     ~ 2th .  Equivalent to a ~ biimp -like version of the xor-connective.
     This theorem stays true, no matter how you permute its operands.  This is
     evident from its sharper version ` ( ph <-> ( ps <-> ( ph <-> ps ) ) ) ` .
     (Contributed by Wolf Lammen, 12-May-2013.) $)
  pm5.1im $p |- ( ph -> ( ps -> ( ph <-> ps ) ) ) $=
    wph wps wph wps wps wph ax-1 wph wps ax-1 impbid21d $.

  ${
    2th.1 $e |- ph $.
    2th.2 $e |- ps $.
    $( Two truths are equivalent.  (Contributed by NM, 18-Aug-1993.) $)
    2th $p |- ( ph <-> ps ) $=
      wph wps wps wph 2th.2 a1i wph wps 2th.1 a1i impbii $.
  $}

  ${
    2thd.1 $e |- ( ph -> ps ) $.
    2thd.2 $e |- ( ph -> ch ) $.
    $( Two truths are equivalent.  Deduction form.  (Contributed by NM,
       3-Jun-2012.) $)
    2thd $p |- ( ph -> ( ps <-> ch ) ) $=
      wph wps wch wps wch wb 2thd.1 2thd.2 wps wch pm5.1im sylc $.
  $}

  $( Two self-implications (see ~ id ) are equivalent.  This theorem, rather
     trivial in our axiomatization, is (the biconditional form of) a standard
     axiom for monothetic BCI logic.  This is the most general theorem of which
     ~ trujust is an instance.  Relatedly, this would be the justification
     theorem if the definition of ` T. ` were ~ dftru2 .  (Contributed by BJ,
     7-Sep-2022.) $)
  monothetic $p |- ( ( ph -> ph ) <-> ( ps -> ps ) ) $=
    wph wph wi wps wps wi wph id wps id 2th $.

  ${
    ibi.1 $e |- ( ph -> ( ph <-> ps ) ) $.
    $( Inference that converts a biconditional implied by one of its arguments,
       into an implication.  (Contributed by NM, 17-Oct-2003.) $)
    ibi $p |- ( ph -> ps ) $=
      wph wph wps wph id ibi.1 mpbid $.
  $}

  ${
    ibir.1 $e |- ( ph -> ( ps <-> ph ) ) $.
    $( Inference that converts a biconditional implied by one of its arguments,
       into an implication.  (Contributed by NM, 22-Jul-2004.) $)
    ibir $p |- ( ph -> ps ) $=
      wph wps wph wps wph ibir.1 bicomd ibi $.
  $}

  ${
    ibd.1 $e |- ( ph -> ( ps -> ( ps <-> ch ) ) ) $.
    $( Deduction that converts a biconditional implied by one of its arguments,
       into an implication.  Deduction associated with ~ ibi .  (Contributed by
       NM, 26-Jun-2004.) $)
    ibd $p |- ( ph -> ( ps -> ch ) ) $=
      wps wph wps wch wb wch ibd.1 wps wch biimp syli $.
  $}

  $( Distribution of implication over biconditional.  Theorem *5.74 of
     [WhiteheadRussell] p. 126.  (Contributed by NM, 1-Aug-1994.)  (Proof
     shortened by Wolf Lammen, 11-Apr-2013.) $)
  pm5.74 $p |- ( ( ph -> ( ps <-> ch ) ) <->
               ( ( ph -> ps ) <-> ( ph -> ch ) ) ) $=
    wph wps wch wb wi wph wps wi wph wch wi wb wph wps wch wb wi wph wps wi wph
    wch wi wps wch wb wps wch wph wps wch biimp imim3i wps wch wb wch wps wph
    wps wch biimpr imim3i impbid wph wps wi wph wch wi wb wph wps wch wph wps
    wi wph wch wi wb wph wps wch wph wps wi wph wch wi biimp pm2.86d wph wps wi
    wph wch wi wb wph wch wps wph wps wi wph wch wi biimpr pm2.86d impbidd
    impbii $.

  ${
    pm5.74i.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    $( Distribution of implication over biconditional (inference form).
       (Contributed by NM, 1-Aug-1994.) $)
    pm5.74i $p |- ( ( ph -> ps ) <-> ( ph -> ch ) ) $=
      wph wps wch wb wi wph wps wi wph wch wi wb pm5.74i.1 wph wps wch pm5.74
      mpbi $.
  $}

  ${
    pm5.74ri.1 $e |- ( ( ph -> ps ) <-> ( ph -> ch ) ) $.
    $( Distribution of implication over biconditional (reverse inference form).
       (Contributed by NM, 1-Aug-1994.) $)
    pm5.74ri $p |- ( ph -> ( ps <-> ch ) ) $=
      wph wps wch wb wi wph wps wi wph wch wi wb pm5.74ri.1 wph wps wch pm5.74
      mpbir $.
  $}

  ${
    pm5.74d.1 $e |- ( ph -> ( ps -> ( ch <-> th ) ) ) $.
    $( Distribution of implication over biconditional (deduction form).
       (Contributed by NM, 21-Mar-1996.) $)
    pm5.74d $p |- ( ph -> ( ( ps -> ch ) <-> ( ps -> th ) ) ) $=
      wph wps wch wth wb wi wps wch wi wps wth wi wb pm5.74d.1 wps wch wth
      pm5.74 sylib $.
  $}

  ${
    pm5.74rd.1 $e |- ( ph -> ( ( ps -> ch ) <-> ( ps -> th ) ) ) $.
    $( Distribution of implication over biconditional (deduction form).
       (Contributed by NM, 19-Mar-1997.) $)
    pm5.74rd $p |- ( ph -> ( ps -> ( ch <-> th ) ) ) $=
      wph wps wch wi wps wth wi wb wps wch wth wb wi pm5.74rd.1 wps wch wth
      pm5.74 sylibr $.
  $}

  ${
    bitri.1 $e |- ( ph <-> ps ) $.
    bitri.2 $e |- ( ps <-> ch ) $.
    $( An inference from transitive law for logical equivalence.  (Contributed
       by NM, 3-Jan-1993.)  (Proof shortened by Wolf Lammen, 13-Oct-2012.) $)
    bitri $p |- ( ph <-> ch ) $=
      wph wch wph wps wch bitri.1 bitri.2 sylbb wph wps wch bitri.1 bitri.2
      sylbbr impbii $.
  $}

  ${
    bitr2i.1 $e |- ( ph <-> ps ) $.
    bitr2i.2 $e |- ( ps <-> ch ) $.
    $( An inference from transitive law for logical equivalence.  (Contributed
       by NM, 12-Mar-1993.) $)
    bitr2i $p |- ( ch <-> ph ) $=
      wph wch wph wps wch bitr2i.1 bitr2i.2 bitri bicomi $.
  $}

  ${
    bitr3i.1 $e |- ( ps <-> ph ) $.
    bitr3i.2 $e |- ( ps <-> ch ) $.
    $( An inference from transitive law for logical equivalence.  (Contributed
       by NM, 2-Jun-1993.) $)
    bitr3i $p |- ( ph <-> ch ) $=
      wph wps wch wps wph bitr3i.1 bicomi bitr3i.2 bitri $.
  $}

  ${
    bitr4i.1 $e |- ( ph <-> ps ) $.
    bitr4i.2 $e |- ( ch <-> ps ) $.
    $( An inference from transitive law for logical equivalence.  (Contributed
       by NM, 3-Jan-1993.) $)
    bitr4i $p |- ( ph <-> ch ) $=
      wph wps wch bitr4i.1 wch wps bitr4i.2 bicomi bitri $.
  $}

  $( Register '<->' as an equality for its type (wff). $)
  $( $j
    equality 'wb' from 'biid' 'bicomi' 'bitri';
    definition 'dfbi1' for 'wb';
  $)

  ${
    bitrd.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    bitrd.2 $e |- ( ph -> ( ch <-> th ) ) $.
    $( Deduction form of ~ bitri .  (Contributed by NM, 12-Mar-1993.)  (Proof
       shortened by Wolf Lammen, 14-Apr-2013.) $)
    bitrd $p |- ( ph -> ( ps <-> th ) ) $=
      wph wps wth wph wps wi wph wch wi wph wth wi wph wps wch bitrd.1 pm5.74i
      wph wch wth bitrd.2 pm5.74i bitri pm5.74ri $.
  $}

  ${
    bitr2d.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    bitr2d.2 $e |- ( ph -> ( ch <-> th ) ) $.
    $( Deduction form of ~ bitr2i .  (Contributed by NM, 9-Jun-2004.) $)
    bitr2d $p |- ( ph -> ( th <-> ps ) ) $=
      wph wps wth wph wps wch wth bitr2d.1 bitr2d.2 bitrd bicomd $.
  $}

  ${
    bitr3d.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    bitr3d.2 $e |- ( ph -> ( ps <-> th ) ) $.
    $( Deduction form of ~ bitr3i .  (Contributed by NM, 14-May-1993.) $)
    bitr3d $p |- ( ph -> ( ch <-> th ) ) $=
      wph wch wps wth wph wps wch bitr3d.1 bicomd bitr3d.2 bitrd $.
  $}

  ${
    bitr4d.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    bitr4d.2 $e |- ( ph -> ( th <-> ch ) ) $.
    $( Deduction form of ~ bitr4i .  (Contributed by NM, 30-Jun-1993.) $)
    bitr4d $p |- ( ph -> ( ps <-> th ) ) $=
      wph wps wch wth bitr4d.1 wph wth wch bitr4d.2 bicomd bitrd $.
  $}

  ${
    bitrid.1 $e |- ( ph <-> ps ) $.
    bitrid.2 $e |- ( ch -> ( ps <-> th ) ) $.
    $( A syllogism inference from two biconditionals.  (Contributed by NM,
       12-Mar-1993.) $)
    bitrid $p |- ( ch -> ( ph <-> th ) ) $=
      wch wph wps wth wph wps wb wch bitrid.1 a1i bitrid.2 bitrd $.
  $}

  ${
    bitr2id.1 $e |- ( ph <-> ps ) $.
    bitr2id.2 $e |- ( ch -> ( ps <-> th ) ) $.
    $( A syllogism inference from two biconditionals.  (Contributed by NM,
       1-Aug-1993.) $)
    bitr2id $p |- ( ch -> ( th <-> ph ) ) $=
      wch wph wth wph wps wch wth bitr2id.1 bitr2id.2 bitrid bicomd $.
  $}

  ${
    bitr3id.1 $e |- ( ps <-> ph ) $.
    bitr3id.2 $e |- ( ch -> ( ps <-> th ) ) $.
    $( A syllogism inference from two biconditionals.  (Contributed by NM,
       5-Aug-1993.) $)
    bitr3id $p |- ( ch -> ( ph <-> th ) ) $=
      wph wps wch wth wps wph bitr3id.1 bicomi bitr3id.2 bitrid $.
  $}

  ${
    bitr3di.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    bitr3di.2 $e |- ( ps <-> th ) $.
    $( A syllogism inference from two biconditionals.  (Contributed by NM,
       25-Nov-1994.) $)
    bitr3di $p |- ( ph -> ( ch <-> th ) ) $=
      wth wps wph wch wps wth bitr3di.2 bicomi bitr3di.1 bitr2id $.
  $}

  ${
    bitrdi.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    bitrdi.2 $e |- ( ch <-> th ) $.
    $( A syllogism inference from two biconditionals.  (Contributed by NM,
       12-Mar-1993.) $)
    bitrdi $p |- ( ph -> ( ps <-> th ) ) $=
      wph wps wch wth bitrdi.1 wch wth wb wph bitrdi.2 a1i bitrd $.
  $}

  ${
    bitr2di.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    bitr2di.2 $e |- ( ch <-> th ) $.
    $( A syllogism inference from two biconditionals.  (Contributed by NM,
       5-Aug-1993.) $)
    bitr2di $p |- ( ph -> ( th <-> ps ) ) $=
      wph wps wth wph wps wch wth bitr2di.1 bitr2di.2 bitrdi bicomd $.
  $}

  ${
    bitr4di.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    bitr4di.2 $e |- ( th <-> ch ) $.
    $( A syllogism inference from two biconditionals.  (Contributed by NM,
       12-Mar-1993.) $)
    bitr4di $p |- ( ph -> ( ps <-> th ) ) $=
      wph wps wch wth bitr4di.1 wth wch bitr4di.2 bicomi bitrdi $.
  $}

  ${
    bitr4id.2 $e |- ( ps <-> ch ) $.
    bitr4id.1 $e |- ( ph -> ( th <-> ch ) ) $.
    $( A syllogism inference from two biconditionals.  (Contributed by NM,
       25-Nov-1994.) $)
    bitr4id $p |- ( ph -> ( ps <-> th ) ) $=
      wph wth wch wps bitr4id.1 wps wch bitr4id.2 bicomi bitr2di $.
  $}

  ${
    3imtr3.1 $e |- ( ph -> ps ) $.
    3imtr3.2 $e |- ( ph <-> ch ) $.
    3imtr3.3 $e |- ( ps <-> th ) $.
    $( A mixed syllogism inference, useful for removing a definition from both
       sides of an implication.  (Contributed by NM, 10-Aug-1994.) $)
    3imtr3i $p |- ( ch -> th ) $=
      wch wps wth wch wph wps 3imtr3.2 3imtr3.1 sylbir 3imtr3.3 sylib $.
  $}

  ${
    3imtr4.1 $e |- ( ph -> ps ) $.
    3imtr4.2 $e |- ( ch <-> ph ) $.
    3imtr4.3 $e |- ( th <-> ps ) $.
    $( A mixed syllogism inference, useful for applying a definition to both
       sides of an implication.  (Contributed by NM, 3-Jan-1993.) $)
    3imtr4i $p |- ( ch -> th ) $=
      wch wps wth wch wph wps 3imtr4.2 3imtr4.1 sylbi 3imtr4.3 sylibr $.
  $}

  ${
    3imtr3d.1 $e |- ( ph -> ( ps -> ch ) ) $.
    3imtr3d.2 $e |- ( ph -> ( ps <-> th ) ) $.
    3imtr3d.3 $e |- ( ph -> ( ch <-> ta ) ) $.
    $( More general version of ~ 3imtr3i .  Useful for converting conditional
       definitions in a formula.  (Contributed by NM, 8-Apr-1996.) $)
    3imtr3d $p |- ( ph -> ( th -> ta ) ) $=
      wph wth wps wta 3imtr3d.2 wph wps wch wta 3imtr3d.1 3imtr3d.3 sylibd
      sylbird $.
  $}

  ${
    3imtr4d.1 $e |- ( ph -> ( ps -> ch ) ) $.
    3imtr4d.2 $e |- ( ph -> ( th <-> ps ) ) $.
    3imtr4d.3 $e |- ( ph -> ( ta <-> ch ) ) $.
    $( More general version of ~ 3imtr4i .  Useful for converting conditional
       definitions in a formula.  (Contributed by NM, 26-Oct-1995.) $)
    3imtr4d $p |- ( ph -> ( th -> ta ) ) $=
      wph wth wps wta 3imtr4d.2 wph wps wch wta 3imtr4d.1 3imtr4d.3 sylibrd
      sylbid $.
  $}

  ${
    3imtr3g.1 $e |- ( ph -> ( ps -> ch ) ) $.
    3imtr3g.2 $e |- ( ps <-> th ) $.
    3imtr3g.3 $e |- ( ch <-> ta ) $.
    $( More general version of ~ 3imtr3i .  Useful for converting definitions
       in a formula.  (Contributed by NM, 20-May-1996.)  (Proof shortened by
       Wolf Lammen, 20-Dec-2013.) $)
    3imtr3g $p |- ( ph -> ( th -> ta ) ) $=
      wph wth wch wta wth wps wph wch 3imtr3g.2 3imtr3g.1 biimtrrid 3imtr3g.3
      imbitrdi $.
  $}

  ${
    3imtr4g.1 $e |- ( ph -> ( ps -> ch ) ) $.
    3imtr4g.2 $e |- ( th <-> ps ) $.
    3imtr4g.3 $e |- ( ta <-> ch ) $.
    $( More general version of ~ 3imtr4i .  Useful for converting definitions
       in a formula.  (Contributed by NM, 20-May-1996.)  (Proof shortened by
       Wolf Lammen, 20-Dec-2013.) $)
    3imtr4g $p |- ( ph -> ( th -> ta ) ) $=
      wph wth wch wta wth wps wph wch 3imtr4g.2 3imtr4g.1 biimtrid 3imtr4g.3
      imbitrrdi $.
  $}

  ${
    3bitri.1 $e |- ( ph <-> ps ) $.
    3bitri.2 $e |- ( ps <-> ch ) $.
    3bitri.3 $e |- ( ch <-> th ) $.
    $( A chained inference from transitive law for logical equivalence.
       (Contributed by NM, 3-Jan-1993.) $)
    3bitri $p |- ( ph <-> th ) $=
      wph wps wth 3bitri.1 wps wch wth 3bitri.2 3bitri.3 bitri bitri $.

    $( A chained inference from transitive law for logical equivalence.
       (Contributed by NM, 4-Aug-2006.) $)
    3bitrri $p |- ( th <-> ph ) $=
      wth wch wph 3bitri.3 wph wps wch 3bitri.1 3bitri.2 bitr2i bitr3i $.
  $}

  ${
    3bitr2i.1 $e |- ( ph <-> ps ) $.
    3bitr2i.2 $e |- ( ch <-> ps ) $.
    3bitr2i.3 $e |- ( ch <-> th ) $.
    $( A chained inference from transitive law for logical equivalence.
       (Contributed by NM, 4-Aug-2006.) $)
    3bitr2i $p |- ( ph <-> th ) $=
      wph wch wth wph wps wch 3bitr2i.1 3bitr2i.2 bitr4i 3bitr2i.3 bitri $.

    $( A chained inference from transitive law for logical equivalence.
       (Contributed by NM, 4-Aug-2006.) $)
    3bitr2ri $p |- ( th <-> ph ) $=
      wph wch wth wph wps wch 3bitr2i.1 3bitr2i.2 bitr4i 3bitr2i.3 bitr2i $.
  $}

  ${
    3bitr3i.1 $e |- ( ph <-> ps ) $.
    3bitr3i.2 $e |- ( ph <-> ch ) $.
    3bitr3i.3 $e |- ( ps <-> th ) $.
    $( A chained inference from transitive law for logical equivalence.
       (Contributed by NM, 19-Aug-1993.) $)
    3bitr3i $p |- ( ch <-> th ) $=
      wch wps wth wch wph wps 3bitr3i.2 3bitr3i.1 bitr3i 3bitr3i.3 bitri $.

    $( A chained inference from transitive law for logical equivalence.
       (Contributed by NM, 21-Jun-1993.) $)
    3bitr3ri $p |- ( th <-> ch ) $=
      wth wps wch 3bitr3i.3 wps wph wch 3bitr3i.1 3bitr3i.2 bitr3i bitr3i $.
  $}

  ${
    3bitr4i.1 $e |- ( ph <-> ps ) $.
    3bitr4i.2 $e |- ( ch <-> ph ) $.
    3bitr4i.3 $e |- ( th <-> ps ) $.
    $( A chained inference from transitive law for logical equivalence.  This
       inference is frequently used to apply a definition to both sides of a
       logical equivalence.  (Contributed by NM, 3-Jan-1993.) $)
    3bitr4i $p |- ( ch <-> th ) $=
      wch wph wth 3bitr4i.2 wph wps wth 3bitr4i.1 3bitr4i.3 bitr4i bitri $.

    $( A chained inference from transitive law for logical equivalence.
       (Contributed by NM, 2-Sep-1995.) $)
    3bitr4ri $p |- ( th <-> ch ) $=
      wch wph wth 3bitr4i.2 wph wps wth 3bitr4i.1 3bitr4i.3 bitr4i bitr2i $.
  $}

  ${
    3bitrd.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    3bitrd.2 $e |- ( ph -> ( ch <-> th ) ) $.
    3bitrd.3 $e |- ( ph -> ( th <-> ta ) ) $.
    $( Deduction from transitivity of biconditional.  (Contributed by NM,
       13-Aug-1999.) $)
    3bitrd $p |- ( ph -> ( ps <-> ta ) ) $=
      wph wps wth wta wph wps wch wth 3bitrd.1 3bitrd.2 bitrd 3bitrd.3 bitrd $.

    $( Deduction from transitivity of biconditional.  (Contributed by NM,
       4-Aug-2006.) $)
    3bitrrd $p |- ( ph -> ( ta <-> ps ) ) $=
      wph wth wta wps 3bitrd.3 wph wps wch wth 3bitrd.1 3bitrd.2 bitr2d bitr3d
      $.
  $}

  ${
    3bitr2d.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    3bitr2d.2 $e |- ( ph -> ( th <-> ch ) ) $.
    3bitr2d.3 $e |- ( ph -> ( th <-> ta ) ) $.
    $( Deduction from transitivity of biconditional.  (Contributed by NM,
       4-Aug-2006.) $)
    3bitr2d $p |- ( ph -> ( ps <-> ta ) ) $=
      wph wps wth wta wph wps wch wth 3bitr2d.1 3bitr2d.2 bitr4d 3bitr2d.3
      bitrd $.

    $( Deduction from transitivity of biconditional.  (Contributed by NM,
       4-Aug-2006.) $)
    3bitr2rd $p |- ( ph -> ( ta <-> ps ) ) $=
      wph wps wth wta wph wps wch wth 3bitr2d.1 3bitr2d.2 bitr4d 3bitr2d.3
      bitr2d $.
  $}

  ${
    3bitr3d.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    3bitr3d.2 $e |- ( ph -> ( ps <-> th ) ) $.
    3bitr3d.3 $e |- ( ph -> ( ch <-> ta ) ) $.
    $( Deduction from transitivity of biconditional.  Useful for converting
       conditional definitions in a formula.  (Contributed by NM,
       24-Apr-1996.) $)
    3bitr3d $p |- ( ph -> ( th <-> ta ) ) $=
      wph wth wch wta wph wps wth wch 3bitr3d.2 3bitr3d.1 bitr3d 3bitr3d.3
      bitrd $.

    $( Deduction from transitivity of biconditional.  (Contributed by NM,
       4-Aug-2006.) $)
    3bitr3rd $p |- ( ph -> ( ta <-> th ) ) $=
      wph wch wta wth 3bitr3d.3 wph wps wch wth 3bitr3d.1 3bitr3d.2 bitr3d
      bitr3d $.
  $}

  ${
    3bitr4d.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    3bitr4d.2 $e |- ( ph -> ( th <-> ps ) ) $.
    3bitr4d.3 $e |- ( ph -> ( ta <-> ch ) ) $.
    $( Deduction from transitivity of biconditional.  Useful for converting
       conditional definitions in a formula.  (Contributed by NM,
       18-Oct-1995.) $)
    3bitr4d $p |- ( ph -> ( th <-> ta ) ) $=
      wph wth wps wta 3bitr4d.2 wph wps wch wta 3bitr4d.1 3bitr4d.3 bitr4d
      bitrd $.

    $( Deduction from transitivity of biconditional.  (Contributed by NM,
       4-Aug-2006.) $)
    3bitr4rd $p |- ( ph -> ( ta <-> th ) ) $=
      wph wta wps wth wph wta wch wps 3bitr4d.3 3bitr4d.1 bitr4d 3bitr4d.2
      bitr4d $.
  $}

  ${
    3bitr3g.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    3bitr3g.2 $e |- ( ps <-> th ) $.
    3bitr3g.3 $e |- ( ch <-> ta ) $.
    $( More general version of ~ 3bitr3i .  Useful for converting definitions
       in a formula.  (Contributed by NM, 4-Jun-1995.) $)
    3bitr3g $p |- ( ph -> ( th <-> ta ) ) $=
      wph wth wch wta wth wps wph wch 3bitr3g.2 3bitr3g.1 bitr3id 3bitr3g.3
      bitrdi $.
  $}

  ${
    3bitr4g.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    3bitr4g.2 $e |- ( th <-> ps ) $.
    3bitr4g.3 $e |- ( ta <-> ch ) $.
    $( More general version of ~ 3bitr4i .  Useful for converting definitions
       in a formula.  (Contributed by NM, 11-May-1993.) $)
    3bitr4g $p |- ( ph -> ( th <-> ta ) ) $=
      wph wth wch wta wth wps wph wch 3bitr4g.2 3bitr4g.1 bitrid 3bitr4g.3
      bitr4di $.
  $}

  $( Double negation.  Theorem *4.13 of [WhiteheadRussell] p. 117.
     (Contributed by NM, 3-Jan-1993.) $)
  notnotb $p |- ( ph <-> -. -. ph ) $=
    wph wph wn wn wph notnot wph notnotr impbii $.

  $( A biconditional form of contraposition.  Theorem *4.1 of
     [WhiteheadRussell] p. 116.  (Contributed by NM, 11-May-1993.) $)
  con34b $p |- ( ( ph -> ps ) <-> ( -. ps -> -. ph ) ) $=
    wph wps wi wps wn wph wn wi wph wps con3 wps wph con4 impbii $.

  ${
    con4bid.1 $e |- ( ph -> ( -. ps <-> -. ch ) ) $.
    $( A contraposition deduction.  (Contributed by NM, 21-May-1994.) $)
    con4bid $p |- ( ph -> ( ps <-> ch ) ) $=
      wph wps wch wph wch wps wph wps wn wch wn con4bid.1 biimprd con4d wph wps
      wn wch wn con4bid.1 biimpd impcon4bid $.
  $}

  ${
    notbid.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    $( Deduction negating both sides of a logical equivalence.  (Contributed by
       NM, 21-May-1994.) $)
    notbid $p |- ( ph -> ( -. ps <-> -. ch ) ) $=
      wph wps wn wch wn wph wps wch wps wn wn wch wn wn notbid.1 wps notnotb
      wch notnotb 3bitr3g con4bid $.
  $}

  $( Contraposition.  Theorem *4.11 of [WhiteheadRussell] p. 117.  (Contributed
     by NM, 21-May-1994.)  (Proof shortened by Wolf Lammen, 12-Jun-2013.) $)
  notbi $p |- ( ( ph <-> ps ) <-> ( -. ph <-> -. ps ) ) $=
    wph wps wb wph wn wps wn wb wph wps wb wph wps wph wps wb id notbid wph wn
    wps wn wb wph wps wph wn wps wn wb id con4bid impbii $.

  ${
    notbii.1 $e |- ( ph <-> ps ) $.
    $( Negate both sides of a logical equivalence.  (Contributed by NM,
       3-Jan-1993.)  (Proof shortened by Wolf Lammen, 19-May-2013.) $)
    notbii $p |- ( -. ph <-> -. ps ) $=
      wph wps wb wph wn wps wn wb notbii.1 wph wps notbi mpbi $.

    $( Theorem notbii is the congruence law for negation. $)
    $( $j congruence 'notbii'; $)
  $}

  ${
    con4bii.1 $e |- ( -. ph <-> -. ps ) $.
    $( A contraposition inference.  (Contributed by NM, 21-May-1994.) $)
    con4bii $p |- ( ph <-> ps ) $=
      wph wps wb wph wn wps wn wb con4bii.1 wph wps notbi mpbir $.
  $}

  ${
    mtbi.1 $e |- -. ph $.
    mtbi.2 $e |- ( ph <-> ps ) $.
    $( An inference from a biconditional, related to modus tollens.
       (Contributed by NM, 15-Nov-1994.)  (Proof shortened by Wolf Lammen,
       25-Oct-2012.) $)
    mtbi $p |- -. ps $=
      wps wph mtbi.1 wph wps mtbi.2 biimpri mto $.
  $}

  ${
    mtbir.1 $e |- -. ps $.
    mtbir.2 $e |- ( ph <-> ps ) $.
    $( An inference from a biconditional, related to modus tollens.
       (Contributed by NM, 15-Nov-1994.)  (Proof shortened by Wolf Lammen,
       14-Oct-2012.) $)
    mtbir $p |- -. ph $=
      wps wph mtbir.1 wph wps mtbir.2 bicomi mtbi $.
  $}

  ${
    mtbid.min $e |- ( ph -> -. ps ) $.
    mtbid.maj $e |- ( ph -> ( ps <-> ch ) ) $.
    $( A deduction from a biconditional, similar to modus tollens.
       (Contributed by NM, 26-Nov-1995.) $)
    mtbid $p |- ( ph -> -. ch ) $=
      wph wch wps mtbid.min wph wps wch mtbid.maj biimprd mtod $.
  $}

  ${
    mtbird.min $e |- ( ph -> -. ch ) $.
    mtbird.maj $e |- ( ph -> ( ps <-> ch ) ) $.
    $( A deduction from a biconditional, similar to modus tollens.
       (Contributed by NM, 10-May-1994.) $)
    mtbird $p |- ( ph -> -. ps ) $=
      wph wps wch mtbird.min wph wps wch mtbird.maj biimpd mtod $.
  $}

  ${
    mtbii.min $e |- -. ps $.
    mtbii.maj $e |- ( ph -> ( ps <-> ch ) ) $.
    $( An inference from a biconditional, similar to modus tollens.
       (Contributed by NM, 27-Nov-1995.) $)
    mtbii $p |- ( ph -> -. ch ) $=
      wph wch wps mtbii.min wph wps wch mtbii.maj biimprd mtoi $.
  $}

  ${
    mtbiri.min $e |- -. ch $.
    mtbiri.maj $e |- ( ph -> ( ps <-> ch ) ) $.
    $( An inference from a biconditional, similar to modus tollens.
       (Contributed by NM, 24-Aug-1995.) $)
    mtbiri $p |- ( ph -> -. ps ) $=
      wph wps wch mtbiri.min wph wps wch mtbiri.maj biimpd mtoi $.
  $}

  ${
    sylnib.1 $e |- ( ph -> -. ps ) $.
    sylnib.2 $e |- ( ps <-> ch ) $.
    $( A mixed syllogism inference from an implication and a biconditional.
       (Contributed by Wolf Lammen, 16-Dec-2013.) $)
    sylnib $p |- ( ph -> -. ch ) $=
      wph wps wch sylnib.1 wps wch sylnib.2 biimpri nsyl $.
  $}

  ${
    sylnibr.1 $e |- ( ph -> -. ps ) $.
    sylnibr.2 $e |- ( ch <-> ps ) $.
    $( A mixed syllogism inference from an implication and a biconditional.
       Useful for substituting a consequent with a definition.  (Contributed by
       Wolf Lammen, 16-Dec-2013.) $)
    sylnibr $p |- ( ph -> -. ch ) $=
      wph wps wch sylnibr.1 wch wps sylnibr.2 bicomi sylnib $.
  $}

  ${
    sylnbi.1 $e |- ( ph <-> ps ) $.
    sylnbi.2 $e |- ( -. ps -> ch ) $.
    $( A mixed syllogism inference from a biconditional and an implication.
       Useful for substituting an antecedent with a definition.  (Contributed
       by Wolf Lammen, 16-Dec-2013.) $)
    sylnbi $p |- ( -. ph -> ch ) $=
      wph wn wps wn wch wph wps sylnbi.1 notbii sylnbi.2 sylbi $.
  $}

  ${
    sylnbir.1 $e |- ( ps <-> ph ) $.
    sylnbir.2 $e |- ( -. ps -> ch ) $.
    $( A mixed syllogism inference from a biconditional and an implication.
       (Contributed by Wolf Lammen, 16-Dec-2013.) $)
    sylnbir $p |- ( -. ph -> ch ) $=
      wph wps wch wps wph sylnbir.1 bicomi sylnbir.2 sylnbi $.
  $}

  ${
    xchnxbi.1 $e |- ( -. ph <-> ps ) $.
    xchnxbi.2 $e |- ( ph <-> ch ) $.
    $( Replacement of a subexpression by an equivalent one.  (Contributed by
       Wolf Lammen, 27-Sep-2014.) $)
    xchnxbi $p |- ( -. ch <-> ps ) $=
      wch wn wph wn wps wph wch xchnxbi.2 notbii xchnxbi.1 bitr3i $.
  $}

  ${
    xchnxbir.1 $e |- ( -. ph <-> ps ) $.
    xchnxbir.2 $e |- ( ch <-> ph ) $.
    $( Replacement of a subexpression by an equivalent one.  (Contributed by
       Wolf Lammen, 27-Sep-2014.) $)
    xchnxbir $p |- ( -. ch <-> ps ) $=
      wph wps wch xchnxbir.1 wch wph xchnxbir.2 bicomi xchnxbi $.
  $}

  ${
    xchbinx.1 $e |- ( ph <-> -. ps ) $.
    xchbinx.2 $e |- ( ps <-> ch ) $.
    $( Replacement of a subexpression by an equivalent one.  (Contributed by
       Wolf Lammen, 27-Sep-2014.) $)
    xchbinx $p |- ( ph <-> -. ch ) $=
      wph wps wn wch wn xchbinx.1 wps wch xchbinx.2 notbii bitri $.
  $}

  ${
    xchbinxr.1 $e |- ( ph <-> -. ps ) $.
    xchbinxr.2 $e |- ( ch <-> ps ) $.
    $( Replacement of a subexpression by an equivalent one.  (Contributed by
       Wolf Lammen, 27-Sep-2014.) $)
    xchbinxr $p |- ( ph <-> -. ch ) $=
      wph wps wch xchbinxr.1 wch wps xchbinxr.2 bicomi xchbinx $.
  $}

  ${
    imbi2i.1 $e |- ( ph <-> ps ) $.
    $( Introduce an antecedent to both sides of a logical equivalence.  This
       and the next three rules are useful for building up wff's around a
       definition, in order to make use of the definition.  (Contributed by NM,
       3-Jan-1993.)  (Proof shortened by Wolf Lammen, 6-Feb-2013.) $)
    imbi2i $p |- ( ( ch -> ph ) <-> ( ch -> ps ) ) $=
      wch wph wps wph wps wb wch imbi2i.1 a1i pm5.74i $.
  $}

  ${
    bibi2i.1 $e |- ( ph <-> ps ) $.
    $( Inference adding a biconditional to the left in an equivalence.
       (Contributed by NM, 26-May-1993.)  (Proof shortened by Andrew Salmon,
       7-May-2011.)  (Proof shortened by Wolf Lammen, 16-May-2013.) $)
    bibi2i $p |- ( ( ch <-> ph ) <-> ( ch <-> ps ) ) $=
      wch wph wb wch wps wb wch wph wb wch wph wps wch wph wb id bibi2i.1
      bitrdi wch wps wb wch wps wph wch wps wb id bibi2i.1 bitr4di impbii $.

    $( Inference adding a biconditional to the right in an equivalence.
       (Contributed by NM, 26-May-1993.) $)
    bibi1i $p |- ( ( ph <-> ch ) <-> ( ps <-> ch ) ) $=
      wph wch wb wch wph wb wch wps wb wps wch wb wph wch bicom wph wps wch
      bibi2i.1 bibi2i wch wps bicom 3bitri $.

    ${
      bibi12i.2 $e |- ( ch <-> th ) $.
      $( The equivalence of two equivalences.  (Contributed by NM,
         26-May-1993.) $)
      bibi12i $p |- ( ( ph <-> ch ) <-> ( ps <-> th ) ) $=
        wph wch wb wph wth wb wps wth wb wch wth wph bibi12i.2 bibi2i wph wps
        wth bibi2i.1 bibi1i bitri $.
    $}
  $}

  ${
    imbid.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    $( Deduction adding an antecedent to both sides of a logical equivalence.
       (Contributed by NM, 11-May-1993.) $)
    imbi2d $p |- ( ph -> ( ( th -> ps ) <-> ( th -> ch ) ) ) $=
      wph wth wps wch wph wps wch wb wth imbid.1 a1d pm5.74d $.

    $( Deduction adding a consequent to both sides of a logical equivalence.
       (Contributed by NM, 11-May-1993.)  (Proof shortened by Wolf Lammen,
       17-Sep-2013.) $)
    imbi1d $p |- ( ph -> ( ( ps -> th ) <-> ( ch -> th ) ) ) $=
      wph wps wth wi wch wth wi wph wch wps wth wph wps wch imbid.1 biimprd
      imim1d wph wps wch wth wph wps wch imbid.1 biimpd imim1d impbid $.

    $( Deduction adding a biconditional to the left in an equivalence.
       (Contributed by NM, 11-May-1993.)  (Proof shortened by Wolf Lammen,
       19-May-2013.) $)
    bibi2d $p |- ( ph -> ( ( th <-> ps ) <-> ( th <-> ch ) ) ) $=
      wph wth wps wb wth wch wb wph wth wi wph wps wi wb wph wth wi wph wch wi
      wb wph wth wps wb wi wph wth wch wb wi wph wps wi wph wch wi wph wth wi
      wph wps wch imbid.1 pm5.74i bibi2i wph wth wps pm5.74 wph wth wch pm5.74
      3bitr4i pm5.74ri $.

    $( Deduction adding a biconditional to the right in an equivalence.
       (Contributed by NM, 11-May-1993.) $)
    bibi1d $p |- ( ph -> ( ( ps <-> th ) <-> ( ch <-> th ) ) ) $=
      wph wth wps wb wth wch wb wps wth wb wch wth wb wph wps wch wth imbid.1
      bibi2d wps wth bicom wch wth bicom 3bitr4g $.
  $}

  ${
    imbi12d.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    imbi12d.2 $e |- ( ph -> ( th <-> ta ) ) $.
    $( Deduction joining two equivalences to form equivalence of implications.
       (Contributed by NM, 16-May-1993.) $)
    imbi12d $p |- ( ph -> ( ( ps -> th ) <-> ( ch -> ta ) ) ) $=
      wph wps wth wi wch wth wi wch wta wi wph wps wch wth imbi12d.1 imbi1d wph
      wth wta wch imbi12d.2 imbi2d bitrd $.

    $( Deduction joining two equivalences to form equivalence of
       biconditionals.  (Contributed by NM, 26-May-1993.) $)
    bibi12d $p |- ( ph -> ( ( ps <-> th ) <-> ( ch <-> ta ) ) ) $=
      wph wps wth wb wch wth wb wch wta wb wph wps wch wth imbi12d.1 bibi1d wph
      wth wta wch imbi12d.2 bibi2d bitrd $.
  $}

  $( Closed form of ~ imbi12i .  Was automatically derived from its "Virtual
     Deduction" version and the Metamath program "MM-PA> MINIMIZE__WITH *"
     command.  (Contributed by Alan Sare, 18-Mar-2012.) $)
  imbi12 $p |- ( ( ph <-> ps ) ->
                    ( ( ch <-> th ) -> ( ( ph -> ch ) <-> ( ps -> th ) ) ) ) $=
    wph wps wb wch wth wb wph wch wi wps wth wi wb wph wps wb wch wth wb wn wi
    wn wph wps wch wth wph wps wb wch wth wb wn simplim wph wps wb wch wth wb
    simprim imbi12d expi $.

  $( Theorem *4.84 of [WhiteheadRussell] p. 122.  (Contributed by NM,
     3-Jan-2005.) $)
  imbi1 $p |- ( ( ph <-> ps ) -> ( ( ph -> ch ) <-> ( ps -> ch ) ) ) $=
    wph wps wb wph wps wch wph wps wb id imbi1d $.

  $( Theorem *4.85 of [WhiteheadRussell] p. 122.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 19-May-2013.) $)
  imbi2 $p |- ( ( ph <-> ps ) -> ( ( ch -> ph ) <-> ( ch -> ps ) ) ) $=
    wph wps wb wph wps wch wph wps wb id imbi2d $.

  ${
    imbi1i.1 $e |- ( ph <-> ps ) $.
    $( Introduce a consequent to both sides of a logical equivalence.
       (Contributed by NM, 3-Jan-1993.)  (Proof shortened by Wolf Lammen,
       17-Sep-2013.) $)
    imbi1i $p |- ( ( ph -> ch ) <-> ( ps -> ch ) ) $=
      wph wps wb wph wch wi wps wch wi wb imbi1i.1 wph wps wch imbi1 ax-mp $.
  $}

  ${
    imbi12i.1 $e |- ( ph <-> ps ) $.
    imbi12i.2 $e |- ( ch <-> th ) $.
    $( Join two logical equivalences to form equivalence of implications.
       (Contributed by NM, 1-Aug-1993.) $)
    imbi12i $p |- ( ( ph -> ch ) <-> ( ps -> th ) ) $=
      wph wps wb wch wth wb wph wch wi wps wth wi wb imbi12i.1 imbi12i.2 wph
      wps wch wth imbi12 mp2 $.

    $( Theorem imbi12i is the congruence law for implication. $)
    $( $j congruence 'imbi12i'; $)
  $}

  $( Theorem *4.86 of [WhiteheadRussell] p. 122.  (Contributed by NM,
     3-Jan-2005.) $)
  bibi1 $p |- ( ( ph <-> ps ) -> ( ( ph <-> ch ) <-> ( ps <-> ch ) ) ) $=
    wph wps wb wph wps wch wph wps wb id bibi1d $.

  $( Closed nested implication form of ~ bitr3i .  Derived automatically from
     ~ bitr3VD .  (Contributed by Alan Sare, 31-Dec-2011.) $)
  bitr3 $p |- ( ( ph <-> ps ) -> ( ( ph <-> ch ) -> ( ps <-> ch ) ) ) $=
    wph wps wb wph wch wb wps wch wb wph wps wch bibi1 biimpd $.

  $( Contraposition.  Theorem *4.12 of [WhiteheadRussell] p. 117.  (Contributed
     by NM, 15-Apr-1995.)  (Proof shortened by Wolf Lammen, 3-Jan-2013.) $)
  con2bi $p |- ( ( ph <-> -. ps ) <-> ( ps <-> -. ph ) ) $=
    wph wps wn wb wph wn wps wn wn wb wph wn wps wb wps wph wn wb wph wps wn
    notbi wps wps wn wn wph wn wps notnotb bibi2i wph wn wps bicom 3bitr2i $.

  ${
    con2bid.1 $e |- ( ph -> ( ps <-> -. ch ) ) $.
    $( A contraposition deduction.  (Contributed by NM, 15-Apr-1995.) $)
    con2bid $p |- ( ph -> ( ch <-> -. ps ) ) $=
      wph wps wch wn wb wch wps wn wb con2bid.1 wch wps con2bi sylibr $.
  $}

  ${
    con1bid.1 $e |- ( ph -> ( -. ps <-> ch ) ) $.
    $( A contraposition deduction.  (Contributed by NM, 9-Oct-1999.) $)
    con1bid $p |- ( ph -> ( -. ch <-> ps ) ) $=
      wph wps wch wn wph wch wps wph wps wn wch con1bid.1 bicomd con2bid bicomd
      $.
  $}

  ${
    con1bii.1 $e |- ( -. ph <-> ps ) $.
    $( A contraposition inference.  (Contributed by NM, 12-Mar-1993.)  (Proof
       shortened by Wolf Lammen, 13-Oct-2012.) $)
    con1bii $p |- ( -. ps <-> ph ) $=
      wph wps wn wph wph wn wps wph notnotb con1bii.1 xchbinx bicomi $.
  $}

  ${
    con2bii.1 $e |- ( ph <-> -. ps ) $.
    $( A contraposition inference.  (Contributed by NM, 12-Mar-1993.) $)
    con2bii $p |- ( ps <-> -. ph ) $=
      wps wps wn wph wps notnotb con2bii.1 xchbinxr $.
  $}

  $( Contraposition.  Bidirectional version of ~ con1 .  (Contributed by NM,
     3-Jan-1993.) $)
  con1b $p |- ( ( -. ph -> ps ) <-> ( -. ps -> ph ) ) $=
    wph wn wps wi wps wn wph wi wph wps con1 wps wph con1 impbii $.

  $( Contraposition.  Bidirectional version of ~ con2 .  (Contributed by NM,
     12-Mar-1993.) $)
  con2b $p |- ( ( ph -> -. ps ) <-> ( ps -> -. ph ) ) $=
    wph wps wn wi wps wph wn wi wph wps con2 wps wph con2 impbii $.

  $( A wff is equivalent to itself with true antecedent.  (Contributed by NM,
     28-Jan-1996.) $)
  biimt $p |- ( ph -> ( ps <-> ( ph -> ps ) ) ) $=
    wph wps wph wps wi wps wph ax-1 wph wps pm2.27 impbid2 $.

  $( Theorem *5.5 of [WhiteheadRussell] p. 125.  (Contributed by NM,
     3-Jan-2005.) $)
  pm5.5 $p |- ( ph -> ( ( ph -> ps ) <-> ps ) ) $=
    wph wps wph wps wi wph wps biimt bicomd $.

  ${
    a1bi.1 $e |- ph $.
    $( Inference introducing a theorem as an antecedent.  (Contributed by NM,
       5-Aug-1993.)  (Proof shortened by Wolf Lammen, 11-Nov-2012.) $)
    a1bi $p |- ( ps <-> ( ph -> ps ) ) $=
      wph wps wph wps wi wb a1bi.1 wph wps biimt ax-mp $.
  $}

  ${
    mt2bi.1 $e |- ph $.
    $( A false consequent falsifies an antecedent.  (Contributed by NM,
       19-Aug-1993.)  (Proof shortened by Wolf Lammen, 12-Nov-2012.) $)
    mt2bi $p |- ( -. ps <-> ( ps -> -. ph ) ) $=
      wps wn wph wps wn wi wps wph wn wi wph wps wn mt2bi.1 a1bi wph wps con2b
      bitri $.
  $}

  $( Modus-tollens-like theorem.  (Contributed by NM, 7-Apr-2001.)  (Proof
     shortened by Wolf Lammen, 12-Nov-2012.) $)
  mtt $p |- ( -. ph -> ( -. ps <-> ( ps -> ph ) ) ) $=
    wph wn wps wn wph wn wps wn wi wps wph wi wph wn wps wn biimt wps wph
    con34b bitr4di $.

  $( If a proposition is false, then implying it is equivalent to being false.
     One of four theorems that can be used to simplify an implication
     ` ( ph -> ps ) ` , the other ones being ~ ax-1 (true consequent), ~ pm2.21
     (false antecedent), ~ pm5.5 (true antecedent).  (Contributed by Mario
     Carneiro, 26-Apr-2019.)  (Proof shortened by Wolf Lammen, 26-May-2019.) $)
  imnot $p |- ( -. ps -> ( ( ph -> ps ) <-> -. ph ) ) $=
    wps wn wph wn wph wps wi wps wph mtt bicomd $.

  $( Theorem *5.501 of [WhiteheadRussell] p. 125.  (Contributed by NM,
     3-Jan-2005.) $)
  pm5.501 $p |- ( ph -> ( ps <-> ( ph <-> ps ) ) ) $=
    wph wps wph wps wb wph wps pm5.1im wph wps wb wph wps wph wps biimp com12
    impbid $.

  $( Implication in terms of implication and biconditional.  (Contributed by
     NM, 31-Mar-1994.)  (Proof shortened by Wolf Lammen, 24-Jan-2013.) $)
  ibib $p |- ( ( ph -> ps ) <-> ( ph -> ( ph <-> ps ) ) ) $=
    wph wps wph wps wb wph wps pm5.501 pm5.74i $.

  $( Implication in terms of implication and biconditional.  (Contributed by
     NM, 29-Apr-2005.)  (Proof shortened by Wolf Lammen, 21-Dec-2013.) $)
  ibibr $p |- ( ( ph -> ps ) <-> ( ph -> ( ps <-> ph ) ) ) $=
    wph wps wps wph wb wph wps wph wps wb wps wph wb wph wps pm5.501 wph wps
    bicom bitrdi pm5.74i $.

  ${
    tbt.1 $e |- ph $.
    $( A wff is equivalent to its equivalence with a truth.  (Contributed by
       NM, 18-Aug-1993.)  (Proof shortened by Andrew Salmon, 13-May-2011.) $)
    tbt $p |- ( ps <-> ( ps <-> ph ) ) $=
      wph wps wps wph wb wb tbt.1 wph wps wps wph wb wph wps ibibr pm5.74ri
      ax-mp $.
  $}

  $( The negation of a wff is equivalent to the wff's equivalence to falsehood.
     (Contributed by Juha Arpiainen, 19-Jan-2006.)  (Proof shortened by Wolf
     Lammen, 28-Jan-2013.) $)
  nbn2 $p |- ( -. ph -> ( -. ps <-> ( ph <-> ps ) ) ) $=
    wph wn wps wn wph wn wps wn wb wph wps wb wph wn wps wn pm5.501 wph wps
    notbi bitr4di $.

  $( Transfer negation via an equivalence.  (Contributed by NM, 3-Oct-2007.)
     (Proof shortened by Wolf Lammen, 28-Jan-2013.) $)
  bibif $p |- ( -. ps -> ( ( ph <-> ps ) <-> -. ph ) ) $=
    wps wn wph wn wps wph wb wph wps wb wps wph nbn2 wps wph bicom bitr2di $.

  ${
    nbn.1 $e |- -. ph $.
    $( The negation of a wff is equivalent to the wff's equivalence to
       falsehood.  (Contributed by NM, 21-Jun-1993.)  (Proof shortened by Wolf
       Lammen, 3-Oct-2013.) $)
    nbn $p |- ( -. ps <-> ( ps <-> ph ) ) $=
      wps wph wb wps wn wph wn wps wph wb wps wn wb nbn.1 wps wph bibif ax-mp
      bicomi $.
  $}

  ${
    nbn3.1 $e |- ph $.
    $( Transfer falsehood via equivalence.  (Contributed by NM,
       11-Sep-2006.) $)
    nbn3 $p |- ( -. ps <-> ( ps <-> -. ph ) ) $=
      wph wn wps wph nbn3.1 notnoti nbn $.
  $}

  $( Two propositions are equivalent if they are both false.  Closed form of
     ~ 2false .  Equivalent to a ~ biimpr -like version of the xor-connective.
     (Contributed by Wolf Lammen, 13-May-2013.) $)
  pm5.21im $p |- ( -. ph -> ( -. ps -> ( ph <-> ps ) ) ) $=
    wph wn wps wn wph wps wb wph wps nbn2 biimpd $.

  ${
    2false.1 $e |- -. ph $.
    2false.2 $e |- -. ps $.
    $( Two falsehoods are equivalent.  (Contributed by NM, 4-Apr-2005.)  (Proof
       shortened by Wolf Lammen, 19-May-2013.) $)
    2false $p |- ( ph <-> ps ) $=
      wph wps wph wn wps wn 2false.1 2false.2 2th con4bii $.
  $}

  ${
    2falsed.1 $e |- ( ph -> -. ps ) $.
    2falsed.2 $e |- ( ph -> -. ch ) $.
    $( Two falsehoods are equivalent (deduction form).  (Contributed by NM,
       11-Oct-2013.)  (Proof shortened by Wolf Lammen, 11-Apr-2024.) $)
    2falsed $p |- ( ph -> ( ps <-> ch ) ) $=
      wph wps wch wph wps wn wch wn 2falsed.1 2falsed.2 2thd con4bid $.
  $}

  ${
    pm5.21ni.1 $e |- ( ph -> ps ) $.
    pm5.21ni.2 $e |- ( ch -> ps ) $.
    $( Two propositions implying a false one are equivalent.  (Contributed by
       NM, 16-Feb-1996.)  (Proof shortened by Wolf Lammen, 19-May-2013.) $)
    pm5.21ni $p |- ( -. ps -> ( ph <-> ch ) ) $=
      wps wn wph wch wph wps pm5.21ni.1 con3i wch wps pm5.21ni.2 con3i 2falsed
      $.

    ${
      pm5.21nii.3 $e |- ( ps -> ( ph <-> ch ) ) $.
      $( Eliminate an antecedent implied by each side of a biconditional.
         (Contributed by NM, 21-May-1999.) $)
      pm5.21nii $p |- ( ph <-> ch ) $=
        wps wph wch wb pm5.21nii.3 wph wps wch pm5.21ni.1 pm5.21ni.2 pm5.21ni
        pm2.61i $.
    $}
  $}

  ${
    pm5.21ndd.1 $e |- ( ph -> ( ch -> ps ) ) $.
    pm5.21ndd.2 $e |- ( ph -> ( th -> ps ) ) $.
    pm5.21ndd.3 $e |- ( ph -> ( ps -> ( ch <-> th ) ) ) $.
    $( Eliminate an antecedent implied by each side of a biconditional,
       deduction version.  (Contributed by Paul Chapman, 21-Nov-2012.)  (Proof
       shortened by Wolf Lammen, 6-Oct-2013.) $)
    pm5.21ndd $p |- ( ph -> ( ch <-> th ) ) $=
      wph wps wch wth wb pm5.21ndd.3 wph wps wn wch wn wth wn wch wth wb wph
      wch wps pm5.21ndd.1 con3d wph wth wps pm5.21ndd.2 con3d wch wth pm5.21im
      syl6c pm2.61d $.
  $}

  ${
    bija.1 $e |- ( ph -> ( ps -> ch ) ) $.
    bija.2 $e |- ( -. ph -> ( -. ps -> ch ) ) $.
    $( Combine antecedents into a single biconditional.  This inference,
       reminiscent of ~ ja , is reversible:  The hypotheses can be deduced from
       the conclusion alone (see ~ pm5.1im and ~ pm5.21im ).  (Contributed by
       Wolf Lammen, 13-May-2013.) $)
    bija $p |- ( ( ph <-> ps ) -> ch ) $=
      wph wps wb wps wch wps wph wps wb wph wch wph wps biimpr bija.1 syli wps
      wn wph wps wb wph wn wch wph wps wb wph wps wph wps biimp con3d bija.2
      syli pm2.61d $.
  $}

  $( Theorem *5.18 of [WhiteheadRussell] p. 124.  This theorem says that
     logical equivalence is the same as negated "exclusive or".  (Contributed
     by NM, 28-Jun-2002.)  (Proof shortened by Andrew Salmon, 20-Jun-2011.)
     (Proof shortened by Wolf Lammen, 15-Oct-2013.) $)
  pm5.18 $p |- ( ( ph <-> ps ) <-> -. ( ph <-> -. ps ) ) $=
    wph wph wps wb wph wps wn wb wn wb wph wph wps wn wb wn wps wph wps wb wph
    wps wph wps wn wb wph wps wn pm5.501 con1bid wph wps pm5.501 bitr2d wph wn
    wph wps wn wb wn wps wn wph wps wb wph wn wps wn wph wps wn wb wph wps wn
    nbn2 con1bid wph wps nbn2 bitr2d pm2.61i $.

  $( Two ways to express "exclusive or".  (Contributed by NM, 1-Jan-2006.) $)
  xor3 $p |- ( -. ( ph <-> ps ) <-> ( ph <-> -. ps ) ) $=
    wph wps wn wb wph wps wb wn wph wps wb wph wps wn wb wph wps pm5.18 con2bii
    bicomi $.

  $( Move negation outside of biconditional.  Compare Theorem *5.18 of
     [WhiteheadRussell] p. 124.  (Contributed by NM, 27-Jun-2002.)  (Proof
     shortened by Wolf Lammen, 20-Sep-2013.) $)
  nbbn $p |- ( ( -. ph <-> ps ) <-> -. ( ph <-> ps ) ) $=
    wph wps wb wn wph wps wn wb wps wph wn wb wph wn wps wb wph wps xor3 wph
    wps con2bi wps wph wn bicom 3bitrri $.

  $( Associative law for the biconditional.  An axiom of system DS in Vladimir
     Lifschitz, "On calculational proofs", Annals of Pure and Applied Logic,
     113:207-224, 2002,
     ~ http://www.cs.utexas.edu/users/ai-lab/pub-view.php?PubID=26805 .
     Interestingly, this law was not included in _Principia Mathematica_ but
     was apparently first noted by Jan Lukasiewicz circa 1923.  (Contributed by
     NM, 8-Jan-2005.)  (Proof shortened by Juha Arpiainen, 19-Jan-2006.)
     (Proof shortened by Wolf Lammen, 21-Sep-2013.) $)
  biass $p |- ( ( ( ph <-> ps ) <-> ch ) <-> ( ph <-> ( ps <-> ch ) ) ) $=
    wph wph wps wb wch wb wph wps wch wb wb wb wph wps wch wb wph wps wb wch wb
    wph wps wch wb wb wph wps wph wps wb wch wph wps pm5.501 bibi1d wph wps wch
    wb pm5.501 bitr3d wph wn wps wch wb wn wph wps wb wch wb wph wps wch wb wb
    wps wch wb wn wps wn wch wb wph wn wph wps wb wch wb wps wch nbbn wph wn
    wps wn wph wps wb wch wph wps nbn2 bibi1d bitr3id wph wps wch wb nbn2
    bitr3d pm2.61i $.

  $( Lukasiewicz's shortest axiom for equivalential calculus.  Storrs McCall,
     ed., _Polish Logic 1920-1939_ (Oxford, 1967), p. 96.  (Contributed by NM,
     10-Jan-2005.) $)
  biluk $p |- ( ( ph <-> ps ) <-> ( ( ch <-> ps ) <-> ( ph <-> ch ) ) ) $=
    wph wps wb wch wps wph wch wb wb wb wch wps wb wph wch wb wb wph wps wb wch
    wb wps wph wch wb wb wb wph wps wb wch wps wph wch wb wb wb wb wph wps wb
    wch wb wps wph wb wch wb wps wph wch wb wb wph wps wb wps wph wb wch wph
    wps bicom bibi1i wps wph wch biass bitri wph wps wb wch wps wph wch wb wb
    biass mpbi wch wps wph wch wb biass bitr4i $.

  $( Theorem *5.19 of [WhiteheadRussell] p. 124.  (Contributed by NM,
     3-Jan-2005.) $)
  pm5.19 $p |- -. ( ph <-> -. ph ) $=
    wph wph wb wph wph wn wb wn wph biid wph wph pm5.18 mpbi $.

  $( Logical equivalence of commuted antecedents.  Part of Theorem *4.87 of
     [WhiteheadRussell] p. 122.  (Contributed by NM, 11-May-1993.) $)
  bi2.04 $p |- ( ( ph -> ( ps -> ch ) ) <-> ( ps -> ( ph -> ch ) ) ) $=
    wph wps wch wi wi wps wph wch wi wi wph wps wch pm2.04 wps wph wch pm2.04
    impbii $.

  $( Antecedent absorption implication.  Theorem *5.4 of [WhiteheadRussell]
     p. 125.  (Contributed by NM, 5-Aug-1993.) $)
  pm5.4 $p |- ( ( ph -> ( ph -> ps ) ) <-> ( ph -> ps ) ) $=
    wph wph wps wi wps wph wps pm5.5 pm5.74i $.

  $( Distributive law for implication.  Compare Theorem *5.41 of
     [WhiteheadRussell] p. 125.  (Contributed by NM, 5-Aug-1993.) $)
  imdi $p |- ( ( ph -> ( ps -> ch ) ) <->
               ( ( ph -> ps ) -> ( ph -> ch ) ) ) $=
    wph wps wch wi wi wph wps wi wph wch wi wi wph wps wch ax-2 wph wps wch
    pm2.86 impbii $.

  $( Theorem *5.41 of [WhiteheadRussell] p. 125.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 12-Oct-2012.) $)
  pm5.41 $p |- ( ( ( ph -> ps ) -> ( ph -> ch ) ) <->
                ( ph -> ( ps -> ch ) ) ) $=
    wph wps wch wi wi wph wps wi wph wch wi wi wph wps wch imdi bicomi $.

  $( The antecedent of one side of a biconditional can be moved out of the
     biconditional to become the antecedent of the remaining biconditional.
     (Contributed by BJ, 1-Jan-2025.)  (Proof shortened by Wolf Lammen,
     5-Jan-2025.) $)
  imbibi $p |- ( ( ( ph -> ps ) <-> ch ) -> ( ph -> ( ps <-> ch ) ) ) $=
    wph wps wi wch wb wph wps wch wph wps wi wph wph wps wi wi wph wps wi wch
    wb wph wch wi wph wps pm5.4 wph wps wi wch wph imbi2 bitr3id pm5.74rd $.

  $( Theorem *4.8 of [WhiteheadRussell] p. 122.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.8 $p |- ( ( ph -> -. ph ) <-> -. ph ) $=
    wph wph wn wi wph wn wph pm2.01 wph wn wph ax-1 impbii $.

  $( A formula is equivalent to its negation implying it.  Theorem *4.81 of
     [WhiteheadRussell] p. 122.  Note that the second step, using ~ pm2.24 ,
     could also use ~ ax-1 .  (Contributed by NM, 3-Jan-2005.) $)
  pm4.81 $p |- ( ( -. ph -> ph ) <-> ph ) $=
    wph wn wph wi wph wph pm2.18 wph wph pm2.24 impbii $.

  $( Simplify an implication between two implications when the antecedent of
     the first is a consequence of the antecedent of the second.  The reverse
     form is useful in producing the successor step in induction proofs.
     (Contributed by Paul Chapman, 22-Jun-2011.)  (Proof shortened by Wolf
     Lammen, 14-Sep-2013.) $)
  imim21b $p |- ( ( ps -> ph ) ->
           ( ( ( ph -> ch ) -> ( ps -> th ) ) <-> ( ps -> ( ch -> th ) ) ) ) $=
    wph wch wi wps wth wi wi wps wph wch wi wth wi wi wps wph wi wps wch wth wi
    wi wph wch wi wps wth bi2.04 wps wph wi wps wph wch wi wth wi wch wth wi
    wph wph wch wi wth wi wch wth wi wb wps wph wph wch wi wch wth wph wch
    pm5.5 imbi1d imim2i pm5.74d bitrid $.


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Logical conjunction
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  This section defines conjunction of two formulas, denoted by infix " ` /\ ` "
  and read "and".  It is defined in terms of implication and negation, which is
  possible in classical logic (but not in intuitionistic logic: see iset.mm).

  After the definition, we briefly introduce conversion of simple expressions
  to and from conjunction.  Two simple operations called importation ( ~ imp )
  and exportation ( ~ ex ) follow.  In the propositions-as-types
  interpretation, they correspond to uncurrying and currying respectively. They
  are foundational for this section.  Most of the theorems proved here trace
  back to them, mostly indirectly, in a layered fashion, where more complex
  expressions are built from simpler ones.  Here are some of these successive
  layers:
  importation and exportation,
  commutativity and associativity laws,
  adding antecedents and simplifying,
  conjunction of consequents,
  syllogisms,
  etc.

  As indicated in the "note on definitions" in the section comment for logical
  equivalence, some theorems containing only implication, negation and
  conjunction are placed in the section after disjunction since theirs proofs
  use disjunction (although this is not required since definitions are
  conservative, see said section comment).

$)

  $( Declare connective for conjunction ("and"). $)
  $c /\ $.  $( Wedge (read:  "and") $)

  $( Extend wff definition to include conjunction ("and"). $)
  wa $a wff ( ph /\ ps ) $.

  $( Define conjunction (logical "and").  Definition of [Margaris] p. 49.  When
     both the left and right operand are true, the result is true; when either
     is false, the result is false.  For example, it is true that
     ` ( 2 = 2 /\ 3 = 3 ) ` .  After we define the constant true ` T. `
     ( ~ df-tru ) and the constant false ` F. ` ( ~ df-fal ), we will be able
     to prove these truth table values: ` ( ( T. /\ T. ) <-> T. ) `
     ( ~ truantru ), ` ( ( T. /\ F. ) <-> F. ) ` ( ~ truanfal ),
     ` ( ( F. /\ T. ) <-> F. ) ` ( ~ falantru ), and
     ` ( ( F. /\ F. ) <-> F. ) ` ( ~ falanfal ).

     This is our first use of the biconditional connective in a definition; we
     use the biconditional connective in place of the traditional "<=def=>",
     which means the same thing, except that we can manipulate the
     biconditional connective directly in proofs rather than having to rely on
     an informal definition substitution rule.  Note that if we mechanically
     substitute ` -. ( ph -> -. ps ) ` for ` ( ph /\ ps ) ` , we end up with an
     instance of previously proved theorem ~ biid .  This is the justification
     for the definition, along with the fact that it introduces a new symbol
     ` /\ ` .  Contrast with ` \/ ` ( ~ df-or ), ` -> ` ( ~ wi ), ` -/\ `
     ( ~ df-nan ), and ` \/_ ` ( ~ df-xor ).  (Contributed by NM,
     5-Jan-1993.) $)
  df-an $a |- ( ( ph /\ ps ) <-> -. ( ph -> -. ps ) ) $.

  $( Theorem *4.63 of [WhiteheadRussell] p. 120.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.63 $p |- ( -. ( ph -> -. ps ) <-> ( ph /\ ps ) ) $=
    wph wps wa wph wps wn wi wn wph wps df-an bicomi $.

  $( Theorem *4.67 of [WhiteheadRussell] p. 120.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.67 $p |- ( -. ( -. ph -> -. ps ) <-> ( -. ph /\ ps ) ) $=
    wph wn wps pm4.63 $.

  $( Express an implication in terms of a negated conjunction.  (Contributed by
     NM, 9-Apr-1994.) $)
  imnan $p |- ( ( ph -> -. ps ) <-> -. ( ph /\ ps ) ) $=
    wph wps wa wph wps wn wi wph wps df-an con2bii $.

  ${
    imnani.1 $e |- -. ( ph /\ ps ) $.
    $( Infer an implication from a negated conjunction.  (Contributed by Mario
       Carneiro, 28-Sep-2015.) $)
    imnani $p |- ( ph -> -. ps ) $=
      wph wps wn wi wph wps wa wn imnani.1 wph wps imnan mpbir $.
  $}

  $( Implication in terms of conjunction and negation.  Theorem 3.4(27) of
     [Stoll] p. 176.  (Contributed by NM, 12-Mar-1993.)  (Proof shortened by
     Wolf Lammen, 30-Oct-2012.) $)
  iman $p |- ( ( ph -> ps ) <-> -. ( ph /\ -. ps ) ) $=
    wph wps wi wph wps wn wn wi wph wps wn wa wn wps wps wn wn wph wps notnotb
    imbi2i wph wps wn imnan bitri $.

  $( Law of noncontradiction.  Theorem *3.24 of [WhiteheadRussell] p. 111 (who
     call it the "law of contradiction").  (Contributed by NM, 16-Sep-1993.)
     (Proof shortened by Wolf Lammen, 24-Nov-2012.) $)
  pm3.24 $p |- -. ( ph /\ -. ph ) $=
    wph wph wi wph wph wn wa wn wph id wph wph iman mpbi $.

  $( Express a conjunction in terms of a negated implication.  (Contributed by
     NM, 2-Aug-1994.) $)
  annim $p |- ( ( ph /\ -. ps ) <-> -. ( ph -> ps ) ) $=
    wph wps wi wph wps wn wa wph wps iman con2bii $.

  $( Theorem *4.61 of [WhiteheadRussell] p. 120.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.61 $p |- ( -. ( ph -> ps ) <-> ( ph /\ -. ps ) ) $=
    wph wps wn wa wph wps wi wn wph wps annim bicomi $.

  $( Theorem *4.65 of [WhiteheadRussell] p. 120.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.65 $p |- ( -. ( -. ph -> ps ) <-> ( -. ph /\ -. ps ) ) $=
    wph wn wps pm4.61 $.

  ${
    imp.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Importation inference.  (Contributed by NM, 3-Jan-1993.)  (Proof
       shortened by Eric Schmidt, 22-Dec-2006.) $)
    imp $p |- ( ( ph /\ ps ) -> ch ) $=
      wph wps wa wph wps wn wi wn wch wph wps df-an wph wps wch imp.1 impi
      sylbi $.

    $( Importation inference with commuted antecedents.  (Contributed by NM,
       25-May-2005.) $)
    impcom $p |- ( ( ps /\ ph ) -> ch ) $=
      wps wph wch wph wps wch imp.1 com12 imp $.
  $}

  ${
    con3dimp.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Variant of ~ con3d with importation.  (Contributed by Jonathan Ben-Naim,
       3-Jun-2011.) $)
    con3dimp $p |- ( ( ph /\ -. ch ) -> -. ps ) $=
      wph wch wn wps wn wph wps wch con3dimp.1 con3d imp $.
  $}

  ${
    mpnanrd.1 $e |- ( ph -> ps ) $.
    mpnanrd.2 $e |- ( ph -> -. ( ps /\ ch ) ) $.
    $( Eliminate the right side of a negated conjunction in an implication.
       (Contributed by ML, 17-Oct-2020.) $)
    mpnanrd $p |- ( ph -> -. ch ) $=
      wph wps wch wn mpnanrd.1 wph wps wch wa wn wps wch wn wi mpnanrd.2 wps
      wch imnan sylibr mpd $.
  $}

  ${
    impd.1 $e |- ( ph -> ( ps -> ( ch -> th ) ) ) $.
    $( Importation deduction.  (Contributed by NM, 31-Mar-1994.) $)
    impd $p |- ( ph -> ( ( ps /\ ch ) -> th ) ) $=
      wps wch wa wph wth wps wch wph wth wi wph wps wch wth impd.1 com3l imp
      com12 $.

    $( Importation deduction with commuted antecedents.  (Contributed by Peter
       Mazsa, 24-Sep-2022.)  (Proof shortened by Wolf Lammen, 22-Oct-2022.) $)
    impcomd $p |- ( ph -> ( ( ch /\ ps ) -> th ) ) $=
      wph wch wps wth wph wps wch wth impd.1 com23 impd $.
  $}

  ${
    ex.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    $( Exportation inference.  (This theorem used to be labeled "exp" but was
       changed to "ex" so as not to conflict with the math token "exp", per the
       June 2006 Metamath spec change.)  A translation of natural deduction
       rule ` -> ` I ( ` -> ` introduction), see ~ natded .  (Contributed by
       NM, 3-Jan-1993.)  (Proof shortened by Eric Schmidt, 22-Dec-2006.) $)
    ex $p |- ( ph -> ( ps -> ch ) ) $=
      wph wps wch wph wps wn wi wn wph wps wa wch wph wps df-an ex.1 sylbir
      expi $.

    $( Exportation inference with commuted antecedents.  (Contributed by NM,
       25-May-2005.) $)
    expcom $p |- ( ps -> ( ph -> ch ) ) $=
      wph wps wch wph wps wch ex.1 ex com12 $.
  $}

  ${
    expd.1 $e |- ( ph -> ( ( ps /\ ch ) -> th ) ) $.
    $( Commuted form of ~ expd .  (Contributed by Alan Sare, 18-Mar-2012.)
       Shorten ~ expd .  (Revised by Wolf Lammen, 28-Jul-2022.) $)
    expdcom $p |- ( ps -> ( ch -> ( ph -> th ) ) ) $=
      wps wch wph wth wi wph wps wch wa wth expd.1 com12 ex $.

    $( Exportation deduction.  (Contributed by NM, 20-Aug-1993.)  (Proof
       shortened by Wolf Lammen, 28-Jul-2022.) $)
    expd $p |- ( ph -> ( ps -> ( ch -> th ) ) ) $=
      wps wch wph wth wph wps wch wth expd.1 expdcom com3r $.
  $}

  ${
    expcomd.1 $e |- ( ph -> ( ( ps /\ ch ) -> th ) ) $.
    $( Deduction form of ~ expcom .  (Contributed by Alan Sare,
       22-Jul-2012.) $)
    expcomd $p |- ( ph -> ( ch -> ( ps -> th ) ) ) $=
      wph wps wch wth wph wps wch wth expcomd.1 expd com23 $.
  $}

  ${
    imp31.1 $e |- ( ph -> ( ps -> ( ch -> th ) ) ) $.
    $( An importation inference.  (Contributed by NM, 26-Apr-1994.) $)
    imp31 $p |- ( ( ( ph /\ ps ) /\ ch ) -> th ) $=
      wph wps wa wch wth wph wps wch wth wi imp31.1 imp imp $.

    $( An importation inference.  (Contributed by NM, 26-Apr-1994.) $)
    imp32 $p |- ( ( ph /\ ( ps /\ ch ) ) -> th ) $=
      wph wps wch wa wth wph wps wch wth imp31.1 impd imp $.
  $}

  ${
    exp31.1 $e |- ( ( ( ph /\ ps ) /\ ch ) -> th ) $.
    $( An exportation inference.  (Contributed by NM, 26-Apr-1994.) $)
    exp31 $p |- ( ph -> ( ps -> ( ch -> th ) ) ) $=
      wph wps wch wth wi wph wps wa wch wth exp31.1 ex ex $.
  $}

  ${
    exp32.1 $e |- ( ( ph /\ ( ps /\ ch ) ) -> th ) $.
    $( An exportation inference.  (Contributed by NM, 26-Apr-1994.) $)
    exp32 $p |- ( ph -> ( ps -> ( ch -> th ) ) ) $=
      wph wps wch wth wph wps wch wa wth exp32.1 ex expd $.
  $}

  ${
    imp4.1 $e |- ( ph -> ( ps -> ( ch -> ( th -> ta ) ) ) ) $.
    $( An importation inference.  (Contributed by NM, 26-Apr-1994.)  Shorten
       ~ imp4a .  (Revised by Wolf Lammen, 19-Jul-2021.) $)
    imp4b $p |- ( ( ph /\ ps ) -> ( ( ch /\ th ) -> ta ) ) $=
      wph wps wa wch wth wta wph wps wch wth wta wi wi imp4.1 imp impd $.

    $( An importation inference.  (Contributed by NM, 26-Apr-1994.)  (Proof
       shortened by Wolf Lammen, 19-Jul-2021.) $)
    imp4a $p |- ( ph -> ( ps -> ( ( ch /\ th ) -> ta ) ) ) $=
      wph wps wch wth wa wta wi wph wps wch wth wta imp4.1 imp4b ex $.

    $( An importation inference.  (Contributed by NM, 26-Apr-1994.) $)
    imp4c $p |- ( ph -> ( ( ( ps /\ ch ) /\ th ) -> ta ) ) $=
      wph wps wch wa wth wta wph wps wch wth wta wi imp4.1 impd impd $.

    $( An importation inference.  (Contributed by NM, 26-Apr-1994.) $)
    imp4d $p |- ( ph -> ( ( ps /\ ( ch /\ th ) ) -> ta ) ) $=
      wph wps wch wth wa wta wph wps wch wth wta imp4.1 imp4a impd $.

    $( An importation inference.  (Contributed by NM, 26-Apr-1994.) $)
    imp41 $p |- ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) -> ta ) $=
      wph wps wa wch wth wta wph wps wch wth wta wi wi imp4.1 imp imp31 $.

    $( An importation inference.  (Contributed by NM, 26-Apr-1994.) $)
    imp42 $p |- ( ( ( ph /\ ( ps /\ ch ) ) /\ th ) -> ta ) $=
      wph wps wch wa wa wth wta wph wps wch wth wta wi imp4.1 imp32 imp $.

    $( An importation inference.  (Contributed by NM, 26-Apr-1994.) $)
    imp43 $p |- ( ( ( ph /\ ps ) /\ ( ch /\ th ) ) -> ta ) $=
      wph wps wa wch wth wa wta wph wps wch wth wta imp4.1 imp4b imp $.

    $( An importation inference.  (Contributed by NM, 26-Apr-1994.) $)
    imp44 $p |- ( ( ph /\ ( ( ps /\ ch ) /\ th ) ) -> ta ) $=
      wph wps wch wa wth wa wta wph wps wch wth wta imp4.1 imp4c imp $.

    $( An importation inference.  (Contributed by NM, 26-Apr-1994.) $)
    imp45 $p |- ( ( ph /\ ( ps /\ ( ch /\ th ) ) ) -> ta ) $=
      wph wps wch wth wa wa wta wph wps wch wth wta imp4.1 imp4d imp $.
  $}

  ${
    exp4b.1 $e |- ( ( ph /\ ps ) -> ( ( ch /\ th ) -> ta ) ) $.
    $( An exportation inference.  (Contributed by NM, 26-Apr-1994.)  (Proof
       shortened by Wolf Lammen, 23-Nov-2012.)  Shorten ~ exp4a .  (Revised by
       Wolf Lammen, 20-Jul-2021.) $)
    exp4b $p |- ( ph -> ( ps -> ( ch -> ( th -> ta ) ) ) ) $=
      wph wps wch wth wta wi wi wph wps wa wch wth wta exp4b.1 expd ex $.
  $}

  ${
    exp4a.1 $e |- ( ph -> ( ps -> ( ( ch /\ th ) -> ta ) ) ) $.
    $( An exportation inference.  (Contributed by NM, 26-Apr-1994.)  (Proof
       shortened by Wolf Lammen, 20-Jul-2021.) $)
    exp4a $p |- ( ph -> ( ps -> ( ch -> ( th -> ta ) ) ) ) $=
      wph wps wch wth wta wph wps wch wth wa wta wi exp4a.1 imp exp4b $.
  $}

  ${
    exp4c.1 $e |- ( ph -> ( ( ( ps /\ ch ) /\ th ) -> ta ) ) $.
    $( An exportation inference.  (Contributed by NM, 26-Apr-1994.) $)
    exp4c $p |- ( ph -> ( ps -> ( ch -> ( th -> ta ) ) ) ) $=
      wph wps wch wth wta wi wph wps wch wa wth wta exp4c.1 expd expd $.
  $}

  ${
    exp4d.1 $e |- ( ph -> ( ( ps /\ ( ch /\ th ) ) -> ta ) ) $.
    $( An exportation inference.  (Contributed by NM, 26-Apr-1994.) $)
    exp4d $p |- ( ph -> ( ps -> ( ch -> ( th -> ta ) ) ) ) $=
      wph wps wch wth wta wph wps wch wth wa wta exp4d.1 expd exp4a $.
  $}

  ${
    exp41.1 $e |- ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) -> ta ) $.
    $( An exportation inference.  (Contributed by NM, 26-Apr-1994.) $)
    exp41 $p |- ( ph -> ( ps -> ( ch -> ( th -> ta ) ) ) ) $=
      wph wps wch wth wta wi wph wps wa wch wa wth wta exp41.1 ex exp31 $.
  $}

  ${
    exp42.1 $e |- ( ( ( ph /\ ( ps /\ ch ) ) /\ th ) -> ta ) $.
    $( An exportation inference.  (Contributed by NM, 26-Apr-1994.) $)
    exp42 $p |- ( ph -> ( ps -> ( ch -> ( th -> ta ) ) ) ) $=
      wph wps wch wth wta wi wph wps wch wa wth wta exp42.1 exp31 expd $.
  $}

  ${
    exp43.1 $e |- ( ( ( ph /\ ps ) /\ ( ch /\ th ) ) -> ta ) $.
    $( An exportation inference.  (Contributed by NM, 26-Apr-1994.) $)
    exp43 $p |- ( ph -> ( ps -> ( ch -> ( th -> ta ) ) ) ) $=
      wph wps wch wth wta wph wps wa wch wth wa wta exp43.1 ex exp4b $.
  $}

  ${
    exp44.1 $e |- ( ( ph /\ ( ( ps /\ ch ) /\ th ) ) -> ta ) $.
    $( An exportation inference.  (Contributed by NM, 26-Apr-1994.) $)
    exp44 $p |- ( ph -> ( ps -> ( ch -> ( th -> ta ) ) ) ) $=
      wph wps wch wth wta wi wph wps wch wa wth wta exp44.1 exp32 expd $.
  $}

  ${
    exp45.1 $e |- ( ( ph /\ ( ps /\ ( ch /\ th ) ) ) -> ta ) $.
    $( An exportation inference.  (Contributed by NM, 26-Apr-1994.) $)
    exp45 $p |- ( ph -> ( ps -> ( ch -> ( th -> ta ) ) ) ) $=
      wph wps wch wth wta wph wps wch wth wa wta exp45.1 exp32 exp4a $.
  $}

  ${
    imp5.1 $e |- ( ph -> ( ps -> ( ch -> ( th -> ( ta -> et ) ) ) ) ) $.
    $( An importation inference.  (Contributed by Jeff Hankins, 7-Jul-2009.) $)
    imp5d $p |- ( ( ( ph /\ ps ) /\ ch ) -> ( ( th /\ ta ) -> et ) ) $=
      wph wps wa wch wa wth wta wet wph wps wch wth wta wet wi wi imp5.1 imp31
      impd $.

    $( An importation inference.  (Contributed by Jeff Hankins, 7-Jul-2009.)
       (Proof shortened by Wolf Lammen, 2-Aug-2022.) $)
    imp5a $p |- ( ph -> ( ps -> ( ch -> ( ( th /\ ta ) -> et ) ) ) ) $=
      wph wps wch wth wta wa wet wi wph wps wch wth wta wet imp5.1 imp5d exp31
      $.

    $( An importation inference.  (Contributed by Jeff Hankins, 7-Jul-2009.) $)
    imp5g $p |- ( ( ph /\ ps ) -> ( ( ( ch /\ th ) /\ ta ) -> et ) ) $=
      wph wps wa wch wth wa wta wet wph wps wch wth wta wet wi imp5.1 imp4b
      impd $.

    $( An importation inference.  (Contributed by Jeff Hankins, 7-Jul-2009.) $)
    imp55 $p |- ( ( ( ph /\ ( ps /\ ( ch /\ th ) ) ) /\ ta ) -> et ) $=
      wph wps wch wth wa wta wet wph wps wch wth wta wet wi imp5.1 imp4a imp42
      $.

    $( An importation inference.  (Contributed by Jeff Hankins, 7-Jul-2009.) $)
    imp511 $p |- ( ( ph /\ ( ( ps /\ ( ch /\ th ) ) /\ ta ) ) -> et ) $=
      wph wps wch wth wa wta wet wph wps wch wth wta wet wi imp5.1 imp4a imp44
      $.
  $}

  ${
    exp5c.1 $e |- ( ph -> ( ( ps /\ ch ) -> ( ( th /\ ta ) -> et ) ) ) $.
    $( An exportation inference.  (Contributed by Jeff Hankins, 7-Jul-2009.) $)
    exp5c $p |- ( ph -> ( ps -> ( ch -> ( th -> ( ta -> et ) ) ) ) ) $=
      wph wps wch wth wta wet wi wi wph wps wch wa wth wta wet exp5c.1 exp4a
      expd $.
  $}

  ${
    exp5j.1 $e |- ( ph -> ( ( ( ( ps /\ ch ) /\ th ) /\ ta ) -> et ) ) $.
    $( An exportation inference.  (Contributed by Jeff Hankins, 7-Jul-2009.) $)
    exp5j $p |- ( ph -> ( ps -> ( ch -> ( th -> ( ta -> et ) ) ) ) ) $=
      wph wps wch wth wta wet wi wph wps wch wa wth wa wta wet exp5j.1 expd
      exp4c $.
  $}

  ${
    exp5l.1 $e |- ( ph -> ( ( ( ps /\ ch ) /\ ( th /\ ta ) ) -> et ) ) $.
    $( An exportation inference.  (Contributed by Jeff Hankins, 7-Jul-2009.) $)
    exp5l $p |- ( ph -> ( ps -> ( ch -> ( th -> ( ta -> et ) ) ) ) ) $=
      wph wps wch wth wta wet wph wps wch wa wth wta wa wet exp5l.1 expd exp5c
      $.
  $}

  ${
    exp53.1 $e |- ( ( ( ( ph /\ ps ) /\ ( ch /\ th ) ) /\ ta ) -> et ) $.
    $( An exportation inference.  (Contributed by Jeff Hankins,
       30-Aug-2009.) $)
    exp53 $p |- ( ph -> ( ps -> ( ch -> ( th -> ( ta -> et ) ) ) ) ) $=
      wph wps wch wth wta wet wi wph wps wa wch wth wa wa wta wet exp53.1 ex
      exp43 $.
  $}

  $( Theorem *3.3 (Exp) of [WhiteheadRussell] p. 112.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 24-Mar-2013.) $)
  pm3.3 $p |- ( ( ( ph /\ ps ) -> ch ) -> ( ph -> ( ps -> ch ) ) ) $=
    wph wps wa wch wi wph wps wch wph wps wa wch wi id expd $.

  $( Theorem *3.31 (Imp) of [WhiteheadRussell] p. 112.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 24-Mar-2013.) $)
  pm3.31 $p |- ( ( ph -> ( ps -> ch ) ) -> ( ( ph /\ ps ) -> ch ) ) $=
    wph wps wch wi wi wph wps wch wph wps wch wi wi id impd $.

  $( Import-export theorem.  Part of Theorem *4.87 of [WhiteheadRussell]
     p. 122.  (Contributed by NM, 10-Jan-1993.)  (Proof shortened by Wolf
     Lammen, 24-Mar-2013.) $)
  impexp $p |- ( ( ( ph /\ ps ) -> ch ) <-> ( ph -> ( ps -> ch ) ) ) $=
    wph wps wa wch wi wph wps wch wi wi wph wps wch pm3.3 wph wps wch pm3.31
    impbii $.

  ${
    impancom.1 $e |- ( ( ph /\ ps ) -> ( ch -> th ) ) $.
    $( Mixed importation/commutation inference.  (Contributed by NM,
       22-Jun-2013.) $)
    impancom $p |- ( ( ph /\ ch ) -> ( ps -> th ) ) $=
      wph wch wps wth wi wph wps wch wth wph wps wch wth wi impancom.1 ex com23
      imp $.
  $}

  ${
    expdimp.1 $e |- ( ph -> ( ( ps /\ ch ) -> th ) ) $.
    $( A deduction version of exportation, followed by importation.
       (Contributed by NM, 6-Sep-2008.) $)
    expdimp $p |- ( ( ph /\ ps ) -> ( ch -> th ) ) $=
      wph wps wch wth wi wph wps wch wth expdimp.1 expd imp $.
  $}

  ${
    expimpd.1 $e |- ( ( ph /\ ps ) -> ( ch -> th ) ) $.
    $( Exportation followed by a deduction version of importation.
       (Contributed by NM, 6-Sep-2008.) $)
    expimpd $p |- ( ph -> ( ( ps /\ ch ) -> th ) ) $=
      wph wps wch wth wph wps wch wth wi expimpd.1 ex impd $.
  $}

  ${
    impr.1 $e |- ( ( ph /\ ps ) -> ( ch -> th ) ) $.
    $( Import a wff into a right conjunct.  (Contributed by Jeff Hankins,
       30-Aug-2009.) $)
    impr $p |- ( ( ph /\ ( ps /\ ch ) ) -> th ) $=
      wph wps wch wth wph wps wch wth wi impr.1 ex imp32 $.
  $}

  ${
    impl.1 $e |- ( ph -> ( ( ps /\ ch ) -> th ) ) $.
    $( Export a wff from a left conjunct.  (Contributed by Mario Carneiro,
       9-Jul-2014.) $)
    impl $p |- ( ( ( ph /\ ps ) /\ ch ) -> th ) $=
      wph wps wch wth wph wps wch wth impl.1 expd imp31 $.
  $}

  ${
    expr.1 $e |- ( ( ph /\ ( ps /\ ch ) ) -> th ) $.
    $( Export a wff from a right conjunct.  (Contributed by Jeff Hankins,
       30-Aug-2009.) $)
    expr $p |- ( ( ph /\ ps ) -> ( ch -> th ) ) $=
      wph wps wch wth wi wph wps wch wth expr.1 exp32 imp $.
  $}

  ${
    expl.1 $e |- ( ( ( ph /\ ps ) /\ ch ) -> th ) $.
    $( Export a wff from a left conjunct.  (Contributed by Jeff Hankins,
       28-Aug-2009.) $)
    expl $p |- ( ph -> ( ( ps /\ ch ) -> th ) ) $=
      wph wps wch wth wph wps wch wth expl.1 exp31 impd $.
  $}

  ${
    ancoms.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    $( Inference commuting conjunction in antecedent.  (Contributed by NM,
       21-Apr-1994.) $)
    ancoms $p |- ( ( ps /\ ph ) -> ch ) $=
      wps wph wch wph wps wch ancoms.1 expcom imp $.
  $}

  $( Theorem *3.22 of [WhiteheadRussell] p. 111.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 13-Nov-2012.) $)
  pm3.22 $p |- ( ( ph /\ ps ) -> ( ps /\ ph ) ) $=
    wps wph wps wph wa wps wph wa id ancoms $.

  $( Commutative law for conjunction.  Theorem *4.3 of [WhiteheadRussell]
     p. 118.  (Contributed by NM, 25-Jun-1998.)  (Proof shortened by Wolf
     Lammen, 4-Nov-2012.) $)
  ancom $p |- ( ( ph /\ ps ) <-> ( ps /\ ph ) ) $=
    wph wps wa wps wph wa wph wps pm3.22 wps wph pm3.22 impbii $.

  ${
    ancomd.1 $e |- ( ph -> ( ps /\ ch ) ) $.
    $( Commutation of conjuncts in consequent.  (Contributed by Jeff Hankins,
       14-Aug-2009.) $)
    ancomd $p |- ( ph -> ( ch /\ ps ) ) $=
      wph wps wch wa wch wps wa ancomd.1 wps wch ancom sylib $.
  $}

  ${
    biancomi.1 $e |- ( ph <-> ( ch /\ ps ) ) $.
    $( Commuting conjunction in a biconditional.  (Contributed by Peter Mazsa,
       17-Jun-2018.) $)
    biancomi $p |- ( ph <-> ( ps /\ ch ) ) $=
      wph wch wps wa wps wch wa biancomi.1 wps wch ancom bitr4i $.
  $}

  ${
    biancomd.1 $e |- ( ph -> ( ps <-> ( th /\ ch ) ) ) $.
    $( Commuting conjunction in a biconditional, deduction form.  (Contributed
       by Peter Mazsa, 3-Oct-2018.) $)
    biancomd $p |- ( ph -> ( ps <-> ( ch /\ th ) ) ) $=
      wph wps wth wch wa wch wth wa biancomd.1 wth wch ancom bitrdi $.
  $}

  $( Closed form of ~ ancoms .  (Contributed by Alan Sare, 31-Dec-2011.) $)
  ancomst $p |- ( ( ( ph /\ ps ) -> ch ) <-> ( ( ps /\ ph ) -> ch ) ) $=
    wph wps wa wps wph wa wch wph wps ancom imbi1i $.

  ${
    ancomsd.1 $e |- ( ph -> ( ( ps /\ ch ) -> th ) ) $.
    $( Deduction commuting conjunction in antecedent.  (Contributed by NM,
       12-Dec-2004.) $)
    ancomsd $p |- ( ph -> ( ( ch /\ ps ) -> th ) ) $=
      wph wch wps wth wph wps wch wth ancomsd.1 expcomd impd $.
  $}

  ${
    anasss.1 $e |- ( ( ( ph /\ ps ) /\ ch ) -> th ) $.
    $( Associative law for conjunction applied to antecedent (eliminates
       syllogism).  (Contributed by NM, 15-Nov-2002.) $)
    anasss $p |- ( ( ph /\ ( ps /\ ch ) ) -> th ) $=
      wph wps wch wth wph wps wch wth anasss.1 exp31 imp32 $.
  $}

  ${
    anassrs.1 $e |- ( ( ph /\ ( ps /\ ch ) ) -> th ) $.
    $( Associative law for conjunction applied to antecedent (eliminates
       syllogism).  (Contributed by NM, 15-Nov-2002.) $)
    anassrs $p |- ( ( ( ph /\ ps ) /\ ch ) -> th ) $=
      wph wps wch wth wph wps wch wth anassrs.1 exp32 imp31 $.
  $}

  $( Associative law for conjunction.  Theorem *4.32 of [WhiteheadRussell]
     p. 118.  (Contributed by NM, 21-Jun-1993.)  (Proof shortened by Wolf
     Lammen, 24-Nov-2012.) $)
  anass $p |- ( ( ( ph /\ ps ) /\ ch ) <-> ( ph /\ ( ps /\ ch ) ) ) $=
    wph wps wa wch wa wph wps wch wa wa wph wps wch wph wps wch wa wa wph wps
    wch wa wa id anassrs wph wps wch wph wps wa wch wa wph wps wa wch wa id
    anasss impbii $.

  $( Join antecedents with conjunction ("conjunction introduction").  Theorem
     *3.2 of [WhiteheadRussell] p. 111.  Its associated inference is ~ pm3.2i
     and its associated deduction is ~ jca (and the double deduction is
     ~ jcad ).  See ~ pm3.2im for a version using only implication and
     negation.  (Contributed by NM, 5-Jan-1993.)  (Proof shortened by Wolf
     Lammen, 12-Nov-2012.) $)
  pm3.2 $p |- ( ph -> ( ps -> ( ph /\ ps ) ) ) $=
    wph wps wph wps wa wph wps wa id ex $.

  ${
    pm3.2i.1 $e |- ph $.
    pm3.2i.2 $e |- ps $.
    $( Infer conjunction of premises.  Inference associated with ~ pm3.2 .  Its
       associated deduction is ~ jca (and the double deduction is ~ jcad ).
       (Contributed by NM, 21-Jun-1993.) $)
    pm3.2i $p |- ( ph /\ ps ) $=
      wph wps wph wps wa pm3.2i.1 pm3.2i.2 wph wps pm3.2 mp2 $.
  $}

  $( Join antecedents with conjunction.  Theorem *3.21 of [WhiteheadRussell]
     p. 111.  (Contributed by NM, 5-Aug-1993.) $)
  pm3.21 $p |- ( ph -> ( ps -> ( ps /\ ph ) ) ) $=
    wps wph wps wph wa wps wph wa id expcom $.

  $( Nested conjunction of antecedents.  (Contributed by NM, 4-Jan-1993.) $)
  pm3.43i $p |- ( ( ph -> ps )
      -> ( ( ph -> ch ) -> ( ph -> ( ps /\ ch ) ) ) ) $=
    wps wch wps wch wa wph wps wch pm3.2 imim3i $.

  $( Theorem *3.43 (Comp) of [WhiteheadRussell] p. 113.  (Contributed by NM,
     3-Jan-2005.) $)
  pm3.43 $p |- ( ( ( ph -> ps ) /\ ( ph -> ch ) )
      -> ( ph -> ( ps /\ ch ) ) ) $=
    wph wps wi wph wch wi wph wps wch wa wi wph wps wch pm3.43i imp $.

  $( A theorem similar to the standard definition of the biconditional.
     Definition of [Margaris] p. 49.  (Contributed by NM, 24-Jan-1993.) $)
  dfbi2 $p |- ( ( ph <-> ps ) <-> ( ( ph -> ps ) /\ ( ps -> ph ) ) ) $=
    wph wps wb wph wps wi wps wph wi wn wi wn wph wps wi wps wph wi wa wph wps
    dfbi1 wph wps wi wps wph wi df-an bitr4i $.

  $( Definition ~ df-bi rewritten in an abbreviated form to help intuitive
     understanding of that definition.  Note that it is a conjunction of two
     implications; one which asserts properties that follow from the
     biconditional and one which asserts properties that imply the
     biconditional.  (Contributed by NM, 15-Aug-2008.) $)
  dfbi $p |- ( ( ( ph <-> ps ) -> ( ( ph -> ps ) /\ ( ps -> ph ) ) )
        /\ ( ( ( ph -> ps ) /\ ( ps -> ph ) ) -> ( ph <-> ps ) ) ) $=
    wph wps wb wph wps wi wps wph wi wa wb wph wps wb wph wps wi wps wph wi wa
    wi wph wps wi wps wph wi wa wph wps wb wi wa wph wps dfbi2 wph wps wb wph
    wps wi wps wph wi wa dfbi2 mpbi $.

  ${
    biimpa.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    $( Importation inference from a logical equivalence.  (Contributed by NM,
       3-May-1994.) $)
    biimpa $p |- ( ( ph /\ ps ) -> ch ) $=
      wph wps wch wph wps wch biimpa.1 biimpd imp $.

    $( Importation inference from a logical equivalence.  (Contributed by NM,
       3-May-1994.) $)
    biimpar $p |- ( ( ph /\ ch ) -> ps ) $=
      wph wch wps wph wps wch biimpa.1 biimprd imp $.

    $( Importation inference from a logical equivalence.  (Contributed by NM,
       3-May-1994.) $)
    biimpac $p |- ( ( ps /\ ph ) -> ch ) $=
      wps wph wch wph wps wch biimpa.1 biimpcd imp $.

    $( Importation inference from a logical equivalence.  (Contributed by NM,
       3-May-1994.) $)
    biimparc $p |- ( ( ch /\ ph ) -> ps ) $=
      wch wph wps wph wps wch biimpa.1 biimprcd imp $.
  $}

  ${
    adantr.1 $e |- ( ph -> ps ) $.
    $( Inference adding a conjunct to the right of an antecedent.  (Contributed
       by NM, 30-Aug-1993.) $)
    adantr $p |- ( ( ph /\ ch ) -> ps ) $=
      wph wch wps wph wps wch adantr.1 a1d imp $.
  $}

  ${
    adantl.1 $e |- ( ph -> ps ) $.
    $( Inference adding a conjunct to the left of an antecedent.  (Contributed
       by NM, 30-Aug-1993.)  (Proof shortened by Wolf Lammen, 23-Nov-2012.) $)
    adantl $p |- ( ( ch /\ ph ) -> ps ) $=
      wph wch wps wph wps wch adantl.1 adantr ancoms $.
  $}

  $( Elimination of a conjunct.  Theorem *3.26 (Simp) of [WhiteheadRussell]
     p. 112.  (Contributed by NM, 3-Jan-1993.)  (Proof shortened by Wolf
     Lammen, 14-Jun-2022.) $)
  simpl $p |- ( ( ph /\ ps ) -> ph ) $=
    wph wph wps wph id adantr $.

  ${
    simpli.1 $e |- ( ph /\ ps ) $.
    $( Inference eliminating a conjunct.  (Contributed by NM, 15-Jun-1994.) $)
    simpli $p |- ph $=
      wph wps wa wph simpli.1 wph wps simpl ax-mp $.
  $}

  $( Elimination of a conjunct.  Theorem *3.27 (Simp) of [WhiteheadRussell]
     p. 112.  (Contributed by NM, 3-Jan-1993.)  (Proof shortened by Wolf
     Lammen, 14-Jun-2022.) $)
  simpr $p |- ( ( ph /\ ps ) -> ps ) $=
    wps wps wph wps id adantl $.

  ${
    simpri.1 $e |- ( ph /\ ps ) $.
    $( Inference eliminating a conjunct.  (Contributed by NM, 15-Jun-1994.) $)
    simpri $p |- ps $=
      wph wps wa wps simpri.1 wph wps simpr ax-mp $.
  $}

  ${
    intnan.1 $e |- -. ph $.
    $( Introduction of conjunct inside of a contradiction.  (Contributed by NM,
       16-Sep-1993.) $)
    intnan $p |- -. ( ps /\ ph ) $=
      wps wph wa wph intnan.1 wps wph simpr mto $.

    $( Introduction of conjunct inside of a contradiction.  (Contributed by NM,
       3-Apr-1995.) $)
    intnanr $p |- -. ( ph /\ ps ) $=
      wph wps wa wph intnan.1 wph wps simpl mto $.
  $}

  ${
    intnand.1 $e |- ( ph -> -. ps ) $.
    $( Introduction of conjunct inside of a contradiction.  (Contributed by NM,
       10-Jul-2005.) $)
    intnand $p |- ( ph -> -. ( ch /\ ps ) ) $=
      wph wps wch wps wa intnand.1 wch wps simpr nsyl $.

    $( Introduction of conjunct inside of a contradiction.  (Contributed by NM,
       10-Jul-2005.) $)
    intnanrd $p |- ( ph -> -. ( ps /\ ch ) ) $=
      wph wps wps wch wa intnand.1 wps wch simpl nsyl $.
  $}

  ${
    adantld.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Deduction adding a conjunct to the left of an antecedent.  (Contributed
       by NM, 4-May-1994.)  (Proof shortened by Wolf Lammen, 20-Dec-2012.) $)
    adantld $p |- ( ph -> ( ( th /\ ps ) -> ch ) ) $=
      wth wps wa wps wph wch wth wps simpr adantld.1 syl5 $.
  $}

  ${
    adantrd.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Deduction adding a conjunct to the right of an antecedent.  (Contributed
       by NM, 4-May-1994.) $)
    adantrd $p |- ( ph -> ( ( ps /\ th ) -> ch ) ) $=
      wps wth wa wps wph wch wps wth simpl adantrd.1 syl5 $.
  $}

  $( Theorem *3.41 of [WhiteheadRussell] p. 113.  (Contributed by NM,
     3-Jan-2005.) $)
  pm3.41 $p |- ( ( ph -> ch ) -> ( ( ph /\ ps ) -> ch ) ) $=
    wph wps wa wph wch wph wps simpl imim1i $.

  $( Theorem *3.42 of [WhiteheadRussell] p. 113.  (Contributed by NM,
     3-Jan-2005.) $)
  pm3.42 $p |- ( ( ps -> ch ) -> ( ( ph /\ ps ) -> ch ) ) $=
    wph wps wa wps wch wph wps simpr imim1i $.

  ${
    simpld.1 $e |- ( ph -> ( ps /\ ch ) ) $.
    $( Deduction eliminating a conjunct.  A translation of natural deduction
       rule ` /\ ` EL ( ` /\ ` elimination left), see ~ natded .  (Contributed
       by NM, 26-May-1993.) $)
    simpld $p |- ( ph -> ps ) $=
      wph wps wch wa wps simpld.1 wps wch simpl syl $.
  $}

  ${
    simprd.1 $e |- ( ph -> ( ps /\ ch ) ) $.
    $( Deduction eliminating a conjunct.  (Contributed by NM, 14-May-1993.)  A
       translation of natural deduction rule ` /\ ` ER ( ` /\ ` elimination
       right), see ~ natded .  (Proof shortened by Wolf Lammen, 3-Oct-2013.) $)
    simprd $p |- ( ph -> ch ) $=
      wph wch wps wph wps wch simprd.1 ancomd simpld $.
  $}

  ${
    simprbi.1 $e |- ( ph <-> ( ps /\ ch ) ) $.
    $( Deduction eliminating a conjunct.  (Contributed by NM, 27-May-1998.) $)
    simprbi $p |- ( ph -> ch ) $=
      wph wps wch wph wps wch wa simprbi.1 biimpi simprd $.
  $}

  ${
    simplbi.1 $e |- ( ph <-> ( ps /\ ch ) ) $.
    $( Deduction eliminating a conjunct.  (Contributed by NM, 27-May-1998.) $)
    simplbi $p |- ( ph -> ps ) $=
      wph wps wch wph wps wch wa simplbi.1 biimpi simpld $.
  $}

  ${
    pm3.26bda.1 $e |- ( ph -> ( ps <-> ( ch /\ th ) ) ) $.
    $( Deduction eliminating a conjunct.  (Contributed by NM, 22-Oct-2007.) $)
    simprbda $p |- ( ( ph /\ ps ) -> ch ) $=
      wph wps wa wch wth wph wps wch wth wa pm3.26bda.1 biimpa simpld $.

    $( Deduction eliminating a conjunct.  (Contributed by NM, 22-Oct-2007.) $)
    simplbda $p |- ( ( ph /\ ps ) -> th ) $=
      wph wps wa wch wth wph wps wch wth wa pm3.26bda.1 biimpa simprd $.
  $}

  ${
    simplbi2.1 $e |- ( ph <-> ( ps /\ ch ) ) $.
    $( Deduction eliminating a conjunct.  (Contributed by Alan Sare,
       31-Dec-2011.) $)
    simplbi2 $p |- ( ps -> ( ch -> ph ) ) $=
      wps wch wph wph wps wch wa simplbi2.1 biimpri ex $.
  $}

  $( Closed form of ~ simplbi2com .  (Contributed by Alan Sare,
     22-Jul-2012.) $)
  simplbi2comt $p |- ( ( ph <-> ( ps /\ ch ) ) -> ( ch -> ( ps -> ph ) ) ) $=
    wph wps wch wa wb wps wch wph wph wps wch wa biimpr expcomd $.

  ${
    simplbi2com.1 $e |- ( ph <-> ( ps /\ ch ) ) $.
    $( A deduction eliminating a conjunct, similar to ~ simplbi2 .
       (Contributed by Alan Sare, 22-Jul-2012.)  (Proof shortened by Wolf
       Lammen, 10-Nov-2012.) $)
    simplbi2com $p |- ( ch -> ( ps -> ph ) ) $=
      wps wch wph wph wps wch simplbi2com.1 simplbi2 com12 $.
  $}

  ${
    simpl2im.1 $e |- ( ph -> ( ps /\ ch ) ) $.
    simpl2im.2 $e |- ( ch -> th ) $.
    $( Implication from an eliminated conjunct implied by the antecedent.
       (Contributed by BJ/AV, 5-Apr-2021.)  (Proof shortened by Wolf Lammen,
       26-Mar-2022.) $)
    simpl2im $p |- ( ph -> th ) $=
      wph wch wth wph wps wch simpl2im.1 simprd simpl2im.2 syl $.
  $}

  ${
    simplbiim.1 $e |- ( ph <-> ( ps /\ ch ) ) $.
    simplbiim.2 $e |- ( ch -> th ) $.
    $( Implication from an eliminated conjunct equivalent to the antecedent.
       (Contributed by Jonathan Ben-Naim, 3-Jun-2011.)  (Proof shortened by
       Wolf Lammen, 26-Mar-2022.) $)
    simplbiim $p |- ( ph -> th ) $=
      wph wch wth wph wps wch simplbiim.1 simprbi simplbiim.2 syl $.
  $}

  ${
    impel.1 $e |- ( ph -> ( ps -> ch ) ) $.
    impel.2 $e |- ( th -> ps ) $.
    $( An inference for implication elimination.  (Contributed by Giovanni
       Mascellani, 23-May-2019.)  (Proof shortened by Wolf Lammen,
       2-Sep-2020.) $)
    impel $p |- ( ( ph /\ th ) -> ch ) $=
      wph wth wch wth wps wph wch impel.2 impel.1 syl5 imp $.
  $}

  ${
    mpan9.1 $e |- ( ph -> ps ) $.
    mpan9.2 $e |- ( ch -> ( ps -> th ) ) $.
    $( Modus ponens conjoining dissimilar antecedents.  (Contributed by NM,
       1-Feb-2008.)  (Proof shortened by Andrew Salmon, 7-May-2011.) $)
    mpan9 $p |- ( ( ph /\ ch ) -> th ) $=
      wch wph wth wph wps wch wth mpan9.1 mpan9.2 syl5 impcom $.
  $}

  ${
    sylan9.1 $e |- ( ph -> ( ps -> ch ) ) $.
    sylan9.2 $e |- ( th -> ( ch -> ta ) ) $.
    $( Nested syllogism inference conjoining dissimilar antecedents.
       (Contributed by NM, 14-May-1993.)  (Proof shortened by Andrew Salmon,
       7-May-2011.) $)
    sylan9 $p |- ( ( ph /\ th ) -> ( ps -> ta ) ) $=
      wph wth wps wta wi wph wps wch wth wta sylan9.1 sylan9.2 syl9 imp $.
  $}

  ${
    sylan9r.1 $e |- ( ph -> ( ps -> ch ) ) $.
    sylan9r.2 $e |- ( th -> ( ch -> ta ) ) $.
    $( Nested syllogism inference conjoining dissimilar antecedents.
       (Contributed by NM, 14-May-1993.) $)
    sylan9r $p |- ( ( th /\ ph ) -> ( ps -> ta ) ) $=
      wth wph wps wta wi wph wps wch wth wta sylan9r.1 sylan9r.2 syl9r imp $.
  $}

  ${
    sylan9bb.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    sylan9bb.2 $e |- ( th -> ( ch <-> ta ) ) $.
    $( Nested syllogism inference conjoining dissimilar antecedents.
       (Contributed by NM, 4-Mar-1995.) $)
    sylan9bb $p |- ( ( ph /\ th ) -> ( ps <-> ta ) ) $=
      wph wth wa wps wch wta wph wps wch wb wth sylan9bb.1 adantr wth wch wta
      wb wph sylan9bb.2 adantl bitrd $.
  $}

  ${
    sylan9bbr.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    sylan9bbr.2 $e |- ( th -> ( ch <-> ta ) ) $.
    $( Nested syllogism inference conjoining dissimilar antecedents.
       (Contributed by NM, 4-Mar-1995.) $)
    sylan9bbr $p |- ( ( th /\ ph ) -> ( ps <-> ta ) ) $=
      wph wth wps wta wb wph wps wch wth wta sylan9bbr.1 sylan9bbr.2 sylan9bb
      ancoms $.
  $}

  ${
    jca.1 $e |- ( ph -> ps ) $.
    jca.2 $e |- ( ph -> ch ) $.
    $( Deduce conjunction of the consequents of two implications ("join
       consequents with 'and'").  Deduction form of ~ pm3.2 and ~ pm3.2i .  Its
       associated deduction is ~ jcad .  Equivalent to the natural deduction
       rule ` /\ ` I ( ` /\ ` introduction), see ~ natded .  (Contributed by
       NM, 3-Jan-1993.)  (Proof shortened by Wolf Lammen, 25-Oct-2012.) $)
    jca $p |- ( ph -> ( ps /\ ch ) ) $=
      wph wps wch wps wch wa jca.1 jca.2 wps wch pm3.2 sylc $.
  $}

  ${
    jcad.1 $e |- ( ph -> ( ps -> ch ) ) $.
    jcad.2 $e |- ( ph -> ( ps -> th ) ) $.
    $( Deduction conjoining the consequents of two implications.  Deduction
       form of ~ jca and double deduction form of ~ pm3.2 and ~ pm3.2i .
       (Contributed by NM, 15-Jul-1993.)  (Proof shortened by Wolf Lammen,
       23-Jul-2013.) $)
    jcad $p |- ( ph -> ( ps -> ( ch /\ th ) ) ) $=
      wph wps wch wth wch wth wa jcad.1 jcad.2 wch wth pm3.2 syl6c $.
  $}

  ${
    jca2.1 $e |- ( ph -> ( ps -> ch ) ) $.
    jca2.2 $e |- ( ps -> th ) $.
    $( Inference conjoining the consequents of two implications.  (Contributed
       by Rodolfo Medina, 12-Oct-2010.) $)
    jca2 $p |- ( ph -> ( ps -> ( ch /\ th ) ) ) $=
      wph wps wch wth jca2.1 wps wth wi wph jca2.2 a1i jcad $.
  $}

  ${
    jca31.1 $e |- ( ph -> ps ) $.
    jca31.2 $e |- ( ph -> ch ) $.
    jca31.3 $e |- ( ph -> th ) $.
    $( Join three consequents.  (Contributed by Jeff Hankins, 1-Aug-2009.) $)
    jca31 $p |- ( ph -> ( ( ps /\ ch ) /\ th ) ) $=
      wph wps wch wa wth wph wps wch jca31.1 jca31.2 jca jca31.3 jca $.

    $( Join three consequents.  (Contributed by FL, 1-Aug-2009.) $)
    jca32 $p |- ( ph -> ( ps /\ ( ch /\ th ) ) ) $=
      wph wps wch wth wa jca31.1 wph wch wth jca31.2 jca31.3 jca jca $.
  $}

  ${
    jcai.1 $e |- ( ph -> ps ) $.
    jcai.2 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Deduction replacing implication with conjunction.  (Contributed by NM,
       15-Jul-1993.) $)
    jcai $p |- ( ph -> ( ps /\ ch ) ) $=
      wph wps wch jcai.1 wph wps wch jcai.1 jcai.2 mpd jca $.
  $}

  $( Distributive law for implication over conjunction.  Compare Theorem *4.76
     of [WhiteheadRussell] p. 121.  (Contributed by NM, 3-Apr-1994.)  (Proof
     shortened by Wolf Lammen, 27-Nov-2013.) $)
  jcab $p |- ( ( ph -> ( ps /\ ch ) )
      <-> ( ( ph -> ps ) /\ ( ph -> ch ) ) ) $=
    wph wps wch wa wi wph wps wi wph wch wi wa wph wps wch wa wi wph wps wi wph
    wch wi wps wch wa wps wph wps wch simpl imim2i wps wch wa wch wph wps wch
    simpr imim2i jca wph wps wch pm3.43 impbii $.

  $( Theorem *4.76 of [WhiteheadRussell] p. 121.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.76 $p |- ( ( ( ph -> ps ) /\ ( ph -> ch ) ) <->
                ( ph -> ( ps /\ ch ) ) ) $=
    wph wps wch wa wi wph wps wi wph wch wi wa wph wps wch jcab bicomi $.

  ${
    jctil.1 $e |- ( ph -> ps ) $.
    jctil.2 $e |- ch $.
    $( Inference conjoining a theorem to left of consequent in an implication.
       (Contributed by NM, 31-Dec-1993.) $)
    jctil $p |- ( ph -> ( ch /\ ps ) ) $=
      wph wch wps wch wph jctil.2 a1i jctil.1 jca $.

    $( Inference conjoining a theorem to right of consequent in an implication.
       (Contributed by NM, 31-Dec-1993.) $)
    jctir $p |- ( ph -> ( ps /\ ch ) ) $=
      wph wps wch jctil.1 wch wph jctil.2 a1i jca $.
  $}

  ${
    jccir.1 $e |- ( ph -> ps ) $.
    jccir.2 $e |- ( ps -> ch ) $.
    $( Inference conjoining a consequent of a consequent to the right of the
       consequent in an implication.  See also ~ ex-natded5.3i .  (Contributed
       by Mario Carneiro, 9-Feb-2017.)  (Revised by AV, 20-Aug-2019.) $)
    jccir $p |- ( ph -> ( ps /\ ch ) ) $=
      wph wps wch jccir.1 wph wps wch jccir.1 jccir.2 syl jca $.

    $( Inference conjoining a consequent of a consequent to the left of the
       consequent in an implication.  Remark:  One can also prove this theorem
       using ~ syl and ~ jca (as done in ~ jccir ), which would be 4 bytes
       shorter, but one step longer than the current proof.
       (Proof modification is discouraged.)  (Contributed by AV,
       20-Aug-2019.) $)
    jccil $p |- ( ph -> ( ch /\ ps ) ) $=
      wph wps wch wph wps wch jccir.1 jccir.2 jccir ancomd $.
  $}

  ${
    jctl.1 $e |- ps $.
    $( Inference conjoining a theorem to the left of a consequent.
       (Contributed by NM, 31-Dec-1993.)  (Proof shortened by Wolf Lammen,
       24-Oct-2012.) $)
    jctl $p |- ( ph -> ( ps /\ ph ) ) $=
      wph wph wps wph id jctl.1 jctil $.

    $( Inference conjoining a theorem to the right of a consequent.
       (Contributed by NM, 18-Aug-1993.)  (Proof shortened by Wolf Lammen,
       24-Oct-2012.) $)
    jctr $p |- ( ph -> ( ph /\ ps ) ) $=
      wph wph wps wph id jctl.1 jctir $.
  $}

  ${
    jctild.1 $e |- ( ph -> ( ps -> ch ) ) $.
    jctild.2 $e |- ( ph -> th ) $.
    $( Deduction conjoining a theorem to left of consequent in an implication.
       (Contributed by NM, 21-Apr-2005.) $)
    jctild $p |- ( ph -> ( ps -> ( th /\ ch ) ) ) $=
      wph wps wth wch wph wth wps jctild.2 a1d jctild.1 jcad $.
  $}

  ${
    jctird.1 $e |- ( ph -> ( ps -> ch ) ) $.
    jctird.2 $e |- ( ph -> th ) $.
    $( Deduction conjoining a theorem to right of consequent in an implication.
       (Contributed by NM, 21-Apr-2005.) $)
    jctird $p |- ( ph -> ( ps -> ( ch /\ th ) ) ) $=
      wph wps wch wth jctird.1 wph wth wps jctird.2 a1d jcad $.
  $}

  $( Introduction of antecedent as conjunct.  Theorem *4.73 of
     [WhiteheadRussell] p. 121.  (Contributed by NM, 30-Mar-1994.) $)
  iba $p |- ( ph -> ( ps <-> ( ps /\ ph ) ) ) $=
    wph wps wps wph wa wph wps pm3.21 wps wph simpl impbid1 $.

  $( Introduction of antecedent as conjunct.  (Contributed by NM,
     5-Dec-1995.) $)
  ibar $p |- ( ph -> ( ps <-> ( ph /\ ps ) ) ) $=
    wph wps wph wps wph wps iba biancomd $.

  ${
    biantru.1 $e |- ph $.
    $( A wff is equivalent to its conjunction with truth.  (Contributed by NM,
       26-May-1993.) $)
    biantru $p |- ( ps <-> ( ps /\ ph ) ) $=
      wph wps wps wph wa wb biantru.1 wph wps iba ax-mp $.
  $}

  ${
    biantrur.1 $e |- ph $.
    $( A wff is equivalent to its conjunction with truth.  (Contributed by NM,
       3-Aug-1994.) $)
    biantrur $p |- ( ps <-> ( ph /\ ps ) ) $=
      wps wph wps wph wps biantrur.1 biantru biancomi $.
  $}

  ${
    biantrud.1 $e |- ( ph -> ps ) $.
    $( A wff is equivalent to its conjunction with truth.  (Contributed by NM,
       2-Aug-1994.)  (Proof shortened by Wolf Lammen, 23-Oct-2013.) $)
    biantrud $p |- ( ph -> ( ch <-> ( ch /\ ps ) ) ) $=
      wph wps wch wch wps wa wb biantrud.1 wps wch iba syl $.

    $( A wff is equivalent to its conjunction with truth.  (Contributed by NM,
       1-May-1995.)  (Proof shortened by Andrew Salmon, 7-May-2011.) $)
    biantrurd $p |- ( ph -> ( ch <-> ( ps /\ ch ) ) ) $=
      wph wps wch wps wch wa wb biantrud.1 wps wch ibar syl $.
  $}

  ${
    bianfi.1 $e |- -. ph $.
    $( A wff conjoined with falsehood is false.  (Contributed by NM,
       21-Jun-1993.)  (Proof shortened by Wolf Lammen, 26-Nov-2012.) $)
    bianfi $p |- ( ph <-> ( ps /\ ph ) ) $=
      wph wps wph wa bianfi.1 wph wps bianfi.1 intnan 2false $.
  $}

  ${
    bianfd.1 $e |- ( ph -> -. ps ) $.
    $( A wff conjoined with falsehood is false.  (Contributed by NM,
       27-Mar-1995.)  (Proof shortened by Wolf Lammen, 5-Nov-2013.) $)
    bianfd $p |- ( ph -> ( ps <-> ( ps /\ ch ) ) ) $=
      wph wps wps wch wa bianfd.1 wph wps wch bianfd.1 intnanrd 2falsed $.
  $}

  ${
    baib.1 $e |- ( ph <-> ( ps /\ ch ) ) $.
    $( Move conjunction outside of biconditional.  (Contributed by NM,
       13-May-1999.) $)
    baib $p |- ( ps -> ( ph <-> ch ) ) $=
      wps wph wps wch wa wch baib.1 wps wch ibar bitr4id $.

    $( Move conjunction outside of biconditional.  (Contributed by NM,
       11-Jul-1994.) $)
    baibr $p |- ( ps -> ( ch <-> ph ) ) $=
      wps wph wch wph wps wch baib.1 baib bicomd $.

    $( Move conjunction outside of biconditional.  (Contributed by Mario
       Carneiro, 11-Sep-2015.)  (Proof shortened by Wolf Lammen,
       19-Jan-2020.) $)
    rbaibr $p |- ( ch -> ( ps <-> ph ) ) $=
      wph wch wps wph wch wps baib.1 biancomi baibr $.

    $( Move conjunction outside of biconditional.  (Contributed by Mario
       Carneiro, 11-Sep-2015.)  (Proof shortened by Wolf Lammen,
       19-Jan-2020.) $)
    rbaib $p |- ( ch -> ( ph <-> ps ) ) $=
      wch wps wph wph wps wch baib.1 rbaibr bicomd $.
  $}

  ${
    baibd.1 $e |- ( ph -> ( ps <-> ( ch /\ th ) ) ) $.
    $( Move conjunction outside of biconditional.  (Contributed by Mario
       Carneiro, 11-Sep-2015.) $)
    baibd $p |- ( ( ph /\ ch ) -> ( ps <-> th ) ) $=
      wph wps wch wth wa wch wth baibd.1 wch wth wch wth wa wch wth ibar bicomd
      sylan9bb $.

    $( Move conjunction outside of biconditional.  (Contributed by Mario
       Carneiro, 11-Sep-2015.) $)
    rbaibd $p |- ( ( ph /\ th ) -> ( ps <-> ch ) ) $=
      wph wps wth wch wph wps wth wch baibd.1 biancomd baibd $.
  $}

  ${
    bianabs.1 $e |- ( ph -> ( ps <-> ( ph /\ ch ) ) ) $.
    $( Absorb a hypothesis into the second member of a biconditional.
       (Contributed by FL, 15-Feb-2007.) $)
    bianabs $p |- ( ph -> ( ps <-> ch ) ) $=
      wph wps wph wch wa wch bianabs.1 wph wch ibar bitr4d $.
  $}

  $( Theorem *5.44 of [WhiteheadRussell] p. 125.  (Contributed by NM,
     3-Jan-2005.) $)
  pm5.44 $p |- ( ( ph -> ps ) -> ( ( ph -> ch ) <->
                ( ph -> ( ps /\ ch ) ) ) ) $=
    wph wps wch wa wi wph wps wi wph wch wi wph wps wch jcab baibr $.

  $( Theorem *5.42 of [WhiteheadRussell] p. 125.  (Contributed by NM,
     3-Jan-2005.) $)
  pm5.42 $p |- ( ( ph -> ( ps -> ch ) ) <->
                ( ph -> ( ps -> ( ph /\ ch ) ) ) ) $=
    wph wps wch wi wps wph wch wa wi wph wch wph wch wa wps wph wch ibar imbi2d
    pm5.74i $.

  $( Conjoin antecedent to left of consequent.  (Contributed by NM,
     15-Aug-1994.) $)
  ancl $p |- ( ( ph -> ps ) -> ( ph -> ( ph /\ ps ) ) ) $=
    wph wps wph wps wa wph wps pm3.2 a2i $.

  $( Conjoin antecedent to left of consequent.  Theorem *4.7 of
     [WhiteheadRussell] p. 120.  (Contributed by NM, 25-Jul-1999.)  (Proof
     shortened by Wolf Lammen, 24-Mar-2013.) $)
  anclb $p |- ( ( ph -> ps ) <-> ( ph -> ( ph /\ ps ) ) ) $=
    wph wps wph wps wa wph wps ibar pm5.74i $.

  $( Conjoin antecedent to right of consequent.  (Contributed by NM,
     15-Aug-1994.) $)
  ancr $p |- ( ( ph -> ps ) -> ( ph -> ( ps /\ ph ) ) ) $=
    wph wps wps wph wa wph wps pm3.21 a2i $.

  $( Conjoin antecedent to right of consequent.  (Contributed by NM,
     25-Jul-1999.)  (Proof shortened by Wolf Lammen, 24-Mar-2013.) $)
  ancrb $p |- ( ( ph -> ps ) <-> ( ph -> ( ps /\ ph ) ) ) $=
    wph wps wps wph wa wph wps iba pm5.74i $.

  ${
    ancli.1 $e |- ( ph -> ps ) $.
    $( Deduction conjoining antecedent to left of consequent.  (Contributed by
       NM, 12-Aug-1993.) $)
    ancli $p |- ( ph -> ( ph /\ ps ) ) $=
      wph wph wps wph id ancli.1 jca $.
  $}

  ${
    ancri.1 $e |- ( ph -> ps ) $.
    $( Deduction conjoining antecedent to right of consequent.  (Contributed by
       NM, 15-Aug-1994.) $)
    ancri $p |- ( ph -> ( ps /\ ph ) ) $=
      wph wps wph ancri.1 wph id jca $.
  $}

  ${
    ancld.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Deduction conjoining antecedent to left of consequent in nested
       implication.  (Contributed by NM, 15-Aug-1994.)  (Proof shortened by
       Wolf Lammen, 1-Nov-2012.) $)
    ancld $p |- ( ph -> ( ps -> ( ps /\ ch ) ) ) $=
      wph wps wps wch wph wps idd ancld.1 jcad $.
  $}

  ${
    ancrd.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Deduction conjoining antecedent to right of consequent in nested
       implication.  (Contributed by NM, 15-Aug-1994.)  (Proof shortened by
       Wolf Lammen, 1-Nov-2012.) $)
    ancrd $p |- ( ph -> ( ps -> ( ch /\ ps ) ) ) $=
      wph wps wch wps ancrd.1 wph wps idd jcad $.
  $}

  ${
    impac.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Importation with conjunction in consequent.  (Contributed by NM,
       9-Aug-1994.) $)
    impac $p |- ( ( ph /\ ps ) -> ( ch /\ ps ) ) $=
      wph wps wch wps wa wph wps wch impac.1 ancrd imp $.
  $}

  $( Conjoin antecedent to left of consequent in nested implication.
     (Contributed by NM, 10-Aug-1994.)  (Proof shortened by Wolf Lammen,
     14-Jul-2013.) $)
  anc2l $p |- ( ( ph -> ( ps -> ch ) ) -> ( ph -> ( ps -> ( ph /\ ch ) ) ) ) $=
    wph wps wch wi wi wph wps wph wch wa wi wi wph wps wch pm5.42 biimpi $.

  $( Conjoin antecedent to right of consequent in nested implication.
     (Contributed by NM, 15-Aug-1994.) $)
  anc2r $p |- ( ( ph -> ( ps -> ch ) ) -> ( ph -> ( ps -> ( ch /\ ph ) ) ) ) $=
    wph wps wch wi wps wch wph wa wi wph wch wch wph wa wps wph wch pm3.21
    imim2d a2i $.

  ${
    anc2li.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Deduction conjoining antecedent to left of consequent in nested
       implication.  (Contributed by NM, 10-Aug-1994.)  (Proof shortened by
       Wolf Lammen, 7-Dec-2012.) $)
    anc2li $p |- ( ph -> ( ps -> ( ph /\ ch ) ) ) $=
      wph wps wch wph anc2li.1 wph id jctild $.
  $}

  ${
    anc2ri.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Deduction conjoining antecedent to right of consequent in nested
       implication.  (Contributed by NM, 15-Aug-1994.)  (Proof shortened by
       Wolf Lammen, 7-Dec-2012.) $)
    anc2ri $p |- ( ph -> ( ps -> ( ch /\ ph ) ) ) $=
      wph wps wch wph anc2ri.1 wph id jctird $.
  $}

  $( Implication in terms of biconditional and conjunction.  Theorem *4.71 of
     [WhiteheadRussell] p. 120.  (Contributed by NM, 21-Jun-1993.)  (Proof
     shortened by Wolf Lammen, 2-Dec-2012.) $)
  pm4.71 $p |- ( ( ph -> ps ) <-> ( ph <-> ( ph /\ ps ) ) ) $=
    wph wph wps wa wi wph wph wps wa wi wph wps wa wph wi wa wph wps wi wph wph
    wps wa wb wph wps wa wph wi wph wph wps wa wi wph wps simpl biantru wph wps
    anclb wph wph wps wa dfbi2 3bitr4i $.

  $( Implication in terms of biconditional and conjunction.  Theorem *4.71 of
     [WhiteheadRussell] p. 120 (with conjunct reversed).  (Contributed by NM,
     25-Jul-1999.) $)
  pm4.71r $p |- ( ( ph -> ps ) <-> ( ph <-> ( ps /\ ph ) ) ) $=
    wph wps wi wph wph wps wa wb wph wps wph wa wb wph wps pm4.71 wph wps wa
    wps wph wa wph wph wps ancom bibi2i bitri $.

  ${
    pm4.71i.1 $e |- ( ph -> ps ) $.
    $( Inference converting an implication to a biconditional with conjunction.
       Inference from Theorem *4.71 of [WhiteheadRussell] p. 120.  (Contributed
       by NM, 4-Jan-2004.) $)
    pm4.71i $p |- ( ph <-> ( ph /\ ps ) ) $=
      wph wps wi wph wph wps wa wb pm4.71i.1 wph wps pm4.71 mpbi $.
  $}

  ${
    pm4.71ri.1 $e |- ( ph -> ps ) $.
    $( Inference converting an implication to a biconditional with conjunction.
       Inference from Theorem *4.71 of [WhiteheadRussell] p. 120 (with conjunct
       reversed).  (Contributed by NM, 1-Dec-2003.) $)
    pm4.71ri $p |- ( ph <-> ( ps /\ ph ) ) $=
      wph wps wph wph wps pm4.71ri.1 pm4.71i biancomi $.
  $}

  ${
    pm4.71rd.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Deduction converting an implication to a biconditional with conjunction.
       Deduction from Theorem *4.71 of [WhiteheadRussell] p. 120.  (Contributed
       by Mario Carneiro, 25-Dec-2016.) $)
    pm4.71d $p |- ( ph -> ( ps <-> ( ps /\ ch ) ) ) $=
      wph wps wch wi wps wps wch wa wb pm4.71rd.1 wps wch pm4.71 sylib $.

    $( Deduction converting an implication to a biconditional with conjunction.
       Deduction from Theorem *4.71 of [WhiteheadRussell] p. 120.  (Contributed
       by NM, 10-Feb-2005.) $)
    pm4.71rd $p |- ( ph -> ( ps <-> ( ch /\ ps ) ) ) $=
      wph wps wch wps wph wps wch pm4.71rd.1 pm4.71d biancomd $.
  $}

  $( Theorem *4.24 of [WhiteheadRussell] p. 117.  (Contributed by NM,
     11-May-1993.) $)
  pm4.24 $p |- ( ph <-> ( ph /\ ph ) ) $=
    wph wph wph id pm4.71i $.

  $( Idempotent law for conjunction.  (Contributed by NM, 8-Jan-2004.)  (Proof
     shortened by Wolf Lammen, 14-Mar-2014.) $)
  anidm $p |- ( ( ph /\ ph ) <-> ph ) $=
    wph wph wph wa wph pm4.24 bicomi $.

  $( Conjunction idempotence with antecedent.  (Contributed by Roy F. Longton,
     8-Aug-2005.) $)
  anidmdbi $p |- ( ( ph -> ( ps /\ ps ) ) <-> ( ph -> ps ) ) $=
    wps wps wa wps wph wps anidm imbi2i $.

  ${
    anidms.1 $e |- ( ( ph /\ ph ) -> ps ) $.
    $( Inference from idempotent law for conjunction.  (Contributed by NM,
       15-Jun-1994.) $)
    anidms $p |- ( ph -> ps ) $=
      wph wps wph wph wps anidms.1 ex pm2.43i $.
  $}

  $( Distribution of implication with conjunction.  (Contributed by NM,
     31-May-1999.)  (Proof shortened by Wolf Lammen, 6-Dec-2012.) $)
  imdistan $p |- ( ( ph -> ( ps -> ch ) ) <->
                ( ( ph /\ ps ) -> ( ph /\ ch ) ) ) $=
    wph wps wch wi wi wph wps wph wch wa wi wi wph wps wa wph wch wa wi wph wps
    wch pm5.42 wph wps wph wch wa impexp bitr4i $.

  ${
    imdistani.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Distribution of implication with conjunction.  (Contributed by NM,
       1-Aug-1994.) $)
    imdistani $p |- ( ( ph /\ ps ) -> ( ph /\ ch ) ) $=
      wph wps wph wch wa wph wps wch imdistani.1 anc2li imp $.
  $}

  ${
    imdistanri.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Distribution of implication with conjunction.  (Contributed by NM,
       8-Jan-2002.) $)
    imdistanri $p |- ( ( ps /\ ph ) -> ( ch /\ ph ) ) $=
      wps wph wch wph wps wch imdistanri.1 com12 impac $.
  $}

  ${
    imdistand.1 $e |- ( ph -> ( ps -> ( ch -> th ) ) ) $.
    $( Distribution of implication with conjunction (deduction form).
       (Contributed by NM, 27-Aug-2004.) $)
    imdistand $p |- ( ph -> ( ( ps /\ ch ) -> ( ps /\ th ) ) ) $=
      wph wps wch wth wi wi wps wch wa wps wth wa wi imdistand.1 wps wch wth
      imdistan sylib $.
  $}

  ${
    imdistanda.1 $e |- ( ( ph /\ ps ) -> ( ch -> th ) ) $.
    $( Distribution of implication with conjunction (deduction version with
       conjoined antecedent).  (Contributed by Jeff Madsen, 19-Jun-2011.) $)
    imdistanda $p |- ( ph -> ( ( ps /\ ch ) -> ( ps /\ th ) ) ) $=
      wph wps wch wth wph wps wch wth wi imdistanda.1 ex imdistand $.
  $}

  $( Theorem *5.3 of [WhiteheadRussell] p. 125.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Andrew Salmon, 7-May-2011.) $)
  pm5.3 $p |- ( ( ( ph /\ ps ) -> ch ) <->
               ( ( ph /\ ps ) -> ( ph /\ ch ) ) ) $=
    wph wps wa wch wph wch wa wph wps wa wph wch wph wps simpl biantrurd
    pm5.74i $.

  $( Distribution of implication over biconditional.  Theorem *5.32 of
     [WhiteheadRussell] p. 125.  (Contributed by NM, 1-Aug-1994.) $)
  pm5.32 $p |- ( ( ph -> ( ps <-> ch ) ) <->
               ( ( ph /\ ps ) <-> ( ph /\ ch ) ) ) $=
    wph wps wch wb wi wph wps wn wi wn wph wch wn wi wn wb wph wps wa wph wch
    wa wb wph wps wch wb wi wph wps wn wch wn wb wi wph wps wn wi wph wch wn wi
    wb wph wps wn wi wn wph wch wn wi wn wb wps wch wb wps wn wch wn wb wph wps
    wch notbi imbi2i wph wps wn wch wn pm5.74 wph wps wn wi wph wch wn wi notbi
    3bitri wph wps wa wph wps wn wi wn wph wch wa wph wch wn wi wn wph wps
    df-an wph wch df-an bibi12i bitr4i $.

  ${
    pm5.32i.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    $( Distribution of implication over biconditional (inference form).
       (Contributed by NM, 1-Aug-1994.) $)
    pm5.32i $p |- ( ( ph /\ ps ) <-> ( ph /\ ch ) ) $=
      wph wps wch wb wi wph wps wa wph wch wa wb pm5.32i.1 wph wps wch pm5.32
      mpbi $.

    $( Distribution of implication over biconditional (inference form).
       (Contributed by NM, 12-Mar-1995.) $)
    pm5.32ri $p |- ( ( ps /\ ph ) <-> ( ch /\ ph ) ) $=
      wph wps wa wph wch wa wps wph wa wch wph wa wph wps wch pm5.32i.1 pm5.32i
      wps wph ancom wch wph ancom 3bitr4i $.
  $}

  ${
    bianim.1 $e |- ( ph <-> ( ps /\ ch ) ) $.
    bianim.2 $e |- ( ch -> ( ps <-> th ) ) $.
    $( Exchanging conjunction in a biconditional.  (Contributed by Peter Mazsa,
       31-Jul-2023.) $)
    bianim $p |- ( ph <-> ( th /\ ch ) ) $=
      wph wps wch wa wth wch wa bianim.1 wch wps wth bianim.2 pm5.32ri bitri $.
  $}

  ${
    pm5.32d.1 $e |- ( ph -> ( ps -> ( ch <-> th ) ) ) $.
    $( Distribution of implication over biconditional (deduction form).
       (Contributed by NM, 29-Oct-1996.) $)
    pm5.32d $p |- ( ph -> ( ( ps /\ ch ) <-> ( ps /\ th ) ) ) $=
      wph wps wch wth wb wi wps wch wa wps wth wa wb pm5.32d.1 wps wch wth
      pm5.32 sylib $.

    $( Distribution of implication over biconditional (deduction form).
       (Contributed by NM, 25-Dec-2004.) $)
    pm5.32rd $p |- ( ph -> ( ( ch /\ ps ) <-> ( th /\ ps ) ) ) $=
      wph wps wch wa wps wth wa wch wps wa wth wps wa wph wps wch wth pm5.32d.1
      pm5.32d wch wps ancom wth wps ancom 3bitr4g $.
  $}

  ${
    pm5.32da.1 $e |- ( ( ph /\ ps ) -> ( ch <-> th ) ) $.
    $( Distribution of implication over biconditional (deduction form).
       (Contributed by NM, 9-Dec-2006.) $)
    pm5.32da $p |- ( ph -> ( ( ps /\ ch ) <-> ( ps /\ th ) ) ) $=
      wph wps wch wth wph wps wch wth wb pm5.32da.1 ex pm5.32d $.
  $}

  ${
    sylan.1 $e |- ( ph -> ps ) $.
    sylan.2 $e |- ( ( ps /\ ch ) -> th ) $.
    $( A syllogism inference.  (Contributed by NM, 21-Apr-1994.)  (Proof
       shortened by Wolf Lammen, 22-Nov-2012.) $)
    sylan $p |- ( ( ph /\ ch ) -> th ) $=
      wph wps wch wth sylan.1 wps wch wth sylan.2 expcom mpan9 $.
  $}

  ${
    sylanb.1 $e |- ( ph <-> ps ) $.
    sylanb.2 $e |- ( ( ps /\ ch ) -> th ) $.
    $( A syllogism inference.  (Contributed by NM, 18-May-1994.) $)
    sylanb $p |- ( ( ph /\ ch ) -> th ) $=
      wph wps wch wth wph wps sylanb.1 biimpi sylanb.2 sylan $.
  $}

  ${
    sylanbr.1 $e |- ( ps <-> ph ) $.
    sylanbr.2 $e |- ( ( ps /\ ch ) -> th ) $.
    $( A syllogism inference.  (Contributed by NM, 18-May-1994.) $)
    sylanbr $p |- ( ( ph /\ ch ) -> th ) $=
      wph wps wch wth wps wph sylanbr.1 biimpri sylanbr.2 sylan $.
  $}

  ${
    sylanbrc.1 $e |- ( ph -> ps ) $.
    sylanbrc.2 $e |- ( ph -> ch ) $.
    sylanbrc.3 $e |- ( th <-> ( ps /\ ch ) ) $.
    $( Syllogism inference.  (Contributed by Jeff Madsen, 2-Sep-2009.) $)
    sylanbrc $p |- ( ph -> th ) $=
      wph wps wch wa wth wph wps wch sylanbrc.1 sylanbrc.2 jca sylanbrc.3
      sylibr $.
  $}

  ${
    syl2anc.1 $e |- ( ph -> ps ) $.
    syl2anc.2 $e |- ( ph -> ch ) $.
    syl2anc.3 $e |- ( ( ps /\ ch ) -> th ) $.
    $( Syllogism inference combined with contraction.  (Contributed by NM,
       16-Mar-2012.) $)
    syl2anc $p |- ( ph -> th ) $=
      wph wps wch wth syl2anc.1 syl2anc.2 wps wch wth syl2anc.3 ex sylc $.
  $}

  ${
    syl2anc2.1 $e |- ( ph -> ps ) $.
    syl2anc2.2 $e |- ( ps -> ch ) $.
    syl2anc2.3 $e |- ( ( ps /\ ch ) -> th ) $.
    $( Double syllogism inference combined with contraction.  (Contributed by
       BTernaryTau, 29-Sep-2023.) $)
    syl2anc2 $p |- ( ph -> th ) $=
      wph wps wch wth syl2anc2.1 wph wps wch syl2anc2.1 syl2anc2.2 syl
      syl2anc2.3 syl2anc $.
  $}

  ${
    sylancl.1 $e |- ( ph -> ps ) $.
    sylancl.2 $e |- ch $.
    sylancl.3 $e |- ( ( ps /\ ch ) -> th ) $.
    $( Syllogism inference combined with modus ponens.  (Contributed by Jeff
       Madsen, 2-Sep-2009.) $)
    sylancl $p |- ( ph -> th ) $=
      wph wps wch wth sylancl.1 wch wph sylancl.2 a1i sylancl.3 syl2anc $.
  $}

  ${
    sylancr.1 $e |- ps $.
    sylancr.2 $e |- ( ph -> ch ) $.
    sylancr.3 $e |- ( ( ps /\ ch ) -> th ) $.
    $( Syllogism inference combined with modus ponens.  (Contributed by Jeff
       Madsen, 2-Sep-2009.) $)
    sylancr $p |- ( ph -> th ) $=
      wph wps wch wth wps wph sylancr.1 a1i sylancr.2 sylancr.3 syl2anc $.
  $}

  ${
    sylancom.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    sylancom.2 $e |- ( ( ch /\ ps ) -> th ) $.
    $( Syllogism inference with commutation of antecedents.  (Contributed by
       NM, 2-Jul-2008.) $)
    sylancom $p |- ( ( ph /\ ps ) -> th ) $=
      wph wps wa wch wps wth sylancom.1 wph wps simpr sylancom.2 syl2anc $.
  $}

  ${
    sylanblc.1 $e |- ( ph -> ps ) $.
    sylanblc.2 $e |- ch $.
    sylanblc.3 $e |- ( ( ps /\ ch ) <-> th ) $.
    $( Syllogism inference combined with a biconditional.  (Contributed by BJ,
       25-Apr-2019.) $)
    sylanblc $p |- ( ph -> th ) $=
      wph wps wch wth sylanblc.1 sylanblc.2 wps wch wa wth sylanblc.3 biimpi
      sylancl $.
  $}

  ${
    sylanblrc.1 $e |- ( ph -> ps ) $.
    sylanblrc.2 $e |- ch $.
    sylanblrc.3 $e |- ( th <-> ( ps /\ ch ) ) $.
    $( Syllogism inference combined with a biconditional.  (Contributed by BJ,
       25-Apr-2019.) $)
    sylanblrc $p |- ( ph -> th ) $=
      wph wps wch wth sylanblrc.1 wch wph sylanblrc.2 a1i sylanblrc.3 sylanbrc
      $.
  $}

  ${
    syldan.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    syldan.2 $e |- ( ( ph /\ ch ) -> th ) $.
    $( A syllogism deduction with conjoined antecedents.  (Contributed by NM,
       24-Feb-2005.)  (Proof shortened by Wolf Lammen, 6-Apr-2013.) $)
    syldan $p |- ( ( ph /\ ps ) -> th ) $=
      wph wps wa wph wch wth wph wps simpl syldan.1 syldan.2 syl2anc $.
  $}

  ${
    sylbida.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    sylbida.2 $e |- ( ( ph /\ ch ) -> th ) $.
    $( A syllogism deduction.  (Contributed by SN, 16-Jul-2024.) $)
    sylbida $p |- ( ( ph /\ ps ) -> th ) $=
      wph wps wch wth wph wps wch sylbida.1 biimpa sylbida.2 syldan $.
  $}

  ${
    sylan2.1 $e |- ( ph -> ch ) $.
    sylan2.2 $e |- ( ( ps /\ ch ) -> th ) $.
    $( A syllogism inference.  (Contributed by NM, 21-Apr-1994.)  (Proof
       shortened by Wolf Lammen, 22-Nov-2012.) $)
    sylan2 $p |- ( ( ps /\ ph ) -> th ) $=
      wps wph wch wth wph wch wps sylan2.1 adantl sylan2.2 syldan $.
  $}

  ${
    sylan2b.1 $e |- ( ph <-> ch ) $.
    sylan2b.2 $e |- ( ( ps /\ ch ) -> th ) $.
    $( A syllogism inference.  (Contributed by NM, 21-Apr-1994.) $)
    sylan2b $p |- ( ( ps /\ ph ) -> th ) $=
      wph wps wch wth wph wch sylan2b.1 biimpi sylan2b.2 sylan2 $.
  $}

  ${
    sylan2br.1 $e |- ( ch <-> ph ) $.
    sylan2br.2 $e |- ( ( ps /\ ch ) -> th ) $.
    $( A syllogism inference.  (Contributed by NM, 21-Apr-1994.) $)
    sylan2br $p |- ( ( ps /\ ph ) -> th ) $=
      wph wps wch wth wch wph sylan2br.1 biimpri sylan2br.2 sylan2 $.
  $}

  ${
    syl2an.1 $e |- ( ph -> ps ) $.
    syl2an.2 $e |- ( ta -> ch ) $.
    syl2an.3 $e |- ( ( ps /\ ch ) -> th ) $.
    $( A double syllogism inference.  For an implication-only version, see
       ~ syl2im .  (Contributed by NM, 31-Jan-1997.) $)
    syl2an $p |- ( ( ph /\ ta ) -> th ) $=
      wta wph wch wth syl2an.2 wph wps wch wth syl2an.1 syl2an.3 sylan sylan2
      $.

    $( A double syllogism inference.  For an implication-only version, see
       ~ syl2imc .  (Contributed by NM, 17-Sep-2013.) $)
    syl2anr $p |- ( ( ta /\ ph ) -> th ) $=
      wph wta wth wph wps wch wth wta syl2an.1 syl2an.2 syl2an.3 syl2an ancoms
      $.
  $}

  ${
    syl2anb.1 $e |- ( ph <-> ps ) $.
    syl2anb.2 $e |- ( ta <-> ch ) $.
    syl2anb.3 $e |- ( ( ps /\ ch ) -> th ) $.
    $( A double syllogism inference.  (Contributed by NM, 29-Jul-1999.) $)
    syl2anb $p |- ( ( ph /\ ta ) -> th ) $=
      wta wph wch wth syl2anb.2 wph wps wch wth syl2anb.1 syl2anb.3 sylanb
      sylan2b $.
  $}

  ${
    syl2anbr.1 $e |- ( ps <-> ph ) $.
    syl2anbr.2 $e |- ( ch <-> ta ) $.
    syl2anbr.3 $e |- ( ( ps /\ ch ) -> th ) $.
    $( A double syllogism inference.  (Contributed by NM, 29-Jul-1999.) $)
    syl2anbr $p |- ( ( ph /\ ta ) -> th ) $=
      wta wph wch wth syl2anbr.2 wph wps wch wth syl2anbr.1 syl2anbr.3 sylanbr
      sylan2br $.
  $}

  ${
    sylancb.1 $e |- ( ph <-> ps ) $.
    sylancb.2 $e |- ( ph <-> ch ) $.
    sylancb.3 $e |- ( ( ps /\ ch ) -> th ) $.
    $( A syllogism inference combined with contraction.  (Contributed by NM,
       3-Sep-2004.) $)
    sylancb $p |- ( ph -> th ) $=
      wph wth wph wps wch wth wph sylancb.1 sylancb.2 sylancb.3 syl2anb anidms
      $.
  $}

  ${
    sylancbr.1 $e |- ( ps <-> ph ) $.
    sylancbr.2 $e |- ( ch <-> ph ) $.
    sylancbr.3 $e |- ( ( ps /\ ch ) -> th ) $.
    $( A syllogism inference combined with contraction.  (Contributed by NM,
       3-Sep-2004.) $)
    sylancbr $p |- ( ph -> th ) $=
      wph wth wph wps wch wth wph sylancbr.1 sylancbr.2 sylancbr.3 syl2anbr
      anidms $.
  $}

  ${
    syldanl.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    syldanl.2 $e |- ( ( ( ph /\ ch ) /\ th ) -> ta ) $.
    $( A syllogism deduction with conjoined antecedents.  (Contributed by Jeff
       Madsen, 20-Jun-2011.) $)
    syldanl $p |- ( ( ( ph /\ ps ) /\ th ) -> ta ) $=
      wph wps wa wph wch wa wth wta wph wps wch wph wps wch syldanl.1 ex
      imdistani syldanl.2 sylan $.
  $}

  ${
    syland.1 $e |- ( ph -> ( ps -> ch ) ) $.
    syland.2 $e |- ( ph -> ( ( ch /\ th ) -> ta ) ) $.
    $( A syllogism deduction.  (Contributed by NM, 15-Dec-2004.) $)
    syland $p |- ( ph -> ( ( ps /\ th ) -> ta ) ) $=
      wph wps wth wta wph wps wch wth wta wi syland.1 wph wch wth wta syland.2
      expd syld impd $.
  $}

  ${
    sylani.1 $e |- ( ph -> ch ) $.
    sylani.2 $e |- ( ps -> ( ( ch /\ th ) -> ta ) ) $.
    $( A syllogism inference.  (Contributed by NM, 2-May-1996.) $)
    sylani $p |- ( ps -> ( ( ph /\ th ) -> ta ) ) $=
      wps wph wch wth wta wph wch wi wps sylani.1 a1i sylani.2 syland $.
  $}

  ${
    sylan2d.1 $e |- ( ph -> ( ps -> ch ) ) $.
    sylan2d.2 $e |- ( ph -> ( ( th /\ ch ) -> ta ) ) $.
    $( A syllogism deduction.  (Contributed by NM, 15-Dec-2004.) $)
    sylan2d $p |- ( ph -> ( ( th /\ ps ) -> ta ) ) $=
      wph wps wth wta wph wps wch wth wta sylan2d.1 wph wth wch wta sylan2d.2
      ancomsd syland ancomsd $.
  $}

  ${
    sylan2i.1 $e |- ( ph -> th ) $.
    sylan2i.2 $e |- ( ps -> ( ( ch /\ th ) -> ta ) ) $.
    $( A syllogism inference.  (Contributed by NM, 1-Aug-1994.) $)
    sylan2i $p |- ( ps -> ( ( ch /\ ph ) -> ta ) ) $=
      wps wph wth wch wta wph wth wi wps sylan2i.1 a1i sylan2i.2 sylan2d $.
  $}

  ${
    syl2ani.1 $e |- ( ph -> ch ) $.
    syl2ani.2 $e |- ( et -> th ) $.
    syl2ani.3 $e |- ( ps -> ( ( ch /\ th ) -> ta ) ) $.
    $( A syllogism inference.  (Contributed by NM, 3-Aug-1999.) $)
    syl2ani $p |- ( ps -> ( ( ph /\ et ) -> ta ) ) $=
      wph wps wch wet wta syl2ani.1 wet wps wch wth wta syl2ani.2 syl2ani.3
      sylan2i sylani $.
  $}

  ${
    syl2and.1 $e |- ( ph -> ( ps -> ch ) ) $.
    syl2and.2 $e |- ( ph -> ( th -> ta ) ) $.
    syl2and.3 $e |- ( ph -> ( ( ch /\ ta ) -> et ) ) $.
    $( A syllogism deduction.  (Contributed by NM, 15-Dec-2004.) $)
    syl2and $p |- ( ph -> ( ( ps /\ th ) -> et ) ) $=
      wph wps wch wth wet syl2and.1 wph wth wta wch wet syl2and.2 syl2and.3
      sylan2d syland $.
  $}

  ${
    anim12d.1 $e |- ( ph -> ( ps -> ch ) ) $.
    anim12d.2 $e |- ( ph -> ( th -> ta ) ) $.
    $( Conjoin antecedents and consequents in a deduction.  (Contributed by NM,
       3-Apr-1994.)  (Proof shortened by Wolf Lammen, 18-Dec-2013.) $)
    anim12d $p |- ( ph -> ( ( ps /\ th ) -> ( ch /\ ta ) ) ) $=
      wph wps wch wth wta wch wta wa anim12d.1 anim12d.2 wph wch wta wa idd
      syl2and $.
  $}

  ${
    anim12d1.1 $e |- ( ph -> ( ps -> ch ) ) $.
    anim12d1.2 $e |- ( th -> ta ) $.
    $( Variant of ~ anim12d where the second implication does not depend on the
       antecedent.  (Contributed by Rodolfo Medina, 12-Oct-2010.) $)
    anim12d1 $p |- ( ph -> ( ( ps /\ th ) -> ( ch /\ ta ) ) ) $=
      wph wps wch wth wta anim12d1.1 wth wta wi wph anim12d1.2 a1i anim12d $.
  $}

  ${
    anim1d.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Add a conjunct to right of antecedent and consequent in a deduction.
       (Contributed by NM, 3-Apr-1994.) $)
    anim1d $p |- ( ph -> ( ( ps /\ th ) -> ( ch /\ th ) ) ) $=
      wph wps wch wth wth anim1d.1 wph wth idd anim12d $.

    $( Add a conjunct to left of antecedent and consequent in a deduction.
       (Contributed by NM, 14-May-1993.) $)
    anim2d $p |- ( ph -> ( ( th /\ ps ) -> ( th /\ ch ) ) ) $=
      wph wth wth wps wch wph wth idd anim1d.1 anim12d $.
  $}

  ${
    anim12i.1 $e |- ( ph -> ps ) $.
    anim12i.2 $e |- ( ch -> th ) $.
    $( Conjoin antecedents and consequents of two premises.  (Contributed by
       NM, 3-Jan-1993.)  (Proof shortened by Wolf Lammen, 14-Dec-2013.) $)
    anim12i $p |- ( ( ph /\ ch ) -> ( ps /\ th ) ) $=
      wph wps wth wps wth wa wch anim12i.1 anim12i.2 wps wth wa id syl2an $.

    $( Variant of ~ anim12i with commutation.  (Contributed by Jonathan
       Ben-Naim, 3-Jun-2011.) $)
    anim12ci $p |- ( ( ph /\ ch ) -> ( th /\ ps ) ) $=
      wch wph wth wps wa wch wth wph wps anim12i.2 anim12i.1 anim12i ancoms $.
  $}

  ${
    anim1i.1 $e |- ( ph -> ps ) $.
    $( Introduce conjunct to both sides of an implication.  (Contributed by NM,
       5-Aug-1993.) $)
    anim1i $p |- ( ( ph /\ ch ) -> ( ps /\ ch ) ) $=
      wph wps wch wch anim1i.1 wch id anim12i $.

    $( Introduce conjunct to both sides of an implication.  (Contributed by
       Peter Mazsa, 24-Sep-2022.) $)
    anim1ci $p |- ( ( ph /\ ch ) -> ( ch /\ ps ) ) $=
      wph wps wch wch anim1i.1 wch id anim12ci $.

    $( Introduce conjunct to both sides of an implication.  (Contributed by NM,
       3-Jan-1993.) $)
    anim2i $p |- ( ( ch /\ ph ) -> ( ch /\ ps ) ) $=
      wch wch wph wps wch id anim1i.1 anim12i $.
  $}

  ${
    anim12ii.1 $e |- ( ph -> ( ps -> ch ) ) $.
    anim12ii.2 $e |- ( th -> ( ps -> ta ) ) $.
    $( Conjoin antecedents and consequents in a deduction.  (Contributed by NM,
       11-Nov-2007.)  (Proof shortened by Wolf Lammen, 19-Jul-2013.) $)
    anim12ii $p |- ( ( ph /\ th ) -> ( ps -> ( ch /\ ta ) ) ) $=
      wph wps wch wi wps wta wi wps wch wta wa wi wth anim12ii.1 anim12ii.2 wps
      wch wta pm3.43 syl2an $.
  $}

  ${
    anim12dan.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    anim12dan.2 $e |- ( ( ph /\ th ) -> ta ) $.
    $( Conjoin antecedents and consequents in a deduction.  (Contributed by
       Jeff Madsen, 16-Jun-2011.) $)
    anim12dan $p |- ( ( ph /\ ( ps /\ th ) ) -> ( ch /\ ta ) ) $=
      wph wps wth wa wch wta wa wph wps wch wth wta wph wps wch anim12dan.1 ex
      wph wth wta anim12dan.2 ex anim12d imp $.
  $}

  ${
    im2an9.1 $e |- ( ph -> ( ps -> ch ) ) $.
    im2an9.2 $e |- ( th -> ( ta -> et ) ) $.
    $( Deduction joining nested implications to form implication of
       conjunctions.  (Contributed by NM, 29-Feb-1996.) $)
    im2anan9 $p |- ( ( ph /\ th ) -> ( ( ps /\ ta ) -> ( ch /\ et ) ) ) $=
      wph wps wta wa wch wth wet wph wps wch wta im2an9.1 adantrd wth wta wet
      wps im2an9.2 adantld anim12ii $.

    $( Deduction joining nested implications to form implication of
       conjunctions.  (Contributed by NM, 29-Feb-1996.) $)
    im2anan9r $p |- ( ( th /\ ph ) -> ( ( ps /\ ta ) -> ( ch /\ et ) ) ) $=
      wph wth wps wta wa wch wet wa wi wph wps wch wth wta wet im2an9.1
      im2an9.2 im2anan9 ancoms $.
  $}

  $( Theorem *3.45 (Fact) of [WhiteheadRussell] p. 113.  (Contributed by NM,
     3-Jan-2005.) $)
  pm3.45 $p |- ( ( ph -> ps ) -> ( ( ph /\ ch ) -> ( ps /\ ch ) ) ) $=
    wph wps wi wph wps wch wph wps wi id anim1d $.

  ${
    anbi.1 $e |- ( ph <-> ps ) $.
    $( Introduce a left conjunct to both sides of a logical equivalence.
       (Contributed by NM, 3-Jan-1993.)  (Proof shortened by Wolf Lammen,
       16-Nov-2013.) $)
    anbi2i $p |- ( ( ch /\ ph ) <-> ( ch /\ ps ) ) $=
      wch wph wps wph wps wb wch anbi.1 a1i pm5.32i $.

    $( Introduce a right conjunct to both sides of a logical equivalence.
       (Contributed by NM, 12-Mar-1993.)  (Proof shortened by Wolf Lammen,
       16-Nov-2013.) $)
    anbi1i $p |- ( ( ph /\ ch ) <-> ( ps /\ ch ) ) $=
      wch wph wps wph wps wb wch anbi.1 a1i pm5.32ri $.

    $( Variant of ~ anbi2i with commutation.  (Contributed by Jonathan
       Ben-Naim, 3-Jun-2011.)  (Proof shortened by Andrew Salmon,
       14-Jun-2011.) $)
    anbi2ci $p |- ( ( ph /\ ch ) <-> ( ch /\ ps ) ) $=
      wph wch wa wch wps wph wps wch anbi.1 anbi1i biancomi $.

    $( Variant of ~ anbi1i with commutation.  (Contributed by Peter Mazsa,
       7-Mar-2020.) $)
    anbi1ci $p |- ( ( ch /\ ph ) <-> ( ps /\ ch ) ) $=
      wch wph wa wps wch wph wps wch anbi.1 anbi2i biancomi $.
  $}

  ${
    bianbi.1 $e |- ( ph <-> ( ps /\ ch ) ) $.
    bianbi.2 $e |- ( ps <-> th ) $.
    $( Exchanging conjunction in a biconditional.  (Contributed by Peter Mazsa,
       31-Jul-2023.) $)
    bianbi $p |- ( ph <-> ( th /\ ch ) ) $=
      wph wps wch wa wth wch wa bianbi.1 wps wth wch bianbi.2 anbi1i bitri $.
  $}

  ${
    anbi12.1 $e |- ( ph <-> ps ) $.
    anbi12.2 $e |- ( ch <-> th ) $.
    $( Conjoin both sides of two equivalences.  (Contributed by NM,
       12-Mar-1993.) $)
    anbi12i $p |- ( ( ph /\ ch ) <-> ( ps /\ th ) ) $=
      wph wch wa wph wth wps wch wth wph anbi12.2 anbi2i anbi12.1 bianbi $.

    $( Variant of ~ anbi12i with commutation.  (Contributed by Jonathan
       Ben-Naim, 3-Jun-2011.) $)
    anbi12ci $p |- ( ( ph /\ ch ) <-> ( th /\ ps ) ) $=
      wph wch wa wth wps wph wps wch wth anbi12.1 anbi12.2 anbi12i biancomi $.
  $}

  ${
    anbid.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    $( Deduction adding a left conjunct to both sides of a logical equivalence.
       (Contributed by NM, 11-May-1993.)  (Proof shortened by Wolf Lammen,
       16-Nov-2013.) $)
    anbi2d $p |- ( ph -> ( ( th /\ ps ) <-> ( th /\ ch ) ) ) $=
      wph wth wps wch wph wps wch wb wth anbid.1 a1d pm5.32d $.

    $( Deduction adding a right conjunct to both sides of a logical
       equivalence.  (Contributed by NM, 11-May-1993.)  (Proof shortened by
       Wolf Lammen, 16-Nov-2013.) $)
    anbi1d $p |- ( ph -> ( ( ps /\ th ) <-> ( ch /\ th ) ) ) $=
      wph wth wps wch wph wps wch wb wth anbid.1 a1d pm5.32rd $.
  $}

  ${
    anbi12d.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    anbi12d.2 $e |- ( ph -> ( th <-> ta ) ) $.
    $( Deduction joining two equivalences to form equivalence of conjunctions.
       (Contributed by NM, 26-May-1993.) $)
    anbi12d $p |- ( ph -> ( ( ps /\ th ) <-> ( ch /\ ta ) ) ) $=
      wph wps wth wa wch wth wa wch wta wa wph wps wch wth anbi12d.1 anbi1d wph
      wth wta wch anbi12d.2 anbi2d bitrd $.
  $}

  $( Introduce a right conjunct to both sides of a logical equivalence.
     Theorem *4.36 of [WhiteheadRussell] p. 118.  (Contributed by NM,
     3-Jan-2005.) $)
  anbi1 $p |- ( ( ph <-> ps ) -> ( ( ph /\ ch ) <-> ( ps /\ ch ) ) ) $=
    wph wps wb wph wps wch wph wps wb id anbi1d $.

  $( Introduce a left conjunct to both sides of a logical equivalence.
     (Contributed by NM, 16-Nov-2013.) $)
  anbi2 $p |- ( ( ph <-> ps ) -> ( ( ch /\ ph ) <-> ( ch /\ ps ) ) ) $=
    wph wps wb wph wps wch wph wps wb id anbi2d $.

  ${
    anbi1cd.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    $( Introduce a proposition as left conjunct on the left-hand side and right
       conjunct on the right-hand side of an equivalence.  Deduction form.
       (Contributed by Peter Mazsa, 22-May-2021.) $)
    anbi1cd $p |- ( ph -> ( ( th /\ ps ) <-> ( ch /\ th ) ) ) $=
      wph wth wps wa wch wth wph wps wch wth anbi1cd.1 anbi2d biancomd $.
  $}

  $( Double commutation in conjunction.  (Contributed by Peter Mazsa,
     27-Jun-2019.) $)
  an2anr $p |- ( ( ( ph /\ ps ) /\ ( ch /\ th ) ) <->
                 ( ( ps /\ ph ) /\ ( th /\ ch ) ) ) $=
    wph wps wa wps wph wa wch wth wa wth wch wa wph wps ancom wch wth ancom
    anbi12i $.

  $( Theorem *4.38 of [WhiteheadRussell] p. 118.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.38 $p |- ( ( ( ph <-> ch ) /\ ( ps <-> th ) ) ->
                ( ( ph /\ ps ) <-> ( ch /\ th ) ) ) $=
    wph wch wb wps wth wb wa wph wch wps wth wph wch wb wps wth wb simpl wph
    wch wb wps wth wb simpr anbi12d $.

  ${
    bi2an9.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    bi2an9.2 $e |- ( th -> ( ta <-> et ) ) $.
    $( Deduction joining two equivalences to form equivalence of conjunctions.
       (Contributed by NM, 31-Jul-1995.) $)
    bi2anan9 $p |- ( ( ph /\ th ) -> ( ( ps /\ ta ) <-> ( ch /\ et ) ) ) $=
      wph wps wch wb wta wet wb wps wta wa wch wet wa wb wth bi2an9.1 bi2an9.2
      wps wta wch wet pm4.38 syl2an $.

    $( Deduction joining two equivalences to form equivalence of conjunctions.
       (Contributed by NM, 19-Feb-1996.) $)
    bi2anan9r $p |- ( ( th /\ ph ) -> ( ( ps /\ ta ) <-> ( ch /\ et ) ) ) $=
      wph wth wps wta wa wch wet wa wb wph wps wch wth wta wet bi2an9.1
      bi2an9.2 bi2anan9 ancoms $.

    $( Deduction joining two biconditionals with different antecedents.
       (Contributed by NM, 12-May-2004.) $)
    bi2bian9 $p |- ( ( ph /\ th ) -> ( ( ps <-> ta ) <-> ( ch <-> et ) ) ) $=
      wph wth wa wps wch wta wet wph wps wch wb wth bi2an9.1 adantr wth wta wet
      wb wph bi2an9.2 adantl bibi12d $.
  $}

  ${
    anbiim.1 $e |- ( ph -> ( ch -> th ) ) $.
    anbiim.2 $e |- ( ps -> ( th -> ch ) ) $.
    $( Adding biconditional when antecedents are conjuncted.  (Contributed by
       metakunt, 16-Apr-2024.)  (Proof shortened by Wolf Lammen,
       7-May-2025.) $)
    anbiim $p |- ( ( ph /\ ps ) -> ( ch <-> th ) ) $=
      wph wps wa wch wth wph wch wth wi wps anbiim.1 adantr wps wth wch wi wph
      anbiim.2 adantl impbid $.
  $}

  ${
    bianass.1 $e |- ( ph <-> ( ps /\ ch ) ) $.
    $( An inference to merge two lists of conjuncts.  (Contributed by Giovanni
       Mascellani, 23-May-2019.) $)
    bianass $p |- ( ( et /\ ph ) <-> ( ( et /\ ps ) /\ ch ) ) $=
      wet wph wa wet wps wch wa wa wet wps wa wch wa wph wps wch wa wet
      bianass.1 anbi2i wet wps wch anass bitr4i $.

    $( An inference to merge two lists of conjuncts.  (Contributed by Peter
       Mazsa, 24-Sep-2022.) $)
    bianassc $p |- ( ( et /\ ph ) <-> ( ( ps /\ et ) /\ ch ) ) $=
      wet wph wa wet wps wa wch wps wet wa wph wps wch wet bianass.1 bianass
      wet wps ancom bianbi $.
  $}

  $( Swap two conjuncts.  (Contributed by Peter Mazsa, 18-Sep-2022.) $)
  an21 $p |- ( ( ( ph /\ ps ) /\ ch ) <-> ( ps /\ ( ph /\ ch ) ) ) $=
    wps wph wch wa wa wph wps wa wch wa wph wch wa wph wch wps wph wch wa biid
    bianassc bicomi $.

  $( Swap two conjuncts.  Note that the first digit (1) in the label refers to
     the outer conjunct position, and the next digit (2) to the inner conjunct
     position.  (Contributed by NM, 12-Mar-1995.)  (Proof shortened by Peter
     Mazsa, 18-Sep-2022.) $)
  an12 $p |- ( ( ph /\ ( ps /\ ch ) ) <-> ( ps /\ ( ph /\ ch ) ) ) $=
    wph wps wch wa wa wps wph wch wa wps wch wa wch wps wph wps wch ancom
    bianass biancomi $.

  $( A rearrangement of conjuncts.  (Contributed by NM, 12-Mar-1995.)  (Proof
     shortened by Wolf Lammen, 25-Dec-2012.) $)
  an32 $p |- ( ( ( ph /\ ps ) /\ ch ) <-> ( ( ph /\ ch ) /\ ps ) ) $=
    wph wps wa wch wa wph wch wa wps wph wps wch an21 biancomi $.

  $( A rearrangement of conjuncts.  (Contributed by NM, 24-Jun-2012.)  (Proof
     shortened by Wolf Lammen, 31-Dec-2012.) $)
  an13 $p |- ( ( ph /\ ( ps /\ ch ) ) <-> ( ch /\ ( ps /\ ph ) ) ) $=
    wph wps wch wa wa wps wph wa wch wa wch wps wph wa wa wps wph wch an21 wps
    wph wa wch ancom bitr3i $.

  $( A rearrangement of conjuncts.  (Contributed by NM, 24-Jun-2012.)  (Proof
     shortened by Wolf Lammen, 31-Dec-2012.) $)
  an31 $p |- ( ( ( ph /\ ps ) /\ ch ) <-> ( ( ch /\ ps ) /\ ph ) ) $=
    wph wps wch wa wa wch wps wph wa wa wph wps wa wch wa wch wps wa wph wa wph
    wps wch an13 wph wps wch anass wch wps wph anass 3bitr4i $.

  ${
    an12s.1 $e |- ( ( ph /\ ( ps /\ ch ) ) -> th ) $.
    $( Swap two conjuncts in antecedent.  The label suffix "s" means that
       ~ an12 is combined with ~ syl (or a variant).  (Contributed by NM,
       13-Mar-1996.) $)
    an12s $p |- ( ( ps /\ ( ph /\ ch ) ) -> th ) $=
      wps wph wch wa wa wph wps wch wa wa wth wps wph wch an12 an12s.1 sylbi $.

    $( Inference commuting a nested conjunction in antecedent.  (Contributed by
       NM, 24-May-2006.)  (Proof shortened by Wolf Lammen, 24-Nov-2012.) $)
    ancom2s $p |- ( ( ph /\ ( ch /\ ps ) ) -> th ) $=
      wch wps wa wph wps wch wa wth wch wps pm3.22 an12s.1 sylan2 $.

    $( Swap two conjuncts in antecedent.  (Contributed by NM, 31-May-2006.) $)
    an13s $p |- ( ( ch /\ ( ps /\ ph ) ) -> th ) $=
      wch wps wph wth wph wps wch wth wph wps wch wth an12s.1 exp32 com13 imp32
      $.
  $}

  ${
    an32s.1 $e |- ( ( ( ph /\ ps ) /\ ch ) -> th ) $.
    $( Swap two conjuncts in antecedent.  (Contributed by NM, 13-Mar-1996.) $)
    an32s $p |- ( ( ( ph /\ ch ) /\ ps ) -> th ) $=
      wph wch wa wps wa wph wps wa wch wa wth wph wch wps an32 an32s.1 sylbi $.

    $( Inference commuting a nested conjunction in antecedent.  (Contributed by
       NM, 24-May-2006.)  (Proof shortened by Wolf Lammen, 24-Nov-2012.) $)
    ancom1s $p |- ( ( ( ps /\ ph ) /\ ch ) -> th ) $=
      wps wph wa wph wps wa wch wth wps wph pm3.22 an32s.1 sylan $.

    $( Swap two conjuncts in antecedent.  (Contributed by NM, 31-May-2006.) $)
    an31s $p |- ( ( ( ch /\ ps ) /\ ph ) -> th ) $=
      wch wps wph wth wph wps wch wth wph wps wch wth an32s.1 exp31 com13 imp31
      $.
  $}

  ${
    anass1rs.1 $e |- ( ( ph /\ ( ps /\ ch ) ) -> th ) $.
    $( Commutative-associative law for conjunction in an antecedent.
       (Contributed by Jeff Madsen, 19-Jun-2011.) $)
    anass1rs $p |- ( ( ( ph /\ ch ) /\ ps ) -> th ) $=
      wph wps wch wth wph wps wch wth anass1rs.1 anassrs an32s $.
  $}

  $( Rearrangement of 4 conjuncts.  (Contributed by NM, 10-Jul-1994.) $)
  an4 $p |- ( ( ( ph /\ ps ) /\ ( ch /\ th ) ) <->
              ( ( ph /\ ch ) /\ ( ps /\ th ) ) ) $=
    wph wps wa wch wth wa wa wph wps wch wth wa wa wa wph wch wa wps wth wa wa
    wph wps wch wth wa anass wps wch wth wa wa wch wps wth wa wph wps wch wth
    an12 bianass bitri $.

  $( Rearrangement of 4 conjuncts.  (Contributed by NM, 7-Feb-1996.) $)
  an42 $p |- ( ( ( ph /\ ps ) /\ ( ch /\ th ) ) <->
                 ( ( ph /\ ch ) /\ ( th /\ ps ) ) ) $=
    wph wps wa wch wth wa wa wph wch wa wps wth wa wa wph wch wa wth wps wa wa
    wph wps wch wth an4 wps wth wa wth wps wa wph wch wa wps wth ancom anbi2i
    bitri $.

  $( Rearrangement of 4 conjuncts.  (Contributed by Rodolfo Medina,
     24-Sep-2010.)  (Proof shortened by Andrew Salmon, 29-Jun-2011.) $)
  an43 $p |- ( ( ( ph /\ ps ) /\ ( ch /\ th ) ) <->
               ( ( ph /\ th ) /\ ( ps /\ ch ) ) ) $=
    wph wth wa wps wch wa wa wph wps wa wch wth wa wa wph wth wps wch an42
    bicomi $.

  $( A rearrangement of conjuncts.  (Contributed by Rodolfo Medina,
     25-Sep-2010.) $)
  an3 $p |- ( ( ( ph /\ ps ) /\ ( ch /\ th ) ) -> ( ph /\ th ) ) $=
    wph wps wa wch wth wa wa wph wth wa wps wch wa wph wps wch wth an43 simplbi
    $.

  ${
    an4s.1 $e |- ( ( ( ph /\ ps ) /\ ( ch /\ th ) ) -> ta ) $.
    $( Inference rearranging 4 conjuncts in antecedent.  (Contributed by NM,
       10-Aug-1995.) $)
    an4s $p |- ( ( ( ph /\ ch ) /\ ( ps /\ th ) ) -> ta ) $=
      wph wch wa wps wth wa wa wph wps wa wch wth wa wa wta wph wch wps wth an4
      an4s.1 sylbi $.
  $}

  ${
    an41r3s.1 $e |- ( ( ( ph /\ ps ) /\ ( ch /\ th ) ) -> ta ) $.
    $( Inference rearranging 4 conjuncts in antecedent.  (Contributed by NM,
       10-Aug-1995.) $)
    an42s $p |- ( ( ( ph /\ ch ) /\ ( th /\ ps ) ) -> ta ) $=
      wph wch wa wps wth wta wph wps wch wth wta an41r3s.1 an4s ancom2s $.
  $}

  $( Absorption into embedded conjunct.  (Contributed by NM, 4-Sep-1995.)
     (Proof shortened by Wolf Lammen, 16-Nov-2013.) $)
  anabs1 $p |- ( ( ( ph /\ ps ) /\ ph ) <-> ( ph /\ ps ) ) $=
    wph wps wa wph wps wa wph wa wph wps wa wph wph wps simpl pm4.71i bicomi $.

  $( Absorption into embedded conjunct.  (Contributed by NM, 20-Jul-1996.)
     (Proof shortened by Wolf Lammen, 9-Dec-2012.) $)
  anabs5 $p |- ( ( ph /\ ( ph /\ ps ) ) <-> ( ph /\ ps ) ) $=
    wph wph wps wa wps wph wps wph wps wa wph wps ibar bicomd pm5.32i $.

  $( Absorption into embedded conjunct.  (Contributed by NM, 20-Jul-1996.)
     (Proof shortened by Wolf Lammen, 17-Nov-2013.) $)
  anabs7 $p |- ( ( ps /\ ( ph /\ ps ) ) <-> ( ph /\ ps ) ) $=
    wph wps wa wps wph wps wa wa wph wps wa wps wph wps simpr pm4.71ri bicomi
    $.

  ${
    anabsan.1 $e |- ( ( ( ph /\ ph ) /\ ps ) -> ch ) $.
    $( Absorption of antecedent with conjunction.  (Contributed by NM,
       24-Mar-1996.) $)
    anabsan $p |- ( ( ph /\ ps ) -> ch ) $=
      wph wph wph wa wps wch wph pm4.24 anabsan.1 sylanb $.
  $}

  ${
    anabss1.1 $e |- ( ( ( ph /\ ps ) /\ ph ) -> ch ) $.
    $( Absorption of antecedent into conjunction.  (Contributed by NM,
       20-Jul-1996.)  (Proof shortened by Wolf Lammen, 31-Dec-2012.) $)
    anabss1 $p |- ( ( ph /\ ps ) -> ch ) $=
      wph wps wch wph wps wph wch anabss1.1 an32s anabsan $.
  $}

  ${
    anabss4.1 $e |- ( ( ( ps /\ ph ) /\ ps ) -> ch ) $.
    $( Absorption of antecedent into conjunction.  (Contributed by NM,
       20-Jul-1996.) $)
    anabss4 $p |- ( ( ph /\ ps ) -> ch ) $=
      wps wph wch wps wph wch anabss4.1 anabss1 ancoms $.
  $}

  ${
    anabss5.1 $e |- ( ( ph /\ ( ph /\ ps ) ) -> ch ) $.
    $( Absorption of antecedent into conjunction.  (Contributed by NM,
       10-May-1994.)  (Proof shortened by Wolf Lammen, 1-Jan-2013.) $)
    anabss5 $p |- ( ( ph /\ ps ) -> ch ) $=
      wph wps wch wph wph wps wch anabss5.1 anassrs anabsan $.
  $}

  ${
    anabsi5.1 $e |- ( ph -> ( ( ph /\ ps ) -> ch ) ) $.
    $( Absorption of antecedent into conjunction.  (Contributed by NM,
       11-Jun-1995.)  (Proof shortened by Wolf Lammen, 18-Nov-2013.) $)
    anabsi5 $p |- ( ( ph /\ ps ) -> ch ) $=
      wph wph wps wa wch wph wps simpl anabsi5.1 mpcom $.
  $}

  ${
    anabsi6.1 $e |- ( ph -> ( ( ps /\ ph ) -> ch ) ) $.
    $( Absorption of antecedent into conjunction.  (Contributed by NM,
       14-Aug-2000.) $)
    anabsi6 $p |- ( ( ph /\ ps ) -> ch ) $=
      wph wps wch wph wps wph wch anabsi6.1 ancomsd anabsi5 $.
  $}

  ${
    anabsi7.1 $e |- ( ps -> ( ( ph /\ ps ) -> ch ) ) $.
    $( Absorption of antecedent into conjunction.  (Contributed by NM,
       20-Jul-1996.)  (Proof shortened by Wolf Lammen, 18-Nov-2013.) $)
    anabsi7 $p |- ( ( ph /\ ps ) -> ch ) $=
      wps wph wch wps wph wch anabsi7.1 anabsi6 ancoms $.
  $}

  ${
    anabsi8.1 $e |- ( ps -> ( ( ps /\ ph ) -> ch ) ) $.
    $( Absorption of antecedent into conjunction.  (Contributed by NM,
       26-Sep-1999.) $)
    anabsi8 $p |- ( ( ph /\ ps ) -> ch ) $=
      wps wph wch wps wph wch anabsi8.1 anabsi5 ancoms $.
  $}

  ${
    anabss7.1 $e |- ( ( ps /\ ( ph /\ ps ) ) -> ch ) $.
    $( Absorption of antecedent into conjunction.  (Contributed by NM,
       20-Jul-1996.)  (Proof shortened by Wolf Lammen, 19-Nov-2013.) $)
    anabss7 $p |- ( ( ph /\ ps ) -> ch ) $=
      wph wps wch wps wph wps wch anabss7.1 anassrs anabss4 $.
  $}

  ${
    anabsan2.1 $e |- ( ( ph /\ ( ps /\ ps ) ) -> ch ) $.
    $( Absorption of antecedent with conjunction.  (Contributed by NM,
       10-May-2004.) $)
    anabsan2 $p |- ( ( ph /\ ps ) -> ch ) $=
      wph wps wch wph wps wps wch anabsan2.1 an12s anabss7 $.
  $}

  ${
    anabss3.1 $e |- ( ( ( ph /\ ps ) /\ ps ) -> ch ) $.
    $( Absorption of antecedent into conjunction.  (Contributed by NM,
       20-Jul-1996.)  (Proof shortened by Wolf Lammen, 1-Jan-2013.) $)
    anabss3 $p |- ( ( ph /\ ps ) -> ch ) $=
      wph wps wch wph wps wps wch anabss3.1 anasss anabsan2 $.
  $}

  $( Distribution of conjunction over conjunction.  (Contributed by NM,
     14-Aug-1995.) $)
  anandi $p |- ( ( ph /\ ( ps /\ ch ) ) <->
               ( ( ph /\ ps ) /\ ( ph /\ ch ) ) ) $=
    wph wps wch wa wa wph wph wa wps wch wa wa wph wps wa wph wch wa wa wph wph
    wa wph wps wch wa wph anidm anbi1i wph wph wps wch an4 bitr3i $.

  $( Distribution of conjunction over conjunction.  (Contributed by NM,
     24-Aug-1995.) $)
  anandir $p |- ( ( ( ph /\ ps ) /\ ch ) <->
               ( ( ph /\ ch ) /\ ( ps /\ ch ) ) ) $=
    wph wps wa wch wa wph wps wa wch wch wa wa wph wch wa wps wch wa wa wch wch
    wa wch wph wps wa wch anidm anbi2i wph wps wch wch an4 bitr3i $.

  ${
    anandis.1 $e |- ( ( ( ph /\ ps ) /\ ( ph /\ ch ) ) -> ta ) $.
    $( Inference that undistributes conjunction in the antecedent.
       (Contributed by NM, 7-Jun-2004.) $)
    anandis $p |- ( ( ph /\ ( ps /\ ch ) ) -> ta ) $=
      wph wps wch wa wta wph wps wph wch wta anandis.1 an4s anabsan $.
  $}

  ${
    anandirs.1 $e |- ( ( ( ph /\ ch ) /\ ( ps /\ ch ) ) -> ta ) $.
    $( Inference that undistributes conjunction in the antecedent.
       (Contributed by NM, 7-Jun-2004.) $)
    anandirs $p |- ( ( ( ph /\ ps ) /\ ch ) -> ta ) $=
      wph wps wa wch wta wph wch wps wch wta anandirs.1 an4s anabsan2 $.
  $}

  ${
    sylanl1.1 $e |- ( ph -> ps ) $.
    sylanl1.2 $e |- ( ( ( ps /\ ch ) /\ th ) -> ta ) $.
    $( A syllogism inference.  (Contributed by NM, 10-Mar-2005.) $)
    sylanl1 $p |- ( ( ( ph /\ ch ) /\ th ) -> ta ) $=
      wph wch wa wps wch wa wth wta wph wps wch sylanl1.1 anim1i sylanl1.2
      sylan $.
  $}

  ${
    sylanl2.1 $e |- ( ph -> ch ) $.
    sylanl2.2 $e |- ( ( ( ps /\ ch ) /\ th ) -> ta ) $.
    $( A syllogism inference.  (Contributed by NM, 1-Jan-2005.) $)
    sylanl2 $p |- ( ( ( ps /\ ph ) /\ th ) -> ta ) $=
      wps wph wch wth wta wph wch wps sylanl2.1 adantl sylanl2.2 syldanl $.
  $}

  ${
    sylanr1.1 $e |- ( ph -> ch ) $.
    sylanr1.2 $e |- ( ( ps /\ ( ch /\ th ) ) -> ta ) $.
    $( A syllogism inference.  (Contributed by NM, 9-Apr-2005.) $)
    sylanr1 $p |- ( ( ps /\ ( ph /\ th ) ) -> ta ) $=
      wph wth wa wps wch wth wa wta wph wch wth sylanr1.1 anim1i sylanr1.2
      sylan2 $.
  $}

  ${
    sylanr2.1 $e |- ( ph -> th ) $.
    sylanr2.2 $e |- ( ( ps /\ ( ch /\ th ) ) -> ta ) $.
    $( A syllogism inference.  (Contributed by NM, 9-Apr-2005.) $)
    sylanr2 $p |- ( ( ps /\ ( ch /\ ph ) ) -> ta ) $=
      wch wph wa wps wch wth wa wta wph wth wch sylanr2.1 anim2i sylanr2.2
      sylan2 $.
  $}

  ${
    syl6an.1 $e |- ( ph -> ps ) $.
    syl6an.2 $e |- ( ph -> ( ch -> th ) ) $.
    syl6an.3 $e |- ( ( ps /\ th ) -> ta ) $.
    $( A syllogism deduction combined with conjoining antecedents.
       (Contributed by Alan Sare, 28-Oct-2011.) $)
    syl6an $p |- ( ph -> ( ch -> ta ) ) $=
      wph wps wch wth wta syl6an.1 syl6an.2 wps wth wta syl6an.3 ex sylsyld $.
  $}

  ${
    syl2an2r.1 $e |- ( ph -> ps ) $.
    syl2an2r.2 $e |- ( ( ph /\ ch ) -> th ) $.
    syl2an2r.3 $e |- ( ( ps /\ th ) -> ta ) $.
    $( ~ syl2anr with antecedents in standard conjunction form.  (Contributed
       by Alan Sare, 27-Aug-2016.)  (Proof shortened by Wolf Lammen,
       28-Mar-2022.) $)
    syl2an2r $p |- ( ( ph /\ ch ) -> ta ) $=
      wph wch wth wta syl2an2r.2 wph wps wth wta syl2an2r.1 syl2an2r.3 sylan
      syldan $.
  $}

  ${
    syl2an2.1 $e |- ( ph -> ps ) $.
    syl2an2.2 $e |- ( ( ch /\ ph ) -> th ) $.
    syl2an2.3 $e |- ( ( ps /\ th ) -> ta ) $.
    $( ~ syl2an with antecedents in standard conjunction form.  (Contributed by
       Alan Sare, 27-Aug-2016.) $)
    syl2an2 $p |- ( ( ch /\ ph ) -> ta ) $=
      wch wph wa wps wth wta wph wps wch syl2an2.1 adantl syl2an2.2 syl2an2.3
      syl2anc $.
  $}

  ${
    mpdan.1 $e |- ( ph -> ps ) $.
    mpdan.2 $e |- ( ( ph /\ ps ) -> ch ) $.
    $( An inference based on modus ponens.  (Contributed by NM, 23-May-1999.)
       (Proof shortened by Wolf Lammen, 22-Nov-2012.) $)
    mpdan $p |- ( ph -> ch ) $=
      wph wph wps wch wph id mpdan.1 mpdan.2 syl2anc $.
  $}

  ${
    mpancom.1 $e |- ( ps -> ph ) $.
    mpancom.2 $e |- ( ( ph /\ ps ) -> ch ) $.
    $( An inference based on modus ponens with commutation of antecedents.
       (Contributed by NM, 28-Oct-2003.)  (Proof shortened by Wolf Lammen,
       7-Apr-2013.) $)
    mpancom $p |- ( ps -> ch ) $=
      wps wph wps wch mpancom.1 wps id mpancom.2 syl2anc $.
  $}

  ${
    mpidan.1 $e |- ( ph -> ch ) $.
    mpidan.2 $e |- ( ( ( ph /\ ps ) /\ ch ) -> th ) $.
    $( A deduction which "stacks" a hypothesis.  (Contributed by Stanislas
       Polu, 9-Mar-2020.)  (Proof shortened by Wolf Lammen, 28-Mar-2021.) $)
    mpidan $p |- ( ( ph /\ ps ) -> th ) $=
      wph wps wa wch wth wph wch wps mpidan.1 adantr mpidan.2 mpdan $.
  $}

  ${
    mpan.1 $e |- ph $.
    mpan.2 $e |- ( ( ph /\ ps ) -> ch ) $.
    $( An inference based on modus ponens.  (Contributed by NM, 30-Aug-1993.)
       (Proof shortened by Wolf Lammen, 7-Apr-2013.) $)
    mpan $p |- ( ps -> ch ) $=
      wph wps wch wph wps mpan.1 a1i mpan.2 mpancom $.
  $}

  ${
    mpan2.1 $e |- ps $.
    mpan2.2 $e |- ( ( ph /\ ps ) -> ch ) $.
    $( An inference based on modus ponens.  (Contributed by NM, 16-Sep-1993.)
       (Proof shortened by Wolf Lammen, 19-Nov-2012.) $)
    mpan2 $p |- ( ph -> ch ) $=
      wph wps wch wps wph mpan2.1 a1i mpan2.2 mpdan $.
  $}

  ${
    mp2an.1 $e |- ph $.
    mp2an.2 $e |- ps $.
    mp2an.3 $e |- ( ( ph /\ ps ) -> ch ) $.
    $( An inference based on modus ponens.  (Contributed by NM,
       13-Apr-1995.) $)
    mp2an $p |- ch $=
      wps wch mp2an.2 wph wps wch mp2an.1 mp2an.3 mpan ax-mp $.
  $}

  ${
    mp4an.1 $e |- ph $.
    mp4an.2 $e |- ps $.
    mp4an.3 $e |- ch $.
    mp4an.4 $e |- th $.
    mp4an.5 $e |- ( ( ( ph /\ ps ) /\ ( ch /\ th ) ) -> ta ) $.
    $( An inference based on modus ponens.  (Contributed by Jeff Madsen,
       15-Jun-2010.) $)
    mp4an $p |- ta $=
      wph wps wa wch wth wa wta wph wps mp4an.1 mp4an.2 pm3.2i wch wth mp4an.3
      mp4an.4 pm3.2i mp4an.5 mp2an $.
  $}

  ${
    mpan2d.1 $e |- ( ph -> ch ) $.
    mpan2d.2 $e |- ( ph -> ( ( ps /\ ch ) -> th ) ) $.
    $( A deduction based on modus ponens.  (Contributed by NM, 12-Dec-2004.) $)
    mpan2d $p |- ( ph -> ( ps -> th ) ) $=
      wph wps wch wth mpan2d.1 wph wps wch wth mpan2d.2 expd mpid $.
  $}

  ${
    mpand.1 $e |- ( ph -> ps ) $.
    mpand.2 $e |- ( ph -> ( ( ps /\ ch ) -> th ) ) $.
    $( A deduction based on modus ponens.  (Contributed by NM, 12-Dec-2004.)
       (Proof shortened by Wolf Lammen, 7-Apr-2013.) $)
    mpand $p |- ( ph -> ( ch -> th ) ) $=
      wph wch wps wth mpand.1 wph wps wch wth mpand.2 ancomsd mpan2d $.
  $}

  ${
    mpani.1 $e |- ps $.
    mpani.2 $e |- ( ph -> ( ( ps /\ ch ) -> th ) ) $.
    $( An inference based on modus ponens.  (Contributed by NM, 10-Apr-1994.)
       (Proof shortened by Wolf Lammen, 19-Nov-2012.) $)
    mpani $p |- ( ph -> ( ch -> th ) ) $=
      wph wps wch wth wps wph mpani.1 a1i mpani.2 mpand $.
  $}

  ${
    mpan2i.1 $e |- ch $.
    mpan2i.2 $e |- ( ph -> ( ( ps /\ ch ) -> th ) ) $.
    $( An inference based on modus ponens.  (Contributed by NM, 10-Apr-1994.)
       (Proof shortened by Wolf Lammen, 19-Nov-2012.) $)
    mpan2i $p |- ( ph -> ( ps -> th ) ) $=
      wph wps wch wth wch wph mpan2i.1 a1i mpan2i.2 mpan2d $.
  $}

  ${
    mp2ani.1 $e |- ps $.
    mp2ani.2 $e |- ch $.
    mp2ani.3 $e |- ( ph -> ( ( ps /\ ch ) -> th ) ) $.
    $( An inference based on modus ponens.  (Contributed by NM,
       12-Dec-2004.) $)
    mp2ani $p |- ( ph -> th ) $=
      wph wch wth mp2ani.2 wph wps wch wth mp2ani.1 mp2ani.3 mpani mpi $.
  $}

  ${
    mp2and.1 $e |- ( ph -> ps ) $.
    mp2and.2 $e |- ( ph -> ch ) $.
    mp2and.3 $e |- ( ph -> ( ( ps /\ ch ) -> th ) ) $.
    $( A deduction based on modus ponens.  (Contributed by NM, 12-Dec-2004.) $)
    mp2and $p |- ( ph -> th ) $=
      wph wch wth mp2and.2 wph wps wch wth mp2and.1 mp2and.3 mpand mpd $.
  $}

  ${
    mpanl1.1 $e |- ph $.
    mpanl1.2 $e |- ( ( ( ph /\ ps ) /\ ch ) -> th ) $.
    $( An inference based on modus ponens.  (Contributed by NM, 16-Aug-1994.)
       (Proof shortened by Wolf Lammen, 7-Apr-2013.) $)
    mpanl1 $p |- ( ( ps /\ ch ) -> th ) $=
      wps wph wps wa wch wth wps wph mpanl1.1 jctl mpanl1.2 sylan $.
  $}

  ${
    mpanl2.1 $e |- ps $.
    mpanl2.2 $e |- ( ( ( ph /\ ps ) /\ ch ) -> th ) $.
    $( An inference based on modus ponens.  (Contributed by NM, 16-Aug-1994.)
       (Proof shortened by Andrew Salmon, 7-May-2011.) $)
    mpanl2 $p |- ( ( ph /\ ch ) -> th ) $=
      wph wph wps wa wch wth wph wps mpanl2.1 jctr mpanl2.2 sylan $.
  $}

  ${
    mpanl12.1 $e |- ph $.
    mpanl12.2 $e |- ps $.
    mpanl12.3 $e |- ( ( ( ph /\ ps ) /\ ch ) -> th ) $.
    $( An inference based on modus ponens.  (Contributed by NM,
       13-Jul-2005.) $)
    mpanl12 $p |- ( ch -> th ) $=
      wps wch wth mpanl12.2 wph wps wch wth mpanl12.1 mpanl12.3 mpanl1 mpan $.
  $}

  ${
    mpanr1.1 $e |- ps $.
    mpanr1.2 $e |- ( ( ph /\ ( ps /\ ch ) ) -> th ) $.
    $( An inference based on modus ponens.  (Contributed by NM, 3-May-1994.)
       (Proof shortened by Andrew Salmon, 7-May-2011.) $)
    mpanr1 $p |- ( ( ph /\ ch ) -> th ) $=
      wph wps wch wth mpanr1.1 wph wps wch wth mpanr1.2 anassrs mpanl2 $.
  $}

  ${
    mpanr2.1 $e |- ch $.
    mpanr2.2 $e |- ( ( ph /\ ( ps /\ ch ) ) -> th ) $.
    $( An inference based on modus ponens.  (Contributed by NM, 3-May-1994.)
       (Proof shortened by Andrew Salmon, 7-May-2011.)  (Proof shortened by
       Wolf Lammen, 7-Apr-2013.) $)
    mpanr2 $p |- ( ( ph /\ ps ) -> th ) $=
      wps wph wps wch wa wth wps wch mpanr2.1 jctr mpanr2.2 sylan2 $.
  $}

  ${
    mpanr12.1 $e |- ps $.
    mpanr12.2 $e |- ch $.
    mpanr12.3 $e |- ( ( ph /\ ( ps /\ ch ) ) -> th ) $.
    $( An inference based on modus ponens.  (Contributed by NM,
       24-Jul-2009.) $)
    mpanr12 $p |- ( ph -> th ) $=
      wph wch wth mpanr12.2 wph wps wch wth mpanr12.1 mpanr12.3 mpanr1 mpan2 $.
  $}

  ${
    mpanlr1.1 $e |- ps $.
    mpanlr1.2 $e |- ( ( ( ph /\ ( ps /\ ch ) ) /\ th ) -> ta ) $.
    $( An inference based on modus ponens.  (Contributed by NM, 30-Dec-2004.)
       (Proof shortened by Wolf Lammen, 7-Apr-2013.) $)
    mpanlr1 $p |- ( ( ( ph /\ ch ) /\ th ) -> ta ) $=
      wch wph wps wch wa wth wta wch wps mpanlr1.1 jctl mpanlr1.2 sylanl2 $.
  $}

  ${
    mpbirand.1 $e |- ( ph -> ch ) $.
    mpbirand.2 $e |- ( ph -> ( ps <-> ( ch /\ th ) ) ) $.
    $( Detach truth from conjunction in biconditional.  (Contributed by Glauco
       Siliprandi, 3-Mar-2021.) $)
    mpbirand $p |- ( ph -> ( ps <-> th ) ) $=
      wph wps wch wth wa wth mpbirand.2 wph wch wth mpbirand.1 biantrurd bitr4d
      $.
  $}

  ${
    mpbiran2d.1 $e |- ( ph -> th ) $.
    mpbiran2d.2 $e |- ( ph -> ( ps <-> ( ch /\ th ) ) ) $.
    $( Detach truth from conjunction in biconditional.  Deduction form.
       (Contributed by Peter Mazsa, 24-Sep-2022.) $)
    mpbiran2d $p |- ( ph -> ( ps <-> ch ) ) $=
      wph wps wth wch mpbiran2d.1 wph wps wth wch mpbiran2d.2 biancomd mpbirand
      $.
  $}

  ${
    mpbiran.1 $e |- ps $.
    mpbiran.2 $e |- ( ph <-> ( ps /\ ch ) ) $.
    $( Detach truth from conjunction in biconditional.  (Contributed by NM,
       27-Feb-1996.) $)
    mpbiran $p |- ( ph <-> ch ) $=
      wph wps wch wa wch mpbiran.2 wps wch mpbiran.1 biantrur bitr4i $.
  $}

  ${
    mpbiran2.1 $e |- ch $.
    mpbiran2.2 $e |- ( ph <-> ( ps /\ ch ) ) $.
    $( Detach truth from conjunction in biconditional.  (Contributed by NM,
       22-Feb-1996.) $)
    mpbiran2 $p |- ( ph <-> ps ) $=
      wph wch wps mpbiran2.1 wph wch wps mpbiran2.2 biancomi mpbiran $.
  $}

  ${
    mpbir2an.1 $e |- ps $.
    mpbir2an.2 $e |- ch $.
    mpbir2an.maj $e |- ( ph <-> ( ps /\ ch ) ) $.
    $( Detach a conjunction of truths in a biconditional.  (Contributed by NM,
       10-May-2005.) $)
    mpbir2an $p |- ph $=
      wph wch mpbir2an.2 wph wps wch mpbir2an.1 mpbir2an.maj mpbiran mpbir $.
  $}

  ${
    mpbi2and.1 $e |- ( ph -> ps ) $.
    mpbi2and.2 $e |- ( ph -> ch ) $.
    mpbi2and.3 $e |- ( ph -> ( ( ps /\ ch ) <-> th ) ) $.
    $( Detach a conjunction of truths in a biconditional.  (Contributed by NM,
       6-Nov-2011.)  (Proof shortened by Wolf Lammen, 24-Nov-2012.) $)
    mpbi2and $p |- ( ph -> th ) $=
      wph wps wch wa wth wph wps wch mpbi2and.1 mpbi2and.2 jca mpbi2and.3 mpbid
      $.
  $}

  ${
    mpbir2and.1 $e |- ( ph -> ch ) $.
    mpbir2and.2 $e |- ( ph -> th ) $.
    mpbir2and.3 $e |- ( ph -> ( ps <-> ( ch /\ th ) ) ) $.
    $( Detach a conjunction of truths in a biconditional.  (Contributed by NM,
       6-Nov-2011.)  (Proof shortened by Wolf Lammen, 24-Nov-2012.) $)
    mpbir2and $p |- ( ph -> ps ) $=
      wph wps wch wth wa wph wch wth mpbir2and.1 mpbir2and.2 jca mpbir2and.3
      mpbird $.
  $}

  ${
    adant2.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       4-May-1994.)  (Proof shortened by Wolf Lammen, 24-Nov-2012.) $)
    adantll $p |- ( ( ( th /\ ph ) /\ ps ) -> ch ) $=
      wth wph wa wph wps wch wth wph simpr adant2.1 sylan $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       4-May-1994.)  (Proof shortened by Wolf Lammen, 24-Nov-2012.) $)
    adantlr $p |- ( ( ( ph /\ th ) /\ ps ) -> ch ) $=
      wph wth wa wph wps wch wph wth simpl adant2.1 sylan $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       4-May-1994.)  (Proof shortened by Wolf Lammen, 24-Nov-2012.) $)
    adantrl $p |- ( ( ph /\ ( th /\ ps ) ) -> ch ) $=
      wth wps wa wph wps wch wth wps simpr adant2.1 sylan2 $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       4-May-1994.)  (Proof shortened by Wolf Lammen, 24-Nov-2012.) $)
    adantrr $p |- ( ( ph /\ ( ps /\ th ) ) -> ch ) $=
      wps wth wa wph wps wch wps wth simpl adant2.1 sylan2 $.
  $}

  ${
    adantl2.1 $e |- ( ( ( ph /\ ps ) /\ ch ) -> th ) $.
    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       26-Dec-2004.)  (Proof shortened by Wolf Lammen, 2-Dec-2012.) $)
    adantlll $p |- ( ( ( ( ta /\ ph ) /\ ps ) /\ ch ) -> th ) $=
      wta wph wa wph wps wch wth wta wph simpr adantl2.1 sylanl1 $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       26-Dec-2004.)  (Proof shortened by Wolf Lammen, 4-Dec-2012.) $)
    adantllr $p |- ( ( ( ( ph /\ ta ) /\ ps ) /\ ch ) -> th ) $=
      wph wta wa wph wps wch wth wph wta simpl adantl2.1 sylanl1 $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       26-Dec-2004.)  (Proof shortened by Wolf Lammen, 4-Dec-2012.) $)
    adantlrl $p |- ( ( ( ph /\ ( ta /\ ps ) ) /\ ch ) -> th ) $=
      wta wps wa wph wps wch wth wta wps simpr adantl2.1 sylanl2 $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       26-Dec-2004.)  (Proof shortened by Wolf Lammen, 4-Dec-2012.) $)
    adantlrr $p |- ( ( ( ph /\ ( ps /\ ta ) ) /\ ch ) -> th ) $=
      wps wta wa wph wps wch wth wps wta simpl adantl2.1 sylanl2 $.
  $}

  ${
    adantr2.1 $e |- ( ( ph /\ ( ps /\ ch ) ) -> th ) $.
    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       26-Dec-2004.)  (Proof shortened by Wolf Lammen, 4-Dec-2012.) $)
    adantrll $p |- ( ( ph /\ ( ( ta /\ ps ) /\ ch ) ) -> th ) $=
      wta wps wa wph wps wch wth wta wps simpr adantr2.1 sylanr1 $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       26-Dec-2004.)  (Proof shortened by Wolf Lammen, 4-Dec-2012.) $)
    adantrlr $p |- ( ( ph /\ ( ( ps /\ ta ) /\ ch ) ) -> th ) $=
      wps wta wa wph wps wch wth wps wta simpl adantr2.1 sylanr1 $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       26-Dec-2004.)  (Proof shortened by Wolf Lammen, 4-Dec-2012.) $)
    adantrrl $p |- ( ( ph /\ ( ps /\ ( ta /\ ch ) ) ) -> th ) $=
      wta wch wa wph wps wch wth wta wch simpr adantr2.1 sylanr2 $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       26-Dec-2004.)  (Proof shortened by Wolf Lammen, 4-Dec-2012.) $)
    adantrrr $p |- ( ( ph /\ ( ps /\ ( ch /\ ta ) ) ) -> th ) $=
      wch wta wa wph wps wch wth wch wta simpl adantr2.1 sylanr2 $.
  $}

  ${
    ad2ant.1 $e |- ( ph -> ps ) $.
    $( Deduction adding two conjuncts to antecedent.  (Contributed by NM,
       19-Oct-1999.)  (Proof shortened by Wolf Lammen, 20-Nov-2012.) $)
    ad2antrr $p |- ( ( ( ph /\ ch ) /\ th ) -> ps ) $=
      wph wth wps wch wph wps wth ad2ant.1 adantr adantlr $.

    $( Deduction adding two conjuncts to antecedent.  (Contributed by NM,
       19-Oct-1999.)  (Proof shortened by Wolf Lammen, 20-Nov-2012.) $)
    ad2antlr $p |- ( ( ( ch /\ ph ) /\ th ) -> ps ) $=
      wph wth wps wch wph wps wth ad2ant.1 adantr adantll $.

    $( Deduction adding two conjuncts to antecedent.  (Contributed by NM,
       19-Oct-1999.) $)
    ad2antrl $p |- ( ( ch /\ ( ph /\ th ) ) -> ps ) $=
      wch wph wps wth wph wps wch ad2ant.1 adantl adantrr $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by NM,
       19-Oct-1999.) $)
    ad2antll $p |- ( ( ch /\ ( th /\ ph ) ) -> ps ) $=
      wth wph wa wps wch wph wps wth ad2ant.1 adantl adantl $.

    $( Deduction adding three conjuncts to antecedent.  (Contributed by NM,
       28-Jul-2012.) $)
    ad3antrrr $p |- ( ( ( ( ph /\ ch ) /\ th ) /\ ta ) -> ps ) $=
      wph wch wa wps wth wta wph wps wch ad2ant.1 adantr ad2antrr $.

    $( Deduction adding three conjuncts to antecedent.  (Contributed by Mario
       Carneiro, 5-Jan-2017.)  (Proof shortened by Wolf Lammen, 5-Apr-2022.) $)
    ad3antlr $p |- ( ( ( ( ch /\ ph ) /\ th ) /\ ta ) -> ps ) $=
      wch wph wa wps wth wta wph wps wch ad2ant.1 adantl ad2antrr $.

    $( Deduction adding 4 conjuncts to antecedent.  (Contributed by Mario
       Carneiro, 4-Jan-2017.)  (Proof shortened by Wolf Lammen, 5-Apr-2022.) $)
    ad4antr $p |- ( ( ( ( ( ph /\ ch ) /\ th ) /\ ta ) /\ et ) -> ps ) $=
      wph wch wa wps wth wta wet wph wps wch ad2ant.1 adantr ad3antrrr $.

    $( Deduction adding 4 conjuncts to antecedent.  (Contributed by Mario
       Carneiro, 5-Jan-2017.)  (Proof shortened by Wolf Lammen, 5-Apr-2022.) $)
    ad4antlr $p |- ( ( ( ( ( ch /\ ph ) /\ th ) /\ ta ) /\ et ) -> ps ) $=
      wch wph wa wps wth wta wet wph wps wch ad2ant.1 adantl ad3antrrr $.

    $( Deduction adding 5 conjuncts to antecedent.  (Contributed by Mario
       Carneiro, 4-Jan-2017.)  (Proof shortened by Wolf Lammen, 5-Apr-2022.) $)
    ad5antr $p |- ( ( ( ( ( ( ph /\ ch ) /\ th ) /\ ta ) /\ et )
      /\ ze ) -> ps ) $=
      wph wch wa wps wth wta wet wze wph wps wch ad2ant.1 adantr ad4antr $.

    $( Deduction adding 5 conjuncts to antecedent.  (Contributed by Mario
       Carneiro, 5-Jan-2017.)  (Proof shortened by Wolf Lammen, 5-Apr-2022.) $)
    ad5antlr $p |- ( ( ( ( ( ( ch /\ ph ) /\ th ) /\ ta ) /\ et )
      /\ ze ) -> ps ) $=
      wch wph wa wps wth wta wet wze wph wps wch ad2ant.1 adantl ad4antr $.

    $( Deduction adding 6 conjuncts to antecedent.  (Contributed by Mario
       Carneiro, 4-Jan-2017.)  (Proof shortened by Wolf Lammen, 5-Apr-2022.) $)
    ad6antr $p |- ( ( ( ( ( ( ( ph /\ ch ) /\ th ) /\ ta ) /\ et )
      /\ ze ) /\ si ) -> ps ) $=
      wph wch wa wps wth wta wet wze wsi wph wps wch ad2ant.1 adantr ad5antr $.

    $( Deduction adding 6 conjuncts to antecedent.  (Contributed by Mario
       Carneiro, 5-Jan-2017.)  (Proof shortened by Wolf Lammen, 5-Apr-2022.) $)
    ad6antlr $p |- ( ( ( ( ( ( ( ch /\ ph ) /\ th ) /\ ta ) /\ et )
      /\ ze ) /\ si ) -> ps ) $=
      wch wph wa wps wth wta wet wze wsi wph wps wch ad2ant.1 adantl ad5antr $.

    $( Deduction adding 7 conjuncts to antecedent.  (Contributed by Mario
       Carneiro, 4-Jan-2017.)  (Proof shortened by Wolf Lammen, 5-Apr-2022.) $)
    ad7antr $p |- ( ( ( ( ( ( ( ( ph /\ ch ) /\ th ) /\ ta ) /\ et )
      /\ ze ) /\ si ) /\ rh ) -> ps ) $=
      wph wch wa wps wth wta wet wze wsi wrh wph wps wch ad2ant.1 adantr
      ad6antr $.

    $( Deduction adding 7 conjuncts to antecedent.  (Contributed by Mario
       Carneiro, 5-Jan-2017.)  (Proof shortened by Wolf Lammen, 5-Apr-2022.) $)
    ad7antlr $p |- ( ( ( ( ( ( ( ( ch /\ ph ) /\ th ) /\ ta ) /\ et )
      /\ ze ) /\ si ) /\ rh ) -> ps ) $=
      wch wph wa wps wth wta wet wze wsi wrh wph wps wch ad2ant.1 adantl
      ad6antr $.

    $( Deduction adding 8 conjuncts to antecedent.  (Contributed by Mario
       Carneiro, 4-Jan-2017.)  (Proof shortened by Wolf Lammen, 5-Apr-2022.) $)
    ad8antr $p |- ( ( ( ( ( ( ( ( ( ph /\ ch ) /\ th ) /\ ta ) /\ et )
      /\ ze ) /\ si ) /\ rh ) /\ mu ) -> ps ) $=
      wph wch wa wps wth wta wet wze wsi wrh wmu wph wps wch ad2ant.1 adantr
      ad7antr $.

    $( Deduction adding 8 conjuncts to antecedent.  (Contributed by Mario
       Carneiro, 5-Jan-2017.)  (Proof shortened by Wolf Lammen, 5-Apr-2022.) $)
    ad8antlr $p |- ( ( ( ( ( ( ( ( ( ch /\ ph ) /\ th ) /\ ta ) /\ et )
      /\ ze ) /\ si ) /\ rh ) /\ mu ) -> ps ) $=
      wch wph wa wps wth wta wet wze wsi wrh wmu wph wps wch ad2ant.1 adantl
      ad7antr $.

    $( Deduction adding 9 conjuncts to antecedent.  (Contributed by Mario
       Carneiro, 4-Jan-2017.)  (Proof shortened by Wolf Lammen, 5-Apr-2022.) $)
    ad9antr $p |- ( ( ( ( ( ( ( ( ( ( ph /\ ch ) /\ th ) /\ ta ) /\ et )
      /\ ze ) /\ si ) /\ rh ) /\ mu ) /\ la ) -> ps ) $=
      wph wch wa wps wth wta wet wze wsi wrh wmu wla wph wps wch ad2ant.1
      adantr ad8antr $.

    $( Deduction adding 9 conjuncts to antecedent.  (Contributed by Mario
       Carneiro, 5-Jan-2017.)  (Proof shortened by Wolf Lammen, 5-Apr-2022.) $)
    ad9antlr $p |- ( ( ( ( ( ( ( ( ( ( ch /\ ph ) /\ th ) /\ ta ) /\ et )
      /\ ze ) /\ si ) /\ rh ) /\ mu ) /\ la ) -> ps ) $=
      wch wph wa wps wth wta wet wze wsi wrh wmu wla wph wps wch ad2ant.1
      adantl ad8antr $.

    $( Deduction adding 10 conjuncts to antecedent.  (Contributed by Mario
       Carneiro, 4-Jan-2017.)  (Proof shortened by Wolf Lammen, 5-Apr-2022.) $)
    ad10antr $p |- ( ( ( ( ( ( ( ( ( ( ( ph /\ ch ) /\ th ) /\ ta ) /\ et )
      /\ ze ) /\ si ) /\ rh ) /\ mu ) /\ la ) /\ ka ) -> ps ) $=
      wph wch wa wps wth wta wet wze wsi wrh wmu wla wka wph wps wch ad2ant.1
      adantr ad9antr $.

    $( Deduction adding 10 conjuncts to antecedent.  (Contributed by Mario
       Carneiro, 5-Jan-2017.)  (Proof shortened by Wolf Lammen, 5-Apr-2022.) $)
    ad10antlr $p |- ( ( ( ( ( ( ( ( ( ( ( ch /\ ph ) /\ th ) /\ ta ) /\ et )
      /\ ze ) /\ si ) /\ rh ) /\ mu ) /\ la ) /\ ka ) -> ps ) $=
      wch wph wa wps wth wta wet wze wsi wrh wmu wla wka wph wps wch ad2ant.1
      adantl ad9antr $.
  $}

  ${
    ad2ant2.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    $( Deduction adding two conjuncts to antecedent.  (Contributed by NM,
       8-Jan-2006.) $)
    ad2ant2l $p |- ( ( ( th /\ ph ) /\ ( ta /\ ps ) ) -> ch ) $=
      wph wta wps wa wch wth wph wps wch wta ad2ant2.1 adantrl adantll $.

    $( Deduction adding two conjuncts to antecedent.  (Contributed by NM,
       8-Jan-2006.) $)
    ad2ant2r $p |- ( ( ( ph /\ th ) /\ ( ps /\ ta ) ) -> ch ) $=
      wph wps wta wa wch wth wph wps wch wta ad2ant2.1 adantrr adantlr $.

    $( Deduction adding two conjuncts to antecedent.  (Contributed by NM,
       23-Nov-2007.) $)
    ad2ant2lr $p |- ( ( ( th /\ ph ) /\ ( ps /\ ta ) ) -> ch ) $=
      wph wps wta wa wch wth wph wps wch wta ad2ant2.1 adantrr adantll $.

    $( Deduction adding two conjuncts to antecedent.  (Contributed by NM,
       24-Nov-2007.) $)
    ad2ant2rl $p |- ( ( ( ph /\ th ) /\ ( ta /\ ps ) ) -> ch ) $=
      wph wta wps wa wch wth wph wps wch wta ad2ant2.1 adantrl adantlr $.
  $}

  ${
    adantl3r.1 $e |- ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) -> ta ) $.
    $( Deduction adding 1 conjunct to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.) $)
    adantl3r $p |- ( ( ( ( ( ph /\ et ) /\ ps ) /\ ch ) /\ th ) -> ta ) $=
      wph wet wa wps wa wph wps wa wch wth wta wph wps wph wps wa wet wph wps
      wa id adantlr adantl3r.1 sylanl1 $.
  $}

  ${
    ad4ant2.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 14-Apr-2022.) $)
    ad4ant13 $p |- ( ( ( ( ph /\ th ) /\ ps ) /\ ta ) -> ch ) $=
      wph wps wta wch wth wph wps wa wch wta ad4ant2.1 adantr adantllr $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 14-Apr-2022.) $)
    ad4ant14 $p |- ( ( ( ( ph /\ th ) /\ ta ) /\ ps ) -> ch ) $=
      wph wth wa wps wch wta wph wps wch wth ad4ant2.1 adantlr adantlr $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 14-Apr-2022.) $)
    ad4ant23 $p |- ( ( ( ( th /\ ph ) /\ ps ) /\ ta ) -> ch ) $=
      wph wps wta wch wth wph wps wa wch wta ad4ant2.1 adantr adantlll $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 14-Apr-2022.) $)
    ad4ant24 $p |- ( ( ( ( th /\ ph ) /\ ta ) /\ ps ) -> ch ) $=
      wph wta wps wch wth wph wps wch wta ad4ant2.1 adantlr adantlll $.
  $}

  ${
    adantl4r.1 $e |- ( ( ( ( ( ph /\ si ) /\ rh ) /\ mu ) /\ la ) -> ka ) $.
    $( Deduction adding 1 conjunct to antecedent.  (Contributed by Thierry
       Arnoux, 11-Feb-2018.) $)
    adantl4r $p |- ( ( ( ( ( ( ph /\ ze ) /\ si ) /\ rh ) /\ mu ) /\ la )
      -> ka ) $=
      wph wze wa wsi wa wrh wa wmu wa wla wka wph wsi wrh wmu wla wka wi wze
      wph wsi wa wrh wa wmu wa wla wka adantl4r.1 ex adantl3r imp $.
  $}

  ${
    ad5ant2.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 14-Apr-2022.) $)
    ad5ant13 $p |- ( ( ( ( ( ph /\ th ) /\ ps ) /\ ta ) /\ et ) -> ch ) $=
      wph wth wa wps wa wch wta wet wph wps wch wth ad5ant2.1 adantlr ad2antrr
      $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 14-Apr-2022.) $)
    ad5ant14 $p |- ( ( ( ( ( ph /\ th ) /\ ta ) /\ ps ) /\ et ) -> ch ) $=
      wph wth wa wps wch wta wet wph wps wch wth ad5ant2.1 adantlr ad4ant13 $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 14-Apr-2022.) $)
    ad5ant15 $p |- ( ( ( ( ( ph /\ th ) /\ ta ) /\ et ) /\ ps ) -> ch ) $=
      wph wth wa wps wch wta wet wph wps wch wth ad5ant2.1 adantlr ad4ant14 $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 14-Apr-2022.) $)
    ad5ant23 $p |- ( ( ( ( ( th /\ ph ) /\ ps ) /\ ta ) /\ et ) -> ch ) $=
      wth wph wa wps wa wch wta wet wph wps wch wth ad5ant2.1 adantll ad2antrr
      $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 14-Apr-2022.) $)
    ad5ant24 $p |- ( ( ( ( ( th /\ ph ) /\ ta ) /\ ps ) /\ et ) -> ch ) $=
      wth wph wa wps wch wta wet wph wps wch wth ad5ant2.1 adantll ad4ant13 $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 14-Apr-2022.) $)
    ad5ant25 $p |- ( ( ( ( ( th /\ ph ) /\ ta ) /\ et ) /\ ps ) -> ch ) $=
      wth wph wa wps wch wta wet wph wps wch wth ad5ant2.1 adantll ad4ant14 $.
  $}

  ${
    adantl5r.1 $e |- ( ( ( ( ( ( ph /\ ze ) /\ si ) /\ rh ) /\ mu ) /\ la )
      -> ka ) $.
    $( Deduction adding 1 conjunct to antecedent.  (Contributed by Thierry
       Arnoux, 11-Feb-2018.) $)
    adantl5r $p |- ( ( ( ( ( ( ( ph /\ et ) /\ ze ) /\ si ) /\ rh ) /\ mu )
      /\ la ) -> ka ) $=
      wph wet wa wze wa wsi wa wrh wa wmu wa wla wka wph wet wze wsi wrh wmu
      wla wka wi wph wze wa wsi wa wrh wa wmu wa wla wka adantl5r.1 ex adantl4r
      imp $.
  $}

  ${
    adantl6r.1 $e |- ( ( ( ( ( ( ( ph /\ et ) /\ ze ) /\ si ) /\ rh ) /\ mu )
      /\ la ) -> ka ) $.
    $( Deduction adding 1 conjunct to antecedent.  (Contributed by Thierry
       Arnoux, 11-Feb-2018.) $)
    adantl6r $p |- ( ( ( ( ( ( ( ( ph /\ ta ) /\ et ) /\ ze ) /\ si ) /\ rh )
      /\ mu ) /\ la ) -> ka ) $=
      wph wta wa wet wa wze wa wsi wa wrh wa wmu wa wla wka wph wta wet wze wsi
      wrh wmu wla wka wi wph wet wa wze wa wsi wa wrh wa wmu wa wla wka
      adantl6r.1 ex adantl5r imp $.
  $}

  $( Theorem *3.33 (Syll) of [WhiteheadRussell] p. 112.  (Contributed by NM,
     3-Jan-2005.) $)
  pm3.33 $p |- ( ( ( ph -> ps ) /\ ( ps -> ch ) ) -> ( ph -> ch ) ) $=
    wph wps wi wps wch wi wph wch wi wph wps wch imim1 imp $.

  $( Theorem *3.34 (Syll) of [WhiteheadRussell] p. 112.  (Contributed by NM,
     3-Jan-2005.) $)
  pm3.34 $p |- ( ( ( ps -> ch ) /\ ( ph -> ps ) ) -> ( ph -> ch ) ) $=
    wps wch wi wph wps wi wph wch wi wps wch wph imim2 imp $.

  $( Simplification of a conjunction.  (Contributed by NM, 18-Mar-2007.) $)
  simpll $p |- ( ( ( ph /\ ps ) /\ ch ) -> ph ) $=
    wph wph wps wch wph id ad2antrr $.

  ${
    simplld.1 $e |- ( ph -> ( ( ps /\ ch ) /\ th ) ) $.
    $( Deduction form of ~ simpll , eliminating a double conjunct.
       (Contributed by Glauco Siliprandi, 11-Dec-2019.) $)
    simplld $p |- ( ph -> ps ) $=
      wph wps wch wph wps wch wa wth simplld.1 simpld simpld $.
  $}

  $( Simplification of a conjunction.  (Contributed by NM, 20-Mar-2007.) $)
  simplr $p |- ( ( ( ph /\ ps ) /\ ch ) -> ps ) $=
    wps wps wph wch wps id ad2antlr $.

  ${
    simplrd.1 $e |- ( ph -> ( ( ps /\ ch ) /\ th ) ) $.
    $( Deduction eliminating a double conjunct.  (Contributed by Glauco
       Siliprandi, 11-Dec-2019.) $)
    simplrd $p |- ( ph -> ch ) $=
      wph wps wch wph wps wch wa wth simplrd.1 simpld simprd $.
  $}

  $( Simplification of a conjunction.  (Contributed by NM, 21-Mar-2007.) $)
  simprl $p |- ( ( ph /\ ( ps /\ ch ) ) -> ps ) $=
    wps wps wph wch wps id ad2antrl $.

  ${
    simprld.1 $e |- ( ph -> ( ps /\ ( ch /\ th ) ) ) $.
    $( Deduction eliminating a double conjunct.  (Contributed by Glauco
       Siliprandi, 11-Dec-2019.) $)
    simprld $p |- ( ph -> ch ) $=
      wph wch wth wph wps wch wth wa simprld.1 simprd simpld $.
  $}

  $( Simplification of a conjunction.  (Contributed by NM, 21-Mar-2007.) $)
  simprr $p |- ( ( ph /\ ( ps /\ ch ) ) -> ch ) $=
    wch wch wph wps wch id ad2antll $.

  ${
    simprrd.1 $e |- ( ph -> ( ps /\ ( ch /\ th ) ) ) $.
    $( Deduction form of ~ simprr , eliminating a double conjunct.
       (Contributed by Glauco Siliprandi, 11-Dec-2019.) $)
    simprrd $p |- ( ph -> th ) $=
      wph wch wth wph wps wch wth wa simprrd.1 simprd simprd $.
  $}

  $( Simplification of a conjunction.  (Contributed by Jeff Hankins,
     28-Jul-2009.)  (Proof shortened by Wolf Lammen, 6-Apr-2022.) $)
  simplll $p |- ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) -> ph ) $=
    wph wph wps wch wth wph id ad3antrrr $.

  $( Simplification of a conjunction.  (Contributed by Jeff Hankins,
     28-Jul-2009.)  (Proof shortened by Wolf Lammen, 6-Apr-2022.) $)
  simpllr $p |- ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) -> ps ) $=
    wps wps wph wch wth wps id ad3antlr $.

  $( Simplification of a conjunction.  (Contributed by Jeff Hankins,
     28-Jul-2009.) $)
  simplrl $p |- ( ( ( ph /\ ( ps /\ ch ) ) /\ th ) -> ps ) $=
    wps wch wa wps wph wth wps wch simpl ad2antlr $.

  $( Simplification of a conjunction.  (Contributed by Jeff Hankins,
     28-Jul-2009.) $)
  simplrr $p |- ( ( ( ph /\ ( ps /\ ch ) ) /\ th ) -> ch ) $=
    wps wch wa wch wph wth wps wch simpr ad2antlr $.

  $( Simplification of a conjunction.  (Contributed by Jeff Hankins,
     28-Jul-2009.) $)
  simprll $p |- ( ( ph /\ ( ( ps /\ ch ) /\ th ) ) -> ps ) $=
    wps wch wa wps wph wth wps wch simpl ad2antrl $.

  $( Simplification of a conjunction.  (Contributed by Jeff Hankins,
     28-Jul-2009.) $)
  simprlr $p |- ( ( ph /\ ( ( ps /\ ch ) /\ th ) ) -> ch ) $=
    wps wch wa wch wph wth wps wch simpr ad2antrl $.

  $( Simplification of a conjunction.  (Contributed by Jeff Hankins,
     28-Jul-2009.) $)
  simprrl $p |- ( ( ph /\ ( ps /\ ( ch /\ th ) ) ) -> ch ) $=
    wch wth wa wch wph wps wch wth simpl ad2antll $.

  $( Simplification of a conjunction.  (Contributed by Jeff Hankins,
     28-Jul-2009.) $)
  simprrr $p |- ( ( ph /\ ( ps /\ ( ch /\ th ) ) ) -> th ) $=
    wch wth wa wth wph wps wch wth simpr ad2antll $.

  $( Simplification of a conjunction.  (Contributed by Mario Carneiro,
     4-Jan-2017.)  (Proof shortened by Wolf Lammen, 24-May-2022.) $)
  simp-4l $p |- ( ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) /\ ta ) -> ph ) $=
    wph wph wps wch wth wta wph id ad4antr $.

  $( Simplification of a conjunction.  (Contributed by Mario Carneiro,
     4-Jan-2017.)  (Proof shortened by Wolf Lammen, 24-May-2022.) $)
  simp-4r $p |- ( ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) /\ ta ) -> ps ) $=
    wps wps wph wch wth wta wps id ad4antlr $.

  $( Simplification of a conjunction.  (Contributed by Mario Carneiro,
     4-Jan-2017.)  (Proof shortened by Wolf Lammen, 24-May-2022.) $)
  simp-5l $p |- ( ( ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) /\ ta )
    /\ et ) -> ph ) $=
    wph wph wps wch wth wta wet wph id ad5antr $.

  $( Simplification of a conjunction.  (Contributed by Mario Carneiro,
     4-Jan-2017.)  (Proof shortened by Wolf Lammen, 24-May-2022.) $)
  simp-5r $p |- ( ( ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) /\ ta )
    /\ et ) -> ps ) $=
    wps wps wph wch wth wta wet wps id ad5antlr $.

  $( Simplification of a conjunction.  (Contributed by Mario Carneiro,
     4-Jan-2017.)  (Proof shortened by Wolf Lammen, 24-May-2022.) $)
  simp-6l $p |- ( ( ( ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) /\ ta )
    /\ et ) /\ ze ) -> ph ) $=
    wph wph wps wch wth wta wet wze wph id ad6antr $.

  $( Simplification of a conjunction.  (Contributed by Mario Carneiro,
     4-Jan-2017.)  (Proof shortened by Wolf Lammen, 24-May-2022.) $)
  simp-6r $p |- ( ( ( ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) /\ ta )
    /\ et ) /\ ze ) -> ps ) $=
    wps wps wph wch wth wta wet wze wps id ad6antlr $.

  $( Simplification of a conjunction.  (Contributed by Mario Carneiro,
     4-Jan-2017.)  (Proof shortened by Wolf Lammen, 24-May-2022.) $)
  simp-7l $p |- ( ( ( ( ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) /\ ta )
    /\ et ) /\ ze ) /\ si ) -> ph ) $=
    wph wph wps wch wth wta wet wze wsi wph id ad7antr $.

  $( Simplification of a conjunction.  (Contributed by Mario Carneiro,
     4-Jan-2017.)  (Proof shortened by Wolf Lammen, 24-May-2022.) $)
  simp-7r $p |- ( ( ( ( ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) /\ ta )
    /\ et ) /\ ze ) /\ si ) -> ps ) $=
    wps wps wph wch wth wta wet wze wsi wps id ad7antlr $.

  $( Simplification of a conjunction.  (Contributed by Mario Carneiro,
     4-Jan-2017.)  (Proof shortened by Wolf Lammen, 24-May-2022.) $)
  simp-8l $p |- ( ( ( ( ( ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) /\ ta )
    /\ et ) /\ ze ) /\ si ) /\ rh ) -> ph ) $=
    wph wph wps wch wth wta wet wze wsi wrh wph id ad8antr $.

  $( Simplification of a conjunction.  (Contributed by Mario Carneiro,
     4-Jan-2017.)  (Proof shortened by Wolf Lammen, 24-May-2022.) $)
  simp-8r $p |- ( ( ( ( ( ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) /\ ta )
    /\ et ) /\ ze ) /\ si ) /\ rh ) -> ps ) $=
    wps wps wph wch wth wta wet wze wsi wrh wps id ad8antlr $.

  $( Simplification of a conjunction.  (Contributed by Mario Carneiro,
     4-Jan-2017.)  (Proof shortened by Wolf Lammen, 24-May-2022.) $)
  simp-9l $p |- ( ( ( ( ( ( ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) /\ ta )
    /\ et ) /\ ze ) /\ si ) /\ rh ) /\ mu ) -> ph ) $=
    wph wph wps wch wth wta wet wze wsi wrh wmu wph id ad9antr $.

  $( Simplification of a conjunction.  (Contributed by Mario Carneiro,
     4-Jan-2017.)  (Proof shortened by Wolf Lammen, 24-May-2022.) $)
  simp-9r $p |- ( ( ( ( ( ( ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) /\ ta )
    /\ et ) /\ ze ) /\ si ) /\ rh ) /\ mu ) -> ps ) $=
    wps wps wph wch wth wta wet wze wsi wrh wmu wps id ad9antlr $.

  $( Simplification of a conjunction.  (Contributed by Mario Carneiro,
     4-Jan-2017.)  (Proof shortened by Wolf Lammen, 24-May-2022.) $)
  simp-10l $p |- ( ( ( ( ( ( ( ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) /\ ta )
    /\ et ) /\ ze ) /\ si ) /\ rh ) /\ mu ) /\ la ) -> ph ) $=
    wph wph wps wch wth wta wet wze wsi wrh wmu wla wph id ad10antr $.

  $( Simplification of a conjunction.  (Contributed by Mario Carneiro,
     4-Jan-2017.)  (Proof shortened by Wolf Lammen, 24-May-2022.) $)
  simp-10r $p |- ( ( ( ( ( ( ( ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) /\ ta )
    /\ et ) /\ ze ) /\ si ) /\ rh ) /\ mu ) /\ la ) -> ps ) $=
    wps wps wph wch wth wta wet wze wsi wrh wmu wla wps id ad10antlr $.

  $( Simplification of a conjunction.  (Contributed by Mario Carneiro,
     4-Jan-2017.)  (Proof shortened by Wolf Lammen, 24-May-2022.) $)
  simp-11l $p |- ( ( ( ( ( ( ( ( ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) /\ ta )
    /\ et ) /\ ze ) /\ si ) /\ rh ) /\ mu ) /\ la ) /\ ka ) -> ph ) $=
    wph wps wa wph wch wth wta wet wze wsi wrh wmu wla wka wph wps simpl
    ad10antr $.

  $( Simplification of a conjunction.  (Contributed by Mario Carneiro,
     4-Jan-2017.)  (Proof shortened by Wolf Lammen, 24-May-2022.) $)
  simp-11r $p |- ( ( ( ( ( ( ( ( ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) /\ ta )
    /\ et ) /\ ze ) /\ si ) /\ rh ) /\ mu ) /\ la ) /\ ka ) -> ps ) $=
    wph wps wa wps wch wth wta wet wze wsi wrh wmu wla wka wph wps simpr
    ad10antr $.

$( Restating theorems using conjunction. $)

  ${
    pm2.01da.1 $e |- ( ( ph /\ ps ) -> -. ps ) $.
    $( Deduction based on reductio ad absurdum.  See ~ pm2.01 .  (Contributed
       by Mario Carneiro, 9-Feb-2017.) $)
    pm2.01da $p |- ( ph -> -. ps ) $=
      wph wps wph wps wps wn pm2.01da.1 ex pm2.01d $.
  $}

  ${
    pm2.18da.1 $e |- ( ( ph /\ -. ps ) -> ps ) $.
    $( Deduction based on reductio ad absurdum.  See ~ pm2.18 .  (Contributed
       by Mario Carneiro, 9-Feb-2017.) $)
    pm2.18da $p |- ( ph -> ps ) $=
      wph wps wph wps wn wps pm2.18da.1 ex pm2.18d $.
  $}

  ${
    impbida.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    impbida.2 $e |- ( ( ph /\ ch ) -> ps ) $.
    $( Deduce an equivalence from two implications.  Variant of ~ impbid .
       (Contributed by NM, 17-Feb-2007.) $)
    impbida $p |- ( ph -> ( ps <-> ch ) ) $=
      wph wps wch wph wps wch impbida.1 ex wph wch wps impbida.2 ex impbid $.
  $}

  ${
    pm5.21nd.1 $e |- ( ( ph /\ ps ) -> th ) $.
    pm5.21nd.2 $e |- ( ( ph /\ ch ) -> th ) $.
    pm5.21nd.3 $e |- ( th -> ( ps <-> ch ) ) $.
    $( Eliminate an antecedent implied by each side of a biconditional.
       Variant of ~ pm5.21ndd .  (Contributed by NM, 20-Nov-2005.)  (Proof
       shortened by Wolf Lammen, 4-Nov-2013.) $)
    pm5.21nd $p |- ( ph -> ( ps <-> ch ) ) $=
      wph wth wps wch wph wps wth pm5.21nd.1 ex wph wch wth pm5.21nd.2 ex wth
      wps wch wb wi wph pm5.21nd.3 a1i pm5.21ndd $.
  $}

  $( Conjunctive detachment.  Theorem *3.35 of [WhiteheadRussell] p. 112.
     Variant of ~ pm2.27 .  (Contributed by NM, 14-Dec-2002.) $)
  pm3.35 $p |- ( ( ph /\ ( ph -> ps ) ) -> ps ) $=
    wph wph wps wi wps wph wps pm2.27 imp $.

  ${
    pm5.74da.1 $e |- ( ( ph /\ ps ) -> ( ch <-> th ) ) $.
    $( Distribution of implication over biconditional (deduction form).
       Variant of ~ pm5.74d .  (Contributed by NM, 4-May-2007.) $)
    pm5.74da $p |- ( ph -> ( ( ps -> ch ) <-> ( ps -> th ) ) ) $=
      wph wps wch wth wph wps wch wth wb pm5.74da.1 ex pm5.74d $.
  $}

  $( Theorem *4.22 of [WhiteheadRussell] p. 117. ~ bitri in closed form.
     (Contributed by NM, 3-Jan-2005.) $)
  bitr $p |- ( ( ( ph <-> ps ) /\ ( ps <-> ch ) ) -> ( ph <-> ch ) ) $=
    wph wps wb wph wch wb wps wch wb wph wps wch bibi1 biimpar $.

  $( A transitive law of equivalence.  Compare Theorem *4.22 of
     [WhiteheadRussell] p. 117.  (Contributed by NM, 18-Aug-1993.) $)
  biantr $p |- ( ( ( ph <-> ps ) /\ ( ch <-> ps ) ) -> ( ph <-> ch ) ) $=
    wch wps wb wph wch wb wph wps wb wch wps wb wch wps wph wch wps wb id
    bibi2d biimparc $.

  $( Theorem *4.14 of [WhiteheadRussell] p. 117.  Related to ~ con34b .
     (Contributed by NM, 3-Jan-2005.)  (Proof shortened by Wolf Lammen,
     23-Oct-2012.) $)
  pm4.14 $p |- ( ( ( ph /\ ps ) -> ch ) <-> ( ( ph /\ -. ch ) -> -. ps ) ) $=
    wph wps wch wi wi wph wch wn wps wn wi wi wph wps wa wch wi wph wch wn wa
    wps wn wi wps wch wi wch wn wps wn wi wph wps wch con34b imbi2i wph wps wch
    impexp wph wch wn wps wn impexp 3bitr4i $.

  $( Theorem *3.37 (Transp) of [WhiteheadRussell] p. 112.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 23-Oct-2012.) $)
  pm3.37 $p |- ( ( ( ph /\ ps ) -> ch ) -> ( ( ph /\ -. ch ) -> -. ps ) ) $=
    wph wps wa wch wi wph wch wn wa wps wn wi wph wps wch pm4.14 biimpi $.

  $( Conjoin antecedents and consequents of two premises.  This is the closed
     theorem form of ~ anim12d .  Theorem *3.47 of [WhiteheadRussell] p. 113.
     It was proved by Leibniz, and it evidently pleased him enough to call it
     _praeclarum theorema_ (splendid theorem).  (Contributed by NM,
     12-Aug-1993.)  (Proof shortened by Wolf Lammen, 7-Apr-2013.) $)
  anim12 $p |- ( ( ( ph -> ps ) /\ ( ch -> th ) )
              -> ( ( ph /\ ch ) -> ( ps /\ th ) ) ) $=
    wph wps wi wph wps wch wth wi wch wth wph wps wi id wch wth wi id im2anan9
    $.

$( Replacing conjunction. $)

  $( Conjunction implies implication.  Theorem *3.4 of [WhiteheadRussell]
     p. 113.  (Contributed by NM, 31-Jul-1995.) $)
  pm3.4 $p |- ( ( ph /\ ps ) -> ( ph -> ps ) ) $=
    wph wps wa wps wph wph wps simpr a1d $.

  ${
    exbiri.1 $e |- ( ( ph /\ ps ) -> ( ch <-> th ) ) $.
    $( Inference form of ~ exbir .  This proof is ~ exbiriVD automatically
       translated and minimized.  (Contributed by Alan Sare, 31-Dec-2011.)
       (Proof shortened by Wolf Lammen, 27-Jan-2013.) $)
    exbiri $p |- ( ph -> ( ps -> ( th -> ch ) ) ) $=
      wph wps wth wch wph wps wa wch wth exbiri.1 biimpar exp31 $.
  $}

$( Contradiction using conjunction. $)

  ${
    pm2.61ian.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    pm2.61ian.2 $e |- ( ( -. ph /\ ps ) -> ch ) $.
    $( Elimination of an antecedent.  (Contributed by NM, 1-Jan-2005.) $)
    pm2.61ian $p |- ( ps -> ch ) $=
      wph wps wch wi wph wps wch pm2.61ian.1 ex wph wn wps wch pm2.61ian.2 ex
      pm2.61i $.
  $}

  ${
    pm2.61dan.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    pm2.61dan.2 $e |- ( ( ph /\ -. ps ) -> ch ) $.
    $( Elimination of an antecedent.  (Contributed by NM, 1-Jan-2005.) $)
    pm2.61dan $p |- ( ph -> ch ) $=
      wph wps wch wph wps wch pm2.61dan.1 ex wph wps wn wch pm2.61dan.2 ex
      pm2.61d $.
  $}

  ${
    pm2.61ddan.1 $e |- ( ( ph /\ ps ) -> th ) $.
    pm2.61ddan.2 $e |- ( ( ph /\ ch ) -> th ) $.
    pm2.61ddan.3 $e |- ( ( ph /\ ( -. ps /\ -. ch ) ) -> th ) $.
    $( Elimination of two antecedents.  (Contributed by NM, 9-Jul-2013.) $)
    pm2.61ddan $p |- ( ph -> th ) $=
      wph wps wth pm2.61ddan.1 wph wps wn wa wch wth wph wch wth wps wn
      pm2.61ddan.2 adantlr wph wps wn wch wn wth pm2.61ddan.3 anassrs pm2.61dan
      pm2.61dan $.
  $}

  ${
    pm2.61dda.1 $e |- ( ( ph /\ -. ps ) -> th ) $.
    pm2.61dda.2 $e |- ( ( ph /\ -. ch ) -> th ) $.
    pm2.61dda.3 $e |- ( ( ph /\ ( ps /\ ch ) ) -> th ) $.
    $( Elimination of two antecedents.  (Contributed by NM, 9-Jul-2013.) $)
    pm2.61dda $p |- ( ph -> th ) $=
      wph wps wth wph wps wa wch wth wph wps wch wth pm2.61dda.3 anassrs wph
      wch wn wth wps pm2.61dda.2 adantlr pm2.61dan pm2.61dda.1 pm2.61dan $.
  $}

  ${
    mtand.1 $e |- ( ph -> -. ch ) $.
    mtand.2 $e |- ( ( ph /\ ps ) -> ch ) $.
    $( A modus tollens deduction.  (Contributed by Jeff Hankins,
       19-Aug-2009.) $)
    mtand $p |- ( ph -> -. ps ) $=
      wph wps wch mtand.1 wph wps wch mtand.2 ex mtod $.
  $}

  ${
    pm2.65da.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    pm2.65da.2 $e |- ( ( ph /\ ps ) -> -. ch ) $.
    $( Deduction for proof by contradiction.  (Contributed by NM,
       12-Jun-2014.) $)
    pm2.65da $p |- ( ph -> -. ps ) $=
      wph wps wch wph wps wch pm2.65da.1 ex wph wps wch wn pm2.65da.2 ex
      pm2.65d $.
  $}

  ${
    condan.1 $e |- ( ( ph /\ -. ps ) -> ch ) $.
    condan.2 $e |- ( ( ph /\ -. ps ) -> -. ch ) $.
    $( Proof by contradiction.  (Contributed by NM, 9-Feb-2006.)  (Proof
       shortened by Wolf Lammen, 19-Jun-2014.) $)
    condan $p |- ( ph -> ps ) $=
      wph wps wph wps wn wch condan.1 condan.2 pm2.65da notnotrd $.
  $}

$( Relation of conjunction to biconditional. $)

  $( An implication is equivalent to the equivalence of some implied
     equivalence and some other equivalence involving a conjunction.  A utility
     lemma as illustrated in ~ biadanii and ~ elelb .  (Contributed by BJ,
     4-Mar-2023.)  (Proof shortened by Wolf Lammen, 8-Mar-2023.) $)
  biadan $p |- ( ( ph -> ps ) <->
                   ( ( ps -> ( ph <-> ch ) ) <-> ( ph <-> ( ps /\ ch ) ) ) ) $=
    wph wps wi wph wps wph wa wb wps wph wa wph wb wps wph wch wb wi wph wps
    wch wa wb wb wph wps pm4.71r wph wps wph wa bicom wph wps wch wa wb wps wph
    wch wb wi wb wps wch wa wph wb wps wph wa wps wch wa wb wb wps wph wch wb
    wi wph wps wch wa wb wb wps wph wa wph wb wph wps wch wa wb wps wch wa wph
    wb wps wph wch wb wi wps wph wa wps wch wa wb wph wps wch wa bicom wps wph
    wch pm5.32 bibi12i wps wph wch wb wi wph wps wch wa wb bicom wps wph wa wph
    wps wch wa biluk 3bitr4ri 3bitri $.

  ${
    biadani.1 $e |- ( ph -> ps ) $.
    $( Inference associated with ~ biadan .  (Contributed by BJ,
       4-Mar-2023.) $)
    biadani $p |- ( ( ps -> ( ph <-> ch ) ) <-> ( ph <-> ( ps /\ ch ) ) ) $=
      wph wps wi wps wph wch wb wi wph wps wch wa wb wb biadani.1 wph wps wch
      biadan mpbi $.

    $( Alternate proof of ~ biadani not using ~ biadan .  (Contributed by BJ,
       4-Mar-2023.)  (Proof modification is discouraged.)
       (New usage is discouraged.) $)
    biadaniALT $p |- ( ( ps -> ( ph <-> ch ) ) <-> ( ph <-> ( ps /\ ch ) ) ) $=
      wps wph wch wb wi wps wph wa wps wch wa wb wph wps wch wa wb wps wph wch
      pm5.32 wph wps wph wa wps wch wa wph wps biadani.1 pm4.71ri bibi1i bitr4i
      $.

    biadanii.2 $e |- ( ps -> ( ph <-> ch ) ) $.
    $( Inference associated with ~ biadani .  Add a conjunction to an
       equivalence.  (Contributed by Jeff Madsen, 20-Jun-2011.)  (Proof
       shortened by BJ, 4-Mar-2023.) $)
    biadanii $p |- ( ph <-> ( ps /\ ch ) ) $=
      wps wph wch wb wi wph wps wch wa wb biadanii.2 wph wps wch biadani.1
      biadani mpbi $.
  $}

  ${
    biadanid.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    biadanid.2 $e |- ( ( ph /\ ch ) -> ( ps <-> th ) ) $.
    $( Deduction associated with ~ biadani .  Add a conjunction to an
       equivalence.  (Contributed by Thierry Arnoux, 16-Jun-2024.) $)
    biadanid $p |- ( ph -> ( ps <-> ( ch /\ th ) ) ) $=
      wph wps wch wth wa wph wps wa wch wth biadanid.1 wph wps wa wch wth
      biadanid.1 wph wch wps wth wph wch wa wps wth biadanid.2 biimpa an32s
      mpdan jca wph wch wth wps wph wch wa wps wth biadanid.2 biimpar anasss
      impbida $.
  $}

  $( Two propositions are equivalent if they are both true.  Theorem *5.1 of
     [WhiteheadRussell] p. 123.  (Contributed by NM, 21-May-1994.) $)
  pm5.1 $p |- ( ( ph /\ ps ) -> ( ph <-> ps ) ) $=
    wph wps wph wps wb wph wps pm5.501 biimpa $.

  $( Two propositions are equivalent if they are both false.  Theorem *5.21 of
     [WhiteheadRussell] p. 124.  (Contributed by NM, 21-May-1994.) $)
  pm5.21 $p |- ( ( -. ph /\ -. ps ) -> ( ph <-> ps ) ) $=
    wph wn wps wn wph wps wb wph wps pm5.21im imp $.

  $( Theorem *5.35 of [WhiteheadRussell] p. 125.  Closed form of ~ 2thd .
     (Contributed by NM, 3-Jan-2005.) $)
  pm5.35 $p |- ( ( ( ph -> ps ) /\ ( ph -> ch ) ) ->
                ( ph -> ( ps <-> ch ) ) ) $=
    wph wps wi wph wch wi wa wph wps wch wph wps wi wph wch wi pm5.1 pm5.74rd
    $.

  $( Introduce one conjunct as an antecedent to the other.  "abai" stands for
     "and, biconditional, and, implication".  (Contributed by NM, 12-Aug-1993.)
     (Proof shortened by Wolf Lammen, 7-Dec-2012.) $)
  abai $p |- ( ( ph /\ ps ) <-> ( ph /\ ( ph -> ps ) ) ) $=
    wph wps wph wps wi wph wps biimt pm5.32i $.

  $( Conjunction with implication.  Compare Theorem *4.45 of [WhiteheadRussell]
     p. 119.  (Contributed by NM, 17-May-1998.) $)
  pm4.45im $p |- ( ph <-> ( ph /\ ( ps -> ph ) ) ) $=
    wph wps wph wi wph wps ax-1 pm4.71i $.

  $( An implication and its reverse are equivalent exactly when both operands
     are equivalent.  The right hand side resembles that of ~ dfbi2 , but
     ` <-> ` is a weaker operator than ` /\ ` .  Note that an implication and
     its reverse can never be simultaneously false, because of ~ pm2.521 .
     (Contributed by Wolf Lammen, 18-Dec-2023.) $)
  impimprbi $p |- ( ( ph <-> ps ) <-> ( ( ph -> ps ) <-> ( ps -> ph ) ) ) $=
    wph wps wb wph wps wi wps wph wi wb wph wps wb wph wps wi wps wph wi wa wph
    wps wi wps wph wi wb wph wps dfbi2 wph wps wi wps wph wi pm5.1 sylbi wph
    wps wi wps wph wi wph wps wb wph wps impbi wph wps wi wn wps wph wi wph wps
    wb wph wps pm2.521 pm2.24d bija impbii $.

$( Moving subexpressions in/out of a conjunction. $)

  $( Theorem to move a conjunct in and out of a negation.  (Contributed by NM,
     9-Nov-2003.) $)
  nan $p |- ( ( ph -> -. ( ps /\ ch ) ) <-> ( ( ph /\ ps ) -> -. ch ) ) $=
    wph wps wa wch wn wi wph wps wch wn wi wi wph wps wch wa wn wi wph wps wch
    wn impexp wps wch wn wi wps wch wa wn wph wps wch imnan imbi2i bitr2i $.

  $( Theorem *5.31 of [WhiteheadRussell] p. 125.  (Contributed by NM,
     3-Jan-2005.) $)
  pm5.31 $p |- ( ( ch /\ ( ph -> ps ) ) -> ( ph -> ( ps /\ ch ) ) ) $=
    wch wph wps wi wa wph wps wch wch wph wps wi simpr wch wph wps wi simpl
    jctird $.

  $( Variant of ~ pm5.31 .  (Contributed by Rodolfo Medina, 15-Oct-2010.) $)
  pm5.31r $p |- ( ( ch /\ ( ph -> ps ) ) -> ( ph -> ( ch /\ ps ) ) ) $=
    wch wph wch wph wps wi wps wch wph ax-1 wph wps wi id anim12ii $.

  $( Theorem *4.15 of [WhiteheadRussell] p. 117.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 18-Nov-2012.) $)
  pm4.15 $p |- ( ( ( ph /\ ps ) -> -. ch ) <-> ( ( ps /\ ch ) -> -. ph ) ) $=
    wps wch wa wph wn wi wph wps wch wa wn wi wph wps wa wch wn wi wps wch wa
    wph con2b wph wps wch nan bitr2i $.

  $( Theorem *5.36 of [WhiteheadRussell] p. 125.  (Contributed by NM,
     3-Jan-2005.) $)
  pm5.36 $p |- ( ( ph /\ ( ph <-> ps ) ) <-> ( ps /\ ( ph <-> ps ) ) ) $=
    wph wps wb wph wps wph wps wb id pm5.32ri $.

$( Absorption in conjunction. $)

  $( A conjunction with a negated conjunction.  (Contributed by AV,
     8-Mar-2022.)  (Proof shortened by Wolf Lammen, 1-Apr-2022.) $)
  annotanannot $p |- ( ( ph /\ -. ( ph /\ ps ) ) <-> ( ph /\ -. ps ) ) $=
    wph wph wps wa wn wps wn wph wph wps wa wps wph wps wph wps wa wph wps ibar
    bicomd notbid pm5.32i $.

  $( Theorem *5.33 of [WhiteheadRussell] p. 125.  (Contributed by NM,
     3-Jan-2005.) $)
  pm5.33 $p |- ( ( ph /\ ( ps -> ch ) ) <->
                ( ph /\ ( ( ph /\ ps ) -> ch ) ) ) $=
    wph wps wch wi wph wps wa wch wi wph wps wph wps wa wch wph wps ibar imbi1d
    pm5.32i $.

$( Miscellaneous theorems using conjunction. $)

  ${
    syl12anc.1 $e |- ( ph -> ps ) $.
    syl12anc.2 $e |- ( ph -> ch ) $.
    syl12anc.3 $e |- ( ph -> th ) $.
    ${
      syl12anc.4 $e |- ( ( ps /\ ( ch /\ th ) ) -> ta ) $.
      $( Syllogism combined with contraction.  (Contributed by Jeff Hankins,
         1-Aug-2009.) $)
      syl12anc $p |- ( ph -> ta ) $=
        wph wps wch wth wa wta syl12anc.1 wph wch wth syl12anc.2 syl12anc.3 jca
        syl12anc.4 syl2anc $.
    $}

    ${
      syl21anc.4 $e |- ( ( ( ps /\ ch ) /\ th ) -> ta ) $.
      $( Syllogism combined with contraction.  (Contributed by Jeff Hankins,
         1-Aug-2009.) $)
      syl21anc $p |- ( ph -> ta ) $=
        wph wps wch wa wth wta wph wps wch syl12anc.1 syl12anc.2 jca syl12anc.3
        syl21anc.4 syl2anc $.
    $}

    ${
      syl22anc.4 $e |- ( ph -> ta ) $.
      syl22anc.5 $e |- ( ( ( ps /\ ch ) /\ ( th /\ ta ) ) -> et ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl22anc $p |- ( ph -> et ) $=
        wph wps wch wa wth wta wet wph wps wch syl12anc.1 syl12anc.2 jca
        syl12anc.3 syl22anc.4 syl22anc.5 syl12anc $.
    $}
  $}

  ${
    bibiad.1 $e |- ( ( ph /\ ps ) -> th ) $.
    bibiad.2 $e |- ( ( ph /\ ch ) -> th ) $.
    bibiad.3 $e |- ( ( ph /\ th ) -> ( ps <-> ch ) ) $.
    $( Eliminate an hypothesis ` th ` in a biconditional.  (Contributed by
       Thierry Arnoux, 4-May-2025.) $)
    bibiad $p |- ( ph -> ( ps <-> ch ) ) $=
      wph wps wch wph wps wa wph wth wps wch wph wps simpl bibiad.1 wph wps
      simpr wph wth wa wps wch bibiad.3 biimpa syl21anc wph wch wa wph wth wch
      wps wph wch simpl bibiad.2 wph wch simpr wph wth wa wps wch bibiad.3
      biimpar syl21anc impbida $.
  $}

  ${
    syl1111anc.1 $e |- ( ph -> ps ) $.
    syl1111anc.2 $e |- ( ph -> ch ) $.
    syl1111anc.3 $e |- ( ph -> th ) $.
    syl1111anc.4 $e |- ( ph -> ta ) $.
    syl1111anc.5 $e |- ( ( ( ( ps /\ ch ) /\ th ) /\ ta ) -> et ) $.
    $( Four-hypothesis elimination deduction for an assertion with a singleton
       virtual hypothesis collection.  Similar to ~ syl112anc except the
       unification theorem uses left-nested conjunction.  (Contributed by Alan
       Sare, 17-Oct-2017.) $)
    syl1111anc $p |- ( ph -> et ) $=
      wph wps wch wa wth wta wet wph wps wch syl1111anc.1 syl1111anc.2 jca
      syl1111anc.3 syl1111anc.4 syl1111anc.5 syl21anc $.
  $}

  ${
    syldbl2.1 $e |- ( ( ph /\ ps ) -> ( ps -> th ) ) $.
    $( Stacked hypotheseis implies goal.  (Contributed by Stanislas Polu,
       9-Mar-2020.) $)
    syldbl2 $p |- ( ( ph /\ ps ) -> th ) $=
      wph wps wth wph wps wa wps wth syldbl2.1 com12 anabsi7 $.
  $}

  ${
    mpsyl4anc.1 $e |- ph $.
    mpsyl4anc.2 $e |- ps $.
    mpsyl4anc.3 $e |- ch $.
    mpsyl4anc.4 $e |- ( th -> ta ) $.
    mpsyl4anc.5 $e |- ( ( ( ( ph /\ ps ) /\ ch ) /\ ta ) -> et ) $.
    $( An elimination deduction.  (Contributed by Alan Sare, 17-Oct-2017.) $)
    mpsyl4anc $p |- ( th -> et ) $=
      wth wph wps wch wta wet wph wth mpsyl4anc.1 a1i wps wth mpsyl4anc.2 a1i
      wch wth mpsyl4anc.3 a1i mpsyl4anc.4 mpsyl4anc.5 syl1111anc $.
  $}

  $( Theorem *4.87 of [WhiteheadRussell] p. 122.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Eric Schmidt, 26-Oct-2006.) $)
  pm4.87 $p |- ( ( ( ( ( ph /\ ps ) -> ch ) <-> ( ph -> ( ps -> ch ) ) ) /\
                ( ( ph -> ( ps -> ch ) ) <-> ( ps -> ( ph -> ch ) ) ) ) /\
                ( ( ps -> ( ph -> ch ) ) <-> ( ( ps /\ ph ) -> ch ) ) ) $=
    wph wps wa wch wi wph wps wch wi wi wb wph wps wch wi wi wps wph wch wi wi
    wb wa wps wph wch wi wi wps wph wa wch wi wb wph wps wa wch wi wph wps wch
    wi wi wb wph wps wch wi wi wps wph wch wi wi wb wph wps wch impexp wph wps
    wch bi2.04 pm3.2i wps wph wa wch wi wps wph wch wi wi wps wph wch impexp
    bicomi pm3.2i $.

  $( Removal of conjunct from one side of an equivalence.  (Contributed by NM,
     21-Jun-1993.) $)
  bimsc1 $p |- ( ( ( ph -> ps ) /\ ( ch <-> ( ps /\ ph ) ) )
               -> ( ch <-> ph ) ) $=
    wch wps wph wa wb wch wps wph wa wph wps wi wph wch wps wph wa wb id wph
    wps wi wps wph wa wph wps wph simpr wph wps ancr impbid2 sylan9bbr $.

  ${
    a2and.1 $e |- ( ph -> ( ( ps /\ rh ) -> ( ta -> th ) ) ) $.
    a2and.2 $e |- ( ph -> ( ( ps /\ rh ) -> ch ) ) $.
    $( Deduction distributing a conjunction as embedded antecedent.
       (Contributed by AV, 25-Oct-2019.)  (Proof shortened by Wolf Lammen,
       19-Jan-2020.) $)
    a2and $p |- ( ph -> ( ( ( ps /\ ch ) -> ta )
                            -> ( ( ps /\ rh ) -> th ) ) ) $=
      wph wps wrh wa wps wch wa wta wi wth wph wps wrh wa wta wth wi wps wch wa
      wps wch wa wta wi wth wi a2and.1 wph wps wrh wch wph wps wrh wch a2and.2
      expd imdistand wps wch wa wta wi wta wth wi wps wch wa wth wps wch wa wta
      wth imim1 com3l syl6c com23 $.
  $}

  ${
    animpimp2impd.1 $e |- ( ( ps /\ ph ) -> ( ch -> ( th -> et ) ) ) $.
    animpimp2impd.2 $e |- ( ( ps /\ ( ph /\ th ) ) -> ( et -> ta ) ) $.
    $( Deduction deriving nested implications from conjunctions.  (Contributed
       by AV, 21-Aug-2022.) $)
    animpimp2impd $p |- ( ph -> ( ( ps -> ch ) -> ( ps -> ( th -> ta ) ) ) ) $=
      wph wps wch wth wta wi wps wph wch wth wta wi wi wps wph wa wch wth wet
      wi wth wta wi animpimp2impd.1 wps wph wa wth wet wta wps wph wth wet wta
      wi animpimp2impd.2 expr a2d syld expcom a2d $.
  $}


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Logical disjunction
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  This section defines disjunction of two formulas, denoted by infix " ` \/ ` "
  and read "or".  It is defined in terms of implication and negation, which is
  possible in classical logic (but not in intuitionistic logic: see iset.mm).
  This section contains only theorems proved without ~ df-an (theorems that are
  proved using ~ df-an are deferred to the next section).  Basic theorems that
  help simplifying and applying disjunction are ~ olc , ~ orc , and ~ orcom .

  As mentioned in the "note on definitions" in the section comment for logical
  equivalence, all theorems in this and the previous section can be stated in
  terms of implication and negation only.  Additionally, in classical logic
  (but not in intuitionistic logic: see iset.mm), it is also possible to
  translate conjunction into disjunction and conversely via the De Morgan law
  ~ anor : conjunction and disjunction are dual connectives.  Either is
  sufficient to develop all propositional calculus of the logic (together with
  implication and negation).  In practice, conjunction is more efficient, its
  big advantage being the possibility to use it to group antecedents in a
  convenient way, using ~ imp and ~ ex as noted in the previous section.

  An illustration of the conservativity of ~ df-an is given by ~ orim12dALT ,
  which is an alternate proof of ~ orim12d not using ~ df-an .

$)

  $( Declare connectives for disjunction ("or"). $)
  $c \/ $.  $( Vee (read:  "or") $)

  $( Extend wff definition to include disjunction ("or"). $)
  wo $a wff ( ph \/ ps ) $.

  $( Define disjunction (logical "or").  Definition of [Margaris] p. 49.  When
     the left operand, right operand, or both are true, the result is true;
     when both sides are false, the result is false.  For example, it is true
     that ` ( 2 = 3 \/ 4 = 4 ) ` ( ~ ex-or ).  After we define the constant
     true ` T. ` ( ~ df-tru ) and the constant false ` F. ` ( ~ df-fal ), we
     will be able to prove these truth table values:
     ` ( ( T. \/ T. ) <-> T. ) ` ( ~ truortru ), ` ( ( T. \/ F. ) <-> T. ) `
     ( ~ truorfal ), ` ( ( F. \/ T. ) <-> T. ) ` ( ~ falortru ), and
     ` ( ( F. \/ F. ) <-> F. ) ` ( ~ falorfal ).

     Contrast with ` /\ ` ( ~ df-an ), ` -> ` ( ~ wi ), ` -/\ ` ( ~ df-nan ),
     and ` \/_ ` ( ~ df-xor ).  (Contributed by NM, 27-Dec-1992.) $)
  df-or $a |- ( ( ph \/ ps ) <-> ( -. ph -> ps ) ) $.

  $( Theorem *4.64 of [WhiteheadRussell] p. 120.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.64 $p |- ( ( -. ph -> ps ) <-> ( ph \/ ps ) ) $=
    wph wps wo wph wn wps wi wph wps df-or bicomi $.

  $( Theorem *4.66 of [WhiteheadRussell] p. 120.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.66 $p |- ( ( -. ph -> -. ps ) <-> ( ph \/ -. ps ) ) $=
    wph wps wn pm4.64 $.

  $( Theorem *2.53 of [WhiteheadRussell] p. 107.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.53 $p |- ( ( ph \/ ps ) -> ( -. ph -> ps ) ) $=
    wph wps wo wph wn wps wi wph wps df-or biimpi $.

  $( Theorem *2.54 of [WhiteheadRussell] p. 107.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.54 $p |- ( ( -. ph -> ps ) -> ( ph \/ ps ) ) $=
    wph wps wo wph wn wps wi wph wps df-or biimpri $.

  $( Implication in terms of disjunction.  Theorem *4.6 of [WhiteheadRussell]
     p. 120.  (Contributed by NM, 3-Jan-1993.) $)
  imor $p |- ( ( ph -> ps ) <-> ( -. ph \/ ps ) ) $=
    wph wps wi wph wn wn wps wi wph wn wps wo wph wph wn wn wps wph notnotb
    imbi1i wph wn wps df-or bitr4i $.

  ${
    imori.1 $e |- ( ph -> ps ) $.
    $( Infer disjunction from implication.  (Contributed by NM,
       12-Mar-2012.) $)
    imori $p |- ( -. ph \/ ps ) $=
      wph wps wi wph wn wps wo imori.1 wph wps imor mpbi $.
  $}

  ${
    imorri.1 $e |- ( -. ph \/ ps ) $.
    $( Infer implication from disjunction.  (Contributed by Jonathan Ben-Naim,
       3-Jun-2011.) $)
    imorri $p |- ( ph -> ps ) $=
      wph wps wi wph wn wps wo imorri.1 wph wps imor mpbir $.
  $}

  $( Theorem *4.62 of [WhiteheadRussell] p. 120.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.62 $p |- ( ( ph -> -. ps ) <-> ( -. ph \/ -. ps ) ) $=
    wph wps wn imor $.

  ${
    jaoi.1 $e |- ( ph -> ps ) $.
    jaoi.2 $e |- ( ch -> ps ) $.
    $( Inference disjoining the antecedents of two implications.  (Contributed
       by NM, 5-Apr-1994.) $)
    jaoi $p |- ( ( ph \/ ch ) -> ps ) $=
      wph wch wo wph wps wph wch wo wph wn wch wps wph wch pm2.53 jaoi.2 syl6
      jaoi.1 pm2.61d2 $.
  $}

  ${
    jao1i.1 $e |- ( ps -> ( ch -> ph ) ) $.
    $( Add a disjunct in the antecedent of an implication.  (Contributed by
       Rodolfo Medina, 24-Sep-2010.) $)
    jao1i $p |- ( ( ph \/ ps ) -> ( ch -> ph ) ) $=
      wph wch wph wi wps wph wch ax-1 jao1i.1 jaoi $.
  $}

  ${
    jaod.1 $e |- ( ph -> ( ps -> ch ) ) $.
    jaod.2 $e |- ( ph -> ( th -> ch ) ) $.
    $( Deduction disjoining the antecedents of two implications.  (Contributed
       by NM, 18-Aug-1994.) $)
    jaod $p |- ( ph -> ( ( ps \/ th ) -> ch ) ) $=
      wps wth wo wph wch wps wph wch wi wth wph wps wch jaod.1 com12 wph wth
      wch jaod.2 com12 jaoi com12 $.

    jaod.3 $e |- ( ph -> ( ps \/ th ) ) $.
    $( Eliminate a disjunction in a deduction.  (Contributed by Mario Carneiro,
       29-May-2016.) $)
    mpjaod $p |- ( ph -> ch ) $=
      wph wps wth wo wch jaod.3 wph wps wch wth jaod.1 jaod.2 jaod mpd $.
  $}

  ${
    ori.1 $e |- ( ph \/ ps ) $.
    $( Infer implication from disjunction.  (Contributed by NM,
       11-Jun-1994.) $)
    ori $p |- ( -. ph -> ps ) $=
      wph wps wo wph wn wps wi ori.1 wph wps df-or mpbi $.
  $}

  ${
    orri.1 $e |- ( -. ph -> ps ) $.
    $( Infer disjunction from implication.  (Contributed by NM,
       11-Jun-1994.) $)
    orri $p |- ( ph \/ ps ) $=
      wph wps wo wph wn wps wi orri.1 wph wps df-or mpbir $.
  $}

  ${
    orrd.1 $e |- ( ph -> ( -. ps -> ch ) ) $.
    $( Deduce disjunction from implication.  (Contributed by NM,
       27-Nov-1995.) $)
    orrd $p |- ( ph -> ( ps \/ ch ) ) $=
      wph wps wn wch wi wps wch wo orrd.1 wps wch pm2.54 syl $.
  $}

  ${
    ord.1 $e |- ( ph -> ( ps \/ ch ) ) $.
    $( Deduce implication from disjunction.  (Contributed by NM,
       18-May-1994.) $)
    ord $p |- ( ph -> ( -. ps -> ch ) ) $=
      wph wps wch wo wps wn wch wi ord.1 wps wch df-or sylib $.
  $}

  ${
    orci.1 $e |- ph $.
    $( Deduction introducing a disjunct.  (Contributed by NM, 19-Jan-2008.)
       (Proof shortened by Wolf Lammen, 14-Nov-2012.) $)
    orci $p |- ( ph \/ ps ) $=
      wph wps wph wps orci.1 pm2.24i orri $.

    $( Deduction introducing a disjunct.  (Contributed by NM, 19-Jan-2008.)
       (Proof shortened by Wolf Lammen, 14-Nov-2012.) $)
    olci $p |- ( ps \/ ph ) $=
      wps wph wph wps wn orci.1 a1i orri $.
  $}

  $( Introduction of a disjunct.  Theorem *2.2 of [WhiteheadRussell] p. 104.
     (Contributed by NM, 30-Aug-1993.) $)
  orc $p |- ( ph -> ( ph \/ ps ) ) $=
    wph wph wps wph wps pm2.24 orrd $.

  $( Introduction of a disjunct.  Axiom *1.3 of [WhiteheadRussell] p. 96.
     (Contributed by NM, 30-Aug-1993.) $)
  olc $p |- ( ph -> ( ps \/ ph ) ) $=
    wph wps wph wph wps wn ax-1 orrd $.

  $( Axiom *1.4 of [WhiteheadRussell] p. 96.  (Contributed by NM,
     3-Jan-2005.) $)
  pm1.4 $p |- ( ( ph \/ ps ) -> ( ps \/ ph ) ) $=
    wph wps wph wo wps wph wps olc wps wph orc jaoi $.

  $( Commutative law for disjunction.  Theorem *4.31 of [WhiteheadRussell]
     p. 118.  (Contributed by NM, 3-Jan-1993.)  (Proof shortened by Wolf
     Lammen, 15-Nov-2012.) $)
  orcom $p |- ( ( ph \/ ps ) <-> ( ps \/ ph ) ) $=
    wph wps wo wps wph wo wph wps pm1.4 wps wph pm1.4 impbii $.

  ${
    orcomd.1 $e |- ( ph -> ( ps \/ ch ) ) $.
    $( Commutation of disjuncts in consequent.  (Contributed by NM,
       2-Dec-2010.) $)
    orcomd $p |- ( ph -> ( ch \/ ps ) ) $=
      wph wps wch wo wch wps wo orcomd.1 wps wch orcom sylib $.
  $}

  ${
    orcoms.1 $e |- ( ( ph \/ ps ) -> ch ) $.
    $( Commutation of disjuncts in antecedent.  (Contributed by NM,
       2-Dec-2012.) $)
    orcoms $p |- ( ( ps \/ ph ) -> ch ) $=
      wps wph wo wph wps wo wch wps wph pm1.4 orcoms.1 syl $.
  $}

  ${
    orcd.1 $e |- ( ph -> ps ) $.
    $( Deduction introducing a disjunct.  A translation of natural deduction
       rule ` \/ ` IR ( ` \/ ` insertion right), see ~ natded .  (Contributed
       by NM, 20-Sep-2007.) $)
    orcd $p |- ( ph -> ( ps \/ ch ) ) $=
      wph wps wps wch wo orcd.1 wps wch orc syl $.

    $( Deduction introducing a disjunct.  A translation of natural deduction
       rule ` \/ ` IL ( ` \/ ` insertion left), see ~ natded .  (Contributed by
       NM, 11-Apr-2008.)  (Proof shortened by Wolf Lammen, 3-Oct-2013.) $)
    olcd $p |- ( ph -> ( ch \/ ps ) ) $=
      wph wps wch wph wps wch orcd.1 orcd orcomd $.
  $}

  ${
    orcs.1 $e |- ( ( ph \/ ps ) -> ch ) $.
    $( Deduction eliminating disjunct. _Notational convention_:  We sometimes
       suffix with "s" the label of an inference that manipulates an
       antecedent, leaving the consequent unchanged.  The "s" means that the
       inference eliminates the need for a syllogism ( ~ syl ) -type inference
       in a proof.  (Contributed by NM, 21-Jun-1994.) $)
    orcs $p |- ( ph -> ch ) $=
      wph wph wps wo wch wph wps orc orcs.1 syl $.
  $}

  ${
    olcs.1 $e |- ( ( ph \/ ps ) -> ch ) $.
    $( Deduction eliminating disjunct.  (Contributed by NM, 21-Jun-1994.)
       (Proof shortened by Wolf Lammen, 3-Oct-2013.) $)
    olcs $p |- ( ps -> ch ) $=
      wps wph wch wph wps wch olcs.1 orcoms orcs $.
  $}

  ${
    olcnd.1 $e |- ( ph -> ( ps \/ ch ) ) $.
    olcnd.2 $e |- ( ph -> -. ch ) $.
    $( A lemma for Conjunctive Normal Form unit propagation, in deduction form.
       (Contributed by Giovanni Mascellani, 15-Sep-2017.)  (Proof shortened by
       Wolf Lammen, 13-Apr-2024.) $)
    olcnd $p |- ( ph -> ps ) $=
      wph wps wch olcnd.2 wph wps wch olcnd.1 ord mt3d $.
  $}

  ${
    orcnd.1 $e |- ( ph -> ( ps \/ ch ) ) $.
    orcnd.2 $e |- ( ph -> -. ps ) $.
    $( A lemma for Conjunctive Normal Form unit propagation, in deduction form.
       (Contributed by Giovanni Mascellani, 15-Sep-2017.) $)
    orcnd $p |- ( ph -> ch ) $=
      wph wch wps wph wps wch orcnd.1 orcomd orcnd.2 olcnd $.
  $}

  ${
    mtord.1 $e |- ( ph -> -. ch ) $.
    mtord.2 $e |- ( ph -> -. th ) $.
    mtord.3 $e |- ( ph -> ( ps -> ( ch \/ th ) ) ) $.
    $( A modus tollens deduction involving disjunction.  (Contributed by Jeff
       Hankins, 15-Jul-2009.) $)
    mtord $p |- ( ph -> -. ps ) $=
      wph wps wth mtord.2 wph wps wch wth wo wch wn wth mtord.3 mtord.1 wch wth
      pm2.53 syl6ci mtod $.
  $}

  ${
    pm3.2ni.1 $e |- -. ph $.
    pm3.2ni.2 $e |- -. ps $.
    $( Infer negated disjunction of negated premises.  (Contributed by NM,
       4-Apr-1995.) $)
    pm3.2ni $p |- -. ( ph \/ ps ) $=
      wph wps wo wph pm3.2ni.1 wph wph wps wph id wps wph pm3.2ni.2 pm2.21i
      jaoi mto $.
  $}

  $( Theorem *2.45 of [WhiteheadRussell] p. 106.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.45 $p |- ( -. ( ph \/ ps ) -> -. ph ) $=
    wph wph wps wo wph wps orc con3i $.

  $( Theorem *2.46 of [WhiteheadRussell] p. 106.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.46 $p |- ( -. ( ph \/ ps ) -> -. ps ) $=
    wps wph wps wo wps wph olc con3i $.

  $( Theorem *2.47 of [WhiteheadRussell] p. 107.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.47 $p |- ( -. ( ph \/ ps ) -> ( -. ph \/ ps ) ) $=
    wph wps wo wn wph wn wps wph wps pm2.45 orcd $.

  $( Theorem *2.48 of [WhiteheadRussell] p. 107.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.48 $p |- ( -. ( ph \/ ps ) -> ( ph \/ -. ps ) ) $=
    wph wps wo wn wps wn wph wph wps pm2.46 olcd $.

  $( Theorem *2.49 of [WhiteheadRussell] p. 107.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.49 $p |- ( -. ( ph \/ ps ) -> ( -. ph \/ -. ps ) ) $=
    wph wps wo wn wps wn wph wn wph wps pm2.46 olcd $.

  $( If neither of two propositions is true, then these propositions are
     equivalent.  (Contributed by BJ, 26-Apr-2019.) $)
  norbi $p |- ( -. ( ph \/ ps ) -> ( ph <-> ps ) ) $=
    wph wph wps wo wps wph wps orc wps wph olc pm5.21ni $.

  $( If two propositions are not equivalent, then at least one is true.
     (Contributed by BJ, 19-Apr-2019.)  (Proof shortened by Wolf Lammen,
     19-Jan-2020.) $)
  nbior $p |- ( -. ( ph <-> ps ) -> ( ph \/ ps ) ) $=
    wph wps wo wph wps wb wph wps norbi con1i $.

  $( Elimination of disjunction by denial of a disjunct.  Theorem *2.55 of
     [WhiteheadRussell] p. 107.  (Contributed by NM, 12-Aug-1994.)  (Proof
     shortened by Wolf Lammen, 21-Jul-2012.) $)
  orel1 $p |- ( -. ph -> ( ( ph \/ ps ) -> ps ) ) $=
    wph wps wo wph wn wps wph wps pm2.53 com12 $.

  $( Theorem *2.25 of [WhiteheadRussell] p. 104.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.25 $p |- ( ph \/ ( ( ph \/ ps ) -> ps ) ) $=
    wph wph wps wo wps wi wph wps orel1 orri $.

  $( Elimination of disjunction by denial of a disjunct.  Theorem *2.56 of
     [WhiteheadRussell] p. 107.  (Contributed by NM, 12-Aug-1994.)  (Proof
     shortened by Wolf Lammen, 5-Apr-2013.) $)
  orel2 $p |- ( -. ph -> ( ( ps \/ ph ) -> ps ) ) $=
    wph wn wps wps wph wph wn wps idd wph wps pm2.21 jaod $.

  $( Slight generalization of Theorem *2.67 of [WhiteheadRussell] p. 107.
     (Contributed by NM, 3-Jan-2005.) $)
  pm2.67-2 $p |- ( ( ( ph \/ ch ) -> ps ) -> ( ph -> ps ) ) $=
    wph wph wch wo wps wph wch orc imim1i $.

  $( Theorem *2.67 of [WhiteheadRussell] p. 107.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.67 $p |- ( ( ( ph \/ ps ) -> ps ) -> ( ph -> ps ) ) $=
    wph wps wps pm2.67-2 $.

  $( A non-intuitionistic positive statement, sometimes called a paradox of
     material implication.  Sometimes called Curry's axiom.  Similar to ~ exmid
     (obtained by substituting ` F. ` for ` ps ` ) but positive.  For another
     non-intuitionistic positive statement, see ~ peirce .  (Contributed by BJ,
     4-Apr-2021.) $)
  curryax $p |- ( ph \/ ( ph -> ps ) ) $=
    wph wph wps wi wph wps pm2.21 orri $.

  $( Law of excluded middle, also called the principle of _tertium non datur_.
     Theorem *2.11 of [WhiteheadRussell] p. 101.  It says that something is
     either true or not true; there are no in-between values of truth.  This is
     an essential distinction of our classical logic and is not a theorem of
     intuitionistic logic.  In intuitionistic logic, if this statement is true
     for some ` ph ` , then ` ph ` is decidable.  (Contributed by NM,
     29-Dec-1992.) $)
  exmid $p |- ( ph \/ -. ph ) $=
    wph wph wn wph wn id orri $.

  $( Law of excluded middle in a context.  (Contributed by Mario Carneiro,
     9-Feb-2017.) $)
  exmidd $p |- ( ph -> ( ps \/ -. ps ) ) $=
    wps wps wn wo wph wps exmid a1i $.

  $( Theorem *2.1 of [WhiteheadRussell] p. 101.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 23-Nov-2012.) $)
  pm2.1 $p |- ( -. ph \/ ph ) $=
    wph wph wph id imori $.

  $( Theorem *2.13 of [WhiteheadRussell] p. 101.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.13 $p |- ( ph \/ -. -. -. ph ) $=
    wph wph wn wn wn wph wn notnot orri $.

  $( Theorem *2.621 of [WhiteheadRussell] p. 107.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.621 $p |- ( ( ph -> ps ) -> ( ( ph \/ ps ) -> ps ) ) $=
    wph wps wi wph wps wps wph wps wi id wph wps wi wps idd jaod $.

  $( Theorem *2.62 of [WhiteheadRussell] p. 107.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 13-Dec-2013.) $)
  pm2.62 $p |- ( ( ph \/ ps ) -> ( ( ph -> ps ) -> ps ) ) $=
    wph wps wi wph wps wo wps wph wps pm2.621 com12 $.

  $( Theorem *2.68 of [WhiteheadRussell] p. 108.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.68 $p |- ( ( ( ph -> ps ) -> ps ) -> ( ph \/ ps ) ) $=
    wph wps wi wps wi wph wps wph wps wps jarl orrd $.

  $( Logical 'or' expressed in terms of implication only.  Theorem *5.25 of
     [WhiteheadRussell] p. 124.  (Contributed by NM, 12-Aug-2004.)  (Proof
     shortened by Wolf Lammen, 20-Oct-2012.) $)
  dfor2 $p |- ( ( ph \/ ps ) <-> ( ( ph -> ps ) -> ps ) ) $=
    wph wps wo wph wps wi wps wi wph wps pm2.62 wph wps pm2.68 impbii $.

  $( Theorem *2.07 of [WhiteheadRussell] p. 101.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.07 $p |- ( ph -> ( ph \/ ph ) ) $=
    wph wph olc $.

  $( Axiom *1.2 of [WhiteheadRussell] p. 96, which they call "Taut".
     (Contributed by NM, 3-Jan-2005.) $)
  pm1.2 $p |- ( ( ph \/ ph ) -> ph ) $=
    wph wph wph wph id wph id jaoi $.

  $( Idempotent law for disjunction.  Theorem *4.25 of [WhiteheadRussell]
     p. 117.  (Contributed by NM, 11-May-1993.)  (Proof shortened by Andrew
     Salmon, 16-Apr-2011.)  (Proof shortened by Wolf Lammen, 10-Mar-2013.) $)
  oridm $p |- ( ( ph \/ ph ) <-> ph ) $=
    wph wph wo wph wph pm1.2 wph pm2.07 impbii $.

  $( Theorem *4.25 of [WhiteheadRussell] p. 117.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.25 $p |- ( ph <-> ( ph \/ ph ) ) $=
    wph wph wo wph wph oridm bicomi $.

  $( Theorem *2.4 of [WhiteheadRussell] p. 106.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.4 $p |- ( ( ph \/ ( ph \/ ps ) ) -> ( ph \/ ps ) ) $=
    wph wph wps wo wph wps wo wph wps orc wph wps wo id jaoi $.

  $( Theorem *2.41 of [WhiteheadRussell] p. 106.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.41 $p |- ( ( ps \/ ( ph \/ ps ) ) -> ( ph \/ ps ) ) $=
    wps wph wps wo wph wps wo wps wph olc wph wps wo id jaoi $.

  ${
    orim12i.1 $e |- ( ph -> ps ) $.
    orim12i.2 $e |- ( ch -> th ) $.
    $( Disjoin antecedents and consequents of two premises.  (Contributed by
       NM, 6-Jun-1994.)  (Proof shortened by Wolf Lammen, 25-Jul-2012.) $)
    orim12i $p |- ( ( ph \/ ch ) -> ( ps \/ th ) ) $=
      wph wps wth wo wch wph wps wth orim12i.1 orcd wch wth wps orim12i.2 olcd
      jaoi $.
  $}

  ${
    orim1i.1 $e |- ( ph -> ps ) $.
    $( Introduce disjunct to both sides of an implication.  (Contributed by NM,
       6-Jun-1994.) $)
    orim1i $p |- ( ( ph \/ ch ) -> ( ps \/ ch ) ) $=
      wph wps wch wch orim1i.1 wch id orim12i $.

    $( Introduce disjunct to both sides of an implication.  (Contributed by NM,
       6-Jun-1994.) $)
    orim2i $p |- ( ( ch \/ ph ) -> ( ch \/ ps ) ) $=
      wch wch wph wps wch id orim1i.1 orim12i $.
  $}

  ${
    orim12dALT.1 $e |- ( ph -> ( ps -> ch ) ) $.
    orim12dALT.2 $e |- ( ph -> ( th -> ta ) ) $.
    $( Alternate proof of ~ orim12d which does not depend on ~ df-an .  This is
       an illustration of the conservativity of definitions (definitions do not
       permit to prove additional theorems whose statements do not contain the
       defined symbol).  (Contributed by Wolf Lammen, 8-Aug-2022.)
       (Proof modification is discouraged.)  (New usage is discouraged.) $)
    orim12dALT $p |- ( ph -> ( ( ps \/ th ) -> ( ch \/ ta ) ) ) $=
      wps wth wo wps wn wth wi wph wch wn wta wi wch wta wo wps wth pm2.53 wph
      wch wn wps wn wth wta wph wps wch orim12dALT.1 con3d orim12dALT.2 imim12d
      wch wta pm2.54 syl56 $.
  $}

  ${
    orbi2i.1 $e |- ( ph <-> ps ) $.
    $( Inference adding a left disjunct to both sides of a logical equivalence.
       (Contributed by NM, 3-Jan-1993.)  (Proof shortened by Wolf Lammen,
       12-Dec-2012.) $)
    orbi2i $p |- ( ( ch \/ ph ) <-> ( ch \/ ps ) ) $=
      wch wph wo wch wps wo wph wps wch wph wps orbi2i.1 biimpi orim2i wps wph
      wch wph wps orbi2i.1 biimpri orim2i impbii $.

    $( Inference adding a right disjunct to both sides of a logical
       equivalence.  (Contributed by NM, 3-Jan-1993.) $)
    orbi1i $p |- ( ( ph \/ ch ) <-> ( ps \/ ch ) ) $=
      wph wch wo wch wph wo wch wps wo wps wch wo wph wch orcom wph wps wch
      orbi2i.1 orbi2i wch wps orcom 3bitri $.
  $}

  ${
    orbi12i.1 $e |- ( ph <-> ps ) $.
    orbi12i.2 $e |- ( ch <-> th ) $.
    $( Infer the disjunction of two equivalences.  (Contributed by NM,
       3-Jan-1993.) $)
    orbi12i $p |- ( ( ph \/ ch ) <-> ( ps \/ th ) ) $=
      wph wch wo wph wth wo wps wth wo wch wth wph orbi12i.2 orbi2i wph wps wth
      orbi12i.1 orbi1i bitri $.
  $}

  ${
    bid.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    $( Deduction adding a left disjunct to both sides of a logical equivalence.
       (Contributed by NM, 21-Jun-1993.) $)
    orbi2d $p |- ( ph -> ( ( th \/ ps ) <-> ( th \/ ch ) ) ) $=
      wph wth wn wps wi wth wn wch wi wth wps wo wth wch wo wph wps wch wth wn
      bid.1 imbi2d wth wps df-or wth wch df-or 3bitr4g $.

    $( Deduction adding a right disjunct to both sides of a logical
       equivalence.  (Contributed by NM, 21-Jun-1993.) $)
    orbi1d $p |- ( ph -> ( ( ps \/ th ) <-> ( ch \/ th ) ) ) $=
      wph wth wps wo wth wch wo wps wth wo wch wth wo wph wps wch wth bid.1
      orbi2d wps wth orcom wch wth orcom 3bitr4g $.
  $}

  $( Theorem *4.37 of [WhiteheadRussell] p. 118.  (Contributed by NM,
     3-Jan-2005.) $)
  orbi1 $p |- ( ( ph <-> ps ) -> ( ( ph \/ ch ) <-> ( ps \/ ch ) ) ) $=
    wph wps wb wph wps wch wph wps wb id orbi1d $.

  ${
    bi12d.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    bi12d.2 $e |- ( ph -> ( th <-> ta ) ) $.
    $( Deduction joining two equivalences to form equivalence of disjunctions.
       (Contributed by NM, 21-Jun-1993.) $)
    orbi12d $p |- ( ph -> ( ( ps \/ th ) <-> ( ch \/ ta ) ) ) $=
      wph wps wth wo wch wth wo wch wta wo wph wps wch wth bi12d.1 orbi1d wph
      wth wta wch bi12d.2 orbi2d bitrd $.
  $}

  $( Axiom *1.5 (Assoc) of [WhiteheadRussell] p. 96.  (Contributed by NM,
     3-Jan-2005.) $)
  pm1.5 $p |- ( ( ph \/ ( ps \/ ch ) ) -> ( ps \/ ( ph \/ ch ) ) ) $=
    wph wps wph wch wo wo wps wch wo wph wph wch wo wps wph wch orc olcd wch
    wph wch wo wps wch wph olc orim2i jaoi $.

  $( Swap two disjuncts.  (Contributed by NM, 5-Aug-1993.)  (Proof shortened by
     Wolf Lammen, 14-Nov-2012.) $)
  or12 $p |- ( ( ph \/ ( ps \/ ch ) ) <-> ( ps \/ ( ph \/ ch ) ) ) $=
    wph wps wch wo wo wps wph wch wo wo wph wps wch pm1.5 wps wph wch pm1.5
    impbii $.

  $( Associative law for disjunction.  Theorem *4.33 of [WhiteheadRussell]
     p. 118.  (Contributed by NM, 5-Aug-1993.)  (Proof shortened by Andrew
     Salmon, 26-Jun-2011.) $)
  orass $p |- ( ( ( ph \/ ps ) \/ ch ) <-> ( ph \/ ( ps \/ ch ) ) ) $=
    wph wps wo wch wo wch wph wps wo wo wph wch wps wo wo wph wps wch wo wo wph
    wps wo wch orcom wch wph wps or12 wch wps wo wps wch wo wph wch wps orcom
    orbi2i 3bitri $.

  $( Theorem *2.31 of [WhiteheadRussell] p. 104.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.31 $p |- ( ( ph \/ ( ps \/ ch ) ) -> ( ( ph \/ ps ) \/ ch ) ) $=
    wph wps wo wch wo wph wps wch wo wo wph wps wch orass biimpri $.

  $( Theorem *2.32 of [WhiteheadRussell] p. 105.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.32 $p |- ( ( ( ph \/ ps ) \/ ch ) -> ( ph \/ ( ps \/ ch ) ) ) $=
    wph wps wo wch wo wph wps wch wo wo wph wps wch orass biimpi $.

  $( Theorem *2.3 of [WhiteheadRussell] p. 104.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.3 $p |- ( ( ph \/ ( ps \/ ch ) ) -> ( ph \/ ( ch \/ ps ) ) ) $=
    wps wch wo wch wps wo wph wps wch pm1.4 orim2i $.

  $( A rearrangement of disjuncts.  (Contributed by NM, 18-Oct-1995.)  (Proof
     shortened by Andrew Salmon, 26-Jun-2011.) $)
  or32 $p |- ( ( ( ph \/ ps ) \/ ch ) <-> ( ( ph \/ ch ) \/ ps ) ) $=
    wph wps wo wch wo wph wps wch wo wo wps wph wch wo wo wph wch wo wps wo wph
    wps wch orass wph wps wch or12 wps wph wch wo orcom 3bitri $.

  $( Rearrangement of 4 disjuncts.  (Contributed by NM, 12-Aug-1994.) $)
  or4 $p |- ( ( ( ph \/ ps ) \/ ( ch \/ th ) ) <->
                ( ( ph \/ ch ) \/ ( ps \/ th ) ) ) $=
    wph wps wch wth wo wo wo wph wch wps wth wo wo wo wph wps wo wch wth wo wo
    wph wch wo wps wth wo wo wps wch wth wo wo wch wps wth wo wo wph wps wch
    wth or12 orbi2i wph wps wch wth wo orass wph wch wps wth wo orass 3bitr4i
    $.

  $( Rearrangement of 4 disjuncts.  (Contributed by NM, 10-Jan-2005.) $)
  or42 $p |- ( ( ( ph \/ ps ) \/ ( ch \/ th ) ) <->
                 ( ( ph \/ ch ) \/ ( th \/ ps ) ) ) $=
    wph wps wo wch wth wo wo wph wch wo wps wth wo wo wph wch wo wth wps wo wo
    wph wps wch wth or4 wps wth wo wth wps wo wph wch wo wps wth orcom orbi2i
    bitri $.

  $( Distribution of disjunction over disjunction.  (Contributed by NM,
     25-Feb-1995.) $)
  orordi $p |- ( ( ph \/ ( ps \/ ch ) ) <->
               ( ( ph \/ ps ) \/ ( ph \/ ch ) ) ) $=
    wph wps wch wo wo wph wph wo wps wch wo wo wph wps wo wph wch wo wo wph wph
    wo wph wps wch wo wph oridm orbi1i wph wph wps wch or4 bitr3i $.

  $( Distribution of disjunction over disjunction.  (Contributed by NM,
     25-Feb-1995.) $)
  orordir $p |- ( ( ( ph \/ ps ) \/ ch ) <->
               ( ( ph \/ ch ) \/ ( ps \/ ch ) ) ) $=
    wph wps wo wch wo wph wps wo wch wch wo wo wph wch wo wps wch wo wo wch wch
    wo wch wph wps wo wch oridm orbi2i wph wps wch wch or4 bitr3i $.

  $( Disjunction distributes over implication.  (Contributed by Wolf Lammen,
     5-Jan-2013.) $)
  orimdi $p |- ( ( ph \/ ( ps -> ch ) )
        <-> ( ( ph \/ ps ) -> ( ph \/ ch ) ) ) $=
    wph wn wps wch wi wi wph wn wps wi wph wn wch wi wi wph wps wch wi wo wph
    wps wo wph wch wo wi wph wn wps wch imdi wph wps wch wi df-or wph wps wo
    wph wn wps wi wph wch wo wph wn wch wi wph wps df-or wph wch df-or imbi12i
    3bitr4i $.

  $( Theorem *2.76 of [WhiteheadRussell] p. 108.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.76 $p |- ( ( ph \/ ( ps -> ch ) )
      -> ( ( ph \/ ps ) -> ( ph \/ ch ) ) ) $=
    wph wps wch wi wo wph wps wo wph wch wo wi wph wps wch orimdi biimpi $.

  $( Theorem *2.85 of [WhiteheadRussell] p. 108.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 5-Jan-2013.) $)
  pm2.85 $p |- ( ( ( ph \/ ps ) -> ( ph \/ ch ) )
      -> ( ph \/ ( ps -> ch ) ) ) $=
    wph wps wch wi wo wph wps wo wph wch wo wi wph wps wch orimdi biimpri $.

  $( Theorem *2.75 of [WhiteheadRussell] p. 108.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 4-Jan-2013.) $)
  pm2.75 $p |- ( ( ph \/ ps )
       -> ( ( ph \/ ( ps -> ch ) ) -> ( ph \/ ch ) ) ) $=
    wph wps wch wi wo wph wps wo wph wch wo wph wps wch pm2.76 com12 $.

  $( Implication distributes over disjunction.  Theorem *4.78 of
     [WhiteheadRussell] p. 121.  (Contributed by NM, 3-Jan-2005.)  (Proof
     shortened by Wolf Lammen, 19-Nov-2012.) $)
  pm4.78 $p |- ( ( ( ph -> ps ) \/ ( ph -> ch ) ) <->
                ( ph -> ( ps \/ ch ) ) ) $=
    wph wn wps wch wo wo wph wn wps wo wph wn wch wo wo wph wps wch wo wi wph
    wps wi wph wch wi wo wph wn wps wch orordi wph wps wch wo imor wph wps wi
    wph wn wps wo wph wch wi wph wn wch wo wph wps imor wph wch imor orbi12i
    3bitr4ri $.

  $( A disjunction with a true formula is equivalent to that true formula.
     (Contributed by NM, 23-May-1999.) $)
  biort $p |- ( ph -> ( ph <-> ( ph \/ ps ) ) ) $=
    wph wph wph wps wo wph id wph wps orc 2thd $.

  $( A wff is equivalent to its disjunction with falsehood.  Theorem *4.74 of
     [WhiteheadRussell] p. 121.  (Contributed by NM, 23-Mar-1995.)  (Proof
     shortened by Wolf Lammen, 18-Nov-2012.) $)
  biorf $p |- ( -. ph -> ( ps <-> ( ph \/ ps ) ) ) $=
    wph wn wps wph wps wo wps wph olc wph wps orel1 impbid2 $.

  $( A wff is equivalent to its negated disjunction with falsehood.
     (Contributed by NM, 9-Jul-2012.) $)
  biortn $p |- ( ph -> ( ps <-> ( -. ph \/ ps ) ) ) $=
    wph wph wn wn wps wph wn wps wo wb wph notnot wph wn wps biorf syl $.

  ${
    biorfi.1 $e |- -. ph $.
    $( The dual of ~ biorf is not ~ biantr but ~ iba (and ~ ibar ).  So there
       should also be a "biorfr".  (Note that these four statements can
       actually be strengthened to biconditionals.)  (Contributed by BJ,
       26-Oct-2019.) $)
    biorfi $p |- ( ps <-> ( ph \/ ps ) ) $=
      wph wn wps wph wps wo wb biorfi.1 wph wps biorf ax-mp $.

    $( A wff is equivalent to its disjunction with falsehood.  (Contributed by
       NM, 23-Mar-1995.)  (Proof shortened by Wolf Lammen, 16-Jul-2021.)
       (Proof shortened by AV, 10-Aug-2025.) $)
    biorfri $p |- ( ps <-> ( ps \/ ph ) ) $=
      wps wph wps wo wps wph wo wph wps biorfi.1 biorfi wph wps orcom bitri $.

    $( Obsolete version of ~ biorfri as of 10-Aug-2025.  A wff is equivalent to
       its disjunction with falsehood.  (Contributed by NM, 23-Mar-1995.)
       (Proof shortened by Wolf Lammen, 16-Jul-2021.)
       (New usage is discouraged.)  (Proof modification is discouraged.) $)
    biorfriOLD $p |- ( ps <-> ( ps \/ ph ) ) $=
      wps wps wph wo wps wph orc wps wph wo wps wph biorfi.1 wps wph pm2.53
      mt3i impbii $.
  $}

  $( Rewriting implication based theorems using disjunction. $)

  $( Theorem *2.26 of [WhiteheadRussell] p. 104.  See ~ pm2.27 .  (Contributed
     by NM, 3-Jan-2005.)  (Proof shortened by Wolf Lammen, 23-Nov-2012.) $)
  pm2.26 $p |- ( -. ph \/ ( ( ph -> ps ) -> ps ) ) $=
    wph wph wps wi wps wi wph wps pm2.27 imori $.

  $( Contradiction and disjunction. $)

  $( Theorem *2.63 of [WhiteheadRussell] p. 107.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.63 $p |- ( ( ph \/ ps ) -> ( ( -. ph \/ ps ) -> ps ) ) $=
    wph wps wo wph wn wps wps wph wps pm2.53 wph wps wo wps idd jaod $.

  $( Theorem *2.64 of [WhiteheadRussell] p. 107.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.64 $p |- ( ( ph \/ ps ) -> ( ( ph \/ -. ps ) -> ph ) ) $=
    wph wps wn wo wph wps wo wph wph wps wn wph wps wo wps wph orel2 jao1i
    com12 $.

  $( Theorem *2.42 of [WhiteheadRussell] p. 106.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.42 $p |- ( ( -. ph \/ ( ph -> ps ) ) -> ( ph -> ps ) ) $=
    wph wn wph wps wi wph wps wi wph wps pm2.21 wph wps wi id jaoi $.

$( Some expressions connecting implication and disjunction. $)

  $( A general instance of Theorem *5.11 of [WhiteheadRussell] p. 123.
     (Contributed by NM, 3-Jan-2005.) $)
  pm5.11g $p |- ( ( ph -> ps ) \/ ( -. ph -> ch ) ) $=
    wph wps wi wph wn wch wi wph wps wch pm2.5g orri $.

  $( Theorem *5.11 of [WhiteheadRussell] p. 123.  (Contributed by NM,
     3-Jan-2005.) $)
  pm5.11 $p |- ( ( ph -> ps ) \/ ( -. ph -> ps ) ) $=
    wph wps wps pm5.11g $.

  $( Theorem *5.12 of [WhiteheadRussell] p. 123.  (Contributed by NM,
     3-Jan-2005.) $)
  pm5.12 $p |- ( ( ph -> ps ) \/ ( ph -> -. ps ) ) $=
    wph wps wi wph wps wn wi wph wps pm2.51 orri $.

  $( Theorem *5.14 of [WhiteheadRussell] p. 123.  (Contributed by NM,
     3-Jan-2005.) $)
  pm5.14 $p |- ( ( ph -> ps ) \/ ( ps -> ch ) ) $=
    wph wps wi wps wch wi wph wps wch pm2.521g orri $.

  $( Theorem *5.13 of [WhiteheadRussell] p. 123.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 14-Nov-2012.) $)
  pm5.13 $p |- ( ( ph -> ps ) \/ ( ps -> ph ) ) $=
    wph wps wph pm5.14 $.

  $( Theorem *5.55 of [WhiteheadRussell] p. 125.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 20-Jan-2013.) $)
  pm5.55 $p |- ( ( ( ph \/ ps ) <-> ph ) \/ ( ( ph \/ ps ) <-> ps ) ) $=
    wph wps wo wph wb wph wps wo wps wb wph wph wps wo wph wb wph wps wo wps wb
    wph wph wph wps wo wph wps biort bicomd wph wn wps wph wps wo wph wps biorf
    bicomd nsyl5 orri $.

  $( Implication in terms of biconditional and disjunction.  Theorem *4.72 of
     [WhiteheadRussell] p. 121.  (Contributed by NM, 30-Aug-1993.)  (Proof
     shortened by Wolf Lammen, 30-Jan-2013.) $)
  pm4.72 $p |- ( ( ph -> ps ) <-> ( ps <-> ( ph \/ ps ) ) ) $=
    wph wps wi wps wph wps wo wb wph wps wi wps wph wps wo wps wph olc wph wps
    pm2.621 impbid2 wph wph wps wo wps wph wps wo wb wps wph wps orc wps wph
    wps wo biimpr syl5 impbii $.

  $( Simplify an implication between implications.  (Contributed by Paul
     Chapman, 17-Nov-2012.)  (Proof shortened by Wolf Lammen, 3-Apr-2013.) $)
  imimorb $p |- ( ( ( ps -> ch ) -> ( ph -> ch ) ) <->
                  ( ph -> ( ps \/ ch ) ) ) $=
    wps wch wi wph wch wi wi wph wps wch wi wch wi wi wph wps wch wo wi wps wch
    wi wph wch bi2.04 wps wch wo wps wch wi wch wi wph wps wch dfor2 imbi2i
    bitr4i $.

  $( Absorption of disjunction into equivalence.  (Contributed by NM,
     6-Aug-1995.)  (Proof shortened by Wolf Lammen, 3-Nov-2013.) $)
  oibabs $p |- ( ( ( ph \/ ps ) -> ( ph <-> ps ) ) <-> ( ph <-> ps ) ) $=
    wph wps wo wph wps wb wi wph wps wb wph wps wo wph wps wb wph wps wb wph
    wps norbi wph wps wb id ja wph wps wb wph wps wo ax-1 impbii $.

  $( Disjunction distributes over the biconditional.  An axiom of system DS in
     Vladimir Lifschitz, "On calculational proofs" (1998),
     ~ http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.25.3384 .
     (Contributed by NM, 8-Jan-2005.)  (Proof shortened by Wolf Lammen,
     4-Feb-2013.) $)
  orbidi $p |- ( ( ph \/ ( ps <-> ch ) ) <->
                ( ( ph \/ ps ) <-> ( ph \/ ch ) ) ) $=
    wph wn wps wch wb wi wph wn wps wi wph wn wch wi wb wph wps wch wb wo wph
    wps wo wph wch wo wb wph wn wps wch pm5.74 wph wps wch wb df-or wph wps wo
    wph wn wps wi wph wch wo wph wn wch wi wph wps df-or wph wch df-or bibi12i
    3bitr4i $.

  $( Disjunction distributes over the biconditional.  Theorem *5.7 of
     [WhiteheadRussell] p. 125.  This theorem is similar to ~ orbidi .
     (Contributed by Roy F. Longton, 21-Jun-2005.) $)
  pm5.7 $p |- ( ( ( ph \/ ch ) <-> ( ps \/ ch ) ) <->
               ( ch \/ ( ph <-> ps ) ) ) $=
    wch wph wps wb wo wch wph wo wch wps wo wb wph wch wo wps wch wo wb wch wph
    wps orbidi wch wph wo wph wch wo wch wps wo wps wch wo wch wph orcom wch
    wps orcom bibi12i bitr2i $.


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Mixed connectives
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  This section gathers theorems of propositional calculus which use (either in
  their statement or proof) mixed connectives (at least conjunction and
  disjunction).

  As noted in the "note on definitions" in the section comment for logical
  equivalence, some theorem statements may contain for instance only
  conjunction or only disjunction, but both definitions are used in their
  proofs to make them shorter (this is exemplified in ~ orim12d versus
  ~ orim12dALT ).  These theorems are mostly grouped at the beginning of this
  section.

  The family of theorems starting with ~ animorl focus on the relation between
  conjunction and disjunction and can be seen as the starting point of mixed
  connectives in statements.  This sectioning is not rigorously true, since for
  instance the section begins with ~ jaao and related theorems.

$)

  ${
    jaao.1 $e |- ( ph -> ( ps -> ch ) ) $.
    jaao.2 $e |- ( th -> ( ta -> ch ) ) $.
    $( Inference conjoining and disjoining the antecedents of two implications.
       (Contributed by NM, 30-Sep-1999.) $)
    jaao $p |- ( ( ph /\ th ) -> ( ( ps \/ ta ) -> ch ) ) $=
      wph wth wa wps wch wta wph wps wch wi wth jaao.1 adantr wth wta wch wi
      wph jaao.2 adantl jaod $.

    $( Inference disjoining and conjoining the antecedents of two implications.
       (Contributed by Stefan Allan, 1-Nov-2008.) $)
    jaoa $p |- ( ( ph \/ th ) -> ( ( ps /\ ta ) -> ch ) ) $=
      wph wps wta wa wch wi wth wph wps wch wta jaao.1 adantrd wth wta wch wps
      jaao.2 adantld jaoi $.
  $}

  ${
    jaoian.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    jaoian.2 $e |- ( ( th /\ ps ) -> ch ) $.
    $( Inference disjoining the antecedents of two implications.  (Contributed
       by NM, 23-Oct-2005.) $)
    jaoian $p |- ( ( ( ph \/ th ) /\ ps ) -> ch ) $=
      wph wth wo wps wch wph wps wch wi wth wph wps wch jaoian.1 ex wth wps wch
      jaoian.2 ex jaoi imp $.
  $}

  ${
    jaodan.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    jaodan.2 $e |- ( ( ph /\ th ) -> ch ) $.
    $( Deduction disjoining the antecedents of two implications.  (Contributed
       by NM, 14-Oct-2005.) $)
    jaodan $p |- ( ( ph /\ ( ps \/ th ) ) -> ch ) $=
      wph wps wth wo wch wph wps wch wth wph wps wch jaodan.1 ex wph wth wch
      jaodan.2 ex jaod imp $.

    jaodan.3 $e |- ( ph -> ( ps \/ th ) ) $.
    $( Eliminate a disjunction in a deduction.  A translation of natural
       deduction rule ` \/ ` E ( ` \/ ` elimination), see ~ natded .
       (Contributed by Mario Carneiro, 29-May-2016.) $)
    mpjaodan $p |- ( ph -> ch ) $=
      wph wps wth wo wch jaodan.3 wph wps wch wth jaodan.1 jaodan.2 jaodan
      mpdan $.
  $}

  $( Theorem *3.44 of [WhiteheadRussell] p. 113.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 3-Oct-2013.) $)
  pm3.44 $p |- ( ( ( ps -> ph ) /\ ( ch -> ph ) )
      -> ( ( ps \/ ch ) -> ph ) ) $=
    wps wph wi wps wph wch wph wi wch wps wph wi id wch wph wi id jaao $.

  $( Disjunction of antecedents.  Compare Theorem *3.44 of [WhiteheadRussell]
     p. 113.  (Contributed by NM, 5-Apr-1994.)  (Proof shortened by Wolf
     Lammen, 4-Apr-2013.) $)
  jao $p |- ( ( ph -> ps ) -> ( ( ch -> ps ) -> ( ( ph \/ ch ) -> ps ) ) ) $=
    wph wps wi wch wps wi wph wch wo wps wi wps wph wch pm3.44 ex $.

  $( Disjunction of antecedents.  Compare Theorem *4.77 of [WhiteheadRussell]
     p. 121.  (Contributed by NM, 30-May-1994.)  (Proof shortened by Wolf
     Lammen, 9-Dec-2012.) $)
  jaob $p |- ( ( ( ph \/ ch ) -> ps ) <-> ( ( ph -> ps ) /\ ( ch -> ps ) ) ) $=
    wph wch wo wps wi wph wps wi wch wps wi wa wph wch wo wps wi wph wps wi wch
    wps wi wph wps wch pm2.67-2 wch wph wch wo wps wch wph olc imim1i jca wps
    wph wch pm3.44 impbii $.

  $( Theorem *4.77 of [WhiteheadRussell] p. 121.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.77 $p |- ( ( ( ps -> ph ) /\ ( ch -> ph ) ) <->
                ( ( ps \/ ch ) -> ph ) ) $=
    wps wch wo wph wi wps wph wi wch wph wi wa wps wph wch jaob bicomi $.

  $( Theorem *3.48 of [WhiteheadRussell] p. 114.  (Contributed by NM,
     28-Jan-1997.) $)
  pm3.48 $p |- ( ( ( ph -> ps ) /\ ( ch -> th ) )
      -> ( ( ph \/ ch ) -> ( ps \/ th ) ) ) $=
    wph wps wi wph wps wth wo wch wth wi wch wps wps wth wo wph wps wth orc
    imim2i wth wps wth wo wch wth wps olc imim2i jaao $.

  ${
    orim12d.1 $e |- ( ph -> ( ps -> ch ) ) $.
    orim12d.2 $e |- ( ph -> ( th -> ta ) ) $.
    $( Disjoin antecedents and consequents in a deduction.  See ~ orim12dALT
       for a proof which does not depend on ~ df-an .  (Contributed by NM,
       10-May-1994.) $)
    orim12d $p |- ( ph -> ( ( ps \/ th ) -> ( ch \/ ta ) ) ) $=
      wph wps wch wi wth wta wi wps wth wo wch wta wo wi orim12d.1 orim12d.2
      wps wch wth wta pm3.48 syl2anc $.
  $}

  ${
    orim1d.1 $e |- ( ph -> ( ps -> ch ) ) $.
    $( Disjoin antecedents and consequents in a deduction.  (Contributed by NM,
       23-Apr-1995.) $)
    orim1d $p |- ( ph -> ( ( ps \/ th ) -> ( ch \/ th ) ) ) $=
      wph wps wch wth wth orim1d.1 wph wth idd orim12d $.

    $( Disjoin antecedents and consequents in a deduction.  (Contributed by NM,
       23-Apr-1995.) $)
    orim2d $p |- ( ph -> ( ( th \/ ps ) -> ( th \/ ch ) ) ) $=
      wph wth wth wps wch wph wth idd orim1d.1 orim12d $.
  $}

  $( Axiom *1.6 (Sum) of [WhiteheadRussell] p. 97.  (Contributed by NM,
     3-Jan-2005.) $)
  orim2 $p |- ( ( ps -> ch ) -> ( ( ph \/ ps ) -> ( ph \/ ch ) ) ) $=
    wps wch wi wps wch wph wps wch wi id orim2d $.

  $( Theorem *2.38 of [WhiteheadRussell] p. 105.  (Contributed by NM,
     6-Mar-2008.) $)
  pm2.38 $p |- ( ( ps -> ch ) -> ( ( ps \/ ph ) -> ( ch \/ ph ) ) ) $=
    wps wch wi wps wch wph wps wch wi id orim1d $.

  $( Theorem *2.36 of [WhiteheadRussell] p. 105.  (Contributed by NM,
     6-Mar-2008.) $)
  pm2.36 $p |- ( ( ps -> ch ) -> ( ( ph \/ ps ) -> ( ch \/ ph ) ) ) $=
    wph wps wo wps wph wo wps wch wi wch wph wo wph wps pm1.4 wph wps wch
    pm2.38 syl5 $.

  $( Theorem *2.37 of [WhiteheadRussell] p. 105.  (Contributed by NM,
     6-Mar-2008.) $)
  pm2.37 $p |- ( ( ps -> ch ) -> ( ( ps \/ ph ) -> ( ph \/ ch ) ) ) $=
    wps wch wi wps wph wo wch wph wo wph wch wo wph wps wch pm2.38 wch wph
    pm1.4 syl6 $.

  $( Theorem *2.81 of [WhiteheadRussell] p. 108.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.81 $p |- ( ( ps -> ( ch -> th ) )
      -> ( ( ph \/ ps ) -> ( ( ph \/ ch ) -> ( ph \/ th ) ) ) ) $=
    wps wch wth wi wi wph wps wo wph wch wth wi wo wph wch wo wph wth wo wi wph
    wps wch wth wi orim2 wph wch wth pm2.76 syl6 $.

  $( Theorem *2.8 of [WhiteheadRussell] p. 108.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 5-Jan-2013.) $)
  pm2.8 $p |- ( ( ph \/ ps ) -> ( ( -. ps \/ ch ) -> ( ph \/ ch ) ) ) $=
    wph wps wo wps wn wph wch wph wps wo wph wps wph wps pm2.53 con1d orim1d $.

  $( Theorem *2.73 of [WhiteheadRussell] p. 108.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.73 $p |- ( ( ph -> ps )
       -> ( ( ( ph \/ ps ) \/ ch ) -> ( ps \/ ch ) ) ) $=
    wph wps wi wph wps wo wps wch wph wps pm2.621 orim1d $.

  $( Theorem *2.74 of [WhiteheadRussell] p. 108.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Andrew Salmon, 7-May-2011.) $)
  pm2.74 $p |- ( ( ps -> ph )
      -> ( ( ( ph \/ ps ) \/ ch ) -> ( ph \/ ch ) ) ) $=
    wps wph wi wph wps wo wph wch wps wph wph wps wo wph wi wps wph orel2 wph
    wph wps wo ax-1 ja orim1d $.

  $( Theorem *2.82 of [WhiteheadRussell] p. 108.  (Contributed by NM,
     3-Jan-2005.) $)
  pm2.82 $p |- ( ( ( ph \/ ps ) \/ ch ) -> ( ( ( ph \/ -. ch ) \/ th )
      -> ( ( ph \/ ps ) \/ th ) ) ) $=
    wph wps wo wch wo wph wch wn wo wph wps wo wth wph wps wo wch wph wch wn wo
    wch wch wn wps wph wch wps pm2.24 orim2d jao1i orim1d $.

  $( Theorem *4.39 of [WhiteheadRussell] p. 118.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.39 $p |- ( ( ( ph <-> ch ) /\ ( ps <-> th ) ) ->
                ( ( ph \/ ps ) <-> ( ch \/ th ) ) ) $=
    wph wch wb wps wth wb wa wph wch wps wth wph wch wb wps wth wb simpl wph
    wch wb wps wth wb simpr orbi12d $.

  $( Conjunction implies disjunction with one common formula (1/4).
     (Contributed by BJ, 4-Oct-2019.) $)
  animorl $p |- ( ( ph /\ ps ) -> ( ph \/ ch ) ) $=
    wph wps wa wph wch wph wps simpl orcd $.

  $( Conjunction implies disjunction with one common formula (2/4).
     (Contributed by BJ, 4-Oct-2019.) $)
  animorr $p |- ( ( ph /\ ps ) -> ( ch \/ ps ) ) $=
    wph wps wa wps wch wph wps simpr olcd $.

  $( Conjunction implies disjunction with one common formula (3/4).
     (Contributed by BJ, 4-Oct-2019.) $)
  animorlr $p |- ( ( ph /\ ps ) -> ( ch \/ ph ) ) $=
    wph wps wa wph wch wph wps simpl olcd $.

  $( Conjunction implies disjunction with one common formula (4/4).
     (Contributed by BJ, 4-Oct-2019.) $)
  animorrl $p |- ( ( ph /\ ps ) -> ( ps \/ ch ) ) $=
    wph wps wa wps wch wph wps simpr orcd $.

  $( Negated conjunction in terms of disjunction (De Morgan's law).  Theorem
     *4.51 of [WhiteheadRussell] p. 120.  (Contributed by NM, 14-May-1993.)
     (Proof shortened by Andrew Salmon, 13-May-2011.) $)
  ianor $p |- ( -. ( ph /\ ps ) <-> ( -. ph \/ -. ps ) ) $=
    wph wps wa wn wph wps wn wi wph wn wps wn wo wph wps imnan wph wps pm4.62
    bitr3i $.

  $( Conjunction in terms of disjunction (De Morgan's law).  Theorem *4.5 of
     [WhiteheadRussell] p. 120.  (Contributed by NM, 3-Jan-1993.)  (Proof
     shortened by Wolf Lammen, 3-Nov-2012.) $)
  anor $p |- ( ( ph /\ ps ) <-> -. ( -. ph \/ -. ps ) ) $=
    wph wps wa wph wps wa wn wph wn wps wn wo wph wps wa notnotb wph wps ianor
    xchbinx $.

  $( Negated disjunction in terms of conjunction (De Morgan's law).  Compare
     Theorem *4.56 of [WhiteheadRussell] p. 120.  (Contributed by NM,
     3-Jan-1993.)  (Proof shortened by Andrew Salmon, 7-May-2011.) $)
  ioran $p |- ( -. ( ph \/ ps ) <-> ( -. ph /\ -. ps ) ) $=
    wph wn wps wi wph wn wps wn wa wph wps wo wph wps pm4.65 wph wps pm4.64
    xchnxbi $.

  $( Theorem *4.52 of [WhiteheadRussell] p. 120.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 5-Nov-2012.) $)
  pm4.52 $p |- ( ( ph /\ -. ps ) <-> -. ( -. ph \/ ps ) ) $=
    wph wps wn wa wph wps wi wph wn wps wo wph wps annim wph wps imor xchbinx
    $.

  $( Theorem *4.53 of [WhiteheadRussell] p. 120.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.53 $p |- ( -. ( ph /\ -. ps ) <-> ( -. ph \/ ps ) ) $=
    wph wn wps wo wph wps wn wa wn wph wps wn wa wph wn wps wo wph wps pm4.52
    con2bii bicomi $.

  $( Theorem *4.54 of [WhiteheadRussell] p. 120.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 5-Nov-2012.) $)
  pm4.54 $p |- ( ( -. ph /\ ps ) <-> -. ( ph \/ -. ps ) ) $=
    wph wn wps wa wph wn wps wn wi wph wps wn wo wph wn wps df-an wph wps
    pm4.66 xchbinx $.

  $( Theorem *4.55 of [WhiteheadRussell] p. 120.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.55 $p |- ( -. ( -. ph /\ ps ) <-> ( ph \/ -. ps ) ) $=
    wph wps wn wo wph wn wps wa wn wph wn wps wa wph wps wn wo wph wps pm4.54
    con2bii bicomi $.

  $( Theorem *4.56 of [WhiteheadRussell] p. 120.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.56 $p |- ( ( -. ph /\ -. ps ) <-> -. ( ph \/ ps ) ) $=
    wph wps wo wn wph wn wps wn wa wph wps ioran bicomi $.

  $( Disjunction in terms of conjunction (De Morgan's law).  Compare Theorem
     *4.57 of [WhiteheadRussell] p. 120.  (Contributed by NM, 3-Jan-1993.)
     (Proof shortened by Andrew Salmon, 7-May-2011.) $)
  oran $p |- ( ( ph \/ ps ) <-> -. ( -. ph /\ -. ps ) ) $=
    wph wn wps wn wa wph wps wo wph wps pm4.56 con2bii $.

  $( Theorem *4.57 of [WhiteheadRussell] p. 120.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.57 $p |- ( -. ( -. ph /\ -. ps ) <-> ( ph \/ ps ) ) $=
    wph wps wo wph wn wps wn wa wn wph wps oran bicomi $.

  $( Theorem *3.1 of [WhiteheadRussell] p. 111.  (Contributed by NM,
     3-Jan-2005.) $)
  pm3.1 $p |- ( ( ph /\ ps ) -> -. ( -. ph \/ -. ps ) ) $=
    wph wps wa wph wn wps wn wo wn wph wps anor biimpi $.

  $( Theorem *3.11 of [WhiteheadRussell] p. 111.  (Contributed by NM,
     3-Jan-2005.) $)
  pm3.11 $p |- ( -. ( -. ph \/ -. ps ) -> ( ph /\ ps ) ) $=
    wph wps wa wph wn wps wn wo wn wph wps anor biimpri $.

  $( Theorem *3.12 of [WhiteheadRussell] p. 111.  (Contributed by NM,
     3-Jan-2005.) $)
  pm3.12 $p |- ( ( -. ph \/ -. ps ) \/ ( ph /\ ps ) ) $=
    wph wn wps wn wo wph wps wa wph wps pm3.11 orri $.

  $( Theorem *3.13 of [WhiteheadRussell] p. 111.  (Contributed by NM,
     3-Jan-2005.) $)
  pm3.13 $p |- ( -. ( ph /\ ps ) -> ( -. ph \/ -. ps ) ) $=
    wph wn wps wn wo wph wps wa wph wps pm3.11 con1i $.

  $( Theorem *3.14 of [WhiteheadRussell] p. 111.  (Contributed by NM,
     3-Jan-2005.) $)
  pm3.14 $p |- ( ( -. ph \/ -. ps ) -> -. ( ph /\ ps ) ) $=
    wph wps wa wph wn wps wn wo wph wps pm3.1 con2i $.

  $( Theorem *4.44 of [WhiteheadRussell] p. 119.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.44 $p |- ( ph <-> ( ph \/ ( ph /\ ps ) ) ) $=
    wph wph wph wps wa wo wph wph wps wa orc wph wph wph wps wa wph id wph wps
    simpl jaoi impbii $.

  $( Theorem *4.45 of [WhiteheadRussell] p. 119.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.45 $p |- ( ph <-> ( ph /\ ( ph \/ ps ) ) ) $=
    wph wph wps wo wph wps orc pm4.71i $.

  $( Absorption of redundant internal disjunct.  Compare Theorem *4.45 of
     [WhiteheadRussell] p. 119.  (Contributed by NM, 21-Jun-1993.)  (Proof
     shortened by Wolf Lammen, 28-Feb-2014.) $)
  orabs $p |- ( ph <-> ( ( ph \/ ps ) /\ ph ) ) $=
    wph wph wps wo wph wps orc pm4.71ri $.

  $( Absorb a disjunct into a conjunct.  (Contributed by Roy F. Longton,
     23-Jun-2005.)  (Proof shortened by Wolf Lammen, 10-Nov-2013.) $)
  oranabs $p |- ( ( ( ph \/ -. ps ) /\ ps ) <-> ( ph /\ ps ) ) $=
    wps wph wps wn wo wph wps wph wps wn wph wo wph wps wn wo wps wph biortn
    wps wn wph orcom bitr2di pm5.32ri $.

  $( Theorem *5.61 of [WhiteheadRussell] p. 125.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 30-Jun-2013.) $)
  pm5.61 $p |- ( ( ( ph \/ ps ) /\ -. ps ) <-> ( ph /\ -. ps ) ) $=
    wps wn wph wps wo wph wps wn wph wps wo wph wps wph orel2 wph wps orc
    impbid1 pm5.32ri $.

  $( Conjunction in antecedent versus disjunction in consequent.  Theorem *5.6
     of [WhiteheadRussell] p. 125.  (Contributed by NM, 8-Jun-1994.) $)
  pm5.6 $p |- ( ( ( ph /\ -. ps ) -> ch ) <-> ( ph -> ( ps \/ ch ) ) ) $=
    wph wps wn wa wch wi wph wps wn wch wi wi wph wps wch wo wi wph wps wn wch
    impexp wps wch wo wps wn wch wi wph wps wch df-or imbi2i bitr4i $.

  ${
    orcanai.1 $e |- ( ph -> ( ps \/ ch ) ) $.
    $( Change disjunction in consequent to conjunction in antecedent.
       (Contributed by NM, 8-Jun-1994.) $)
    orcanai $p |- ( ( ph /\ -. ps ) -> ch ) $=
      wph wps wn wch wph wps wch orcanai.1 ord imp $.
  $}

  $( Theorem *4.79 of [WhiteheadRussell] p. 121.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 27-Jun-2013.) $)
  pm4.79 $p |- ( ( ( ps -> ph ) \/ ( ch -> ph ) ) <->
                ( ( ps /\ ch ) -> ph ) ) $=
    wps wph wi wch wph wi wo wps wch wa wph wi wps wph wi wps wph wch wph wi
    wch wps wph wi id wch wph wi id jaoa wps wch wa wph wi wps wph wi wch wph
    wi wps wph wi wn wps wps wch wa wph wi wch wph wi wps wph simplim wps wch
    wph pm3.3 syl5 orrd impbii $.

  $( Theorem *5.53 of [WhiteheadRussell] p. 125.  (Contributed by NM,
     3-Jan-2005.) $)
  pm5.53 $p |- ( ( ( ( ph \/ ps ) \/ ch ) -> th ) <->
                ( ( ( ph -> th ) /\ ( ps -> th ) ) /\ ( ch -> th ) ) ) $=
    wph wps wo wch wo wth wi wph wps wo wth wi wch wth wi wph wth wi wps wth wi
    wa wph wps wo wth wch jaob wph wth wps jaob bianbi $.

  $( Distributive law for disjunction.  Theorem *4.41 of [WhiteheadRussell]
     p. 119.  (Contributed by NM, 5-Jan-1993.)  (Proof shortened by Andrew
     Salmon, 7-May-2011.)  (Proof shortened by Wolf Lammen, 28-Nov-2013.) $)
  ordi $p |- ( ( ph \/ ( ps /\ ch ) ) <-> ( ( ph \/ ps ) /\ ( ph \/ ch ) ) ) $=
    wph wn wps wch wa wi wph wn wps wi wph wn wch wi wa wph wps wch wa wo wph
    wps wo wph wch wo wa wph wn wps wch jcab wph wps wch wa df-or wph wps wo
    wph wn wps wi wph wch wo wph wn wch wi wph wps df-or wph wch df-or anbi12i
    3bitr4i $.

  $( Distributive law for disjunction.  (Contributed by NM, 12-Aug-1994.) $)
  ordir $p |- ( ( ( ph /\ ps ) \/ ch ) <->
              ( ( ph \/ ch ) /\ ( ps \/ ch ) ) ) $=
    wch wph wps wa wo wch wph wo wch wps wo wa wph wps wa wch wo wph wch wo wps
    wch wo wa wch wph wps ordi wph wps wa wch orcom wph wch wo wch wph wo wps
    wch wo wch wps wo wph wch orcom wps wch orcom anbi12i 3bitr4i $.

  $( Distributive law for conjunction.  Theorem *4.4 of [WhiteheadRussell]
     p. 118.  (Contributed by NM, 21-Jun-1993.)  (Proof shortened by Wolf
     Lammen, 5-Jan-2013.) $)
  andi $p |- ( ( ph /\ ( ps \/ ch ) ) <-> ( ( ph /\ ps ) \/ ( ph /\ ch ) ) ) $=
    wph wps wch wo wa wph wps wa wph wch wa wo wph wps wph wps wa wph wch wa wo
    wch wph wps wa wph wch wa orc wph wch wa wph wps wa olc jaodan wph wps wa
    wph wps wch wo wa wph wch wa wps wps wch wo wph wps wch orc anim2i wch wps
    wch wo wph wch wps olc anim2i jaoi impbii $.

  $( Distributive law for conjunction.  (Contributed by NM, 12-Aug-1994.) $)
  andir $p |- ( ( ( ph \/ ps ) /\ ch ) <->
              ( ( ph /\ ch ) \/ ( ps /\ ch ) ) ) $=
    wch wph wps wo wa wch wph wa wch wps wa wo wph wps wo wch wa wph wch wa wps
    wch wa wo wch wph wps andi wph wps wo wch ancom wph wch wa wch wph wa wps
    wch wa wch wps wa wph wch ancom wps wch ancom orbi12i 3bitr4i $.

  $( Double distributive law for disjunction.  (Contributed by NM,
     12-Aug-1994.) $)
  orddi $p |- ( ( ( ph /\ ps ) \/ ( ch /\ th ) ) <->
              ( ( ( ph \/ ch ) /\ ( ph \/ th ) ) /\
              ( ( ps \/ ch ) /\ ( ps \/ th ) ) ) ) $=
    wph wps wa wch wth wa wo wph wch wth wa wo wps wch wth wa wo wa wph wch wo
    wph wth wo wa wps wch wo wps wth wo wa wa wph wps wch wth wa ordir wph wch
    wth wa wo wph wch wo wph wth wo wa wps wch wth wa wo wps wch wo wps wth wo
    wa wph wch wth ordi wps wch wth ordi anbi12i bitri $.

  $( Double distributive law for conjunction.  (Contributed by NM,
     12-Aug-1994.) $)
  anddi $p |- ( ( ( ph \/ ps ) /\ ( ch \/ th ) ) <->
              ( ( ( ph /\ ch ) \/ ( ph /\ th ) ) \/
              ( ( ps /\ ch ) \/ ( ps /\ th ) ) ) ) $=
    wph wps wo wch wth wo wa wph wch wth wo wa wps wch wth wo wa wo wph wch wa
    wph wth wa wo wps wch wa wps wth wa wo wo wph wps wch wth wo andir wph wch
    wth wo wa wph wch wa wph wth wa wo wps wch wth wo wa wps wch wa wps wth wa
    wo wph wch wth andi wps wch wth andi orbi12i bitri $.

$( Theorems relating XOR to conjunction or disjunction. $)

  $( Theorem *5.17 of [WhiteheadRussell] p. 124.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 3-Jan-2013.) $)
  pm5.17 $p |- ( ( ( ph \/ ps ) /\ -. ( ph /\ ps ) ) <-> ( ph <-> -. ps ) ) $=
    wph wps wn wb wps wn wph wb wps wn wph wi wph wps wn wi wa wph wps wo wph
    wps wa wn wa wph wps wn bicom wps wn wph dfbi2 wps wn wph wi wph wps wo wph
    wps wn wi wph wps wa wn wph wps wo wps wph wo wps wn wph wi wph wps orcom
    wps wph df-or bitr2i wph wps imnan anbi12i 3bitrri $.

  $( Theorem *5.15 of [WhiteheadRussell] p. 124.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 15-Oct-2013.) $)
  pm5.15 $p |- ( ( ph <-> ps ) \/ ( ph <-> -. ps ) ) $=
    wph wps wb wph wps wn wb wph wps wb wn wph wps wn wb wph wps xor3 biimpi
    orri $.

  $( Theorem *5.16 of [WhiteheadRussell] p. 124.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 17-Oct-2013.) $)
  pm5.16 $p |- -. ( ( ph <-> ps ) /\ ( ph <-> -. ps ) ) $=
    wph wps wb wph wps wn wb wn wi wph wps wb wph wps wn wb wa wn wph wps wb
    wph wps wn wb wn wph wps pm5.18 biimpi wph wps wb wph wps wn wb imnan mpbi
    $.

  $( Two ways to express exclusive disjunction ( ~ df-xor ).  Theorem *5.22 of
     [WhiteheadRussell] p. 124.  (Contributed by NM, 3-Jan-2005.)  (Proof
     shortened by Wolf Lammen, 22-Jan-2013.) $)
  xor $p |- ( -. ( ph <-> ps ) <->
                ( ( ph /\ -. ps ) \/ ( ps /\ -. ph ) ) ) $=
    wph wps wn wa wps wph wn wa wo wph wps wb wph wps wi wps wph wi wa wph wps
    wn wa wn wps wph wn wa wn wa wph wps wb wph wps wn wa wps wph wn wa wo wn
    wph wps wi wph wps wn wa wn wps wph wi wps wph wn wa wn wph wps iman wps
    wph iman anbi12i wph wps dfbi2 wph wps wn wa wps wph wn wa ioran 3bitr4ri
    con1bii $.

  $( Two ways to express "exclusive or".  (Contributed by NM, 3-Jan-2005.)
     (Proof shortened by Wolf Lammen, 24-Jan-2013.) $)
  nbi2 $p |- ( -. ( ph <-> ps ) <-> ( ( ph \/ ps ) /\ -. ( ph /\ ps ) ) ) $=
    wph wps wb wn wph wps wn wb wph wps wo wph wps wa wn wa wph wps xor3 wph
    wps pm5.17 bitr4i $.

  $( Conjunction distributes over exclusive-or, using ` -. ( ph <-> ps ) ` to
     express exclusive-or.  This is one way to interpret the distributive law
     of multiplication over addition in modulo 2 arithmetic.  This is not
     necessarily true in intuitionistic logic, though ~ anxordi does hold in
     it.  (Contributed by NM, 3-Oct-2008.) $)
  xordi $p |- ( ( ph /\ -. ( ps <-> ch ) ) <->
                -. ( ( ph /\ ps ) <-> ( ph /\ ch ) ) ) $=
    wph wps wch wb wn wa wph wps wch wb wi wph wps wa wph wch wa wb wph wps wch
    wb annim wph wps wch pm5.32 xchbinx $.

  $( Theorem *5.54 of [WhiteheadRussell] p. 125.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 7-Nov-2013.) $)
  pm5.54 $p |- ( ( ( ph /\ ps ) <-> ph ) \/ ( ( ph /\ ps ) <-> ps ) ) $=
    wph wps wa wph wb wph wps wa wps wb wph wps wa wph wps wa wph wb wps wps
    wph wps wa wph wb wph wps wph wph wps wa wps wph iba bicomd adantl wps wph
    wph wps wa wps wph iba bicomd pm5.21ni orri $.

  $( Theorem *5.62 of [WhiteheadRussell] p. 125.  (Contributed by Roy F.
     Longton, 21-Jun-2005.) $)
  pm5.62 $p |- ( ( ( ph /\ ps ) \/ -. ps ) <-> ( ph \/ -. ps ) ) $=
    wph wps wa wps wn wo wph wps wn wo wps wps wn wo wps exmid wph wps wps wn
    ordir mpbiran2 $.

  $( Theorem *5.63 of [WhiteheadRussell] p. 125.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 25-Dec-2012.) $)
  pm5.63 $p |- ( ( ph \/ ps ) <-> ( ph \/ ( -. ph /\ ps ) ) ) $=
    wph wph wn wps wa wo wph wps wo wph wph wn wps wa wo wph wph wn wo wph wps
    wo wph exmid wph wph wn wps ordi mpbiran bicomi $.

  ${
    niabn.1 $e |- ph $.
    $( Miscellaneous inference relating falsehoods.  (Contributed by NM,
       31-Mar-1994.) $)
    niabn $p |- ( -. ps -> ( ( ch /\ ps ) <-> -. ph ) ) $=
      wch wps wa wps wph wn wch wps simpr wph wps niabn.1 pm2.24i pm5.21ni $.
  $}

  ${
    ninba.1 $e |- ph $.
    $( Miscellaneous inference relating falsehoods.  (Contributed by NM,
       31-Mar-1994.) $)
    ninba $p |- ( -. ps -> ( -. ph <-> ( ch /\ ps ) ) ) $=
      wps wn wch wps wa wph wn wph wps wch ninba.1 niabn bicomd $.
  $}

  $( Theorem *4.43 of [WhiteheadRussell] p. 119.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Wolf Lammen, 26-Nov-2012.) $)
  pm4.43 $p |- ( ph <-> ( ( ph \/ ps ) /\ ( ph \/ -. ps ) ) ) $=
    wph wph wps wps wn wa wo wph wps wo wph wps wn wo wa wps wps wn wa wph wps
    pm3.24 biorfri wph wps wps wn ordi bitri $.

  $( Theorem *4.82 of [WhiteheadRussell] p. 122.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.82 $p |- ( ( ( ph -> ps ) /\ ( ph -> -. ps ) ) <-> -. ph ) $=
    wph wps wi wph wps wn wi wa wph wn wph wps wi wph wps wn wi wph wn wph wps
    pm2.65 imp wph wn wph wps wi wph wps wn wi wph wps pm2.21 wph wps wn pm2.21
    jca impbii $.

  $( Theorem *4.83 of [WhiteheadRussell] p. 122.  (Contributed by NM,
     3-Jan-2005.) $)
  pm4.83 $p |- ( ( ( ph -> ps ) /\ ( -. ph -> ps ) ) <-> ps ) $=
    wps wph wph wn wo wps wi wph wps wi wph wn wps wi wa wph wph wn wo wps wph
    exmid a1bi wph wps wph wn jaob bitr2i $.

  $( Negation inferred from embedded conjunct.  (Contributed by NM,
     20-Aug-1993.)  (Proof shortened by Wolf Lammen, 25-Nov-2012.) $)
  pclem6 $p |- ( ( ph <-> ( ps /\ -. ph ) ) -> -. ps ) $=
    wps wph wps wph wn wa wb wps wph wn wps wph wn wa wb wph wps wph wn wa wb
    wn wps wph wn ibar wph wps wph wn wa nbbn sylib con2i $.

  $( Dijkstra-Scholten's Golden Rule for calculational proofs.  (Contributed by
     NM, 10-Jan-2005.) $)
  bigolden $p |- ( ( ( ph /\ ps ) <-> ph ) <-> ( ps <-> ( ph \/ ps ) ) ) $=
    wph wps wi wph wph wps wa wb wps wph wps wo wb wph wps wa wph wb wph wps
    pm4.71 wph wps pm4.72 wph wph wps wa bicom 3bitr3ri $.

  $( Theorem *5.71 of [WhiteheadRussell] p. 125.  (Contributed by Roy F.
     Longton, 23-Jun-2005.) $)
  pm5.71 $p |- ( ( ps -> -. ch ) -> ( ( ( ph \/ ps ) /\ ch ) <->
                ( ph /\ ch ) ) ) $=
    wps wch wn wph wps wo wch wa wph wch wa wb wps wn wph wps wo wph wch wps wn
    wph wps wo wph wps wph orel2 wph wps orc impbid1 anbi1d wch wn wch wph wps
    wo wph wch wph wps wo wph wb pm2.21 pm5.32rd ja $.

  $( Theorem *5.75 of [WhiteheadRussell] p. 126.  (Contributed by NM,
     3-Jan-2005.)  (Proof shortened by Andrew Salmon, 7-May-2011.)  (Proof
     shortened by Wolf Lammen, 23-Dec-2012.)  (Proof shortened by Kyle Wyonch,
     12-Feb-2021.) $)
  pm5.75 $p |- ( ( ( ch -> -. ps ) /\ ( ph <-> ( ps \/ ch ) ) )
      -> ( ( ph /\ -. ps ) <-> ch ) ) $=
    wph wps wch wo wb wph wps wn wa wch wps wn wa wch wps wn wi wch wph wps wch
    wo wb wph wps wn wa wps wch wo wps wn wa wch wps wn wa wph wps wch wo wps
    wn anbi1 wps wn wps wch wo wch wps wn wch wps wch wo wps wch biorf bicomd
    pm5.32ri bitrdi wch wps wn wa wch wch wps wn wi wch wps wn abai rbaib
    sylan9bbr $.

  ${
    ecase2d.1 $e |- ( ph -> ps ) $.
    ecase2d.2 $e |- ( ph -> -. ( ps /\ ch ) ) $.
    ecase2d.3 $e |- ( ph -> -. ( ps /\ th ) ) $.
    ecase2d.4 $e |- ( ph -> ( ta \/ ( ch \/ th ) ) ) $.
    $( Deduction for elimination by cases.  (Contributed by NM, 21-Apr-1994.)
       (Proof shortened by Wolf Lammen, 19-Sep-2024.) $)
    ecase2d $p |- ( ph -> ta ) $=
      wph wta wph wta wn wch wth wph wps wch ecase2d.1 ecase2d.2 mpnanrd wph
      wps wth ecase2d.1 ecase2d.3 mpnanrd wph wta wch wth wo ecase2d.4 ord
      mtord notnotrd $.
  $}

  ${
    ecase3.1 $e |- ( ph -> ch ) $.
    ecase3.2 $e |- ( ps -> ch ) $.
    ecase3.3 $e |- ( -. ( ph \/ ps ) -> ch ) $.
    $( Inference for elimination by cases.  (Contributed by NM, 23-Mar-1995.)
       (Proof shortened by Wolf Lammen, 26-Nov-2012.) $)
    ecase3 $p |- ch $=
      wph wps wo wch wph wch wps ecase3.1 ecase3.2 jaoi ecase3.3 pm2.61i $.
  $}

  ${
    ecase.1 $e |- ( -. ph -> ch ) $.
    ecase.2 $e |- ( -. ps -> ch ) $.
    ecase.3 $e |- ( ( ph /\ ps ) -> ch ) $.
    $( Inference for elimination by cases.  (Contributed by NM,
       13-Jul-2005.) $)
    ecase $p |- ch $=
      wph wps wch wph wps wch ecase.3 ex ecase.1 ecase.2 pm2.61nii $.
  $}

  ${
    ecase3d.1 $e |- ( ph -> ( ps -> th ) ) $.
    ecase3d.2 $e |- ( ph -> ( ch -> th ) ) $.
    ecase3d.3 $e |- ( ph -> ( -. ( ps \/ ch ) -> th ) ) $.
    $( Deduction for elimination by cases.  (Contributed by NM, 2-May-1996.)
       (Proof shortened by Andrew Salmon, 7-May-2011.) $)
    ecase3d $p |- ( ph -> th ) $=
      wph wps wch wo wth wph wps wth wch ecase3d.1 ecase3d.2 jaod ecase3d.3
      pm2.61d $.
  $}

  ${
    ecased.1 $e |- ( ph -> ( -. ps -> th ) ) $.
    ecased.2 $e |- ( ph -> ( -. ch -> th ) ) $.
    ecased.3 $e |- ( ph -> ( ( ps /\ ch ) -> th ) ) $.
    $( Deduction for elimination by cases.  (Contributed by NM, 8-Oct-2012.) $)
    ecased $p |- ( ph -> th ) $=
      wph wps wn wch wn wth ecased.1 ecased.2 wps wn wch wn wo wn wps wch wa
      wph wth wps wch pm3.11 ecased.3 syl5 ecase3d $.
  $}

  ${
    ecase3ad.1 $e |- ( ph -> ( ps -> th ) ) $.
    ecase3ad.2 $e |- ( ph -> ( ch -> th ) ) $.
    ecase3ad.3 $e |- ( ph -> ( ( -. ps /\ -. ch ) -> th ) ) $.
    $( Deduction for elimination by cases.  (Contributed by NM, 24-May-2013.)
       (Proof shortened by Wolf Lammen, 20-Sep-2024.) $)
    ecase3ad $p |- ( ph -> th ) $=
      wph wps wch wth wph wps wth ecase3ad.1 imp wph wch wth ecase3ad.2 imp wph
      wps wn wch wn wa wth ecase3ad.3 imp pm2.61ddan $.
  $}

  ${
    ccase.1 $e |- ( ( ph /\ ps ) -> ta ) $.
    ccase.2 $e |- ( ( ch /\ ps ) -> ta ) $.
    ccase.3 $e |- ( ( ph /\ th ) -> ta ) $.
    ccase.4 $e |- ( ( ch /\ th ) -> ta ) $.
    $( Inference for combining cases.  (Contributed by NM, 29-Jul-1999.)
       (Proof shortened by Wolf Lammen, 6-Jan-2013.) $)
    ccase $p |- ( ( ( ph \/ ch ) /\ ( ps \/ th ) ) -> ta ) $=
      wph wch wo wps wta wth wph wps wta wch ccase.1 ccase.2 jaoian wph wth wta
      wch ccase.3 ccase.4 jaoian jaodan $.
  $}

  ${
    ccased.1 $e |- ( ph -> ( ( ps /\ ch ) -> et ) ) $.
    ccased.2 $e |- ( ph -> ( ( th /\ ch ) -> et ) ) $.
    ccased.3 $e |- ( ph -> ( ( ps /\ ta ) -> et ) ) $.
    ccased.4 $e |- ( ph -> ( ( th /\ ta ) -> et ) ) $.
    $( Deduction for combining cases.  (Contributed by NM, 9-May-2004.) $)
    ccased $p |- ( ph -> ( ( ( ps \/ th ) /\ ( ch \/ ta ) ) -> et ) ) $=
      wps wth wo wch wta wo wa wph wet wps wch wth wta wph wet wi wph wps wch
      wa wet ccased.1 com12 wph wth wch wa wet ccased.2 com12 wph wps wta wa
      wet ccased.3 com12 wph wth wta wa wet ccased.4 com12 ccase com12 $.
  $}

  ${
    ccase2.1 $e |- ( ( ph /\ ps ) -> ta ) $.
    ccase2.2 $e |- ( ch -> ta ) $.
    ccase2.3 $e |- ( th -> ta ) $.
    $( Inference for combining cases.  (Contributed by NM, 29-Jul-1999.) $)
    ccase2 $p |- ( ( ( ph \/ ch ) /\ ( ps \/ th ) ) -> ta ) $=
      wph wps wch wth wta ccase2.1 wch wta wps ccase2.2 adantr wth wta wph
      ccase2.3 adantl wth wta wch ccase2.3 adantl ccase $.
  $}

  ${
    4cases.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    4cases.2 $e |- ( ( ph /\ -. ps ) -> ch ) $.
    4cases.3 $e |- ( ( -. ph /\ ps ) -> ch ) $.
    4cases.4 $e |- ( ( -. ph /\ -. ps ) -> ch ) $.
    $( Inference eliminating two antecedents from the four possible cases that
       result from their true/false combinations.  (Contributed by NM,
       25-Oct-2003.) $)
    4cases $p |- ch $=
      wps wch wph wps wch 4cases.1 4cases.3 pm2.61ian wph wps wn wch 4cases.2
      4cases.4 pm2.61ian pm2.61i $.
  $}

  ${
    4casesdan.1 $e |- ( ( ph /\ ( ps /\ ch ) ) -> th ) $.
    4casesdan.2 $e |- ( ( ph /\ ( ps /\ -. ch ) ) -> th ) $.
    4casesdan.3 $e |- ( ( ph /\ ( -. ps /\ ch ) ) -> th ) $.
    4casesdan.4 $e |- ( ( ph /\ ( -. ps /\ -. ch ) ) -> th ) $.
    $( Deduction eliminating two antecedents from the four possible cases that
       result from their true/false combinations.  (Contributed by NM,
       19-Mar-2013.) $)
    4casesdan $p |- ( ph -> th ) $=
      wps wch wph wth wi wph wps wch wa wth 4casesdan.1 expcom wph wps wch wn
      wa wth 4casesdan.2 expcom wph wps wn wch wa wth 4casesdan.3 expcom wph
      wps wn wch wn wa wth 4casesdan.4 expcom 4cases $.
  $}

  ${
    cases.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    cases.2 $e |- ( -. ph -> ( ps <-> th ) ) $.
    $( Case disjunction according to the value of ` ph ` .  (Contributed by NM,
       25-Apr-2019.) $)
    cases $p |- ( ps <-> ( ( ph /\ ch ) \/ ( -. ph /\ th ) ) ) $=
      wps wph wph wn wo wps wa wph wps wa wph wn wps wa wo wph wch wa wph wn
      wth wa wo wph wph wn wo wps wph exmid biantrur wph wph wn wps andir wph
      wps wa wph wch wa wph wn wps wa wph wn wth wa wph wps wch cases.1 pm5.32i
      wph wn wps wth cases.2 pm5.32i orbi12i 3bitri $.
  $}

  $( Lemma for an alternate version of weak deduction theorem.  (Contributed by
     NM, 2-Apr-1994.)  (Proof shortened by Andrew Salmon, 7-May-2011.)  (Proof
     shortened by Wolf Lammen, 4-Dec-2012.) $)
  dedlem0a $p |- ( ph -> ( ps <-> ( ( ch -> ph ) -> ( ps /\ ph ) ) ) ) $=
    wph wps wps wph wa wch wph wi wps wph wa wi wph wps iba wch wph wps wph wa
    wch wph wi wps wph wa wi wb wch wph wi wps wph wa biimt jarri bitrd $.

  $( Lemma for an alternate version of weak deduction theorem.  (Contributed by
     NM, 2-Apr-1994.) $)
  dedlem0b $p |- ( -. ph -> ( ps <-> ( ( ps -> ph ) -> ( ch /\ ph ) ) ) ) $=
    wph wn wps wps wph wi wch wph wa wi wph wn wps wph wi wps wch wph wa wph wn
    wph wch wph wa wps wph wch wph wa pm2.21 imim2d com23 wps wph wi wch wph wa
    wi wph wn wps wps wph wi wch wph wa wi wps wph wps wn wps wph wi wch wph wa
    wph wps wph pm2.21 wch wph simpr imim12i con1d com12 impbid $.

  $( Lemma for weak deduction theorem.  See also ~ ifptru .  (Contributed by
     NM, 26-Jun-2002.)  (Proof shortened by Andrew Salmon, 7-May-2011.) $)
  dedlema $p |- ( ph -> ( ps <-> ( ( ps /\ ph ) \/ ( ch /\ -. ph ) ) ) ) $=
    wph wps wps wph wa wch wph wn wa wo wps wph wps wph wa wch wph wn wa wo wps
    wph wa wch wph wn wa orc expcom wph wps wph wa wps wch wph wn wa wps wph wa
    wps wi wph wps wph simpl a1i wph wph wn wps wch wph wps pm2.24 adantld jaod
    impbid $.

  $( Lemma for weak deduction theorem.  See also ~ ifpfal .  (Contributed by
     NM, 15-May-1999.)  (Proof shortened by Andrew Salmon, 7-May-2011.) $)
  dedlemb $p |- ( -. ph -> ( ch <-> ( ( ps /\ ph ) \/ ( ch /\ -. ph ) ) ) ) $=
    wph wn wch wps wph wa wch wph wn wa wo wch wph wn wps wph wa wch wph wn wa
    wo wch wph wn wa wps wph wa olc expcom wph wn wps wph wa wch wch wph wn wa
    wph wn wph wch wps wph wch pm2.21 adantld wch wph wn wa wch wi wph wn wch
    wph wn simpl a1i jaod impbid $.

  $( Case disjunction according to the value of ` ph ` .  (Contributed by BJ,
     6-Apr-2019.)  (Proof shortened by Wolf Lammen, 28-Feb-2022.) $)
  cases2 $p |- ( ( ( ph /\ ps ) \/ ( -. ph /\ ch ) )
                                   <-> ( ( ph -> ps ) /\ ( -. ph -> ch ) ) ) $=
    wph wps wph wa wch wph wn wa wo wi wph wn wps wph wa wch wph wn wa wo wi wa
    wps wph wa wch wph wn wa wo wph wps wi wph wn wch wi wa wph wps wa wph wn
    wch wa wo wph wps wph wa wch wph wn wa wo pm4.83 wph wps wi wph wps wph wa
    wch wph wn wa wo wi wph wn wch wi wph wn wps wph wa wch wph wn wa wo wi wph
    wps wps wph wa wch wph wn wa wo wph wps wch dedlema pm5.74i wph wn wch wps
    wph wa wch wph wn wa wo wph wps wch dedlemb pm5.74i anbi12i wph wps wa wps
    wph wa wph wn wch wa wch wph wn wa wph wps ancom wph wn wch ancom orbi12i
    3bitr4ri $.

  $( Alternate proof of ~ cases2 , not using ~ dedlema or ~ dedlemb .
     (Contributed by BJ, 6-Apr-2019.)  (Proof shortened by Wolf Lammen,
     2-Jan-2020.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  cases2ALT $p |- ( ( ( ph /\ ps ) \/ ( -. ph /\ ch ) )
                                   <-> ( ( ph -> ps ) /\ ( -. ph -> ch ) ) ) $=
    wph wps wa wph wn wch wa wo wph wps wi wph wn wch wi wa wph wps wa wph wps
    wi wph wn wch wi wa wph wn wch wa wph wps wa wph wps wi wph wn wch wi wph
    wps pm3.4 wph wph wn wch wi wps wph wch pm2.24 adantr jca wph wn wch wa wph
    wps wi wph wn wch wi wph wn wph wps wi wch wph wps pm2.21 adantr wph wn wch
    pm3.4 jca jaoi wph wph wps wi wph wn wch wi wa wph wps wa wph wn wch wa wo
    wph wph wps wi wph wps wa wph wn wch wa wo wph wn wch wi wph wph wps wi wa
    wph wps wa wph wn wch wa wph wph wps wi wps wph wps pm2.27 imdistani orcd
    adantrr wph wn wph wn wch wi wph wps wa wph wn wch wa wo wph wps wi wph wn
    wph wn wch wi wa wph wn wch wa wph wps wa wph wn wph wn wch wi wch wph wn
    wch pm2.27 imdistani olcd adantrl pm2.61ian impbii $.

  $( An alternate definition of the biconditional.  Theorem *5.23 of
     [WhiteheadRussell] p. 124.  (Contributed by NM, 27-Jun-2002.)  (Proof
     shortened by Wolf Lammen, 3-Nov-2013.)  (Proof shortened by NM,
     29-Oct-2021.) $)
  dfbi3 $p |- ( ( ph <-> ps ) <-> ( ( ph /\ ps ) \/ ( -. ph /\ -. ps ) ) ) $=
    wph wps wi wps wph wi wa wph wps wi wph wn wps wn wi wa wph wps wb wph wps
    wa wph wn wps wn wa wo wps wph wi wph wn wps wn wi wph wps wi wps wph
    con34b anbi2i wph wps dfbi2 wph wps wps wn cases2 3bitr4i $.

  $( Theorem *5.24 of [WhiteheadRussell] p. 124.  (Contributed by NM,
     3-Jan-2005.) $)
  pm5.24 $p |- ( -. ( ( ph /\ ps ) \/ ( -. ph /\ -. ps ) ) <->
                ( ( ph /\ -. ps ) \/ ( ps /\ -. ph ) ) ) $=
    wph wps wb wph wps wn wa wps wph wn wa wo wph wps wa wph wn wps wn wa wo
    wph wps xor wph wps dfbi3 xchnxbi $.

  $( The disjunction of the four possible combinations of two wffs and their
     negations is always true.  A four-way excluded middle (see ~ exmid ).
     (Contributed by David Abernethy, 28-Jan-2014.)  (Proof shortened by NM,
     29-Oct-2021.) $)
  4exmid $p |- ( ( ( ph /\ ps ) \/ ( -. ph /\ -. ps ) )
              \/ ( ( ph /\ -. ps ) \/ ( ps /\ -. ph ) ) ) $=
    wph wps wa wph wn wps wn wa wo wph wps wn wa wps wph wn wa wo wph wps wa
    wph wn wps wn wa wo wn wph wps wn wa wps wph wn wa wo wph wps pm5.24 biimpi
    orri $.

  $( The consensus theorem.  This theorem and its dual (with ` \/ ` and ` /\ `
     interchanged) are commonly used in computer logic design to eliminate
     redundant terms from Boolean expressions.  Specifically, we prove that the
     term ` ( ps /\ ch ) ` on the left-hand side is redundant.  (Contributed by
     NM, 16-May-2003.)  (Proof shortened by Andrew Salmon, 13-May-2011.)
     (Proof shortened by Wolf Lammen, 20-Jan-2013.) $)
  consensus $p |- ( ( ( ( ph /\ ps ) \/ ( -. ph /\ ch ) ) \/ ( ps /\ ch ) ) <->
                      ( ( ph /\ ps ) \/ ( -. ph /\ ch ) ) ) $=
    wph wps wa wph wn wch wa wo wps wch wa wo wph wps wa wph wn wch wa wo wph
    wps wa wph wn wch wa wo wph wps wa wph wn wch wa wo wps wch wa wph wps wa
    wph wn wch wa wo id wph wps wch wa wph wps wa wph wn wch wa wo wph wps wph
    wps wa wph wn wch wa wo wch wph wps wa wph wn wch wa orc adantrr wph wn wch
    wph wps wa wph wn wch wa wo wps wph wn wch wa wph wps wa olc adantrl
    pm2.61ian jaoi wph wps wa wph wn wch wa wo wps wch wa orc impbii $.

  $( Theorem *4.42 of [WhiteheadRussell] p. 119.  See also ~ ifpid .
     (Contributed by Roy F. Longton, 21-Jun-2005.) $)
  pm4.42 $p |- ( ph <-> ( ( ph /\ ps ) \/ ( ph /\ -. ps ) ) ) $=
    wps wph wph wps wa wph wps wn wa wo wb wps wph wph dedlema wps wph wph
    dedlemb pm2.61i $.

  ${
    prlem1.1 $e |- ( ph -> ( et <-> ch ) ) $.
    prlem1.2 $e |- ( ps -> -. th ) $.
    $( A specialized lemma for set theory (to derive the Axiom of Pairing).
       (Contributed by NM, 18-Oct-1995.)  (Proof shortened by Andrew Salmon,
       13-May-2011.)  (Proof shortened by Wolf Lammen, 5-Jan-2013.) $)
    prlem1 $p |- ( ph -> ( ps ->
                  ( ( ( ps /\ ch ) \/ ( th /\ ta ) ) -> et ) ) ) $=
      wph wps wps wch wa wth wta wa wo wet wi wph wps wch wa wet wps wth wta wa
      wph wch wet wps wph wet wch prlem1.1 biimprd adantld wps wth wet wta wps
      wth wet prlem1.2 pm2.21d adantrd jaao ex $.
  $}

  $( A specialized lemma for set theory (to derive the Axiom of Pairing).
     (Contributed by NM, 21-Jun-1993.)  (Proof shortened by Andrew Salmon,
     13-May-2011.)  (Proof shortened by Wolf Lammen, 9-Dec-2012.) $)
  prlem2 $p |- ( ( ( ph /\ ps ) \/ ( ch /\ th ) ) <->
              ( ( ph \/ ch ) /\ ( ( ph /\ ps ) \/ ( ch /\ th ) ) ) ) $=
    wph wps wa wch wth wa wo wph wch wo wph wps wa wph wch wth wa wch wph wps
    simpl wch wth simpl orim12i pm4.71ri $.

  ${
    oplem1.1 $e |- ( ph -> ( ps \/ ch ) ) $.
    oplem1.2 $e |- ( ph -> ( th \/ ta ) ) $.
    oplem1.3 $e |- ( ps <-> th ) $.
    oplem1.4 $e |- ( ch -> ( th <-> ta ) ) $.
    $( A specialized lemma for set theory (ordered pair theorem).  (Contributed
       by NM, 18-Oct-1995.)  (Proof shortened by Wolf Lammen, 8-Dec-2012.) $)
    oplem1 $p |- ( ph -> ps ) $=
      wph wth wps wph wth wph wth wn wch wta wa wth wph wth wn wch wta wth wn
      wps wn wph wch wps wth oplem1.3 notbii wph wps wch oplem1.1 ord biimtrrid
      wph wth wta oplem1.2 ord jcad wch wth wta oplem1.4 biimpar syl6 pm2.18d
      oplem1.3 sylibr $.
  $}

  $( A single axiom for Boolean algebra known as DN_1.  See McCune, Veroff,
     Fitelson, Harris, Feist, Wos, _Short single axioms for Boolean algebra_,
     Journal of Automated Reasoning, 29(1):1--16, 2002.
     ( ~ https://www.cs.unm.edu/~~mccune/papers/basax/v12.pdf ).  (Contributed
     by Jeff Hankins, 3-Jul-2009.)  (Proof shortened by Andrew Salmon,
     13-May-2011.)  (Proof shortened by Wolf Lammen, 6-Jan-2013.) $)
  dn1 $p |- ( -. ( -. ( -. ( ph \/ ps ) \/ ch ) \/
            -. ( ph \/ -. ( -. ch \/ -. ( ch \/ th ) ) ) ) <-> ch ) $=
    wch wph wps wo wn wch wo wph wch wo wa wph wps wo wn wch wo wph wch wn wch
    wth wo wn wo wn wo wa wph wps wo wn wch wo wn wph wch wn wch wth wo wn wo
    wn wo wn wo wn wch wch wph wps wo wn wph wa wo wph wps wo wn wph wa wch wo
    wph wps wo wn wch wo wph wch wo wa wph wps wo wn wph wa wch wph wps wo wn
    wph wn wi wph wps wo wn wph wa wn wph wps pm2.45 wph wps wo wn wph imnan
    mpbi biorfri wch wph wps wo wn wph wa orcom wph wps wo wn wph wch ordir
    3bitri wph wch wo wph wch wn wch wth wo wn wo wn wo wph wps wo wn wch wo
    wch wch wn wch wth wo wn wo wn wph wch wch wch wth wo wa wch wn wch wth wo
    wn wo wn wch wth pm4.45 wch wch wth wo anor bitri orbi2i anbi2i wph wps wo
    wn wch wo wph wch wn wch wth wo wn wo wn wo anor 3bitrri $.

  $( A closed form of ~ mpbir , analogous to ~ pm2.27 (assertion).
     (Contributed by Jonathan Ben-Naim, 3-Jun-2011.)  (Proof shortened by Roger
     Witte, 17-Aug-2020.) $)
  bianir $p |- ( ( ph /\ ( ps <-> ph ) ) -> ps ) $=
    wps wph wb wph wps wps wph biimpr impcom $.

  ${
    jaoi2.1 $e |- ( ( ph \/ ( -. ph /\ ch ) ) -> ps ) $.
    $( Inference removing a negated conjunct in a disjunction of an antecedent
       if this conjunct is part of the disjunction.  (Contributed by Alexander
       van der Vekens, 3-Nov-2017.)  (Proof shortened by Wolf Lammen,
       21-Sep-2018.) $)
    jaoi2 $p |- ( ( ph \/ ch ) -> ps ) $=
      wph wch wo wph wph wn wch wa wo wps wph wch pm5.63 jaoi2.1 sylbi $.
  $}

  ${
    jaoi3.1 $e |- ( ph -> ps ) $.
    jaoi3.2 $e |- ( ( -. ph /\ ch ) -> ps ) $.
    $( Inference separating a disjunct of an antecedent.  (Contributed by
       Alexander van der Vekens, 25-May-2018.) $)
    jaoi3 $p |- ( ( ph \/ ch ) -> ps ) $=
      wph wps wch wph wps wph wn wch wa jaoi3.1 jaoi3.2 jaoi jaoi2 $.
  $}

  $( Selecting one statement from a disjunction if one of the disjuncted
     statements is false.  (Contributed by AV, 6-Sep-2018.)  (Proof shortened
     by AV, 13-Oct-2018.)  (Proof shortened by Wolf Lammen, 19-Jan-2020.) $)
  ornld $p |- ( ph -> ( ( ( ph -> ( th \/ ta ) ) /\ -. th ) -> ta ) ) $=
    wph wph wth wta wo wi wth wn wta wph wph wth wta wo wi wa wth wta wph wth
    wta wo pm3.35 ord expimpd $.


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  The conditional operator for propositions
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  This subsection introduces the conditional operator for propositions, denoted
  by ` if- ( ph , ps , ch ) ` (see ~ df-ifp ).  It is the analogue for
  propositions of the conditional operator for classes, denoted by
  ` if ( ph , A , B ) ` (see ~ df-if ).

$)

  $( Comma.  Also used later for adders, pairs, tuples, etc. $)
  $c , $.

  $( Symbol for the conditional operator for propositions. $)
  $c if- $.

  $( Extend wff notation to include the conditional operator for
     propositions. $)
  wif $a wff if- ( ph , ps , ch ) $.

  $( Definition of the conditional operator for propositions.  The expression
     ` if- ( ph , ps , ch ) ` is read "if ` ph ` then ` ps ` else ` ch ` ".
     See ~ dfifp2 , ~ dfifp3 , ~ dfifp4 , ~ dfifp5 , ~ dfifp6 and ~ dfifp7 for
     alternate definitions.

     This definition (in the form of ~ dfifp2 ) appears in Section II.24 of
     [Church] p. 129 (Definition D12 page 132), where it is called "conditioned
     disjunction".  Church's ` [ ps , ph , ch ] ` corresponds to our
     ` if- ( ph , ps , ch ) ` (note the permutation of the first two
     variables).

     This form was chosen as the definition rather than ~ dfifp2 for
     compatibility with intuitionistic logic development: with this form, it is
     clear that ` if- ( ph , ps , ch ) ` implies decidability of ` ph ` , which
     is most often what is wanted.

     Church uses the conditional operator as an intermediate step to prove
     completeness of some systems of connectives.  The first result is that the
     system ` { if- , T. , F. } ` is complete: for the induction step, consider
     a formula of n+1 variables; single out one variable, say ` ph ` ; when one
     sets ` ph ` to True (resp.  False), then what remains is a formula of n
     variables, so by the induction hypothesis it is equivalent to a formula
     using only the connectives ` if- , T. , F. ` , say ` ps ` (resp. ` ch ` );
     therefore, the formula ` if- ( ph , ps , ch ) ` is equivalent to the
     initial formula of n+1 variables.  Now, since ` { -> , -. } ` and similar
     systems suffice to express the connectives ` if- , T. , F. ` , they are
     also complete.

     (Contributed by BJ, 22-Jun-2019.) $)
  df-ifp $a |-
            ( if- ( ph , ps , ch ) <-> ( ( ph /\ ps ) \/ ( -. ph /\ ch ) ) ) $.

  $( Alternate definition of the conditional operator for propositions.  The
     value of ` if- ( ph , ps , ch ) ` is "if ` ph ` then ` ps ` , and if not
     ` ph ` then ` ch ` ".  This is the definition used in Section II.24 of
     [Church] p. 129 (Definition D12 page 132) (see comment of ~ df-ifp ).
     (Contributed by BJ, 22-Jun-2019.) $)
  dfifp2 $p |-
            ( if- ( ph , ps , ch ) <-> ( ( ph -> ps ) /\ ( -. ph -> ch ) ) ) $=
    wph wps wch wif wph wps wa wph wn wch wa wo wph wps wi wph wn wch wi wa wph
    wps wch df-ifp wph wps wch cases2 bitri $.

  $( Alternate definition of the conditional operator for propositions.
     (Contributed by BJ, 30-Sep-2019.) $)
  dfifp3 $p |- ( if- ( ph , ps , ch ) <-> ( ( ph -> ps ) /\ ( ph \/ ch ) ) ) $=
    wph wps wch wif wph wps wi wph wn wch wi wa wph wps wi wph wch wo wa wph
    wps wch dfifp2 wph wn wch wi wph wch wo wph wps wi wph wch pm4.64 anbi2i
    bitri $.

  $( Alternate definition of the conditional operator for propositions.
     (Contributed by BJ, 30-Sep-2019.) $)
  dfifp4 $p |-
            ( if- ( ph , ps , ch ) <-> ( ( -. ph \/ ps ) /\ ( ph \/ ch ) ) ) $=
    wph wps wch wif wph wps wi wph wch wo wph wn wps wo wph wps wch dfifp3 wph
    wps imor bianbi $.

  $( Alternate definition of the conditional operator for propositions.
     (Contributed by BJ, 2-Oct-2019.) $)
  dfifp5 $p |-
         ( if- ( ph , ps , ch ) <-> ( ( -. ph \/ ps ) /\ ( -. ph -> ch ) ) ) $=
    wph wps wch wif wph wps wi wph wn wch wi wph wn wps wo wph wps wch dfifp2
    wph wps imor bianbi $.

  $( Alternate definition of the conditional operator for propositions.
     (Contributed by BJ, 2-Oct-2019.) $)
  dfifp6 $p |-
            ( if- ( ph , ps , ch ) <-> ( ( ph /\ ps ) \/ -. ( ch -> ph ) ) ) $=
    wph wps wch wif wph wps wa wph wn wch wa wo wph wps wa wch wph wi wn wo wph
    wps wch df-ifp wph wn wch wa wch wph wi wn wph wps wa wph wn wch wa wch wph
    wn wa wch wph wi wn wph wn wch ancom wch wph annim bitri orbi2i bitri $.

  $( Alternate definition of the conditional operator for propositions.
     (Contributed by BJ, 2-Oct-2019.) $)
  dfifp7 $p |- ( if- ( ph , ps , ch ) <-> ( ( ch -> ph ) -> ( ph /\ ps ) ) ) $=
    wph wps wa wch wph wi wn wo wch wph wi wn wph wps wa wo wph wps wch wif wch
    wph wi wph wps wa wi wph wps wa wch wph wi wn orcom wph wps wch dfifp6 wch
    wph wi wph wps wa imor 3bitr4i $.

  $( Define the biconditional as conditional logic operator.  (Contributed by
     RP, 20-Apr-2020.)  (Proof shortened by Wolf Lammen, 30-Apr-2024.) $)
  ifpdfbi $p |- ( ( ph <-> ps ) <-> if- ( ph , ps , -. ps ) ) $=
    wph wps wi wps wph wi wa wph wps wi wph wn wps wn wi wa wph wps wb wph wps
    wps wn wif wps wph wi wph wn wps wn wi wph wps wi wps wph con34b anbi2i wph
    wps dfbi2 wph wps wps wn dfifp2 3bitr4i $.

  $( The conditional operator is implied by the conjunction of its possible
     outputs.  Dual statement of ~ ifpor .  (Contributed by BJ,
     30-Sep-2019.) $)
  anifp $p |- ( ( ps /\ ch ) -> if- ( ph , ps , ch ) ) $=
    wps wch wa wph wn wps wo wph wch wo wa wph wps wch wif wps wph wn wps wo
    wch wph wch wo wps wph wn olc wch wph olc anim12i wph wps wch dfifp4 sylibr
    $.

  $( The conditional operator implies the disjunction of its possible outputs.
     Dual statement of ~ anifp .  (Contributed by BJ, 1-Oct-2019.) $)
  ifpor $p |- ( if- ( ph , ps , ch ) -> ( ps \/ ch ) ) $=
    wph wps wch wif wph wps wa wph wn wch wa wo wps wch wo wph wps wch df-ifp
    wph wps wa wps wph wn wch wa wch wph wps simpr wph wn wch simpr orim12i
    sylbi $.

  $( Conditional operator for the negation of a proposition.  (Contributed by
     BJ, 30-Sep-2019.)  (Proof shortened by Wolf Lammen, 5-May-2024.) $)
  ifpn $p |- ( if- ( ph , ps , ch ) <-> if- ( -. ph , ch , ps ) ) $=
    wph wn wps wo wph wn wch wi wa wph wn wch wi wph wn wps wo wa wph wps wch
    wif wph wn wch wps wif wph wn wps wo wph wn wch wi ancom wph wps wch dfifp5
    wph wn wch wps dfifp3 3bitr4i $.

  $( Value of the conditional operator for propositions when its first argument
     is true.  Analogue for propositions of ~ iftrue .  This is essentially
     ~ dedlema .  (Contributed by BJ, 20-Sep-2019.)  (Proof shortened by Wolf
     Lammen, 10-Jul-2020.) $)
  ifptru $p |- ( ph -> ( if- ( ph , ps , ch ) <-> ps ) ) $=
    wph wps wph wps wi wph wps wch wif wph wps biimt wph wph wps wi wph wps wi
    wph wch wo wa wph wps wch wif wph wph wch wo wph wps wi wph wch orc
    biantrud wph wps wch dfifp3 bitr4di bitr2d $.

  $( Value of the conditional operator for propositions when its first argument
     is false.  Analogue for propositions of ~ iffalse .  This is essentially
     ~ dedlemb .  (Contributed by BJ, 20-Sep-2019.)  (Proof shortened by Wolf
     Lammen, 25-Jun-2020.) $)
  ifpfal $p |- ( -. ph -> ( if- ( ph , ps , ch ) <-> ch ) ) $=
    wph wps wch wif wph wn wch wps wif wph wn wch wph wps wch ifpn wph wn wch
    wps ifptru bitrid $.

  $( Value of the conditional operator for propositions when the same
     proposition is returned in either case.  Analogue for propositions of
     ~ ifid .  This is essentially ~ pm4.42 .  (Contributed by BJ,
     20-Sep-2019.) $)
  ifpid $p |- ( if- ( ph , ps , ps ) <-> ps ) $=
    wph wph wps wps wif wps wb wph wps wps ifptru wph wps wps ifpfal pm2.61i $.

  ${
    casesifp.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    casesifp.2 $e |- ( -. ph -> ( ps <-> th ) ) $.
    $( Version of ~ cases expressed using ` if- ` .  Case disjunction according
       to the value of ` ph ` .  One can see this as a proof that the two
       hypotheses characterize the conditional operator for propositions.  For
       the converses, see ~ ifptru and ~ ifpfal .  (Contributed by BJ,
       20-Sep-2019.) $)
    casesifp $p |- ( ps <-> if- ( ph , ch , th ) ) $=
      wps wph wch wa wph wn wth wa wo wph wch wth wif wph wps wch wth
      casesifp.1 casesifp.2 cases wph wch wth df-ifp bitr4i $.
  $}

  ${
    ifpbi123d.1 $e |- ( ph -> ( ps <-> ta ) ) $.
    ifpbi123d.2 $e |- ( ph -> ( ch <-> et ) ) $.
    ifpbi123d.3 $e |- ( ph -> ( th <-> ze ) ) $.
    $( Equivalence deduction for conditional operator for propositions.
       (Contributed by AV, 30-Dec-2020.)  (Proof shortened by Wolf Lammen,
       17-Apr-2024.) $)
    ifpbi123d $p |- ( ph -> ( if- ( ps , ch , th )
                              <-> if- ( ta , et , ze ) ) ) $=
      wph wps wch wi wps wth wo wa wta wet wi wta wze wo wa wps wch wth wif wta
      wet wze wif wph wps wch wi wta wet wi wps wth wo wta wze wo wph wps wta
      wch wet ifpbi123d.1 ifpbi123d.2 imbi12d wph wps wta wth wze ifpbi123d.1
      ifpbi123d.3 orbi12d anbi12d wps wch wth dfifp3 wta wet wze dfifp3 3bitr4g
      $.
  $}

  ${
    ifpbi23d.1 $e |- ( ph -> ( ch <-> et ) ) $.
    ifpbi23d.2 $e |- ( ph -> ( th <-> ze ) ) $.
    $( Equivalence deduction for conditional operator for propositions.
       Convenience theorem for a frequent case.  (Contributed by Wolf Lammen,
       28-Apr-2024.) $)
    ifpbi23d $p |- ( ph -> ( if- ( ps , ch , th )
                              <-> if- ( ps , et , ze ) ) ) $=
      wph wps wch wth wps wet wze wph wps biidd ifpbi23d.1 ifpbi23d.2 ifpbi123d
      $.
  $}

  ${
    ifpimpda.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    ifpimpda.2 $e |- ( ( ph /\ -. ps ) -> th ) $.
    $( Separation of the values of the conditional operator for propositions.
       (Contributed by AV, 30-Dec-2020.)  (Proof shortened by Wolf Lammen,
       27-Feb-2021.) $)
    ifpimpda $p |- ( ph -> if- ( ps , ch , th ) ) $=
      wph wps wch wi wps wn wth wi wps wch wth wif wph wps wch ifpimpda.1 ex
      wph wps wn wth ifpimpda.2 ex wps wch wth dfifp2 sylanbrc $.
  $}

  ${
    1fpid3.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    $( The value of the conditional operator for propositions is its third
       argument if the first and second argument imply the third argument.
       (Contributed by AV, 4-Apr-2021.) $)
    1fpid3 $p |- ( if- ( ph , ps , ch ) -> ch ) $=
      wph wps wch wif wph wps wa wph wn wch wa wo wch wph wps wch df-ifp wph
      wps wa wch wph wn wch wa 1fpid3.1 wph wn wch simpr jaoi sylbi $.
  $}


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  The weak deduction theorem for propositional calculus
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

  This subsection contains a few results related to the weak deduction theorem
  in propositional calculus.  For the weak deduction theorem in set theory, see
  the section beginning with ~ dedth .  For more information on the weak
  deduction theorem, see the Weak Deduction Theorem page ~ mmdeduction.html .

$)

  ${
    elimh.1 $e |- ( ( if- ( ch , ph , ps ) <-> ph ) -> ( ta <-> ch ) ) $.
    elimh.2 $e |- ( ( if- ( ch , ph , ps ) <-> ps ) -> ( ta <-> th ) ) $.
    elimh.3 $e |- th $.
    $( Hypothesis builder for the weak deduction theorem.  For more
       information, see the Weak Deduction Theorem page ~ mmdeduction.html .
       (Contributed by NM, 26-Jun-2002.)  Revised to use the conditional
       operator.  (Revised by BJ, 30-Sep-2019.)  Commute consequent.  (Revised
       by Steven Nguyen, 27-Apr-2023.) $)
    elimh $p |- ta $=
      wch wta wch wta wch wch wph wps wif wph wb wta wch wb wch wph wps ifptru
      elimh.1 syl ibir wch wn wta wth elimh.3 wch wn wch wph wps wif wps wb wta
      wth wb wch wph wps ifpfal elimh.2 syl mpbiri pm2.61i $.
  $}

  ${
    dedt.1 $e |- ( ( if- ( ch , ph , ps ) <-> ph ) -> ( ta <-> th ) ) $.
    dedt.2 $e |- ta $.
    $( The weak deduction theorem.  For more information, see the Weak
       Deduction Theorem page ~ mmdeduction.html .  (Contributed by NM,
       26-Jun-2002.)  Revised to use the conditional operator.  (Revised by BJ,
       30-Sep-2019.)  Commute consequent.  (Revised by Steven Nguyen,
       27-Apr-2023.) $)
    dedt $p |- ( ch -> th ) $=
      wch wch wph wps wif wph wb wth wch wph wps ifptru wch wph wps wif wph wb
      wta wth dedt.2 dedt.1 mpbii syl $.
  $}

  $( Proof of ~ con3 from its associated inference ~ con3i that illustrates the
     use of the weak deduction theorem ~ dedt .  (Contributed by NM,
     27-Jun-2002.)  Revised to use the conditional operator.  (Revised by BJ,
     30-Sep-2019.)  Revised ~ dedt and ~ elimh .  (Revised by Steven Nguyen,
     27-Apr-2023.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  con3ALT $p |- ( ( ph -> ps ) -> ( -. ps -> -. ph ) ) $=
    wps wph wph wps wi wps wn wph wn wi wph wps wi wps wph wif wn wph wn wi wph
    wps wi wps wph wif wps wb wph wps wi wps wph wif wn wps wn wph wn wph wps
    wi wps wph wif wps wb wph wps wi wps wph wif wps wph wps wi wps wph wif wps
    wb id notbid imbi1d wph wph wps wi wps wph wif wps wph wph wps wi wph wph
    wi wph wph wps wi wps wph wif wi wph wps wi wps wph wif wps wph imbi2 wph
    wps wi wps wph wif wph wph imbi2 wph id elimh con3i dedt $.


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Abbreviated conjunction and disjunction of three wff's
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
$)

  $( Extend wff definition to include three-way disjunction ('or'). $)
  w3o $a wff ( ph \/ ps \/ ch ) $.
  $( Extend wff definition to include three-way conjunction ('and'). $)
  w3a $a wff ( ph /\ ps /\ ch ) $.

  $( These abbreviations help eliminate parentheses to aid readability. $)

  $( Define disjunction ('or') of three wff's.  Definition *2.33 of
     [WhiteheadRussell] p. 105.  This abbreviation reduces the number of
     parentheses and emphasizes that the order of bracketing is not important
     by virtue of the associative law ~ orass .  (Contributed by NM,
     8-Apr-1994.) $)
  df-3or $a |- ( ( ph \/ ps \/ ch ) <-> ( ( ph \/ ps ) \/ ch ) ) $.

  $( Define conjunction ('and') of three wff's.  Definition *4.34 of
     [WhiteheadRussell] p. 118.  This abbreviation reduces the number of
     parentheses and emphasizes that the order of bracketing is not important
     by virtue of the associative law ~ anass .  (Contributed by NM,
     8-Apr-1994.) $)
  df-3an $a |- ( ( ph /\ ps /\ ch ) <-> ( ( ph /\ ps ) /\ ch ) ) $.

  $( Associative law for triple disjunction.  (Contributed by NM,
     8-Apr-1994.) $)
  3orass $p |- ( ( ph \/ ps \/ ch ) <-> ( ph \/ ( ps \/ ch ) ) ) $=
    wph wps wch w3o wph wps wo wch wo wph wps wch wo wo wph wps wch df-3or wph
    wps wch orass bitri $.

  $( Partial elimination of a triple disjunction by denial of a disjunct.
     (Contributed by Scott Fenton, 26-Mar-2011.) $)
  3orel1 $p |- ( -. ph -> ( ( ph \/ ps \/ ch ) -> ( ps \/ ch ) ) ) $=
    wph wps wch w3o wph wps wch wo wo wph wn wps wch wo wph wps wch 3orass wph
    wps wch wo orel1 biimtrid $.

  $( Rotation law for triple disjunction.  (Contributed by NM, 4-Apr-1995.) $)
  3orrot $p |- ( ( ph \/ ps \/ ch ) <-> ( ps \/ ch \/ ph ) ) $=
    wph wps wch wo wo wps wch wo wph wo wph wps wch w3o wps wch wph w3o wph wps
    wch wo orcom wph wps wch 3orass wps wch wph df-3or 3bitr4i $.

  $( Commutation law for triple disjunction.  (Contributed by Mario Carneiro,
     4-Sep-2016.) $)
  3orcoma $p |- ( ( ph \/ ps \/ ch ) <-> ( ps \/ ph \/ ch ) ) $=
    wph wps wch wo wo wps wph wch wo wo wph wps wch w3o wps wph wch w3o wph wps
    wch or12 wph wps wch 3orass wps wph wch 3orass 3bitr4i $.

  $( Commutation law for triple disjunction.  (Contributed by Scott Fenton,
     20-Apr-2011.)  (Proof shortened by Wolf Lammen, 8-Apr-2022.) $)
  3orcomb $p |- ( ( ph \/ ps \/ ch ) <-> ( ph \/ ch \/ ps ) ) $=
    wph wps wch w3o wps wph wch w3o wph wch wps w3o wph wps wch 3orcoma wps wph
    wch 3orrot bitri $.

  $( Associative law for triple conjunction.  (Contributed by NM,
     8-Apr-1994.) $)
  3anass $p |- ( ( ph /\ ps /\ ch ) <-> ( ph /\ ( ps /\ ch ) ) ) $=
    wph wps wch w3a wph wps wa wch wa wph wps wch wa wa wph wps wch df-3an wph
    wps wch anass bitri $.

  $( Convert triple conjunction to conjunction, then commute.  (Contributed by
     Jonathan Ben-Naim, 3-Jun-2011.)  (Proof shortened by Andrew Salmon,
     14-Jun-2011.)  (Revised to shorten ~ 3ancoma by Wolf Lammen,
     5-Jun-2022.) $)
  3anan12 $p |- ( ( ph /\ ps /\ ch ) <-> ( ps /\ ( ph /\ ch ) ) ) $=
    wph wps wch w3a wph wps wch wa wa wps wph wch wa wa wph wps wch 3anass wph
    wps wch an12 bitri $.

  $( Convert triple conjunction to conjunction, then commute.  (Contributed by
     Jonathan Ben-Naim, 3-Jun-2011.) $)
  3anan32 $p |- ( ( ph /\ ps /\ ch ) <-> ( ( ph /\ ch ) /\ ps ) ) $=
    wph wps wch w3a wph wps wa wch wa wph wch wa wps wa wph wps wch df-3an wph
    wps wch an32 bitri $.

  $( Commutation law for triple conjunction.  (Contributed by NM, 21-Apr-1994.)
     (Proof shortened by Wolf Lammen, 5-Jun-2022.) $)
  3ancoma $p |- ( ( ph /\ ps /\ ch ) <-> ( ps /\ ph /\ ch ) ) $=
    wph wps wch w3a wps wph wch wa wa wps wph wch w3a wph wps wch 3anan12 wps
    wph wch 3anass bitr4i $.

  $( Commutation law for triple conjunction.  (Contributed by NM, 21-Apr-1994.)
     (Revised to shorten ~ 3anrot by Wolf Lammen, 9-Jun-2022.) $)
  3ancomb $p |- ( ( ph /\ ps /\ ch ) <-> ( ph /\ ch /\ ps ) ) $=
    wph wps wch w3a wph wps wa wch wa wph wch wps w3a wph wps wch df-3an wph
    wch wps 3anan32 bitr4i $.

  $( Rotation law for triple conjunction.  (Contributed by NM, 8-Apr-1994.)
     (Proof shortened by Wolf Lammen, 9-Jun-2022.) $)
  3anrot $p |- ( ( ph /\ ps /\ ch ) <-> ( ps /\ ch /\ ph ) ) $=
    wph wps wch w3a wps wph wch w3a wps wch wph w3a wph wps wch 3ancoma wps wph
    wch 3ancomb bitri $.

  $( Reversal law for triple conjunction.  (Contributed by NM, 21-Apr-1994.) $)
  3anrev $p |- ( ( ph /\ ps /\ ch ) <-> ( ch /\ ps /\ ph ) ) $=
    wph wps wch w3a wps wph wch w3a wch wps wph w3a wph wps wch 3ancoma wch wps
    wph 3anrot bitr4i $.

  $( Distribution of triple conjunction over conjunction.  (Contributed by
     David A. Wheeler, 4-Nov-2018.) $)
  anandi3 $p |- ( ( ph /\ ps /\ ch ) <-> ( ( ph /\ ps ) /\ ( ph /\ ch ) ) ) $=
    wph wps wch w3a wph wps wch wa wa wph wps wa wph wch wa wa wph wps wch
    3anass wph wps wch anandi bitri $.

  $( Distribution of triple conjunction over conjunction.  (Contributed by
     David A. Wheeler, 4-Nov-2018.) $)
  anandi3r $p |- ( ( ph /\ ps /\ ch ) <-> ( ( ph /\ ps ) /\ ( ch /\ ps ) ) ) $=
    wph wps wch w3a wph wch wa wps wa wph wps wa wch wps wa wa wph wps wch
    3anan32 wph wch wps anandir bitri $.

  $( Idempotent law for conjunction.  (Contributed by Peter Mazsa,
     17-Oct-2023.) $)
  3anidm $p |- ( ( ph /\ ph /\ ph ) <-> ph ) $=
    wph wph wph w3a wph wph wa wph wa wph wph wa wph wph wph wph df-3an wph wph
    anabs1 wph anidm 3bitri $.

  $( Associative law for four conjunctions with a triple conjunction.
     (Contributed by Alexander van der Vekens, 24-Jun-2018.) $)
  3an4anass $p |- ( ( ( ph /\ ps /\ ch ) /\ th )
                    <-> ( ( ph /\ ps ) /\ ( ch /\ th ) ) ) $=
    wph wps wch w3a wth wa wph wps wa wch wa wth wa wph wps wa wch wth wa wa
    wph wps wch w3a wph wps wa wch wa wth wph wps wch df-3an anbi1i wph wps wa
    wch wth anass bitri $.

  $( Negated triple disjunction as triple conjunction.  (Contributed by Scott
     Fenton, 19-Apr-2011.) $)
  3ioran $p |- ( -. ( ph \/ ps \/ ch ) <-> ( -. ph /\ -. ps /\ -. ch ) ) $=
    wph wps wo wn wch wn wa wph wn wps wn wa wch wn wa wph wps wch w3o wn wph
    wn wps wn wch wn w3a wph wps wo wn wph wn wps wn wa wch wn wph wps ioran
    anbi1i wph wps wo wch wo wph wps wo wn wch wn wa wph wps wch w3o wph wps wo
    wch ioran wph wps wch df-3or xchnxbir wph wn wps wn wch wn df-3an 3bitr4i
    $.

  $( Negated triple conjunction expressed in terms of triple disjunction.
     (Contributed by Jeff Hankins, 15-Aug-2009.)  (Proof shortened by Andrew
     Salmon, 13-May-2011.)  Shorten with ~ xchnxbir .  (Revised by Wolf Lammen,
     8-Apr-2022.) $)
  3ianor $p |- ( -. ( ph /\ ps /\ ch ) <-> ( -. ph \/ -. ps \/ -. ch ) ) $=
    wph wps wa wn wch wn wo wph wn wps wn wo wch wn wo wph wps wch w3a wn wph
    wn wps wn wch wn w3o wph wps wa wn wph wn wps wn wo wch wn wph wps ianor
    orbi1i wph wps wa wch wa wph wps wa wn wch wn wo wph wps wch w3a wph wps wa
    wch ianor wph wps wch df-3an xchnxbir wph wn wps wn wch wn df-3or 3bitr4i
    $.

  $( Triple conjunction expressed in terms of triple disjunction.  (Contributed
     by Jeff Hankins, 15-Aug-2009.)  (Proof shortened by Wolf Lammen,
     8-Apr-2022.) $)
  3anor $p |- ( ( ph /\ ps /\ ch ) <-> -. ( -. ph \/ -. ps \/ -. ch ) ) $=
    wph wn wps wn wch wn w3o wn wph wps wch w3a wph wps wch w3a wph wn wps wn
    wch wn w3o wph wps wch 3ianor con1bii bicomi $.

  $( Triple disjunction in terms of triple conjunction.  (Contributed by NM,
     8-Oct-2012.) $)
  3oran $p |- ( ( ph \/ ps \/ ch ) <-> -. ( -. ph /\ -. ps /\ -. ch ) ) $=
    wph wn wps wn wch wn w3a wn wph wps wch w3o wph wps wch w3o wph wn wps wn
    wch wn w3a wph wps wch 3ioran con1bii bicomi $.

  ${
    3impa.1 $e |- ( ( ( ph /\ ps ) /\ ch ) -> th ) $.
    $( Importation from double to triple conjunction.  (Contributed by NM,
       20-Aug-1995.)  (Revised to shorten ~ 3imp by Wolf Lammen,
       20-Jun-2022.) $)
    3impa $p |- ( ( ph /\ ps /\ ch ) -> th ) $=
      wph wps wch w3a wph wps wa wch wa wth wph wps wch df-3an 3impa.1 sylbi $.
  $}

  ${
    3imp.1 $e |- ( ph -> ( ps -> ( ch -> th ) ) ) $.
    $( Importation inference.  (Contributed by NM, 8-Apr-1994.)  (Proof
       shortened by Wolf Lammen, 20-Jun-2022.) $)
    3imp $p |- ( ( ph /\ ps /\ ch ) -> th ) $=
      wph wps wch wth wph wps wch wth 3imp.1 imp31 3impa $.

    $( The importation inference ~ 3imp with commutation of the first and third
       conjuncts of the assertion relative to the hypothesis.  (Contributed by
       Alan Sare, 11-Sep-2016.) $)
    3imp31 $p |- ( ( ch /\ ps /\ ph ) -> th ) $=
      wch wps wph wth wph wps wch wth 3imp.1 com13 3imp $.

    $( Importation inference.  (Contributed by Alan Sare, 17-Oct-2017.) $)
    3imp231 $p |- ( ( ps /\ ch /\ ph ) -> th ) $=
      wps wch wph wth wph wps wch wth 3imp.1 com3l 3imp $.

    $( The importation inference ~ 3imp with commutation of the first and
       second conjuncts of the assertion relative to the hypothesis.
       (Contributed by Alan Sare, 11-Sep-2016.)  (Revised to shorten ~ 3com12
       by Wolf Lammen, 23-Jun-2022.) $)
    3imp21 $p |- ( ( ps /\ ph /\ ch ) -> th ) $=
      wch wps wph wth wph wps wch wth 3imp.1 com13 3imp231 $.
  $}

  ${
    3impb.1 $e |- ( ( ph /\ ( ps /\ ch ) ) -> th ) $.
    $( Importation from double to triple conjunction.  (Contributed by NM,
       20-Aug-1995.) $)
    3impb $p |- ( ( ph /\ ps /\ ch ) -> th ) $=
      wph wps wch wth wph wps wch wth 3impb.1 exp32 3imp $.
  $}

  ${
    bi23imp13.1 $e |- ( ph -> ( ps <-> ( ch -> th ) ) ) $.
    $( ~ 3imp with middle implication of the hypothesis a biconditional.
       (Contributed by Alan Sare, 6-Nov-2017.) $)
    bi23imp13 $p |- ( ( ph /\ ps /\ ch ) -> th ) $=
      wph wps wch wth wph wps wch wth wi bi23imp13.1 biimpd 3imp $.
  $}

  ${
    3impib.1 $e |- ( ph -> ( ( ps /\ ch ) -> th ) ) $.
    $( Importation to triple conjunction.  (Contributed by NM, 13-Jun-2006.) $)
    3impib $p |- ( ( ph /\ ps /\ ch ) -> th ) $=
      wph wps wch wth wph wps wch wth 3impib.1 expd 3imp $.
  $}

  ${
    3impia.1 $e |- ( ( ph /\ ps ) -> ( ch -> th ) ) $.
    $( Importation to triple conjunction.  (Contributed by NM, 13-Jun-2006.)
       (Proof shortened by Wolf Lammen, 21-Jun-2022.) $)
    3impia $p |- ( ( ph /\ ps /\ ch ) -> th ) $=
      wph wps wch wth wph wps wch wth 3impia.1 expimpd 3impib $.
  $}

  ${
    3exp.1 $e |- ( ( ph /\ ps /\ ch ) -> th ) $.
    $( Exportation from triple to double conjunction.  (Contributed by NM,
       20-Aug-1995.)  (Revised to shorten ~ 3exp and ~ pm3.2an3 by Wolf Lammen,
       22-Jun-2022.) $)
    3expa $p |- ( ( ( ph /\ ps ) /\ ch ) -> th ) $=
      wph wps wa wch wa wph wps wch w3a wth wph wps wch df-3an 3exp.1 sylbir $.

    $( Exportation inference.  (Contributed by NM, 30-May-1994.)  (Proof
       shortened by Wolf Lammen, 22-Jun-2022.) $)
    3exp $p |- ( ph -> ( ps -> ( ch -> th ) ) ) $=
      wph wps wch wth wph wps wch wth 3exp.1 3expa exp31 $.

    $( Exportation from triple to double conjunction.  (Contributed by NM,
       20-Aug-1995.) $)
    3expb $p |- ( ( ph /\ ( ps /\ ch ) ) -> th ) $=
      wph wps wch wth wph wps wch wth 3exp.1 3exp imp32 $.

    $( Exportation from triple conjunction.  (Contributed by NM, 19-May-2007.)
       (Proof shortened by Wolf Lammen, 22-Jun-2022.) $)
    3expia $p |- ( ( ph /\ ps ) -> ( ch -> th ) ) $=
      wph wps wch wth wph wps wch wth 3exp.1 3expb expr $.

    $( Exportation from triple conjunction.  (Contributed by NM,
       19-May-2007.) $)
    3expib $p |- ( ph -> ( ( ps /\ ch ) -> th ) ) $=
      wph wps wch wth wph wps wch wth 3exp.1 3exp impd $.

    $( Commutation in antecedent.  Swap 1st and 2nd.  (Contributed by NM,
       28-Jan-1996.)  (Proof shortened by Andrew Salmon, 13-May-2011.)  (Proof
       shortened by Wolf Lammen, 22-Jun-2022.) $)
    3com12 $p |- ( ( ps /\ ph /\ ch ) -> th ) $=
      wph wps wch wth wph wps wch wth 3exp.1 3exp 3imp21 $.

    $( Commutation in antecedent.  Swap 1st and 3rd.  (Contributed by NM,
       28-Jan-1996.)  (Proof shortened by Wolf Lammen, 22-Jun-2022.) $)
    3com13 $p |- ( ( ch /\ ps /\ ph ) -> th ) $=
      wph wps wch wth wph wps wch wth 3exp.1 3exp 3imp31 $.

    $( Commutation in antecedent.  Rotate right.  (Contributed by NM,
       28-Jan-1996.)  Theorems shortened and reordered.  (Revised by Wolf
       Lammen, 9-Apr-2022.) $)
    3comr $p |- ( ( ch /\ ph /\ ps ) -> th ) $=
      wps wph wch wth wph wps wch wth 3exp.1 3com12 3com13 $.

    $( Commutation in antecedent.  Swap 2nd and 3rd.  (Contributed by NM,
       28-Jan-1996.)  (Proof shortened by Wolf Lammen, 9-Apr-2022.) $)
    3com23 $p |- ( ( ph /\ ch /\ ps ) -> th ) $=
      wch wph wps wth wph wps wch wth 3exp.1 3comr 3com12 $.

    $( Commutation in antecedent.  Rotate left.  (Contributed by NM,
       28-Jan-1996.) $)
    3coml $p |- ( ( ps /\ ch /\ ph ) -> th ) $=
      wph wch wps wth wph wps wch wth 3exp.1 3com23 3com13 $.
  $}

  ${
    3jca.1 $e |- ( ph -> ps ) $.
    3jca.2 $e |- ( ph -> ch ) $.
    3jca.3 $e |- ( ph -> th ) $.
    $( Join consequents with conjunction.  (Contributed by NM, 9-Apr-1994.) $)
    3jca $p |- ( ph -> ( ps /\ ch /\ th ) ) $=
      wph wps wch wa wth wa wps wch wth w3a wph wps wch wth 3jca.1 3jca.2
      3jca.3 jca31 wps wch wth df-3an sylibr $.
  $}

  ${
    3jcad.1 $e |- ( ph -> ( ps -> ch ) ) $.
    3jcad.2 $e |- ( ph -> ( ps -> th ) ) $.
    3jcad.3 $e |- ( ph -> ( ps -> ta ) ) $.
    $( Deduction conjoining the consequents of three implications.
       (Contributed by NM, 25-Sep-2005.) $)
    3jcad $p |- ( ph -> ( ps -> ( ch /\ th /\ ta ) ) ) $=
      wph wps wch wth wta w3a wph wps wa wch wth wta wph wps wch 3jcad.1 imp
      wph wps wth 3jcad.2 imp wph wps wta 3jcad.3 imp 3jca ex $.
  $}

  ${
    3adant.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       16-Jul-1995.)  (Proof shortened by Wolf Lammen, 21-Jun-2022.) $)
    3adant1 $p |- ( ( th /\ ph /\ ps ) -> ch ) $=
      wth wph wps wch wph wps wch wth 3adant.1 adantll 3impa $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       16-Jul-1995.) $)
    3adant2 $p |- ( ( ph /\ th /\ ps ) -> ch ) $=
      wph wth wps wch wph wps wch wth 3adant.1 adantlr 3impa $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       16-Jul-1995.)  (Proof shortened by Wolf Lammen, 21-Jun-2022.) $)
    3adant3 $p |- ( ( ph /\ ps /\ th ) -> ch ) $=
      wph wps wth wch wph wps wch wth 3adant.1 adantrr 3impb $.
  $}

  ${
    3ad2ant.1 $e |- ( ph -> ch ) $.
    $( Deduction adding conjuncts to an antecedent.  (Contributed by NM,
       21-Apr-2005.) $)
    3ad2ant1 $p |- ( ( ph /\ ps /\ th ) -> ch ) $=
      wph wth wch wps wph wch wth 3ad2ant.1 adantr 3adant2 $.

    $( Deduction adding conjuncts to an antecedent.  (Contributed by NM,
       21-Apr-2005.) $)
    3ad2ant2 $p |- ( ( ps /\ ph /\ th ) -> ch ) $=
      wph wth wch wps wph wch wth 3ad2ant.1 adantr 3adant1 $.

    $( Deduction adding conjuncts to an antecedent.  (Contributed by NM,
       21-Apr-2005.) $)
    3ad2ant3 $p |- ( ( ps /\ th /\ ph ) -> ch ) $=
      wth wph wch wps wph wch wth 3ad2ant.1 adantl 3adant1 $.
  $}

  $( Simplification of triple conjunction.  (Contributed by NM, 21-Apr-1994.)
     (Proof shortened by Wolf Lammen, 22-Jun-2022.) $)
  simp1 $p |- ( ( ph /\ ps /\ ch ) -> ph ) $=
    wph wps wph wch wph id 3ad2ant1 $.

  $( Simplification of triple conjunction.  (Contributed by NM, 21-Apr-1994.)
     (Proof shortened by Wolf Lammen, 22-Jun-2022.) $)
  simp2 $p |- ( ( ph /\ ps /\ ch ) -> ps ) $=
    wps wph wps wch wps id 3ad2ant2 $.

  $( Simplification of triple conjunction.  (Contributed by NM, 21-Apr-1994.)
     (Proof shortened by Wolf Lammen, 22-Jun-2022.) $)
  simp3 $p |- ( ( ph /\ ps /\ ch ) -> ch ) $=
    wch wph wch wps wch id 3ad2ant3 $.

  ${
    3simp1i.1 $e |- ( ph /\ ps /\ ch ) $.
    $( Infer a conjunct from a triple conjunction.  (Contributed by NM,
       19-Apr-2005.) $)
    simp1i $p |- ph $=
      wph wps wch w3a wph 3simp1i.1 wph wps wch simp1 ax-mp $.

    $( Infer a conjunct from a triple conjunction.  (Contributed by NM,
       19-Apr-2005.) $)
    simp2i $p |- ps $=
      wph wps wch w3a wps 3simp1i.1 wph wps wch simp2 ax-mp $.

    $( Infer a conjunct from a triple conjunction.  (Contributed by NM,
       19-Apr-2005.) $)
    simp3i $p |- ch $=
      wph wps wch w3a wch 3simp1i.1 wph wps wch simp3 ax-mp $.
  $}

  ${
    3simp1d.1 $e |- ( ph -> ( ps /\ ch /\ th ) ) $.
    $( Deduce a conjunct from a triple conjunction.  (Contributed by NM,
       4-Sep-2005.) $)
    simp1d $p |- ( ph -> ps ) $=
      wph wps wch wth w3a wps 3simp1d.1 wps wch wth simp1 syl $.

    $( Deduce a conjunct from a triple conjunction.  (Contributed by NM,
       4-Sep-2005.) $)
    simp2d $p |- ( ph -> ch ) $=
      wph wps wch wth w3a wch 3simp1d.1 wps wch wth simp2 syl $.

    $( Deduce a conjunct from a triple conjunction.  (Contributed by NM,
       4-Sep-2005.) $)
    simp3d $p |- ( ph -> th ) $=
      wph wps wch wth w3a wth 3simp1d.1 wps wch wth simp3 syl $.
  $}

  ${
    3simp1bi.1 $e |- ( ph <-> ( ps /\ ch /\ th ) ) $.
    $( Deduce a conjunct from a triple conjunction.  (Contributed by Jonathan
       Ben-Naim, 3-Jun-2011.) $)
    simp1bi $p |- ( ph -> ps ) $=
      wph wps wch wth wph wps wch wth w3a 3simp1bi.1 biimpi simp1d $.

    $( Deduce a conjunct from a triple conjunction.  (Contributed by Jonathan
       Ben-Naim, 3-Jun-2011.) $)
    simp2bi $p |- ( ph -> ch ) $=
      wph wps wch wth wph wps wch wth w3a 3simp1bi.1 biimpi simp2d $.

    $( Deduce a conjunct from a triple conjunction.  (Contributed by Jonathan
       Ben-Naim, 3-Jun-2011.) $)
    simp3bi $p |- ( ph -> th ) $=
      wph wps wch wth wph wps wch wth w3a 3simp1bi.1 biimpi simp3d $.
  $}

  $( Simplification of triple conjunction.  (Contributed by NM, 21-Apr-1994.)
     (Proof shortened by Wolf Lammen, 21-Jun-2022.) $)
  3simpa $p |- ( ( ph /\ ps /\ ch ) -> ( ph /\ ps ) ) $=
    wph wps wph wps wa wch wph wps wa id 3adant3 $.

  $( Simplification of triple conjunction.  (Contributed by NM, 21-Apr-1994.)
     (Proof shortened by Wolf Lammen, 21-Jun-2022.) $)
  3simpb $p |- ( ( ph /\ ps /\ ch ) -> ( ph /\ ch ) ) $=
    wph wch wph wch wa wps wph wch wa id 3adant2 $.

  $( Simplification of triple conjunction.  (Contributed by NM, 21-Apr-1994.)
     (Proof shortened by Andrew Salmon, 13-May-2011.)  (Proof shortened by Wolf
     Lammen, 21-Jun-2022.) $)
  3simpc $p |- ( ( ph /\ ps /\ ch ) -> ( ps /\ ch ) ) $=
    wps wch wps wch wa wph wps wch wa id 3adant1 $.

  ${
    3anim123i.1 $e |- ( ph -> ps ) $.
    3anim123i.2 $e |- ( ch -> th ) $.
    3anim123i.3 $e |- ( ta -> et ) $.
    $( Join antecedents and consequents with conjunction.  (Contributed by NM,
       8-Apr-1994.) $)
    3anim123i $p |- ( ( ph /\ ch /\ ta ) -> ( ps /\ th /\ et ) ) $=
      wph wch wta w3a wps wth wet wph wch wps wta 3anim123i.1 3ad2ant1 wch wph
      wth wta 3anim123i.2 3ad2ant2 wta wph wet wch 3anim123i.3 3ad2ant3 3jca $.
  $}

  ${
    3animi.1 $e |- ( ph -> ps ) $.
    $( Add two conjuncts to antecedent and consequent.  (Contributed by Jeff
       Hankins, 16-Aug-2009.) $)
    3anim1i $p |- ( ( ph /\ ch /\ th ) -> ( ps /\ ch /\ th ) ) $=
      wph wps wch wch wth wth 3animi.1 wch id wth id 3anim123i $.

    $( Add two conjuncts to antecedent and consequent.  (Contributed by AV,
       21-Nov-2019.) $)
    3anim2i $p |- ( ( ch /\ ph /\ th ) -> ( ch /\ ps /\ th ) ) $=
      wch wch wph wps wth wth wch id 3animi.1 wth id 3anim123i $.

    $( Add two conjuncts to antecedent and consequent.  (Contributed by Jeff
       Hankins, 19-Aug-2009.) $)
    3anim3i $p |- ( ( ch /\ th /\ ph ) -> ( ch /\ th /\ ps ) ) $=
      wch wch wth wth wph wps wch id wth id 3animi.1 3anim123i $.
  $}

  ${
    bi3.1 $e |- ( ph <-> ps ) $.
    bi3.2 $e |- ( ch <-> th ) $.
    bi3.3 $e |- ( ta <-> et ) $.
    $( Join 3 biconditionals with conjunction.  (Contributed by NM,
       21-Apr-1994.) $)
    3anbi123i $p |- ( ( ph /\ ch /\ ta ) <-> ( ps /\ th /\ et ) ) $=
      wph wch wa wta wa wps wth wa wet wa wph wch wta w3a wps wth wet w3a wph
      wch wa wps wth wa wta wet wph wps wch wth bi3.1 bi3.2 anbi12i bi3.3
      anbi12i wph wch wta df-3an wps wth wet df-3an 3bitr4i $.

    $( Join 3 biconditionals with disjunction.  (Contributed by NM,
       17-May-1994.) $)
    3orbi123i $p |- ( ( ph \/ ch \/ ta ) <-> ( ps \/ th \/ et ) ) $=
      wph wch wo wta wo wps wth wo wet wo wph wch wta w3o wps wth wet w3o wph
      wch wo wps wth wo wta wet wph wps wch wth bi3.1 bi3.2 orbi12i bi3.3
      orbi12i wph wch wta df-3or wps wth wet df-3or 3bitr4i $.
  $}

  ${
    3anbi1i.1 $e |- ( ph <-> ps ) $.
    $( Inference adding two conjuncts to each side of a biconditional.
       (Contributed by NM, 8-Sep-2006.) $)
    3anbi1i $p |- ( ( ph /\ ch /\ th ) <-> ( ps /\ ch /\ th ) ) $=
      wph wps wch wch wth wth 3anbi1i.1 wch biid wth biid 3anbi123i $.

    $( Inference adding two conjuncts to each side of a biconditional.
       (Contributed by NM, 8-Sep-2006.) $)
    3anbi2i $p |- ( ( ch /\ ph /\ th ) <-> ( ch /\ ps /\ th ) ) $=
      wch wch wph wps wth wth wch biid 3anbi1i.1 wth biid 3anbi123i $.

    $( Inference adding two conjuncts to each side of a biconditional.
       (Contributed by NM, 8-Sep-2006.) $)
    3anbi3i $p |- ( ( ch /\ th /\ ph ) <-> ( ch /\ th /\ ps ) ) $=
      wch wch wth wth wph wps wch biid wth biid 3anbi1i.1 3anbi123i $.
  $}

  ${
    syl3an.1 $e |- ( ph -> ps ) $.
    syl3an.2 $e |- ( ch -> th ) $.
    syl3an.3 $e |- ( ta -> et ) $.
    syl3an.4 $e |- ( ( ps /\ th /\ et ) -> ze ) $.
    $( A triple syllogism inference.  (Contributed by NM, 13-May-2004.) $)
    syl3an $p |- ( ( ph /\ ch /\ ta ) -> ze ) $=
      wph wch wta w3a wps wth wet w3a wze wph wps wch wth wta wet syl3an.1
      syl3an.2 syl3an.3 3anim123i syl3an.4 syl $.
  $}

  ${
    syl3anb.1 $e |- ( ph <-> ps ) $.
    syl3anb.2 $e |- ( ch <-> th ) $.
    syl3anb.3 $e |- ( ta <-> et ) $.
    syl3anb.4 $e |- ( ( ps /\ th /\ et ) -> ze ) $.
    $( A triple syllogism inference.  (Contributed by NM, 15-Oct-2005.) $)
    syl3anb $p |- ( ( ph /\ ch /\ ta ) -> ze ) $=
      wph wch wta w3a wps wth wet w3a wze wph wps wch wth wta wet syl3anb.1
      syl3anb.2 syl3anb.3 3anbi123i syl3anb.4 sylbi $.
  $}

  ${
    syl3anbr.1 $e |- ( ps <-> ph ) $.
    syl3anbr.2 $e |- ( th <-> ch ) $.
    syl3anbr.3 $e |- ( et <-> ta ) $.
    syl3anbr.4 $e |- ( ( ps /\ th /\ et ) -> ze ) $.
    $( A triple syllogism inference.  (Contributed by NM, 29-Dec-2011.) $)
    syl3anbr $p |- ( ( ph /\ ch /\ ta ) -> ze ) $=
      wph wps wch wth wta wet wze wps wph syl3anbr.1 bicomi wth wch syl3anbr.2
      bicomi wet wta syl3anbr.3 bicomi syl3anbr.4 syl3anb $.
  $}

  ${
    syl3an1.1 $e |- ( ph -> ps ) $.
    syl3an1.2 $e |- ( ( ps /\ ch /\ th ) -> ta ) $.
    $( A syllogism inference.  (Contributed by NM, 22-Aug-1995.) $)
    syl3an1 $p |- ( ( ph /\ ch /\ th ) -> ta ) $=
      wph wch wth w3a wps wch wth w3a wta wph wps wch wth syl3an1.1 3anim1i
      syl3an1.2 syl $.
  $}

  ${
    syl3an2.1 $e |- ( ph -> ch ) $.
    syl3an2.2 $e |- ( ( ps /\ ch /\ th ) -> ta ) $.
    $( A syllogism inference.  (Contributed by NM, 22-Aug-1995.)  (Proof
       shortened by Wolf Lammen, 26-Jun-2022.) $)
    syl3an2 $p |- ( ( ps /\ ph /\ th ) -> ta ) $=
      wps wph wth w3a wps wch wth w3a wta wph wch wps wth syl3an2.1 3anim2i
      syl3an2.2 syl $.
  $}

  ${
    syl3an3.1 $e |- ( ph -> th ) $.
    syl3an3.2 $e |- ( ( ps /\ ch /\ th ) -> ta ) $.
    $( A syllogism inference.  (Contributed by NM, 22-Aug-1995.)  (Proof
       shortened by Wolf Lammen, 26-Jun-2022.) $)
    syl3an3 $p |- ( ( ps /\ ch /\ ph ) -> ta ) $=
      wps wch wph w3a wps wch wth w3a wta wph wth wps wch syl3an3.1 3anim3i
      syl3an3.2 syl $.
  $}

  ${
    syl3an132.1 $e |- ( ph -> ps ) $.
    syl3an132.2 $e |- ( ( ch /\ th ) -> ta ) $.
    syl3an132.3 $e |- ( ( ps /\ ta ) -> et ) $.
    $( ~ syl2an with antecedents in standard conjunction form.  (Contributed by
       Alan Sare, 26-Aug-2016.) $)
    syl3an132 $p |- ( ( ph /\ ch /\ th ) -> et ) $=
      wph wch wth wet wph wps wta wet wch wth wa syl3an132.1 syl3an132.2
      syl3an132.3 syl2an 3impb $.
  $}

  ${
    3adantl.1 $e |- ( ( ( ph /\ ps ) /\ ch ) -> th ) $.
    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       24-Feb-2005.) $)
    3adantl1 $p |- ( ( ( ta /\ ph /\ ps ) /\ ch ) -> th ) $=
      wta wph wps w3a wph wps wa wch wth wta wph wps 3simpc 3adantl.1 sylan $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       24-Feb-2005.) $)
    3adantl2 $p |- ( ( ( ph /\ ta /\ ps ) /\ ch ) -> th ) $=
      wph wta wps w3a wph wps wa wch wth wph wta wps 3simpb 3adantl.1 sylan $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       24-Feb-2005.) $)
    3adantl3 $p |- ( ( ( ph /\ ps /\ ta ) /\ ch ) -> th ) $=
      wph wps wta w3a wph wps wa wch wth wph wps wta 3simpa 3adantl.1 sylan $.
  $}

  ${
    3adantr.1 $e |- ( ( ph /\ ( ps /\ ch ) ) -> th ) $.
    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       27-Apr-2005.) $)
    3adantr1 $p |- ( ( ph /\ ( ta /\ ps /\ ch ) ) -> th ) $=
      wta wps wch w3a wph wps wch wa wth wta wps wch 3simpc 3adantr.1 sylan2 $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       27-Apr-2005.) $)
    3adantr2 $p |- ( ( ph /\ ( ps /\ ta /\ ch ) ) -> th ) $=
      wps wta wch w3a wph wps wch wa wth wps wta wch 3simpb 3adantr.1 sylan2 $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       27-Apr-2005.) $)
    3adantr3 $p |- ( ( ph /\ ( ps /\ ch /\ ta ) ) -> th ) $=
      wps wch wta w3a wph wps wch wa wth wps wch wta 3simpa 3adantr.1 sylan2 $.
  $}

  ${
    ad4ant3.1 $e |- ( ( ph /\ ps /\ ch ) -> th ) $.
    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 14-Apr-2022.) $)
    ad4ant123 $p |- ( ( ( ( ph /\ ps ) /\ ch ) /\ ta ) -> th ) $=
      wph wps wa wch wa wth wta wph wps wch wth ad4ant3.1 3expa adantr $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 14-Apr-2022.) $)
    ad4ant124 $p |- ( ( ( ( ph /\ ps ) /\ ta ) /\ ch ) -> th ) $=
      wph wps wa wch wth wta wph wps wch wth ad4ant3.1 3expa adantlr $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 14-Apr-2022.) $)
    ad4ant134 $p |- ( ( ( ( ph /\ ta ) /\ ps ) /\ ch ) -> th ) $=
      wph wps wch wth wta wph wps wch wth ad4ant3.1 3expa adantllr $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 14-Apr-2022.) $)
    ad4ant234 $p |- ( ( ( ( ta /\ ph ) /\ ps ) /\ ch ) -> th ) $=
      wph wps wch wth wta wph wps wch wth ad4ant3.1 3expa adantlll $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       8-Jan-2006.)  (Proof shortened by Wolf Lammen, 23-Jun-2022.) $)
    3adant1l $p |- ( ( ( ta /\ ph ) /\ ps /\ ch ) -> th ) $=
      wta wph wa wph wps wch wth wta wph simpr ad4ant3.1 syl3an1 $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       8-Jan-2006.)  (Proof shortened by Wolf Lammen, 23-Jun-2022.) $)
    3adant1r $p |- ( ( ( ph /\ ta ) /\ ps /\ ch ) -> th ) $=
      wph wta wa wph wps wch wth wph wta simpl ad4ant3.1 syl3an1 $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       8-Jan-2006.)  (Proof shortened by Wolf Lammen, 25-Jun-2022.) $)
    3adant2l $p |- ( ( ph /\ ( ta /\ ps ) /\ ch ) -> th ) $=
      wta wps wa wph wps wch wth wta wps simpr ad4ant3.1 syl3an2 $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       8-Jan-2006.)  (Proof shortened by Wolf Lammen, 25-Jun-2022.) $)
    3adant2r $p |- ( ( ph /\ ( ps /\ ta ) /\ ch ) -> th ) $=
      wps wta wa wph wps wch wth wps wta simpl ad4ant3.1 syl3an2 $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       8-Jan-2006.)  (Proof shortened by Wolf Lammen, 25-Jun-2022.) $)
    3adant3l $p |- ( ( ph /\ ps /\ ( ta /\ ch ) ) -> th ) $=
      wta wch wa wph wps wch wth wta wch simpr ad4ant3.1 syl3an3 $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       8-Jan-2006.)  (Proof shortened by Wolf Lammen, 25-Jun-2022.) $)
    3adant3r $p |- ( ( ph /\ ps /\ ( ch /\ ta ) ) -> th ) $=
      wch wta wa wph wps wch wth wch wta simpl ad4ant3.1 syl3an3 $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       16-Feb-2008.) $)
    3adant3r1 $p |- ( ( ph /\ ( ta /\ ps /\ ch ) ) -> th ) $=
      wph wps wch wth wta wph wps wch wth ad4ant3.1 3expb 3adantr1 $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       17-Feb-2008.) $)
    3adant3r2 $p |- ( ( ph /\ ( ps /\ ta /\ ch ) ) -> th ) $=
      wph wps wch wth wta wph wps wch wth ad4ant3.1 3expb 3adantr2 $.

    $( Deduction adding a conjunct to antecedent.  (Contributed by NM,
       18-Feb-2008.) $)
    3adant3r3 $p |- ( ( ph /\ ( ps /\ ch /\ ta ) ) -> th ) $=
      wph wps wch wth wta wph wps wch wth ad4ant3.1 3expb 3adantr3 $.
  $}

  ${
    3ad2antl.1 $e |- ( ( ph /\ ch ) -> th ) $.
    $( Deduction adding conjuncts to antecedent.  (Contributed by NM,
       4-Aug-2007.) $)
    3ad2antl1 $p |- ( ( ( ph /\ ps /\ ta ) /\ ch ) -> th ) $=
      wph wta wch wth wps wph wch wth wta 3ad2antl.1 adantlr 3adantl2 $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by NM,
       4-Aug-2007.) $)
    3ad2antl2 $p |- ( ( ( ps /\ ph /\ ta ) /\ ch ) -> th ) $=
      wph wta wch wth wps wph wch wth wta 3ad2antl.1 adantlr 3adantl1 $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by NM,
       4-Aug-2007.) $)
    3ad2antl3 $p |- ( ( ( ps /\ ta /\ ph ) /\ ch ) -> th ) $=
      wta wph wch wth wps wph wch wth wta 3ad2antl.1 adantll 3adantl1 $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by NM,
       25-Dec-2007.) $)
    3ad2antr1 $p |- ( ( ph /\ ( ch /\ ps /\ ta ) ) -> th ) $=
      wph wch wps wth wta wph wch wth wps 3ad2antl.1 adantrr 3adantr3 $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by NM,
       27-Dec-2007.) $)
    3ad2antr2 $p |- ( ( ph /\ ( ps /\ ch /\ ta ) ) -> th ) $=
      wph wps wch wth wta wph wch wth wps 3ad2antl.1 adantrl 3adantr3 $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by NM,
       30-Dec-2007.) $)
    3ad2antr3 $p |- ( ( ph /\ ( ps /\ ta /\ ch ) ) -> th ) $=
      wph wta wch wth wps wph wch wth wta 3ad2antl.1 adantrl 3adantr1 $.
  $}

  $( Simplification of conjunction.  (Contributed by Jeff Hankins,
     17-Nov-2009.)  (Proof shortened by Wolf Lammen, 23-Jun-2022.) $)
  simpl1 $p |- ( ( ( ph /\ ps /\ ch ) /\ th ) -> ph ) $=
    wph wps wth wph wch wph wth simpl 3ad2antl1 $.

  $( Simplification of conjunction.  (Contributed by Jeff Hankins,
     17-Nov-2009.)  (Proof shortened by Wolf Lammen, 23-Jun-2022.) $)
  simpl2 $p |- ( ( ( ph /\ ps /\ ch ) /\ th ) -> ps ) $=
    wps wph wth wps wch wps wth simpl 3ad2antl2 $.

  $( Simplification of conjunction.  (Contributed by Jeff Hankins,
     17-Nov-2009.)  (Proof shortened by Wolf Lammen, 23-Jun-2022.) $)
  simpl3 $p |- ( ( ( ph /\ ps /\ ch ) /\ th ) -> ch ) $=
    wch wph wth wch wps wch wth simpl 3ad2antl3 $.

  $( Simplification of conjunction.  (Contributed by Jeff Hankins,
     17-Nov-2009.)  (Proof shortened by Wolf Lammen, 23-Jun-2022.) $)
  simpr1 $p |- ( ( ph /\ ( ps /\ ch /\ th ) ) -> ps ) $=
    wph wch wps wps wth wph wps simpr 3ad2antr1 $.

  $( Simplification of conjunction.  (Contributed by Jeff Hankins,
     17-Nov-2009.)  (Proof shortened by Wolf Lammen, 23-Jun-2022.) $)
  simpr2 $p |- ( ( ph /\ ( ps /\ ch /\ th ) ) -> ch ) $=
    wph wps wch wch wth wph wch simpr 3ad2antr2 $.

  $( Simplification of conjunction.  (Contributed by Jeff Hankins,
     17-Nov-2009.)  (Proof shortened by Wolf Lammen, 23-Jun-2022.) $)
  simpr3 $p |- ( ( ph /\ ( ps /\ ch /\ th ) ) -> th ) $=
    wph wps wth wth wch wph wth simpr 3ad2antr3 $.

  $( Simplification of triple conjunction.  (Contributed by NM, 9-Nov-2011.) $)
  simp1l $p |- ( ( ( ph /\ ps ) /\ ch /\ th ) -> ph ) $=
    wph wps wa wch wph wth wph wps simpl 3ad2ant1 $.

  $( Simplification of triple conjunction.  (Contributed by NM, 9-Nov-2011.) $)
  simp1r $p |- ( ( ( ph /\ ps ) /\ ch /\ th ) -> ps ) $=
    wph wps wa wch wps wth wph wps simpr 3ad2ant1 $.

  $( Simplification of triple conjunction.  (Contributed by NM, 9-Nov-2011.) $)
  simp2l $p |- ( ( ph /\ ( ps /\ ch ) /\ th ) -> ps ) $=
    wps wch wa wph wps wth wps wch simpl 3ad2ant2 $.

  $( Simplification of triple conjunction.  (Contributed by NM, 9-Nov-2011.) $)
  simp2r $p |- ( ( ph /\ ( ps /\ ch ) /\ th ) -> ch ) $=
    wps wch wa wph wch wth wps wch simpr 3ad2ant2 $.

  $( Simplification of triple conjunction.  (Contributed by NM, 9-Nov-2011.) $)
  simp3l $p |- ( ( ph /\ ps /\ ( ch /\ th ) ) -> ch ) $=
    wch wth wa wph wch wps wch wth simpl 3ad2ant3 $.

  $( Simplification of triple conjunction.  (Contributed by NM, 9-Nov-2011.) $)
  simp3r $p |- ( ( ph /\ ps /\ ( ch /\ th ) ) -> th ) $=
    wch wth wa wph wth wps wch wth simpr 3ad2ant3 $.

  $( Simplification of doubly triple conjunction.  (Contributed by NM,
     17-Nov-2011.) $)
  simp11 $p |- ( ( ( ph /\ ps /\ ch ) /\ th /\ ta ) -> ph ) $=
    wph wps wch w3a wth wph wta wph wps wch simp1 3ad2ant1 $.

  $( Simplification of doubly triple conjunction.  (Contributed by NM,
     17-Nov-2011.) $)
  simp12 $p |- ( ( ( ph /\ ps /\ ch ) /\ th /\ ta ) -> ps ) $=
    wph wps wch w3a wth wps wta wph wps wch simp2 3ad2ant1 $.

  $( Simplification of doubly triple conjunction.  (Contributed by NM,
     17-Nov-2011.) $)
  simp13 $p |- ( ( ( ph /\ ps /\ ch ) /\ th /\ ta ) -> ch ) $=
    wph wps wch w3a wth wch wta wph wps wch simp3 3ad2ant1 $.

  $( Simplification of doubly triple conjunction.  (Contributed by NM,
     17-Nov-2011.) $)
  simp21 $p |- ( ( ph /\ ( ps /\ ch /\ th ) /\ ta ) -> ps ) $=
    wps wch wth w3a wph wps wta wps wch wth simp1 3ad2ant2 $.

  $( Simplification of doubly triple conjunction.  (Contributed by NM,
     17-Nov-2011.) $)
  simp22 $p |- ( ( ph /\ ( ps /\ ch /\ th ) /\ ta ) -> ch ) $=
    wps wch wth w3a wph wch wta wps wch wth simp2 3ad2ant2 $.

  $( Simplification of doubly triple conjunction.  (Contributed by NM,
     17-Nov-2011.) $)
  simp23 $p |- ( ( ph /\ ( ps /\ ch /\ th ) /\ ta ) -> th ) $=
    wps wch wth w3a wph wth wta wps wch wth simp3 3ad2ant2 $.

  $( Simplification of doubly triple conjunction.  (Contributed by NM,
     17-Nov-2011.) $)
  simp31 $p |- ( ( ph /\ ps /\ ( ch /\ th /\ ta ) ) -> ch ) $=
    wch wth wta w3a wph wch wps wch wth wta simp1 3ad2ant3 $.

  $( Simplification of doubly triple conjunction.  (Contributed by NM,
     17-Nov-2011.) $)
  simp32 $p |- ( ( ph /\ ps /\ ( ch /\ th /\ ta ) ) -> th ) $=
    wch wth wta w3a wph wth wps wch wth wta simp2 3ad2ant3 $.

  $( Simplification of doubly triple conjunction.  (Contributed by NM,
     17-Nov-2011.) $)
  simp33 $p |- ( ( ph /\ ps /\ ( ch /\ th /\ ta ) ) -> ta ) $=
    wch wth wta w3a wph wta wps wch wth wta simp3 3ad2ant3 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 23-Jun-2022.) $)
  simpll1 $p |- ( ( ( ( ph /\ ps /\ ch ) /\ th ) /\ ta ) -> ph ) $=
    wph wps wch w3a wph wth wta wph wps wch simp1 ad2antrr $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 23-Jun-2022.) $)
  simpll2 $p |- ( ( ( ( ph /\ ps /\ ch ) /\ th ) /\ ta ) -> ps ) $=
    wph wps wch w3a wps wth wta wph wps wch simp2 ad2antrr $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 23-Jun-2022.) $)
  simpll3 $p |- ( ( ( ( ph /\ ps /\ ch ) /\ th ) /\ ta ) -> ch ) $=
    wph wps wch w3a wch wth wta wph wps wch simp3 ad2antrr $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 23-Jun-2022.) $)
  simplr1 $p |- ( ( ( th /\ ( ph /\ ps /\ ch ) ) /\ ta ) -> ph ) $=
    wph wps wch w3a wph wth wta wph wps wch simp1 ad2antlr $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 23-Jun-2022.) $)
  simplr2 $p |- ( ( ( th /\ ( ph /\ ps /\ ch ) ) /\ ta ) -> ps ) $=
    wph wps wch w3a wps wth wta wph wps wch simp2 ad2antlr $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 23-Jun-2022.) $)
  simplr3 $p |- ( ( ( th /\ ( ph /\ ps /\ ch ) ) /\ ta ) -> ch ) $=
    wph wps wch w3a wch wth wta wph wps wch simp3 ad2antlr $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 23-Jun-2022.) $)
  simprl1 $p |- ( ( ta /\ ( ( ph /\ ps /\ ch ) /\ th ) ) -> ph ) $=
    wph wps wch w3a wph wta wth wph wps wch simp1 ad2antrl $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 23-Jun-2022.) $)
  simprl2 $p |- ( ( ta /\ ( ( ph /\ ps /\ ch ) /\ th ) ) -> ps ) $=
    wph wps wch w3a wps wta wth wph wps wch simp2 ad2antrl $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 23-Jun-2022.) $)
  simprl3 $p |- ( ( ta /\ ( ( ph /\ ps /\ ch ) /\ th ) ) -> ch ) $=
    wph wps wch w3a wch wta wth wph wps wch simp3 ad2antrl $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 23-Jun-2022.) $)
  simprr1 $p |- ( ( ta /\ ( th /\ ( ph /\ ps /\ ch ) ) ) -> ph ) $=
    wph wps wch w3a wph wta wth wph wps wch simp1 ad2antll $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 23-Jun-2022.) $)
  simprr2 $p |- ( ( ta /\ ( th /\ ( ph /\ ps /\ ch ) ) ) -> ps ) $=
    wph wps wch w3a wps wta wth wph wps wch simp2 ad2antll $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 23-Jun-2022.) $)
  simprr3 $p |- ( ( ta /\ ( th /\ ( ph /\ ps /\ ch ) ) ) -> ch ) $=
    wph wps wch w3a wch wta wth wph wps wch simp3 ad2antll $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 23-Jun-2022.) $)
  simpl1l $p |- ( ( ( ( ph /\ ps ) /\ ch /\ th ) /\ ta ) -> ph ) $=
    wph wps wa wch wta wph wth wph wps wta simpll 3ad2antl1 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 23-Jun-2022.) $)
  simpl1r $p |- ( ( ( ( ph /\ ps ) /\ ch /\ th ) /\ ta ) -> ps ) $=
    wph wps wa wch wta wps wth wph wps wta simplr 3ad2antl1 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 23-Jun-2022.) $)
  simpl2l $p |- ( ( ( ch /\ ( ph /\ ps ) /\ th ) /\ ta ) -> ph ) $=
    wph wps wa wch wta wph wth wph wps wta simpll 3ad2antl2 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 23-Jun-2022.) $)
  simpl2r $p |- ( ( ( ch /\ ( ph /\ ps ) /\ th ) /\ ta ) -> ps ) $=
    wph wps wa wch wta wps wth wph wps wta simplr 3ad2antl2 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 23-Jun-2022.) $)
  simpl3l $p |- ( ( ( ch /\ th /\ ( ph /\ ps ) ) /\ ta ) -> ph ) $=
    wph wps wa wch wta wph wth wph wps wta simpll 3ad2antl3 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 23-Jun-2022.) $)
  simpl3r $p |- ( ( ( ch /\ th /\ ( ph /\ ps ) ) /\ ta ) -> ps ) $=
    wph wps wa wch wta wps wth wph wps wta simplr 3ad2antl3 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpr1l $p |- ( ( ta /\ ( ( ph /\ ps ) /\ ch /\ th ) ) -> ph ) $=
    wta wch wph wps wa wph wth wta wph wps simprl 3ad2antr1 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpr1r $p |- ( ( ta /\ ( ( ph /\ ps ) /\ ch /\ th ) ) -> ps ) $=
    wta wch wph wps wa wps wth wta wph wps simprr 3ad2antr1 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpr2l $p |- ( ( ta /\ ( ch /\ ( ph /\ ps ) /\ th ) ) -> ph ) $=
    wta wch wph wps wa wph wth wta wph wps simprl 3ad2antr2 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpr2r $p |- ( ( ta /\ ( ch /\ ( ph /\ ps ) /\ th ) ) -> ps ) $=
    wta wch wph wps wa wps wth wta wph wps simprr 3ad2antr2 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpr3l $p |- ( ( ta /\ ( ch /\ th /\ ( ph /\ ps ) ) ) -> ph ) $=
    wta wch wph wps wa wph wth wta wph wps simprl 3ad2antr3 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpr3r $p |- ( ( ta /\ ( ch /\ th /\ ( ph /\ ps ) ) ) -> ps ) $=
    wta wch wph wps wa wps wth wta wph wps simprr 3ad2antr3 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp1ll $p |- ( ( ( ( ph /\ ps ) /\ ch ) /\ th /\ ta ) -> ph ) $=
    wph wps wa wch wa wth wph wta wph wps wch simpll 3ad2ant1 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp1lr $p |- ( ( ( ( ph /\ ps ) /\ ch ) /\ th /\ ta ) -> ps ) $=
    wph wps wa wch wa wth wps wta wph wps wch simplr 3ad2ant1 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp1rl $p |- ( ( ( ch /\ ( ph /\ ps ) ) /\ th /\ ta ) -> ph ) $=
    wch wph wps wa wa wth wph wta wch wph wps simprl 3ad2ant1 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp1rr $p |- ( ( ( ch /\ ( ph /\ ps ) ) /\ th /\ ta ) -> ps ) $=
    wch wph wps wa wa wth wps wta wch wph wps simprr 3ad2ant1 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp2ll $p |- ( ( th /\ ( ( ph /\ ps ) /\ ch ) /\ ta ) -> ph ) $=
    wph wps wa wch wa wth wph wta wph wps wch simpll 3ad2ant2 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp2lr $p |- ( ( th /\ ( ( ph /\ ps ) /\ ch ) /\ ta ) -> ps ) $=
    wph wps wa wch wa wth wps wta wph wps wch simplr 3ad2ant2 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp2rl $p |- ( ( th /\ ( ch /\ ( ph /\ ps ) ) /\ ta ) -> ph ) $=
    wch wph wps wa wa wth wph wta wch wph wps simprl 3ad2ant2 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp2rr $p |- ( ( th /\ ( ch /\ ( ph /\ ps ) ) /\ ta ) -> ps ) $=
    wch wph wps wa wa wth wps wta wch wph wps simprr 3ad2ant2 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp3ll $p |- ( ( th /\ ta /\ ( ( ph /\ ps ) /\ ch ) ) -> ph ) $=
    wph wps wa wch wa wth wph wta wph wps wch simpll 3ad2ant3 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp3lr $p |- ( ( th /\ ta /\ ( ( ph /\ ps ) /\ ch ) ) -> ps ) $=
    wph wps wa wch wa wth wps wta wph wps wch simplr 3ad2ant3 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp3rl $p |- ( ( th /\ ta /\ ( ch /\ ( ph /\ ps ) ) ) -> ph ) $=
    wch wph wps wa wa wth wph wta wch wph wps simprl 3ad2ant3 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp3rr $p |- ( ( th /\ ta /\ ( ch /\ ( ph /\ ps ) ) ) -> ps ) $=
    wch wph wps wa wa wth wps wta wch wph wps simprr 3ad2ant3 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpl11 $p |- ( ( ( ( ph /\ ps /\ ch ) /\ th /\ ta ) /\ et ) -> ph ) $=
    wph wps wch w3a wth wet wph wta wph wps wch wet simpl1 3ad2antl1 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpl12 $p |- ( ( ( ( ph /\ ps /\ ch ) /\ th /\ ta ) /\ et ) -> ps ) $=
    wph wps wch w3a wth wet wps wta wph wps wch wet simpl2 3ad2antl1 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpl13 $p |- ( ( ( ( ph /\ ps /\ ch ) /\ th /\ ta ) /\ et ) -> ch ) $=
    wph wps wch w3a wth wet wch wta wph wps wch wet simpl3 3ad2antl1 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpl21 $p |- ( ( ( th /\ ( ph /\ ps /\ ch ) /\ ta ) /\ et ) -> ph ) $=
    wph wps wch w3a wth wet wph wta wph wps wch wet simpl1 3ad2antl2 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpl22 $p |- ( ( ( th /\ ( ph /\ ps /\ ch ) /\ ta ) /\ et ) -> ps ) $=
    wph wps wch w3a wth wet wps wta wph wps wch wet simpl2 3ad2antl2 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpl23 $p |- ( ( ( th /\ ( ph /\ ps /\ ch ) /\ ta ) /\ et ) -> ch ) $=
    wph wps wch w3a wth wet wch wta wph wps wch wet simpl3 3ad2antl2 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpl31 $p |- ( ( ( th /\ ta /\ ( ph /\ ps /\ ch ) ) /\ et ) -> ph ) $=
    wph wps wch w3a wth wet wph wta wph wps wch wet simpl1 3ad2antl3 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpl32 $p |- ( ( ( th /\ ta /\ ( ph /\ ps /\ ch ) ) /\ et ) -> ps ) $=
    wph wps wch w3a wth wet wps wta wph wps wch wet simpl2 3ad2antl3 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpl33 $p |- ( ( ( th /\ ta /\ ( ph /\ ps /\ ch ) ) /\ et ) -> ch ) $=
    wph wps wch w3a wth wet wch wta wph wps wch wet simpl3 3ad2antl3 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpr11 $p |- ( ( et /\ ( ( ph /\ ps /\ ch ) /\ th /\ ta ) ) -> ph ) $=
    wet wth wph wps wch w3a wph wta wet wph wps wch simpr1 3ad2antr1 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpr12 $p |- ( ( et /\ ( ( ph /\ ps /\ ch ) /\ th /\ ta ) ) -> ps ) $=
    wet wth wph wps wch w3a wps wta wet wph wps wch simpr2 3ad2antr1 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpr13 $p |- ( ( et /\ ( ( ph /\ ps /\ ch ) /\ th /\ ta ) ) -> ch ) $=
    wet wth wph wps wch w3a wch wta wet wph wps wch simpr3 3ad2antr1 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpr21 $p |- ( ( et /\ ( th /\ ( ph /\ ps /\ ch ) /\ ta ) ) -> ph ) $=
    wet wth wph wps wch w3a wph wta wet wph wps wch simpr1 3ad2antr2 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpr22 $p |- ( ( et /\ ( th /\ ( ph /\ ps /\ ch ) /\ ta ) ) -> ps ) $=
    wet wth wph wps wch w3a wps wta wet wph wps wch simpr2 3ad2antr2 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpr23 $p |- ( ( et /\ ( th /\ ( ph /\ ps /\ ch ) /\ ta ) ) -> ch ) $=
    wet wth wph wps wch w3a wch wta wet wph wps wch simpr3 3ad2antr2 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpr31 $p |- ( ( et /\ ( th /\ ta /\ ( ph /\ ps /\ ch ) ) ) -> ph ) $=
    wet wth wph wps wch w3a wph wta wet wph wps wch simpr1 3ad2antr3 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpr32 $p |- ( ( et /\ ( th /\ ta /\ ( ph /\ ps /\ ch ) ) ) -> ps ) $=
    wet wth wph wps wch w3a wps wta wet wph wps wch simpr2 3ad2antr3 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.)  (Proof
     shortened by Wolf Lammen, 24-Jun-2022.) $)
  simpr33 $p |- ( ( et /\ ( th /\ ta /\ ( ph /\ ps /\ ch ) ) ) -> ch ) $=
    wet wth wph wps wch w3a wch wta wet wph wps wch simpr3 3ad2antr3 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp1l1 $p |- ( ( ( ( ph /\ ps /\ ch ) /\ th ) /\ ta /\ et ) -> ph ) $=
    wph wps wch w3a wth wa wta wph wet wph wps wch wth simpl1 3ad2ant1 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp1l2 $p |- ( ( ( ( ph /\ ps /\ ch ) /\ th ) /\ ta /\ et ) -> ps ) $=
    wph wps wch w3a wth wa wta wps wet wph wps wch wth simpl2 3ad2ant1 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp1l3 $p |- ( ( ( ( ph /\ ps /\ ch ) /\ th ) /\ ta /\ et ) -> ch ) $=
    wph wps wch w3a wth wa wta wch wet wph wps wch wth simpl3 3ad2ant1 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp1r1 $p |- ( ( ( th /\ ( ph /\ ps /\ ch ) ) /\ ta /\ et ) -> ph ) $=
    wth wph wps wch w3a wa wta wph wet wth wph wps wch simpr1 3ad2ant1 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp1r2 $p |- ( ( ( th /\ ( ph /\ ps /\ ch ) ) /\ ta /\ et ) -> ps ) $=
    wth wph wps wch w3a wa wta wps wet wth wph wps wch simpr2 3ad2ant1 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp1r3 $p |- ( ( ( th /\ ( ph /\ ps /\ ch ) ) /\ ta /\ et ) -> ch ) $=
    wth wph wps wch w3a wa wta wch wet wth wph wps wch simpr3 3ad2ant1 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp2l1 $p |- ( ( ta /\ ( ( ph /\ ps /\ ch ) /\ th ) /\ et ) -> ph ) $=
    wph wps wch w3a wth wa wta wph wet wph wps wch wth simpl1 3ad2ant2 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp2l2 $p |- ( ( ta /\ ( ( ph /\ ps /\ ch ) /\ th ) /\ et ) -> ps ) $=
    wph wps wch w3a wth wa wta wps wet wph wps wch wth simpl2 3ad2ant2 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp2l3 $p |- ( ( ta /\ ( ( ph /\ ps /\ ch ) /\ th ) /\ et ) -> ch ) $=
    wph wps wch w3a wth wa wta wch wet wph wps wch wth simpl3 3ad2ant2 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp2r1 $p |- ( ( ta /\ ( th /\ ( ph /\ ps /\ ch ) ) /\ et ) -> ph ) $=
    wth wph wps wch w3a wa wta wph wet wth wph wps wch simpr1 3ad2ant2 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp2r2 $p |- ( ( ta /\ ( th /\ ( ph /\ ps /\ ch ) ) /\ et ) -> ps ) $=
    wth wph wps wch w3a wa wta wps wet wth wph wps wch simpr2 3ad2ant2 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp2r3 $p |- ( ( ta /\ ( th /\ ( ph /\ ps /\ ch ) ) /\ et ) -> ch ) $=
    wth wph wps wch w3a wa wta wch wet wth wph wps wch simpr3 3ad2ant2 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp3l1 $p |- ( ( ta /\ et /\ ( ( ph /\ ps /\ ch ) /\ th ) ) -> ph ) $=
    wph wps wch w3a wth wa wta wph wet wph wps wch wth simpl1 3ad2ant3 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp3l2 $p |- ( ( ta /\ et /\ ( ( ph /\ ps /\ ch ) /\ th ) ) -> ps ) $=
    wph wps wch w3a wth wa wta wps wet wph wps wch wth simpl2 3ad2ant3 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp3l3 $p |- ( ( ta /\ et /\ ( ( ph /\ ps /\ ch ) /\ th ) ) -> ch ) $=
    wph wps wch w3a wth wa wta wch wet wph wps wch wth simpl3 3ad2ant3 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp3r1 $p |- ( ( ta /\ et /\ ( th /\ ( ph /\ ps /\ ch ) ) ) -> ph ) $=
    wth wph wps wch w3a wa wta wph wet wth wph wps wch simpr1 3ad2ant3 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp3r2 $p |- ( ( ta /\ et /\ ( th /\ ( ph /\ ps /\ ch ) ) ) -> ps ) $=
    wth wph wps wch w3a wa wta wps wet wth wph wps wch simpr2 3ad2ant3 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp3r3 $p |- ( ( ta /\ et /\ ( th /\ ( ph /\ ps /\ ch ) ) ) -> ch ) $=
    wth wph wps wch w3a wa wta wch wet wth wph wps wch simpr3 3ad2ant3 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp11l $p |- ( ( ( ( ph /\ ps ) /\ ch /\ th ) /\ ta /\ et ) -> ph ) $=
    wph wps wa wch wth w3a wta wph wet wph wps wch wth simp1l 3ad2ant1 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp11r $p |- ( ( ( ( ph /\ ps ) /\ ch /\ th ) /\ ta /\ et ) -> ps ) $=
    wph wps wa wch wth w3a wta wps wet wph wps wch wth simp1r 3ad2ant1 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp12l $p |- ( ( ( ch /\ ( ph /\ ps ) /\ th ) /\ ta /\ et ) -> ph ) $=
    wch wph wps wa wth w3a wta wph wet wch wph wps wth simp2l 3ad2ant1 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp12r $p |- ( ( ( ch /\ ( ph /\ ps ) /\ th ) /\ ta /\ et ) -> ps ) $=
    wch wph wps wa wth w3a wta wps wet wch wph wps wth simp2r 3ad2ant1 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp13l $p |- ( ( ( ch /\ th /\ ( ph /\ ps ) ) /\ ta /\ et ) -> ph ) $=
    wch wth wph wps wa w3a wta wph wet wch wth wph wps simp3l 3ad2ant1 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp13r $p |- ( ( ( ch /\ th /\ ( ph /\ ps ) ) /\ ta /\ et ) -> ps ) $=
    wch wth wph wps wa w3a wta wps wet wch wth wph wps simp3r 3ad2ant1 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp21l $p |- ( ( ta /\ ( ( ph /\ ps ) /\ ch /\ th ) /\ et ) -> ph ) $=
    wph wps wa wch wth w3a wta wph wet wph wps wch wth simp1l 3ad2ant2 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp21r $p |- ( ( ta /\ ( ( ph /\ ps ) /\ ch /\ th ) /\ et ) -> ps ) $=
    wph wps wa wch wth w3a wta wps wet wph wps wch wth simp1r 3ad2ant2 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp22l $p |- ( ( ta /\ ( ch /\ ( ph /\ ps ) /\ th ) /\ et ) -> ph ) $=
    wch wph wps wa wth w3a wta wph wet wch wph wps wth simp2l 3ad2ant2 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp22r $p |- ( ( ta /\ ( ch /\ ( ph /\ ps ) /\ th ) /\ et ) -> ps ) $=
    wch wph wps wa wth w3a wta wps wet wch wph wps wth simp2r 3ad2ant2 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp23l $p |- ( ( ta /\ ( ch /\ th /\ ( ph /\ ps ) ) /\ et ) -> ph ) $=
    wch wth wph wps wa w3a wta wph wet wch wth wph wps simp3l 3ad2ant2 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp23r $p |- ( ( ta /\ ( ch /\ th /\ ( ph /\ ps ) ) /\ et ) -> ps ) $=
    wch wth wph wps wa w3a wta wps wet wch wth wph wps simp3r 3ad2ant2 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp31l $p |- ( ( ta /\ et /\ ( ( ph /\ ps ) /\ ch /\ th ) ) -> ph ) $=
    wph wps wa wch wth w3a wta wph wet wph wps wch wth simp1l 3ad2ant3 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp31r $p |- ( ( ta /\ et /\ ( ( ph /\ ps ) /\ ch /\ th ) ) -> ps ) $=
    wph wps wa wch wth w3a wta wps wet wph wps wch wth simp1r 3ad2ant3 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp32l $p |- ( ( ta /\ et /\ ( ch /\ ( ph /\ ps ) /\ th ) ) -> ph ) $=
    wch wph wps wa wth w3a wta wph wet wch wph wps wth simp2l 3ad2ant3 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp32r $p |- ( ( ta /\ et /\ ( ch /\ ( ph /\ ps ) /\ th ) ) -> ps ) $=
    wch wph wps wa wth w3a wta wps wet wch wph wps wth simp2r 3ad2ant3 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp33l $p |- ( ( ta /\ et /\ ( ch /\ th /\ ( ph /\ ps ) ) ) -> ph ) $=
    wch wth wph wps wa w3a wta wph wet wch wth wph wps simp3l 3ad2ant3 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp33r $p |- ( ( ta /\ et /\ ( ch /\ th /\ ( ph /\ ps ) ) ) -> ps ) $=
    wch wth wph wps wa w3a wta wps wet wch wth wph wps simp3r 3ad2ant3 $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp111 $p |- ( ( ( ( ph /\ ps /\ ch ) /\ th /\ ta ) /\ et /\ ze ) -> ph ) $=
    wph wps wch w3a wth wta w3a wet wph wze wph wps wch wth wta simp11 3ad2ant1
    $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp112 $p |- ( ( ( ( ph /\ ps /\ ch ) /\ th /\ ta ) /\ et /\ ze ) -> ps ) $=
    wph wps wch w3a wth wta w3a wet wps wze wph wps wch wth wta simp12 3ad2ant1
    $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp113 $p |- ( ( ( ( ph /\ ps /\ ch ) /\ th /\ ta ) /\ et /\ ze ) -> ch ) $=
    wph wps wch w3a wth wta w3a wet wch wze wph wps wch wth wta simp13 3ad2ant1
    $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp121 $p |- ( ( ( th /\ ( ph /\ ps /\ ch ) /\ ta ) /\ et /\ ze ) -> ph ) $=
    wth wph wps wch w3a wta w3a wet wph wze wth wph wps wch wta simp21 3ad2ant1
    $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp122 $p |- ( ( ( th /\ ( ph /\ ps /\ ch ) /\ ta ) /\ et /\ ze ) -> ps ) $=
    wth wph wps wch w3a wta w3a wet wps wze wth wph wps wch wta simp22 3ad2ant1
    $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp123 $p |- ( ( ( th /\ ( ph /\ ps /\ ch ) /\ ta ) /\ et /\ ze ) -> ch ) $=
    wth wph wps wch w3a wta w3a wet wch wze wth wph wps wch wta simp23 3ad2ant1
    $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp131 $p |- ( ( ( th /\ ta /\ ( ph /\ ps /\ ch ) ) /\ et /\ ze ) -> ph ) $=
    wth wta wph wps wch w3a w3a wet wph wze wth wta wph wps wch simp31 3ad2ant1
    $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp132 $p |- ( ( ( th /\ ta /\ ( ph /\ ps /\ ch ) ) /\ et /\ ze ) -> ps ) $=
    wth wta wph wps wch w3a w3a wet wps wze wth wta wph wps wch simp32 3ad2ant1
    $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp133 $p |- ( ( ( th /\ ta /\ ( ph /\ ps /\ ch ) ) /\ et /\ ze ) -> ch ) $=
    wth wta wph wps wch w3a w3a wet wch wze wth wta wph wps wch simp33 3ad2ant1
    $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp211 $p |- ( ( et /\ ( ( ph /\ ps /\ ch ) /\ th /\ ta ) /\ ze ) -> ph ) $=
    wph wps wch w3a wth wta w3a wet wph wze wph wps wch wth wta simp11 3ad2ant2
    $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp212 $p |- ( ( et /\ ( ( ph /\ ps /\ ch ) /\ th /\ ta ) /\ ze ) -> ps ) $=
    wph wps wch w3a wth wta w3a wet wps wze wph wps wch wth wta simp12 3ad2ant2
    $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp213 $p |- ( ( et /\ ( ( ph /\ ps /\ ch ) /\ th /\ ta ) /\ ze ) -> ch ) $=
    wph wps wch w3a wth wta w3a wet wch wze wph wps wch wth wta simp13 3ad2ant2
    $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp221 $p |- ( ( et /\ ( th /\ ( ph /\ ps /\ ch ) /\ ta ) /\ ze ) -> ph ) $=
    wth wph wps wch w3a wta w3a wet wph wze wth wph wps wch wta simp21 3ad2ant2
    $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp222 $p |- ( ( et /\ ( th /\ ( ph /\ ps /\ ch ) /\ ta ) /\ ze ) -> ps ) $=
    wth wph wps wch w3a wta w3a wet wps wze wth wph wps wch wta simp22 3ad2ant2
    $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp223 $p |- ( ( et /\ ( th /\ ( ph /\ ps /\ ch ) /\ ta ) /\ ze ) -> ch ) $=
    wth wph wps wch w3a wta w3a wet wch wze wth wph wps wch wta simp23 3ad2ant2
    $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp231 $p |- ( ( et /\ ( th /\ ta /\ ( ph /\ ps /\ ch ) ) /\ ze ) -> ph ) $=
    wth wta wph wps wch w3a w3a wet wph wze wth wta wph wps wch simp31 3ad2ant2
    $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp232 $p |- ( ( et /\ ( th /\ ta /\ ( ph /\ ps /\ ch ) ) /\ ze ) -> ps ) $=
    wth wta wph wps wch w3a w3a wet wps wze wth wta wph wps wch simp32 3ad2ant2
    $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp233 $p |- ( ( et /\ ( th /\ ta /\ ( ph /\ ps /\ ch ) ) /\ ze ) -> ch ) $=
    wth wta wph wps wch w3a w3a wet wch wze wth wta wph wps wch simp33 3ad2ant2
    $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp311 $p |- ( ( et /\ ze /\ ( ( ph /\ ps /\ ch ) /\ th /\ ta ) ) -> ph ) $=
    wph wps wch w3a wth wta w3a wet wph wze wph wps wch wth wta simp11 3ad2ant3
    $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp312 $p |- ( ( et /\ ze /\ ( ( ph /\ ps /\ ch ) /\ th /\ ta ) ) -> ps ) $=
    wph wps wch w3a wth wta w3a wet wps wze wph wps wch wth wta simp12 3ad2ant3
    $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp313 $p |- ( ( et /\ ze /\ ( ( ph /\ ps /\ ch ) /\ th /\ ta ) ) -> ch ) $=
    wph wps wch w3a wth wta w3a wet wch wze wph wps wch wth wta simp13 3ad2ant3
    $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp321 $p |- ( ( et /\ ze /\ ( th /\ ( ph /\ ps /\ ch ) /\ ta ) ) -> ph ) $=
    wth wph wps wch w3a wta w3a wet wph wze wth wph wps wch wta simp21 3ad2ant3
    $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp322 $p |- ( ( et /\ ze /\ ( th /\ ( ph /\ ps /\ ch ) /\ ta ) ) -> ps ) $=
    wth wph wps wch w3a wta w3a wet wps wze wth wph wps wch wta simp22 3ad2ant3
    $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp323 $p |- ( ( et /\ ze /\ ( th /\ ( ph /\ ps /\ ch ) /\ ta ) ) -> ch ) $=
    wth wph wps wch w3a wta w3a wet wch wze wth wph wps wch wta simp23 3ad2ant3
    $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp331 $p |- ( ( et /\ ze /\ ( th /\ ta /\ ( ph /\ ps /\ ch ) ) ) -> ph ) $=
    wth wta wph wps wch w3a w3a wet wph wze wth wta wph wps wch simp31 3ad2ant3
    $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp332 $p |- ( ( et /\ ze /\ ( th /\ ta /\ ( ph /\ ps /\ ch ) ) ) -> ps ) $=
    wth wta wph wps wch w3a w3a wet wps wze wth wta wph wps wch simp32 3ad2ant3
    $.

  $( Simplification of conjunction.  (Contributed by NM, 9-Mar-2012.) $)
  simp333 $p |- ( ( et /\ ze /\ ( th /\ ta /\ ( ph /\ ps /\ ch ) ) ) -> ch ) $=
    wth wta wph wps wch w3a w3a wet wch wze wth wta wph wps wch simp33 3ad2ant3
    $.

  ${
    3anibar.1 $e |- ( ( ph /\ ps /\ ch ) -> ( th <-> ( ch /\ ta ) ) ) $.
    $( Remove a hypothesis from the second member of a biconditional.
       (Contributed by FL, 22-Jul-2008.) $)
    3anibar $p |- ( ( ph /\ ps /\ ch ) -> ( th <-> ta ) ) $=
      wph wps wch w3a wth wch wta wph wps wch simp3 3anibar.1 mpbirand $.
  $}

  $( Introduction in triple disjunction.  (Contributed by NM, 4-Apr-1995.) $)
  3mix1 $p |- ( ph -> ( ph \/ ps \/ ch ) ) $=
    wph wph wps wch wo wo wph wps wch w3o wph wps wch wo orc wph wps wch 3orass
    sylibr $.

  $( Introduction in triple disjunction.  (Contributed by NM, 4-Apr-1995.) $)
  3mix2 $p |- ( ph -> ( ps \/ ph \/ ch ) ) $=
    wph wph wch wps w3o wps wph wch w3o wph wch wps 3mix1 wps wph wch 3orrot
    sylibr $.

  $( Introduction in triple disjunction.  (Contributed by NM, 4-Apr-1995.) $)
  3mix3 $p |- ( ph -> ( ps \/ ch \/ ph ) ) $=
    wph wph wps wch w3o wps wch wph w3o wph wps wch 3mix1 wph wps wch 3orrot
    sylib $.

  ${
    3mixi.1 $e |- ph $.
    $( Introduction in triple disjunction.  (Contributed by Mario Carneiro,
       6-Oct-2014.) $)
    3mix1i $p |- ( ph \/ ps \/ ch ) $=
      wph wph wps wch w3o 3mixi.1 wph wps wch 3mix1 ax-mp $.

    $( Introduction in triple disjunction.  (Contributed by Mario Carneiro,
       6-Oct-2014.) $)
    3mix2i $p |- ( ps \/ ph \/ ch ) $=
      wph wps wph wch w3o 3mixi.1 wph wps wch 3mix2 ax-mp $.

    $( Introduction in triple disjunction.  (Contributed by Mario Carneiro,
       6-Oct-2014.) $)
    3mix3i $p |- ( ps \/ ch \/ ph ) $=
      wph wps wch wph w3o 3mixi.1 wph wps wch 3mix3 ax-mp $.
  $}

  ${
    3mixd.1 $e |- ( ph -> ps ) $.
    $( Deduction introducing triple disjunction.  (Contributed by Scott Fenton,
       8-Jun-2011.) $)
    3mix1d $p |- ( ph -> ( ps \/ ch \/ th ) ) $=
      wph wps wps wch wth w3o 3mixd.1 wps wch wth 3mix1 syl $.

    $( Deduction introducing triple disjunction.  (Contributed by Scott Fenton,
       8-Jun-2011.) $)
    3mix2d $p |- ( ph -> ( ch \/ ps \/ th ) ) $=
      wph wps wch wps wth w3o 3mixd.1 wps wch wth 3mix2 syl $.

    $( Deduction introducing triple disjunction.  (Contributed by Scott Fenton,
       8-Jun-2011.) $)
    3mix3d $p |- ( ph -> ( ch \/ th \/ ps ) ) $=
      wph wps wch wth wps w3o 3mixd.1 wps wch wth 3mix3 syl $.
  $}

  ${
    3pm3.2i.1 $e |- ph $.
    3pm3.2i.2 $e |- ps $.
    3pm3.2i.3 $e |- ch $.
    $( Infer conjunction of premises.  (Contributed by NM, 10-Feb-1995.) $)
    3pm3.2i $p |- ( ph /\ ps /\ ch ) $=
      wph wps wch w3a wph wps wa wch wph wps 3pm3.2i.1 3pm3.2i.2 pm3.2i
      3pm3.2i.3 wph wps wch df-3an mpbir2an $.
  $}

  $( Version of ~ pm3.2 for a triple conjunction.  (Contributed by Alan Sare,
     24-Oct-2011.)  (Proof shortened by Kyle Wyonch, 24-Apr-2021.)  (Proof
     shortened by Wolf Lammen, 21-Jun-2022.) $)
  pm3.2an3 $p |- ( ph -> ( ps -> ( ch -> ( ph /\ ps /\ ch ) ) ) ) $=
    wph wps wch wph wps wch w3a wph wps wch w3a id 3exp $.

  ${
    mpbir3an.1 $e |- ps $.
    mpbir3an.2 $e |- ch $.
    mpbir3an.3 $e |- th $.
    mpbir3an.4 $e |- ( ph <-> ( ps /\ ch /\ th ) ) $.
    $( Detach a conjunction of truths in a biconditional.  (Contributed by NM,
       16-Sep-2011.) $)
    mpbir3an $p |- ph $=
      wph wps wch wth w3a wps wch wth mpbir3an.1 mpbir3an.2 mpbir3an.3 3pm3.2i
      mpbir3an.4 mpbir $.
  $}

  ${
    mpbir3and.1 $e |- ( ph -> ch ) $.
    mpbir3and.2 $e |- ( ph -> th ) $.
    mpbir3and.3 $e |- ( ph -> ta ) $.
    mpbir3and.4 $e |- ( ph -> ( ps <-> ( ch /\ th /\ ta ) ) ) $.
    $( Detach a conjunction of truths in a biconditional.  (Contributed by
       Mario Carneiro, 11-May-2014.)  (Revised by Mario Carneiro,
       9-Jan-2015.) $)
    mpbir3and $p |- ( ph -> ps ) $=
      wph wps wch wth wta w3a wph wch wth wta mpbir3and.1 mpbir3and.2
      mpbir3and.3 3jca mpbir3and.4 mpbird $.
  $}

  ${
    syl3anbrc.1 $e |- ( ph -> ps ) $.
    syl3anbrc.2 $e |- ( ph -> ch ) $.
    syl3anbrc.3 $e |- ( ph -> th ) $.
    syl3anbrc.4 $e |- ( ta <-> ( ps /\ ch /\ th ) ) $.
    $( Syllogism inference.  (Contributed by Mario Carneiro, 11-May-2014.) $)
    syl3anbrc $p |- ( ph -> ta ) $=
      wph wps wch wth w3a wta wph wps wch wth syl3anbrc.1 syl3anbrc.2
      syl3anbrc.3 3jca syl3anbrc.4 sylibr $.
  $}

  ${
    syl21anbrc.1 $e |- ( ph -> ps ) $.
    syl21anbrc.2 $e |- ( ph -> ch ) $.
    syl21anbrc.3 $e |- ( ph -> th ) $.
    syl21anbrc.4 $e |- ( ta <-> ( ( ps /\ ch ) /\ th ) ) $.
    $( Syllogism inference.  (Contributed by Peter Mazsa, 18-Sep-2022.) $)
    syl21anbrc $p |- ( ph -> ta ) $=
      wph wps wch wa wth wa wta wph wps wch wth syl21anbrc.1 syl21anbrc.2
      syl21anbrc.3 jca31 syl21anbrc.4 sylibr $.
  $}

  ${
    3imp3i2an.1 $e |- ( ( ph /\ ps /\ ch ) -> th ) $.
    3imp3i2an.2 $e |- ( ( ph /\ ch ) -> ta ) $.
    3imp3i2an.3 $e |- ( ( th /\ ta ) -> et ) $.
    $( An elimination deduction.  (Contributed by Alan Sare, 17-Oct-2017.)
       (Proof shortened by Wolf Lammen, 13-Apr-2022.) $)
    3imp3i2an $p |- ( ( ph /\ ps /\ ch ) -> et ) $=
      wph wps wch w3a wth wta wet 3imp3i2an.1 wph wch wta wps 3imp3i2an.2
      3adant2 3imp3i2an.3 syl2anc $.
  $}

  ${
    ex3.1 $e |- ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) -> ta ) $.
    $( Apply ~ ex to a hypothesis with a 3-right-nested conjunction antecedent,
       with the antecedent of the assertion being a triple conjunction rather
       than a 2-right-nested conjunction.  (Contributed by Alan Sare,
       22-Apr-2018.) $)
    ex3 $p |- ( ( ph /\ ps /\ ch ) -> ( th -> ta ) ) $=
      wph wps wch wth wta wi wph wps wa wch wa wth wta ex3.1 ex 3impa $.
  $}

  ${
    3imp1.1 $e |- ( ph -> ( ps -> ( ch -> ( th -> ta ) ) ) ) $.
    $( Importation to left triple conjunction.  (Contributed by NM,
       24-Feb-2005.) $)
    3imp1 $p |- ( ( ( ph /\ ps /\ ch ) /\ th ) -> ta ) $=
      wph wps wch w3a wth wta wph wps wch wth wta wi 3imp1.1 3imp imp $.

    $( Importation deduction for triple conjunction.  (Contributed by NM,
       26-Oct-2006.) $)
    3impd $p |- ( ph -> ( ( ps /\ ch /\ th ) -> ta ) ) $=
      wps wch wth w3a wph wta wps wch wth wph wta wi wph wps wch wth wta
      3imp1.1 com4l 3imp com12 $.

    $( Importation to right triple conjunction.  (Contributed by NM,
       26-Oct-2006.) $)
    3imp2 $p |- ( ( ph /\ ( ps /\ ch /\ th ) ) -> ta ) $=
      wph wps wch wth w3a wta wph wps wch wth wta 3imp1.1 3impd imp $.
  $}

  ${
    3impdi.1 $e |- ( ( ( ph /\ ps ) /\ ( ph /\ ch ) ) -> th ) $.
    $( Importation inference (undistribute conjunction).  (Contributed by NM,
       14-Aug-1995.) $)
    3impdi $p |- ( ( ph /\ ps /\ ch ) -> th ) $=
      wph wps wch wth wph wps wch wth 3impdi.1 anandis 3impb $.
  $}

  ${
    3impdir.1 $e |- ( ( ( ph /\ ps ) /\ ( ch /\ ps ) ) -> th ) $.
    $( Importation inference (undistribute conjunction).  (Contributed by NM,
       20-Aug-1995.) $)
    3impdir $p |- ( ( ph /\ ch /\ ps ) -> th ) $=
      wph wch wps wth wph wch wps wth 3impdir.1 anandirs 3impa $.
  $}

  ${
    3exp1.1 $e |- ( ( ( ph /\ ps /\ ch ) /\ th ) -> ta ) $.
    $( Exportation from left triple conjunction.  (Contributed by NM,
       24-Feb-2005.) $)
    3exp1 $p |- ( ph -> ( ps -> ( ch -> ( th -> ta ) ) ) ) $=
      wph wps wch wth wta wi wph wps wch w3a wth wta 3exp1.1 ex 3exp $.
  $}

  ${
    3expd.1 $e |- ( ph -> ( ( ps /\ ch /\ th ) -> ta ) ) $.
    $( Exportation deduction for triple conjunction.  (Contributed by NM,
       26-Oct-2006.) $)
    3expd $p |- ( ph -> ( ps -> ( ch -> ( th -> ta ) ) ) ) $=
      wps wch wth wph wta wps wch wth wph wta wi wph wps wch wth w3a wta
      3expd.1 com12 3exp com4r $.
  $}

  ${
    3exp2.1 $e |- ( ( ph /\ ( ps /\ ch /\ th ) ) -> ta ) $.
    $( Exportation from right triple conjunction.  (Contributed by NM,
       26-Oct-2006.) $)
    3exp2 $p |- ( ph -> ( ps -> ( ch -> ( th -> ta ) ) ) ) $=
      wph wps wch wth wta wph wps wch wth w3a wta 3exp2.1 ex 3expd $.
  $}

  ${
    exp5o.1 $e |- ( ( ph /\ ps /\ ch ) -> ( ( th /\ ta ) -> et ) ) $.
    $( A triple exportation inference.  (Contributed by Jeff Hankins,
       8-Jul-2009.) $)
    exp5o $p |- ( ph -> ( ps -> ( ch -> ( th -> ( ta -> et ) ) ) ) ) $=
      wph wps wch wth wta wet wi wi wph wps wch w3a wth wta wet exp5o.1 expd
      3exp $.
  $}

  ${
    exp516.1 $e |- ( ( ( ph /\ ( ps /\ ch /\ th ) ) /\ ta ) -> et ) $.
    $( A triple exportation inference.  (Contributed by Jeff Hankins,
       8-Jul-2009.) $)
    exp516 $p |- ( ph -> ( ps -> ( ch -> ( th -> ( ta -> et ) ) ) ) ) $=
      wph wps wch wth wta wet wi wph wps wch wth w3a wta wet exp516.1 exp31
      3expd $.
  $}

  ${
    exp520.1 $e |- ( ( ( ph /\ ps /\ ch ) /\ ( th /\ ta ) ) -> et ) $.
    $( A triple exportation inference.  (Contributed by Jeff Hankins,
       8-Jul-2009.) $)
    exp520 $p |- ( ph -> ( ps -> ( ch -> ( th -> ( ta -> et ) ) ) ) ) $=
      wph wps wch wth wta wet wph wps wch w3a wth wta wa wet exp520.1 ex exp5o
      $.
  $}

  $( Version of ~ impexp for a triple conjunction.  (Contributed by Alan Sare,
     31-Dec-2011.) $)
  3impexp $p |- ( ( ( ph /\ ps /\ ch ) -> th ) <->
                ( ph -> ( ps -> ( ch -> th ) ) ) ) $=
    wph wps wch w3a wth wi wph wps wch wth wi wi wi wph wps wch w3a wth wi wph
    wps wch wth wph wps wch w3a wth wi id 3expd wph wps wch wth wi wi wi wph
    wps wch wth wph wps wch wth wi wi wi id 3impd impbii $.

  ${
    3an1rs.1 $e |- ( ( ( ph /\ ps /\ ch ) /\ th ) -> ta ) $.
    $( Swap conjuncts.  (Contributed by NM, 16-Dec-2007.)  (Proof shortened by
       Wolf Lammen, 14-Apr-2022.) $)
    3an1rs $p |- ( ( ( ph /\ ps /\ th ) /\ ch ) -> ta ) $=
      wph wps wth wch wta wph wps wch wth wta wph wps wch wth wta 3an1rs.1
      3exp1 com34 3imp1 $.
  $}

  ${
    3anassrs.1 $e |- ( ( ph /\ ( ps /\ ch /\ th ) ) -> ta ) $.
    $( Associative law for conjunction applied to antecedent (eliminates
       syllogism).  (Contributed by Mario Carneiro, 4-Jan-2017.) $)
    3anassrs $p |- ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) -> ta ) $=
      wph wps wch wth wta wph wps wch wth wta 3anassrs.1 3exp2 imp41 $.
  $}

  $( An equivalence of two four-terms conjunctions with the terms regrouped
     (here, the second sub-conjunct of the first term is pulled separately).
     (Contributed by Zhi Wang, 4-Sep-2024.) $)
  4anpull2 $p |- ( ( ( ph /\ ps ) /\ ( ch /\ th ) )
          <-> ( ( ph /\ ch /\ th ) /\ ps ) ) $=
    wph wps wa wch wth wa wa wph wps wch wth wa wa wa wph wch wth w3a wps wa
    wph wps wch wth wa anass wph wch wth wa wa wps wa wph wch wth wa wps wa wa
    wph wch wth w3a wps wa wph wps wch wth wa wa wa wph wch wth wa wps anass
    wph wch wth w3a wph wch wth wa wa wps wph wch wth 3anass anbi1i wps wch wth
    wa wa wch wth wa wps wa wph wps wch wth wa ancom anbi2i 3bitr4ri bitri $.

  ${
    ad5ant.1 $e |- ( ( ph /\ ps /\ ch ) -> th ) $.
    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 14-Apr-2022.) $)
    ad5ant245 $p |- ( ( ( ( ( ta /\ ph ) /\ et ) /\ ps ) /\ ch ) -> th ) $=
      wta wph wa wps wch wth wet wph wps wch wth wta ad5ant.1 3adant1l
      ad4ant134 $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 14-Apr-2022.) $)
    ad5ant234 $p |- ( ( ( ( ( ta /\ ph ) /\ ps ) /\ ch ) /\ et ) -> th ) $=
      wta wph wa wps wa wch wa wth wet wph wps wch wth wta ad5ant.1 ad4ant234
      adantr $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 14-Apr-2022.) $)
    ad5ant235 $p |- ( ( ( ( ( ta /\ ph ) /\ ps ) /\ et ) /\ ch ) -> th ) $=
      wta wph wa wps wa wch wth wet wph wps wch wth wta ad5ant.1 ad4ant234
      adantlr $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 23-Jun-2022.) $)
    ad5ant123 $p |- ( ( ( ( ( ph /\ ps ) /\ ch ) /\ ta ) /\ et ) -> th ) $=
      wph wps wa wch wa wth wta wet wph wps wch wth ad5ant.1 3expa ad2antrr $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 23-Jun-2022.) $)
    ad5ant124 $p |- ( ( ( ( ( ph /\ ps ) /\ ta ) /\ ch ) /\ et ) -> th ) $=
      wph wps wa wta wa wch wa wth wet wph wps wch wth wta ad5ant.1 ad4ant124
      adantr $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 23-Jun-2022.) $)
    ad5ant125 $p |- ( ( ( ( ( ph /\ ps ) /\ ta ) /\ et ) /\ ch ) -> th ) $=
      wph wps wa wta wet wch wth wph wps wa wch wth wi wta wet wph wps wch wth
      ad5ant.1 3expia 2a1d imp41 $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 23-Jun-2022.) $)
    ad5ant134 $p |- ( ( ( ( ( ph /\ ta ) /\ ps ) /\ ch ) /\ et ) -> th ) $=
      wph wta wa wps wa wch wa wth wet wph wps wch wth wta ad5ant.1 ad4ant134
      adantr $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 23-Jun-2022.) $)
    ad5ant135 $p |- ( ( ( ( ( ph /\ ta ) /\ ps ) /\ et ) /\ ch ) -> th ) $=
      wph wta wa wps wa wch wth wet wph wps wch wth wta ad5ant.1 ad4ant134
      adantlr $.

    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.)  (Proof shortened by Wolf Lammen, 23-Jun-2022.) $)
    ad5ant145 $p |- ( ( ( ( ( ph /\ ta ) /\ et ) /\ ps ) /\ ch ) -> th ) $=
      wph wta wa wps wch wth wet wph wps wch wth wta ad5ant.1 ad4ant134
      adantllr $.
  $}

  ${
    ad5ant2345.1 $e |- ( ( ( ( ph /\ ps ) /\ ch ) /\ th ) -> ta ) $.
    $( Deduction adding conjuncts to antecedent.  (Contributed by Alan Sare,
       17-Oct-2017.) $)
    ad5ant2345 $p |- ( ( ( ( ( et /\ ph ) /\ ps ) /\ ch ) /\ th ) -> ta ) $=
      wet wph wa wps wch wth wta wph wps wch wth wta wi wi wi wet wph wps wch
      wth wta ad5ant2345.1 exp41 adantl imp41 $.
  $}

  ${
    syl3anc.1 $e |- ( ph -> ps ) $.
    syl3anc.2 $e |- ( ph -> ch ) $.
    syl3anc.3 $e |- ( ph -> th ) $.
    ${
      syl3anc.4 $e |- ( ( ps /\ ch /\ th ) -> ta ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl3anc $p |- ( ph -> ta ) $=
        wph wps wch wth w3a wta wph wps wch wth syl3anc.1 syl3anc.2 syl3anc.3
        3jca syl3anc.4 syl $.
    $}

    syl3Xanc.4 $e |- ( ph -> ta ) $.
    ${
      syl13anc.5 $e |- ( ( ps /\ ( ch /\ th /\ ta ) ) -> et ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl13anc $p |- ( ph -> et ) $=
        wph wps wch wth wta w3a wet syl3anc.1 wph wch wth wta syl3anc.2
        syl3anc.3 syl3Xanc.4 3jca syl13anc.5 syl2anc $.
    $}

    ${
      syl31anc.5 $e |- ( ( ( ps /\ ch /\ th ) /\ ta ) -> et ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl31anc $p |- ( ph -> et ) $=
        wph wps wch wth w3a wta wet wph wps wch wth syl3anc.1 syl3anc.2
        syl3anc.3 3jca syl3Xanc.4 syl31anc.5 syl2anc $.
    $}

    ${
      syl112anc.5 $e |- ( ( ps /\ ch /\ ( th /\ ta ) ) -> et ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl112anc $p |- ( ph -> et ) $=
        wph wps wch wth wta wa wet syl3anc.1 syl3anc.2 wph wth wta syl3anc.3
        syl3Xanc.4 jca syl112anc.5 syl3anc $.
    $}

    ${
      syl121anc.5 $e |- ( ( ps /\ ( ch /\ th ) /\ ta ) -> et ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl121anc $p |- ( ph -> et ) $=
        wph wps wch wth wa wta wet syl3anc.1 wph wch wth syl3anc.2 syl3anc.3
        jca syl3Xanc.4 syl121anc.5 syl3anc $.
    $}

    ${
      syl211anc.5 $e |- ( ( ( ps /\ ch ) /\ th /\ ta ) -> et ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl211anc $p |- ( ph -> et ) $=
        wph wps wch wa wth wta wet wph wps wch syl3anc.1 syl3anc.2 jca
        syl3anc.3 syl3Xanc.4 syl211anc.5 syl3anc $.
    $}

    syl23anc.5 $e |- ( ph -> et ) $.
    ${
      syl23anc.6 $e |- ( ( ( ps /\ ch ) /\ ( th /\ ta /\ et ) ) -> ze ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl23anc $p |- ( ph -> ze ) $=
        wph wps wch wa wth wta wet wze wph wps wch syl3anc.1 syl3anc.2 jca
        syl3anc.3 syl3Xanc.4 syl23anc.5 syl23anc.6 syl13anc $.
    $}

    ${
      syl32anc.6 $e |- ( ( ( ps /\ ch /\ th ) /\ ( ta /\ et ) ) -> ze ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl32anc $p |- ( ph -> ze ) $=
        wph wps wch wth wta wet wa wze syl3anc.1 syl3anc.2 syl3anc.3 wph wta
        wet syl3Xanc.4 syl23anc.5 jca syl32anc.6 syl31anc $.
    $}

    ${
      syl122anc.6 $e |- ( ( ps /\ ( ch /\ th ) /\ ( ta /\ et ) ) -> ze ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl122anc $p |- ( ph -> ze ) $=
        wph wps wch wth wta wet wa wze syl3anc.1 syl3anc.2 syl3anc.3 wph wta
        wet syl3Xanc.4 syl23anc.5 jca syl122anc.6 syl121anc $.
    $}

    ${
      syl212anc.6 $e |- ( ( ( ps /\ ch ) /\ th /\ ( ta /\ et ) ) -> ze ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl212anc $p |- ( ph -> ze ) $=
        wph wps wch wth wta wet wa wze syl3anc.1 syl3anc.2 syl3anc.3 wph wta
        wet syl3Xanc.4 syl23anc.5 jca syl212anc.6 syl211anc $.
    $}

    ${
      syl221anc.6 $e |- ( ( ( ps /\ ch ) /\ ( th /\ ta ) /\ et ) -> ze ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl221anc $p |- ( ph -> ze ) $=
        wph wps wch wth wta wa wet wze syl3anc.1 syl3anc.2 wph wth wta
        syl3anc.3 syl3Xanc.4 jca syl23anc.5 syl221anc.6 syl211anc $.
    $}

    ${
      syl113anc.6 $e |- ( ( ps /\ ch /\ ( th /\ ta /\ et ) ) -> ze ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl113anc $p |- ( ph -> ze ) $=
        wph wps wch wth wta wet w3a wze syl3anc.1 syl3anc.2 wph wth wta wet
        syl3anc.3 syl3Xanc.4 syl23anc.5 3jca syl113anc.6 syl3anc $.
    $}

    ${
      syl131anc.6 $e |- ( ( ps /\ ( ch /\ th /\ ta ) /\ et ) -> ze ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl131anc $p |- ( ph -> ze ) $=
        wph wps wch wth wta w3a wet wze syl3anc.1 wph wch wth wta syl3anc.2
        syl3anc.3 syl3Xanc.4 3jca syl23anc.5 syl131anc.6 syl3anc $.
    $}

    ${
      syl311anc.6 $e |- ( ( ( ps /\ ch /\ th ) /\ ta /\ et ) -> ze ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl311anc $p |- ( ph -> ze ) $=
        wph wps wch wth w3a wta wet wze wph wps wch wth syl3anc.1 syl3anc.2
        syl3anc.3 3jca syl3Xanc.4 syl23anc.5 syl311anc.6 syl3anc $.
    $}

    syl33anc.6 $e |- ( ph -> ze ) $.
    ${
      syl33anc.7 $e |- ( ( ( ps /\ ch /\ th ) /\ ( ta /\ et /\ ze ) )
           -> si ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl33anc $p |- ( ph -> si ) $=
        wph wps wch wth w3a wta wet wze wsi wph wps wch wth syl3anc.1 syl3anc.2
        syl3anc.3 3jca syl3Xanc.4 syl23anc.5 syl33anc.6 syl33anc.7 syl13anc $.
    $}

    ${
      syl222anc.7 $e |- ( ( ( ps /\ ch ) /\ ( th /\ ta ) /\ ( et /\ ze ) )
           -> si ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl222anc $p |- ( ph -> si ) $=
        wph wps wch wth wta wet wze wa wsi syl3anc.1 syl3anc.2 syl3anc.3
        syl3Xanc.4 wph wet wze syl23anc.5 syl33anc.6 jca syl222anc.7 syl221anc
        $.
    $}

    ${
      syl123anc.7 $e |- ( ( ps /\ ( ch /\ th ) /\ ( ta /\ et /\ ze ) )
           -> si ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl123anc $p |- ( ph -> si ) $=
        wph wps wch wth wa wta wet wze wsi syl3anc.1 wph wch wth syl3anc.2
        syl3anc.3 jca syl3Xanc.4 syl23anc.5 syl33anc.6 syl123anc.7 syl113anc $.
    $}

    ${
      syl132anc.7 $e |- ( ( ps /\ ( ch /\ th /\ ta ) /\ ( et /\ ze ) )
           -> si ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Jul-2012.) $)
      syl132anc $p |- ( ph -> si ) $=
        wph wps wch wth wta wet wze wa wsi syl3anc.1 syl3anc.2 syl3anc.3
        syl3Xanc.4 wph wet wze syl23anc.5 syl33anc.6 jca syl132anc.7 syl131anc
        $.
    $}

    ${
      syl213anc.7 $e |- ( ( ( ps /\ ch ) /\ th /\ ( ta /\ et /\ ze ) )
           -> si ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl213anc $p |- ( ph -> si ) $=
        wph wps wch wa wth wta wet wze wsi wph wps wch syl3anc.1 syl3anc.2 jca
        syl3anc.3 syl3Xanc.4 syl23anc.5 syl33anc.6 syl213anc.7 syl113anc $.
    $}

    ${
      syl231anc.7 $e |- ( ( ( ps /\ ch ) /\ ( th /\ ta /\ et ) /\ ze )
           -> si ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl231anc $p |- ( ph -> si ) $=
        wph wps wch wa wth wta wet wze wsi wph wps wch syl3anc.1 syl3anc.2 jca
        syl3anc.3 syl3Xanc.4 syl23anc.5 syl33anc.6 syl231anc.7 syl131anc $.
    $}

    ${
      syl312anc.7 $e |- ( ( ( ps /\ ch /\ th ) /\ ta /\ ( et /\ ze ) )
           -> si ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Jul-2012.) $)
      syl312anc $p |- ( ph -> si ) $=
        wph wps wch wth wta wet wze wa wsi syl3anc.1 syl3anc.2 syl3anc.3
        syl3Xanc.4 wph wet wze syl23anc.5 syl33anc.6 jca syl312anc.7 syl311anc
        $.
    $}

    ${
      syl321anc.7 $e |- ( ( ( ps /\ ch /\ th ) /\ ( ta /\ et ) /\ ze )
           -> si ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Jul-2012.) $)
      syl321anc $p |- ( ph -> si ) $=
        wph wps wch wth wta wet wa wze wsi syl3anc.1 syl3anc.2 syl3anc.3 wph
        wta wet syl3Xanc.4 syl23anc.5 jca syl33anc.6 syl321anc.7 syl311anc $.
    $}

    syl133anc.7 $e |- ( ph -> si ) $.
    ${
      syl133anc.8 $e |- ( ( ps /\ ( ch /\ th /\ ta ) /\ ( et /\ ze /\ si ) )
           -> rh ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl133anc $p |- ( ph -> rh ) $=
        wph wps wch wth wta wet wze wsi w3a wrh syl3anc.1 syl3anc.2 syl3anc.3
        syl3Xanc.4 wph wet wze wsi syl23anc.5 syl33anc.6 syl133anc.7 3jca
        syl133anc.8 syl131anc $.
    $}

    ${
      syl313anc.8 $e |- ( ( ( ps /\ ch /\ th ) /\ ta /\ ( et /\ ze /\ si ) )
           -> rh ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl313anc $p |- ( ph -> rh ) $=
        wph wps wch wth wta wet wze wsi w3a wrh syl3anc.1 syl3anc.2 syl3anc.3
        syl3Xanc.4 wph wet wze wsi syl23anc.5 syl33anc.6 syl133anc.7 3jca
        syl313anc.8 syl311anc $.
    $}

    ${
      syl331anc.8 $e |- ( ( ( ps /\ ch /\ th ) /\ ( ta /\ et /\ ze ) /\ si )
           -> rh ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl331anc $p |- ( ph -> rh ) $=
        wph wps wch wth wta wet wze w3a wsi wrh syl3anc.1 syl3anc.2 syl3anc.3
        wph wta wet wze syl3Xanc.4 syl23anc.5 syl33anc.6 3jca syl133anc.7
        syl331anc.8 syl311anc $.
    $}

    ${
      syl223anc.8 $e |- ( ( ( ps /\ ch ) /\ ( th /\ ta ) /\ ( et /\ ze /\ si )
          ) -> rh ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl223anc $p |- ( ph -> rh ) $=
        wph wps wch wth wta wa wet wze wsi wrh syl3anc.1 syl3anc.2 wph wth wta
        syl3anc.3 syl3Xanc.4 jca syl23anc.5 syl33anc.6 syl133anc.7 syl223anc.8
        syl213anc $.
    $}

    ${
      syl232anc.8 $e |- ( ( ( ps /\ ch ) /\ ( th /\ ta /\ et ) /\ ( ze /\ si )
          ) -> rh ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl232anc $p |- ( ph -> rh ) $=
        wph wps wch wth wta wet wze wsi wa wrh syl3anc.1 syl3anc.2 syl3anc.3
        syl3Xanc.4 syl23anc.5 wph wze wsi syl33anc.6 syl133anc.7 jca
        syl232anc.8 syl231anc $.
    $}

    ${
      syl322anc.8 $e |- ( ( ( ps /\ ch /\ th ) /\ ( ta /\ et ) /\ ( ze /\ si )
          ) -> rh ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl322anc $p |- ( ph -> rh ) $=
        wph wps wch wth wta wet wze wsi wa wrh syl3anc.1 syl3anc.2 syl3anc.3
        syl3Xanc.4 syl23anc.5 wph wze wsi syl33anc.6 syl133anc.7 jca
        syl322anc.8 syl321anc $.
    $}

    syl233anc.8 $e |- ( ph -> rh ) $.
    ${
      syl233anc.9 $e |- ( ( ( ps /\ ch ) /\ ( th /\ ta /\ et ) /\ ( ze /\ si /\
          rh ) ) -> mu ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl233anc $p |- ( ph -> mu ) $=
        wph wps wch wa wth wta wet wze wsi wrh wmu wph wps wch syl3anc.1
        syl3anc.2 jca syl3anc.3 syl3Xanc.4 syl23anc.5 syl33anc.6 syl133anc.7
        syl233anc.8 syl233anc.9 syl133anc $.
    $}

    ${
      syl323anc.9 $e |- ( ( ( ps /\ ch /\ th ) /\ ( ta /\ et ) /\ ( ze /\ si /\
          rh ) ) -> mu ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl323anc $p |- ( ph -> mu ) $=
        wph wps wch wth wta wet wa wze wsi wrh wmu syl3anc.1 syl3anc.2
        syl3anc.3 wph wta wet syl3Xanc.4 syl23anc.5 jca syl33anc.6 syl133anc.7
        syl233anc.8 syl323anc.9 syl313anc $.
    $}

    ${
      syl332anc.9 $e |- ( ( ( ps /\ ch /\ th ) /\ ( ta /\ et /\ ze ) /\ ( si /\
          rh ) ) -> mu ) $.
      $( Syllogism combined with contraction.  (Contributed by NM,
         11-Mar-2012.) $)
      syl332anc $p |- ( ph -> mu ) $=
        wph wps wch wth wta wet wze wsi wrh wa wmu syl3anc.1 syl3anc.2
        syl3anc.3 syl3Xanc.4 syl23anc.5 syl33anc.6 wph wsi wrh syl133anc.7
        syl233anc.8 jca syl332anc.9 syl331anc $.
    $}

    syl333anc.9 $e |- ( ph -> mu ) $.
    ${
      syl333anc.10 $e |- ( ( ( ps /\ ch /\ th ) /\ ( ta /\ et /\ ze )
          /\ ( si /\ rh /\ mu ) ) -> la ) $.
      $( A syllogism inference combined with contraction.  (Contributed by NM,
         10-Mar-2012.) $)
      syl333anc $p |- ( ph -> la ) $=
        wph wps wch wth wta wet wze wsi wrh wmu w3a wla syl3anc.1 syl3anc.2
        syl3anc.3 syl3Xanc.4 syl23anc.5 syl33anc.6 wph wsi wrh wmu syl133anc.7
        syl233anc.8 syl333anc.9 3jca syl333anc.10 syl331anc $.
    $}
  $}

  ${
    syl3an1b.1 $e |- ( ph <-> ps ) $.
    syl3an1b.2 $e |- ( ( ps /\ ch /\ th ) -> ta ) $.
    $( A syllogism inference.  (Contributed by NM, 22-Aug-1995.) $)
    syl3an1b $p |- ( ( ph /\ ch /\ th ) -> ta ) $=
      wph wps wch wth wta wph wps syl3an1b.1 biimpi syl3an1b.2 syl3an1 $.
  $}

  ${
    syl3an2b.1 $e |- ( ph <-> ch ) $.
    syl3an2b.2 $e |- ( ( ps /\ ch /\ th ) -> ta ) $.
    $( A syllogism inference.  (Contributed by NM, 22-Aug-1995.) $)
    syl3an2b $p |- ( ( ps /\ ph /\ th ) -> ta ) $=
      wph wps wch wth wta wph wch syl3an2b.1 biimpi syl3an2b.2 syl3an2 $.
  $}

  ${
    syl3an3b.1 $e |- ( ph <-> th ) $.
    syl3an3b.2 $e |- ( ( ps /\ ch /\ th ) -> ta ) $.
    $( A syllogism inference.  (Contributed by NM, 22-Aug-1995.) $)
    syl3an3b $p |- ( ( ps /\ ch /\ ph ) -> ta ) $=
      wph wps wch wth wta wph wth syl3an3b.1 biimpi syl3an3b.2 syl3an3 $.
  $}

  ${
    syl3an1br.1 $e |- ( ps <-> ph ) $.
    syl3an1br.2 $e |- ( ( ps /\ ch /\ th ) -> ta ) $.
    $( A syllogism inference.  (Contributed by NM, 22-Aug-1995.) $)
    syl3an1br $p |- ( ( ph /\ ch /\ th ) -> ta ) $=
      wph wps wch wth wta wps wph syl3an1br.1 biimpri syl3an1br.2 syl3an1 $.
  $}

  ${
    syl3an2br.1 $e |- ( ch <-> ph ) $.
    syl3an2br.2 $e |- ( ( ps /\ ch /\ th ) -> ta ) $.
    $( A syllogism inference.  (Contributed by NM, 22-Aug-1995.) $)
    syl3an2br $p |- ( ( ps /\ ph /\ th ) -> ta ) $=
      wph wps wch wth wta wch wph syl3an2br.1 biimpri syl3an2br.2 syl3an2 $.
  $}

  ${
    syl3an3br.1 $e |- ( th <-> ph ) $.
    syl3an3br.2 $e |- ( ( ps /\ ch /\ th ) -> ta ) $.
    $( A syllogism inference.  (Contributed by NM, 22-Aug-1995.) $)
    syl3an3br $p |- ( ( ps /\ ch /\ ph ) -> ta ) $=
      wph wps wch wth wta wth wph syl3an3br.1 biimpri syl3an3br.2 syl3an3 $.
  $}

  ${
    syld3an3.1 $e |- ( ( ph /\ ps /\ ch ) -> th ) $.
    syld3an3.2 $e |- ( ( ph /\ ps /\ th ) -> ta ) $.
    $( A syllogism inference.  (Contributed by NM, 20-May-2007.) $)
    syld3an3 $p |- ( ( ph /\ ps /\ ch ) -> ta ) $=
      wph wps wch w3a wph wps wth wta wph wps wch simp1 wph wps wch simp2
      syld3an3.1 syld3an3.2 syl3anc $.
  $}

  ${
    syld3an1.1 $e |- ( ( ch /\ ps /\ th ) -> ph ) $.
    syld3an1.2 $e |- ( ( ph /\ ps /\ th ) -> ta ) $.
    $( A syllogism inference.  (Contributed by NM, 7-Jul-2008.)  (Proof
       shortened by Wolf Lammen, 26-Jun-2022.) $)
    syld3an1 $p |- ( ( ch /\ ps /\ th ) -> ta ) $=
      wch wps wth w3a wph wps wth wta syld3an1.1 wch wps wth simp2 wch wps wth
      simp3 syld3an1.2 syl3anc $.
  $}

  ${
    syld3an2.1 $e |- ( ( ph /\ ch /\ th ) -> ps ) $.
    syld3an2.2 $e |- ( ( ph /\ ps /\ th ) -> ta ) $.
    $( A syllogism inference.  (Contributed by NM, 20-May-2007.) $)
    syld3an2 $p |- ( ( ph /\ ch /\ th ) -> ta ) $=
      wph wch wth w3a wph wps wth wta wph wch wth simp1 syld3an2.1 wph wch wth
      simp3 syld3an2.2 syl3anc $.
  $}

  ${
    syl3anl1.1 $e |- ( ph -> ps ) $.
    syl3anl1.2 $e |- ( ( ( ps /\ ch /\ th ) /\ ta ) -> et ) $.
    $( A syllogism inference.  (Contributed by NM, 24-Feb-2005.) $)
    syl3anl1 $p |- ( ( ( ph /\ ch /\ th ) /\ ta ) -> et ) $=
      wph wch wth w3a wps wch wth w3a wta wet wph wps wch wth syl3anl1.1
      3anim1i syl3anl1.2 sylan $.
  $}

  ${
    syl3anl2.1 $e |- ( ph -> ch ) $.
    syl3anl2.2 $e |- ( ( ( ps /\ ch /\ th ) /\ ta ) -> et ) $.
    $( A syllogism inference.  (Contributed by NM, 24-Feb-2005.)  (Proof
       shortened by Wolf Lammen, 27-Jun-2022.) $)
    syl3anl2 $p |- ( ( ( ps /\ ph /\ th ) /\ ta ) -> et ) $=
      wps wph wth w3a wps wch wth w3a wta wet wph wch wps wth syl3anl2.1
      3anim2i syl3anl2.2 sylan $.
  $}

  ${
    syl3anl3.1 $e |- ( ph -> th ) $.
    syl3anl3.2 $e |- ( ( ( ps /\ ch /\ th ) /\ ta ) -> et ) $.
    $( A syllogism inference.  (Contributed by NM, 24-Feb-2005.) $)
    syl3anl3 $p |- ( ( ( ps /\ ch /\ ph ) /\ ta ) -> et ) $=
      wps wch wph w3a wps wch wth w3a wta wet wph wth wps wch syl3anl3.1
      3anim3i syl3anl3.2 sylan $.
  $}

  ${
    syl3anl.1 $e |- ( ph -> ps ) $.
    syl3anl.2 $e |- ( ch -> th ) $.
    syl3anl.3 $e |- ( ta -> et ) $.
    syl3anl.4 $e |- ( ( ( ps /\ th /\ et ) /\ ze ) -> si ) $.
    $( A triple syllogism inference.  (Contributed by NM, 24-Dec-2006.) $)
    syl3anl $p |- ( ( ( ph /\ ch /\ ta ) /\ ze ) -> si ) $=
      wph wch wta w3a wps wth wet w3a wze wsi wph wps wch wth wta wet syl3anl.1
      syl3anl.2 syl3anl.3 3anim123i syl3anl.4 sylan $.
  $}

  ${
    syl3anr1.1 $e |- ( ph -> ps ) $.
    syl3anr1.2 $e |- ( ( ch /\ ( ps /\ th /\ ta ) ) -> et ) $.
    $( A syllogism inference.  (Contributed by NM, 31-Jul-2007.) $)
    syl3anr1 $p |- ( ( ch /\ ( ph /\ th /\ ta ) ) -> et ) $=
      wph wth wta w3a wch wps wth wta w3a wet wph wps wth wta syl3anr1.1
      3anim1i syl3anr1.2 sylan2 $.
  $}

  ${
    syl3anr2.1 $e |- ( ph -> th ) $.
    syl3anr2.2 $e |- ( ( ch /\ ( ps /\ th /\ ta ) ) -> et ) $.
    $( A syllogism inference.  (Contributed by NM, 1-Aug-2007.)  (Proof
       shortened by Wolf Lammen, 27-Jun-2022.) $)
    syl3anr2 $p |- ( ( ch /\ ( ps /\ ph /\ ta ) ) -> et ) $=
      wps wph wta w3a wch wps wth wta w3a wet wph wth wps wta syl3anr2.1
      3anim2i syl3anr2.2 sylan2 $.
  $}

  ${
    syl3anr3.1 $e |- ( ph -> ta ) $.
    syl3anr3.2 $e |- ( ( ch /\ ( ps /\ th /\ ta ) ) -> et ) $.
    $( A syllogism inference.  (Contributed by NM, 23-Aug-2007.) $)
    syl3anr3 $p |- ( ( ch /\ ( ps /\ th /\ ph ) ) -> et ) $=
      wps wth wph w3a wch wps wth wta w3a wet wph wta wps wth syl3anr3.1
      3anim3i syl3anr3.2 sylan2 $.
  $}

  ${
    3anidm12.1 $e |- ( ( ph /\ ph /\ ps ) -> ch ) $.
    $( Inference from idempotent law for conjunction.  (Contributed by NM,
       7-Mar-2008.) $)
    3anidm12 $p |- ( ( ph /\ ps ) -> ch ) $=
      wph wps wch wph wph wps wch 3anidm12.1 3expib anabsi5 $.
  $}

  ${
    3anidm13.1 $e |- ( ( ph /\ ps /\ ph ) -> ch ) $.
    $( Inference from idempotent law for conjunction.  (Contributed by NM,
       7-Mar-2008.) $)
    3anidm13 $p |- ( ( ph /\ ps ) -> ch ) $=
      wph wps wch wph wps wph wch 3anidm13.1 3com23 3anidm12 $.
  $}

  ${
    3anidm23.1 $e |- ( ( ph /\ ps /\ ps ) -> ch ) $.
    $( Inference from idempotent law for conjunction.  (Contributed by NM,
       1-Feb-2007.) $)
    3anidm23 $p |- ( ( ph /\ ps ) -> ch ) $=
      wph wps wch wph wps wps wch 3anidm23.1 3expa anabss3 $.
  $}

  ${
    syl2an3an.1 $e |- ( ph -> ps ) $.
    syl2an3an.2 $e |- ( ph -> ch ) $.
    syl2an3an.3 $e |- ( th -> ta ) $.
    syl2an3an.4 $e |- ( ( ps /\ ch /\ ta ) -> et ) $.
    $( ~ syl3an with antecedents in standard conjunction form.  (Contributed by
       Alan Sare, 31-Aug-2016.) $)
    syl2an3an $p |- ( ( ph /\ th ) -> et ) $=
      wph wth wet wph wps wph wch wth wta wet syl2an3an.1 syl2an3an.2
      syl2an3an.3 syl2an3an.4 syl3an 3anidm12 $.
  $}

  ${
    syl2an23an.1 $e |- ( ph -> ps ) $.
    syl2an23an.2 $e |- ( ph -> ch ) $.
    syl2an23an.3 $e |- ( ( th /\ ph ) -> ta ) $.
    syl2an23an.4 $e |- ( ( ps /\ ch /\ ta ) -> et ) $.
    $( Deduction related to ~ syl3an with antecedents in standard conjunction
       form.  (Contributed by Alan Sare, 31-Aug-2016.)  (Proof shortened by
       Wolf Lammen, 28-Jun-2022.) $)
    syl2an23an $p |- ( ( th /\ ph ) -> et ) $=
      wth wph wet wph wps wch wth wph wa wta wet syl2an23an.1 syl2an23an.2
      syl2an23an.3 syl2an23an.4 syl2an3an anabss7 $.
  $}

  ${
    3ori.1 $e |- ( ph \/ ps \/ ch ) $.
    $( Infer implication from triple disjunction.  (Contributed by NM,
       26-Sep-2006.) $)
    3ori $p |- ( ( -. ph /\ -. ps ) -> ch ) $=
      wph wn wps wn wa wph wps wo wn wch wph wps ioran wph wps wo wch wph wps
      wch w3o wph wps wo wch wo 3ori.1 wph wps wch df-3or mpbi ori sylbir $.
  $}

  $( Disjunction of three antecedents.  (Contributed by NM, 8-Apr-1994.) $)
  3jao $p |- ( ( ( ph -> ps ) /\ ( ch -> ps ) /\ ( th -> ps ) ) ->
              ( ( ph \/ ch \/ th ) -> ps ) ) $=
    wph wps wi wch wps wi wth wps wi wph wch wth w3o wps wi wph wps wi wch wps
    wi wph wch wo wps wi wth wps wi wph wch wth w3o wps wi wi wph wps wch jao
    wph wch wth w3o wph wch wo wth wo wph wch wo wps wi wth wps wi wps wph wch
    wth df-3or wph wch wo wps wth jao syl7bi syl6 3imp $.

  $( Disjunction of three antecedents.  (Contributed by NM, 13-Sep-2011.)
     (Proof shortened by Hongxiu Chen, 29-Jun-2025.) $)
  3jaob $p |- ( ( ( ph \/ ch \/ th ) -> ps ) <->
              ( ( ph -> ps ) /\ ( ch -> ps ) /\ ( th -> ps ) ) ) $=
    wph wch wo wth wo wps wi wph wps wi wch wps wi wa wth wps wi wa wph wch wth
    w3o wps wi wph wps wi wch wps wi wth wps wi w3a wph wch wth wps pm5.53 wph
    wch wth w3o wph wch wo wth wo wps wph wch wth df-3or imbi1i wph wps wi wch
    wps wi wth wps wi df-3an 3bitr4i $.

  $( Obsolete version of ~ 3jaob as of 29-Jun-2025.  (Contributed by NM,
     13-Sep-2011.)  (Proof modification is discouraged.)
     (New usage is discouraged.) $)
  3jaobOLD $p |- ( ( ( ph \/ ch \/ th ) -> ps ) <->
              ( ( ph -> ps ) /\ ( ch -> ps ) /\ ( th -> ps ) ) ) $=
    wph wch wth w3o wps wi wph wps wi wch wps wi wth wps wi w3a wph wch wth w3o
    wps wi wph wps wi wch wps wi wth wps wi wph wph wch wth w3o wps wph wch wth
    3mix1 imim1i wch wph wch wth w3o wps wch wph wth 3mix2 imim1i wth wph wch
    wth w3o wps wth wph wch 3mix3 imim1i 3jca wph wps wch wth 3jao impbii $.

  ${
    3jaoi.1 $e |- ( ph -> ps ) $.
    3jaoi.2 $e |- ( ch -> ps ) $.
    3jaoi.3 $e |- ( th -> ps ) $.
    $( Disjunction of three antecedents (inference).  (Contributed by NM,
       12-Sep-1995.) $)
    3jaoi $p |- ( ( ph \/ ch \/ th ) -> ps ) $=
      wph wps wi wch wps wi wth wps wi w3a wph wch wth w3o wps wi wph wps wi
      wch wps wi wth wps wi 3jaoi.1 3jaoi.2 3jaoi.3 3pm3.2i wph wps wch wth
      3jao ax-mp $.
  $}

  ${
    3jaod.1 $e |- ( ph -> ( ps -> ch ) ) $.
    3jaod.2 $e |- ( ph -> ( th -> ch ) ) $.
    3jaod.3 $e |- ( ph -> ( ta -> ch ) ) $.
    $( Disjunction of three antecedents (deduction).  (Contributed by NM,
       14-Oct-2005.) $)
    3jaod $p |- ( ph -> ( ( ps \/ th \/ ta ) -> ch ) ) $=
      wph wps wch wi wth wch wi wta wch wi wps wth wta w3o wch wi 3jaod.1
      3jaod.2 3jaod.3 wps wch wth wta 3jao syl3anc $.
  $}

  ${
    3jaoian.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    3jaoian.2 $e |- ( ( th /\ ps ) -> ch ) $.
    3jaoian.3 $e |- ( ( ta /\ ps ) -> ch ) $.
    $( Disjunction of three antecedents (inference).  (Contributed by NM,
       14-Oct-2005.) $)
    3jaoian $p |- ( ( ( ph \/ th \/ ta ) /\ ps ) -> ch ) $=
      wph wth wta w3o wps wch wph wps wch wi wth wta wph wps wch 3jaoian.1 ex
      wth wps wch 3jaoian.2 ex wta wps wch 3jaoian.3 ex 3jaoi imp $.
  $}

  ${
    3jaodan.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    3jaodan.2 $e |- ( ( ph /\ th ) -> ch ) $.
    3jaodan.3 $e |- ( ( ph /\ ta ) -> ch ) $.
    $( Disjunction of three antecedents (deduction).  (Contributed by NM,
       14-Oct-2005.) $)
    3jaodan $p |- ( ( ph /\ ( ps \/ th \/ ta ) ) -> ch ) $=
      wph wps wth wta w3o wch wph wps wch wth wta wph wps wch 3jaodan.1 ex wph
      wth wch 3jaodan.2 ex wph wta wch 3jaodan.3 ex 3jaod imp $.
  $}

  ${
    mpjao3dan.1 $e |- ( ( ph /\ ps ) -> ch ) $.
    mpjao3dan.2 $e |- ( ( ph /\ th ) -> ch ) $.
    mpjao3dan.3 $e |- ( ( ph /\ ta ) -> ch ) $.
    mpjao3dan.4 $e |- ( ph -> ( ps \/ th \/ ta ) ) $.
    $( Eliminate a three-way disjunction in a deduction.  (Contributed by
       Thierry Arnoux, 13-Apr-2018.)  (Proof shortened by Wolf Lammen,
       20-Apr-2024.) $)
    mpjao3dan $p |- ( ph -> ch ) $=
      wph wps wth wta w3o wch mpjao3dan.4 wph wps wch wth wta mpjao3dan.1
      mpjao3dan.2 mpjao3dan.3 3jaodan mpdan $.
  $}

  ${
    3jaao.1 $e |- ( ph -> ( ps -> ch ) ) $.
    3jaao.2 $e |- ( th -> ( ta -> ch ) ) $.
    3jaao.3 $e |- ( et -> ( ze -> ch ) ) $.
    $( Inference conjoining and disjoining the antecedents of three
       implications.  (Contributed by Jeff Hankins, 15-Aug-2009.)  (Proof
       shortened by Andrew Salmon, 13-May-2011.) $)
    3jaao $p |- ( ( ph /\ th /\ et ) -> ( ( ps \/ ta \/ ze ) -> ch ) ) $=
      wph wth wet w3a wps wch wta wze wph wth wps wch wi wet 3jaao.1 3ad2ant1
      wth wph wta wch wi wet 3jaao.2 3ad2ant2 wet wph wze wch wi wth 3jaao.3
      3ad2ant3 3jaod $.
  $}

  ${
    syl3an9b.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    syl3an9b.2 $e |- ( th -> ( ch <-> ta ) ) $.
    syl3an9b.3 $e |- ( et -> ( ta <-> ze ) ) $.
    $( Nested syllogism inference conjoining 3 dissimilar antecedents.
       (Contributed by NM, 1-May-1995.) $)
    syl3an9b $p |- ( ( ph /\ th /\ et ) -> ( ps <-> ze ) ) $=
      wph wth wet wps wze wb wph wth wa wps wta wet wze wph wps wch wth wta
      syl3an9b.1 syl3an9b.2 sylan9bb syl3an9b.3 sylan9bb 3impa $.
  $}

  ${
    bi3d.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    bi3d.2 $e |- ( ph -> ( th <-> ta ) ) $.
    bi3d.3 $e |- ( ph -> ( et <-> ze ) ) $.
    $( Deduction joining 3 equivalences to form equivalence of disjunctions.
       (Contributed by NM, 20-Apr-1994.) $)
    3orbi123d $p |- ( ph -> ( ( ps \/ th \/ et ) <-> ( ch \/ ta \/ ze ) ) ) $=
      wph wps wth wo wet wo wch wta wo wze wo wps wth wet w3o wch wta wze w3o
      wph wps wth wo wch wta wo wet wze wph wps wch wth wta bi3d.1 bi3d.2
      orbi12d bi3d.3 orbi12d wps wth wet df-3or wch wta wze df-3or 3bitr4g $.

    $( Deduction joining 3 equivalences to form equivalence of conjunctions.
       (Contributed by NM, 22-Apr-1994.) $)
    3anbi123d $p |- ( ph -> ( ( ps /\ th /\ et ) <-> ( ch /\ ta /\ ze ) ) ) $=
      wph wps wth wa wet wa wch wta wa wze wa wps wth wet w3a wch wta wze w3a
      wph wps wth wa wch wta wa wet wze wph wps wch wth wta bi3d.1 bi3d.2
      anbi12d bi3d.3 anbi12d wps wth wet df-3an wch wta wze df-3an 3bitr4g $.
  $}

  ${
    3anbi12d.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    3anbi12d.2 $e |- ( ph -> ( th <-> ta ) ) $.
    $( Deduction conjoining and adding a conjunct to equivalences.
       (Contributed by NM, 8-Sep-2006.) $)
    3anbi12d $p |- ( ph -> ( ( ps /\ th /\ et ) <-> ( ch /\ ta /\ et ) ) ) $=
      wph wps wch wth wta wet wet 3anbi12d.1 3anbi12d.2 wph wet biidd 3anbi123d
      $.

    $( Deduction conjoining and adding a conjunct to equivalences.
       (Contributed by NM, 8-Sep-2006.) $)
    3anbi13d $p |- ( ph -> ( ( ps /\ et /\ th ) <-> ( ch /\ et /\ ta ) ) ) $=
      wph wps wch wet wet wth wta 3anbi12d.1 wph wet biidd 3anbi12d.2 3anbi123d
      $.

    $( Deduction conjoining and adding a conjunct to equivalences.
       (Contributed by NM, 8-Sep-2006.) $)
    3anbi23d $p |- ( ph -> ( ( et /\ ps /\ th ) <-> ( et /\ ch /\ ta ) ) ) $=
      wph wet wet wps wch wth wta wph wet biidd 3anbi12d.1 3anbi12d.2 3anbi123d
      $.
  $}

  ${
    3anbi1d.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    $( Deduction adding conjuncts to an equivalence.  (Contributed by NM,
       8-Sep-2006.) $)
    3anbi1d $p |- ( ph -> ( ( ps /\ th /\ ta ) <-> ( ch /\ th /\ ta ) ) ) $=
      wph wps wch wth wth wta 3anbi1d.1 wph wth biidd 3anbi12d $.

    $( Deduction adding conjuncts to an equivalence.  (Contributed by NM,
       8-Sep-2006.) $)
    3anbi2d $p |- ( ph -> ( ( th /\ ps /\ ta ) <-> ( th /\ ch /\ ta ) ) ) $=
      wph wth wth wps wch wta wph wth biidd 3anbi1d.1 3anbi12d $.

    $( Deduction adding conjuncts to an equivalence.  (Contributed by NM,
       8-Sep-2006.) $)
    3anbi3d $p |- ( ph -> ( ( th /\ ta /\ ps ) <-> ( th /\ ta /\ ch ) ) ) $=
      wph wth wth wps wch wta wph wth biidd 3anbi1d.1 3anbi13d $.
  $}

  ${
    3anim123d.1 $e |- ( ph -> ( ps -> ch ) ) $.
    3anim123d.2 $e |- ( ph -> ( th -> ta ) ) $.
    3anim123d.3 $e |- ( ph -> ( et -> ze ) ) $.
    $( Deduction joining 3 implications to form implication of conjunctions.
       (Contributed by NM, 24-Feb-2005.) $)
    3anim123d $p |- ( ph -> ( ( ps /\ th /\ et ) -> ( ch /\ ta /\ ze ) ) ) $=
      wph wps wth wa wet wa wch wta wa wze wa wps wth wet w3a wch wta wze w3a
      wph wps wth wa wch wta wa wet wze wph wps wch wth wta 3anim123d.1
      3anim123d.2 anim12d 3anim123d.3 anim12d wps wth wet df-3an wch wta wze
      df-3an 3imtr4g $.

    $( Deduction joining 3 implications to form implication of disjunctions.
       (Contributed by NM, 4-Apr-1997.) $)
    3orim123d $p |- ( ph -> ( ( ps \/ th \/ et ) -> ( ch \/ ta \/ ze ) ) ) $=
      wph wps wth wo wet wo wch wta wo wze wo wps wth wet w3o wch wta wze w3o
      wph wps wth wo wch wta wo wet wze wph wps wch wth wta 3anim123d.1
      3anim123d.2 orim12d 3anim123d.3 orim12d wps wth wet df-3or wch wta wze
      df-3or 3imtr4g $.
  $}

  $( Rearrangement of 6 conjuncts.  (Contributed by NM, 13-Mar-1995.) $)
  an6 $p |- ( ( ( ph /\ ps /\ ch ) /\ ( th /\ ta /\ et ) ) <->
              ( ( ph /\ th ) /\ ( ps /\ ta ) /\ ( ch /\ et ) ) ) $=
    wph wps wa wch wa wth wta wa wet wa wa wph wth wa wps wta wa wa wch wet wa
    wa wph wps wch w3a wth wta wet w3a wa wph wth wa wps wta wa wch wet wa w3a
    wph wps wa wch wa wth wta wa wet wa wa wph wps wa wth wta wa wa wch wet wa
    wph wth wa wps wta wa wa wph wps wa wch wth wta wa wet an4 wph wps wth wta
    an4 bianbi wph wps wch w3a wph wps wa wch wa wth wta wet w3a wth wta wa wet
    wa wph wps wch df-3an wth wta wet df-3an anbi12i wph wth wa wps wta wa wch
    wet wa df-3an 3bitr4i $.

  $( Analogue of ~ an4 for triple conjunction.  (Contributed by Scott Fenton,
     16-Mar-2011.)  (Proof shortened by Andrew Salmon, 25-May-2011.) $)
  3an6 $p |- ( ( ( ph /\ ps ) /\ ( ch /\ th ) /\ ( ta /\ et ) ) <->
                ( ( ph /\ ch /\ ta ) /\ ( ps /\ th /\ et ) ) ) $=
    wph wch wta w3a wps wth wet w3a wa wph wps wa wch wth wa wta wet wa w3a wph
    wch wta wps wth wet an6 bicomi $.

  $( Analogue of ~ or4 for triple conjunction.  (Contributed by Scott Fenton,
     16-Mar-2011.) $)
  3or6 $p |- ( ( ( ph \/ ps ) \/ ( ch \/ th ) \/ ( ta \/ et ) ) <->
                ( ( ph \/ ch \/ ta ) \/ ( ps \/ th \/ et ) ) ) $=
    wph wps wo wch wth wo wo wta wet wo wo wph wch wo wta wo wps wth wo wet wo
    wo wph wps wo wch wth wo wta wet wo w3o wph wch wta w3o wps wth wet w3o wo
    wph wch wo wta wo wps wth wo wet wo wo wph wch wo wps wth wo wo wta wet wo
    wo wph wps wo wch wth wo wo wta wet wo wo wph wch wo wta wps wth wo wet or4
    wph wch wo wps wth wo wo wph wps wo wch wth wo wo wta wet wo wph wch wps
    wth or4 orbi1i bitr2i wph wps wo wch wth wo wta wet wo df-3or wph wch wta
    w3o wph wch wo wta wo wps wth wet w3o wps wth wo wet wo wph wch wta df-3or
    wps wth wet df-3or orbi12i 3bitr4i $.

  ${
    mp3an1.1 $e |- ph $.
    mp3an1.2 $e |- ( ( ph /\ ps /\ ch ) -> th ) $.
    $( An inference based on modus ponens.  (Contributed by NM,
       21-Nov-1994.) $)
    mp3an1 $p |- ( ( ps /\ ch ) -> th ) $=
      wph wps wch wa wth mp3an1.1 wph wps wch wth mp3an1.2 3expb mpan $.
  $}

  ${
    mp3an2.1 $e |- ps $.
    mp3an2.2 $e |- ( ( ph /\ ps /\ ch ) -> th ) $.
    $( An inference based on modus ponens.  (Contributed by NM,
       21-Nov-1994.) $)
    mp3an2 $p |- ( ( ph /\ ch ) -> th ) $=
      wph wps wch wth mp3an2.1 wph wps wch wth mp3an2.2 3expa mpanl2 $.
  $}

  ${
    mp3an3.1 $e |- ch $.
    mp3an3.2 $e |- ( ( ph /\ ps /\ ch ) -> th ) $.
    $( An inference based on modus ponens.  (Contributed by NM,
       21-Nov-1994.) $)
    mp3an3 $p |- ( ( ph /\ ps ) -> th ) $=
      wph wps wa wch wth mp3an3.1 wph wps wch wth mp3an3.2 3expia mpi $.
  $}

  ${
    mp3an12.1 $e |- ph $.
    mp3an12.2 $e |- ps $.
    mp3an12.3 $e |- ( ( ph /\ ps /\ ch ) -> th ) $.
    $( An inference based on modus ponens.  (Contributed by NM,
       13-Jul-2005.) $)
    mp3an12 $p |- ( ch -> th ) $=
      wps wch wth mp3an12.2 wph wps wch wth mp3an12.1 mp3an12.3 mp3an1 mpan $.
  $}

  ${
    mp3an13.1 $e |- ph $.
    mp3an13.2 $e |- ch $.
    mp3an13.3 $e |- ( ( ph /\ ps /\ ch ) -> th ) $.
    $( An inference based on modus ponens.  (Contributed by NM,
       14-Jul-2005.) $)
    mp3an13 $p |- ( ps -> th ) $=
      wph wps wth mp3an13.1 wph wps wch wth mp3an13.2 mp3an13.3 mp3an3 mpan $.
  $}

  ${
    mp3an23.1 $e |- ps $.
    mp3an23.2 $e |- ch $.
    mp3an23.3 $e |- ( ( ph /\ ps /\ ch ) -> th ) $.
    $( An inference based on modus ponens.  (Contributed by NM,
       14-Jul-2005.) $)
    mp3an23 $p |- ( ph -> th ) $=
      wph wps wth mp3an23.1 wph wps wch wth mp3an23.2 mp3an23.3 mp3an3 mpan2 $.
  $}

  ${
    mp3an1i.1 $e |- ps $.
    mp3an1i.2 $e |- ( ph -> ( ( ps /\ ch /\ th ) -> ta ) ) $.
    $( An inference based on modus ponens.  (Contributed by NM, 5-Jul-2005.) $)
    mp3an1i $p |- ( ph -> ( ( ch /\ th ) -> ta ) ) $=
      wch wth wa wph wta wps wch wth wph wta wi mp3an1i.1 wph wps wch wth w3a
      wta mp3an1i.2 com12 mp3an1 com12 $.
  $}

  ${
    mp3anl1.1 $e |- ph $.
    mp3anl1.2 $e |- ( ( ( ph /\ ps /\ ch ) /\ th ) -> ta ) $.
    $( An inference based on modus ponens.  (Contributed by NM,
       24-Feb-2005.) $)
    mp3anl1 $p |- ( ( ( ps /\ ch ) /\ th ) -> ta ) $=
      wps wch wa wth wta wph wps wch wth wta wi mp3anl1.1 wph wps wch w3a wth
      wta mp3anl1.2 ex mp3an1 imp $.
  $}

  ${
    mp3anl2.1 $e |- ps $.
    mp3anl2.2 $e |- ( ( ( ph /\ ps /\ ch ) /\ th ) -> ta ) $.
    $( An inference based on modus ponens.  (Contributed by NM,
       24-Feb-2005.) $)
    mp3anl2 $p |- ( ( ( ph /\ ch ) /\ th ) -> ta ) $=
      wph wch wa wth wta wph wps wch wth wta wi mp3anl2.1 wph wps wch w3a wth
      wta mp3anl2.2 ex mp3an2 imp $.
  $}

  ${
    mp3anl3.1 $e |- ch $.
    mp3anl3.2 $e |- ( ( ( ph /\ ps /\ ch ) /\ th ) -> ta ) $.
    $( An inference based on modus ponens.  (Contributed by NM,
       24-Feb-2005.) $)
    mp3anl3 $p |- ( ( ( ph /\ ps ) /\ th ) -> ta ) $=
      wph wps wa wth wta wph wps wch wth wta wi mp3anl3.1 wph wps wch w3a wth
      wta mp3anl3.2 ex mp3an3 imp $.
  $}

  ${
    mp3anr1.1 $e |- ps $.
    mp3anr1.2 $e |- ( ( ph /\ ( ps /\ ch /\ th ) ) -> ta ) $.
    $( An inference based on modus ponens.  (Contributed by NM, 4-Nov-2006.) $)
    mp3anr1 $p |- ( ( ph /\ ( ch /\ th ) ) -> ta ) $=
      wch wth wa wph wta wps wch wth wph wta mp3anr1.1 wph wps wch wth w3a wta
      mp3anr1.2 ancoms mp3anl1 ancoms $.
  $}

  ${
    mp3anr2.1 $e |- ch $.
    mp3anr2.2 $e |- ( ( ph /\ ( ps /\ ch /\ th ) ) -> ta ) $.
    $( An inference based on modus ponens.  (Contributed by NM,
       24-Nov-2006.) $)
    mp3anr2 $p |- ( ( ph /\ ( ps /\ th ) ) -> ta ) $=
      wps wth wa wph wta wps wch wth wph wta mp3anr2.1 wph wps wch wth w3a wta
      mp3anr2.2 ancoms mp3anl2 ancoms $.
  $}

  ${
    mp3anr3.1 $e |- th $.
    mp3anr3.2 $e |- ( ( ph /\ ( ps /\ ch /\ th ) ) -> ta ) $.
    $( An inference based on modus ponens.  (Contributed by NM,
       19-Oct-2007.) $)
    mp3anr3 $p |- ( ( ph /\ ( ps /\ ch ) ) -> ta ) $=
      wps wch wa wph wta wps wch wth wph wta mp3anr3.1 wph wps wch wth w3a wta
      mp3anr3.2 ancoms mp3anl3 ancoms $.
  $}

  ${
    mp3an.1 $e |- ph $.
    mp3an.2 $e |- ps $.
    mp3an.3 $e |- ch $.
    mp3an.4 $e |- ( ( ph /\ ps /\ ch ) -> th ) $.
    $( An inference based on modus ponens.  (Contributed by NM,
       14-May-1999.) $)
    mp3an $p |- th $=
      wps wch wth mp3an.2 mp3an.3 wph wps wch wth mp3an.1 mp3an.4 mp3an1 mp2an
      $.
  $}

  ${
    mpd3an3.2 $e |- ( ( ph /\ ps ) -> ch ) $.
    mpd3an3.3 $e |- ( ( ph /\ ps /\ ch ) -> th ) $.
    $( An inference based on modus ponens.  (Contributed by NM, 8-Nov-2007.) $)
    mpd3an3 $p |- ( ( ph /\ ps ) -> th ) $=
      wph wps wa wch wth mpd3an3.2 wph wps wch wth mpd3an3.3 3expa mpdan $.
  $}

  ${
    mpd3an23.1 $e |- ( ph -> ps ) $.
    mpd3an23.2 $e |- ( ph -> ch ) $.
    mpd3an23.3 $e |- ( ( ph /\ ps /\ ch ) -> th ) $.
    $( An inference based on modus ponens.  (Contributed by NM, 4-Dec-2006.) $)
    mpd3an23 $p |- ( ph -> th ) $=
      wph wph wps wch wth wph id mpd3an23.1 mpd3an23.2 mpd3an23.3 syl3anc $.
  $}

  ${
    mp3and.1 $e |- ( ph -> ps ) $.
    mp3and.2 $e |- ( ph -> ch ) $.
    mp3and.3 $e |- ( ph -> th ) $.
    mp3and.4 $e |- ( ph -> ( ( ps /\ ch /\ th ) -> ta ) ) $.
    $( A deduction based on modus ponens.  (Contributed by Mario Carneiro,
       24-Dec-2016.) $)
    mp3and $p |- ( ph -> ta ) $=
      wph wps wch wth w3a wta wph wps wch wth mp3and.1 mp3and.2 mp3and.3 3jca
      mp3and.4 mpd $.
  $}

  ${
    mp3an12i.1 $e |- ph $.
    mp3an12i.2 $e |- ps $.
    mp3an12i.3 $e |- ( ch -> th ) $.
    mp3an12i.4 $e |- ( ( ph /\ ps /\ th ) -> ta ) $.
    $( ~ mp3an with antecedents in standard conjunction form and with one
       hypothesis an implication.  (Contributed by Alan Sare, 28-Aug-2016.) $)
    mp3an12i $p |- ( ch -> ta ) $=
      wch wth wta mp3an12i.3 wph wps wth wta mp3an12i.1 mp3an12i.2 mp3an12i.4
      mp3an12 syl $.
  $}

  ${
    mp3an2i.1 $e |- ph $.
    mp3an2i.2 $e |- ( ps -> ch ) $.
    mp3an2i.3 $e |- ( ps -> th ) $.
    mp3an2i.4 $e |- ( ( ph /\ ch /\ th ) -> ta ) $.
    $( ~ mp3an with antecedents in standard conjunction form and with two
       hypotheses which are implications.  (Contributed by Alan Sare,
       28-Aug-2016.) $)
    mp3an2i $p |- ( ps -> ta ) $=
      wps wch wth wta mp3an2i.2 mp3an2i.3 wph wch wth wta mp3an2i.1 mp3an2i.4
      mp3an1 syl2anc $.
  $}

  ${
    mp3an3an.1 $e |- ph $.
    mp3an3an.2 $e |- ( ps -> ch ) $.
    mp3an3an.3 $e |- ( th -> ta ) $.
    mp3an3an.4 $e |- ( ( ph /\ ch /\ ta ) -> et ) $.
    $( ~ mp3an with antecedents in standard conjunction form and with two
       hypotheses which are implications.  (Contributed by Alan Sare,
       28-Aug-2016.) $)
    mp3an3an $p |- ( ( ps /\ th ) -> et ) $=
      wps wch wta wet wth mp3an3an.2 mp3an3an.3 wph wch wta wet mp3an3an.1
      mp3an3an.4 mp3an1 syl2an $.
  $}

  ${
    mp3an2ani.1 $e |- ph $.
    mp3an2ani.2 $e |- ( ps -> ch ) $.
    mp3an2ani.3 $e |- ( ( ps /\ th ) -> ta ) $.
    mp3an2ani.4 $e |- ( ( ph /\ ch /\ ta ) -> et ) $.
    $( An elimination deduction.  (Contributed by Alan Sare, 17-Oct-2017.) $)
    mp3an2ani $p |- ( ( ps /\ th ) -> et ) $=
      wps wth wet wph wps wch wps wth wa wta wet mp3an2ani.1 mp3an2ani.2
      mp3an2ani.3 mp3an2ani.4 mp3an3an anabss5 $.
  $}

  ${
    biimp3a.1 $e |- ( ( ph /\ ps ) -> ( ch <-> th ) ) $.
    $( Infer implication from a logical equivalence.  Similar to ~ biimpa .
       (Contributed by NM, 4-Sep-2005.) $)
    biimp3a $p |- ( ( ph /\ ps /\ ch ) -> th ) $=
      wph wps wch wth wph wps wa wch wth biimp3a.1 biimpa 3impa $.

    $( Infer implication from a logical equivalence.  Similar to ~ biimpar .
       (Contributed by NM, 2-Jan-2009.) $)
    biimp3ar $p |- ( ( ph /\ ps /\ th ) -> ch ) $=
      wph wps wth wch wph wps wch wth biimp3a.1 exbiri 3imp $.
  $}

  ${
    3anandis.1 $e |- ( ( ( ph /\ ps ) /\ ( ph /\ ch ) /\ ( ph /\ th ) )
                      -> ta ) $.
    $( Inference that undistributes a triple conjunction in the antecedent.
       (Contributed by NM, 18-Apr-2007.) $)
    3anandis $p |- ( ( ph /\ ( ps /\ ch /\ th ) ) -> ta ) $=
      wph wps wch wth w3a wa wph wps wph wch wph wth wta wph wps wch wth w3a
      simpl wph wps wch wth simpr1 wph wps wch wth w3a simpl wph wps wch wth
      simpr2 wph wps wch wth w3a simpl wph wps wch wth simpr3 3anandis.1
      syl222anc $.
  $}

  ${
    3anandirs.1 $e |- ( ( ( ph /\ th ) /\ ( ps /\ th ) /\ ( ch /\ th ) )
                      -> ta ) $.
    $( Inference that undistributes a triple conjunction in the antecedent.
       (Contributed by NM, 25-Jul-2006.) $)
    3anandirs $p |- ( ( ( ph /\ ps /\ ch ) /\ th ) -> ta ) $=
      wph wps wch w3a wth wa wph wth wps wth wch wth wta wph wps wch wth simpl1
      wph wps wch w3a wth simpr wph wps wch wth simpl2 wph wps wch w3a wth
      simpr wph wps wch wth simpl3 wph wps wch w3a wth simpr 3anandirs.1
      syl222anc $.
  $}

  ${
    ecase23d.1 $e |- ( ph -> -. ch ) $.
    ecase23d.2 $e |- ( ph -> -. th ) $.
    ecase23d.3 $e |- ( ph -> ( ps \/ ch \/ th ) ) $.
    $( Deduction for elimination by cases.  (Contributed by NM,
       22-Apr-1994.) $)
    ecase23d $p |- ( ph -> ps ) $=
      wph wps wch wth wo wph wps wch wth w3o wps wch wth wo wo ecase23d.3 wps
      wch wth 3orass sylib wph wch wn wth wn wch wth wo wn ecase23d.1
      ecase23d.2 wch wth ioran sylanbrc olcnd $.
  $}

  ${
    3ecase.1 $e |- ( -. ph -> th ) $.
    3ecase.2 $e |- ( -. ps -> th ) $.
    3ecase.3 $e |- ( -. ch -> th ) $.
    3ecase.4 $e |- ( ( ph /\ ps /\ ch ) -> th ) $.
    $( Inference for elimination by cases.  (Contributed by NM,
       13-Jul-2005.) $)
    3ecase $p |- th $=
      wps wch wth wph wps wch wth wi wi wph wps wch wth 3ecase.4 3exp wph wn
      wth wps wch 3ecase.1 2a1d pm2.61i 3ecase.2 3ecase.3 pm2.61nii $.
  $}

  ${
    3biorfd.1 $e |- ( ph -> -. th ) $.
    $( A disjunction is equivalent to a threefold disjunction with single
       falsehood, analogous to ~ biorf .  (Contributed by Alexander van der
       Vekens, 8-Sep-2017.) $)
    3bior1fd $p |- ( ph -> ( ( ch \/ ps ) <-> ( th \/ ch \/ ps ) ) ) $=
      wph wch wps wo wth wch wps wo wo wth wch wps w3o wph wth wn wch wps wo
      wth wch wps wo wo wb 3biorfd.1 wth wch wps wo biorf syl wth wch wps
      3orass bitr4di $.

    $( A disjunction is equivalent to a threefold disjunction with single
       falsehood of a conjunction.  (Contributed by Alexander van der Vekens,
       8-Sep-2017.) $)
    3bior1fand $p |- ( ph -> ( ( ch \/ ps )
                       <-> ( ( th /\ ta ) \/ ch \/ ps ) ) ) $=
      wph wps wch wth wta wa wph wth wta 3biorfd.1 intnanrd 3bior1fd $.

    3biorfd.2 $e |- ( ph -> -. ch ) $.
    $( A wff is equivalent to its threefold disjunction with double falsehood,
       analogous to ~ biorf .  (Contributed by Alexander van der Vekens,
       8-Sep-2017.) $)
    3bior2fd $p |- ( ph -> ( ps <-> ( th \/ ch \/ ps ) ) ) $=
      wph wps wch wps wo wth wch wps w3o wph wch wn wps wch wps wo wb 3biorfd.2
      wch wps biorf syl wph wps wch wth 3biorfd.1 3bior1fd bitrd $.
  $}

  ${
    3biantd.1 $e |- ( ph -> th ) $.
    $( A conjunction is equivalent to a threefold conjunction with single
       truth, analogous to ~ biantrud .  (Contributed by Alexander van der
       Vekens, 26-Sep-2017.) $)
    3biant1d $p |- ( ph -> ( ( ch /\ ps ) <-> ( th /\ ch /\ ps ) ) ) $=
      wph wch wps wa wth wch wps wa wa wth wch wps w3a wph wth wch wps wa
      3biantd.1 biantrurd wth wch wps 3anass bitr4di $.
  $}

  ${
    intn3and.1 $e |- ( ph -> -. ps ) $.
    $( Introduction of a triple conjunct inside a contradiction.  (Contributed
       by FL, 27-Dec-2007.)  (Proof shortened by Andrew Salmon,
       26-Jun-2011.) $)
    intn3an1d $p |- ( ph -> -. ( ps /\ ch /\ th ) ) $=
      wph wps wps wch wth w3a intn3and.1 wps wch wth simp1 nsyl $.

    $( Introduction of a triple conjunct inside a contradiction.  (Contributed
       by FL, 27-Dec-2007.)  (Proof shortened by Andrew Salmon,
       26-Jun-2011.) $)
    intn3an2d $p |- ( ph -> -. ( ch /\ ps /\ th ) ) $=
      wph wps wch wps wth w3a intn3and.1 wch wps wth simp2 nsyl $.

    $( Introduction of a triple conjunct inside a contradiction.  (Contributed
       by FL, 27-Dec-2007.)  (Proof shortened by Andrew Salmon,
       26-Jun-2011.) $)
    intn3an3d $p |- ( ph -> -. ( ch /\ th /\ ps ) ) $=
      wph wps wch wth wps w3a intn3and.1 wch wth wps simp3 nsyl $.
  $}

  $( Distribution of conjunction over threefold conjunction.  (Contributed by
     Thierry Arnoux, 8-Apr-2019.) $)
  an3andi $p |- ( ( ph /\ ( ps /\ ch /\ th ) ) <->
               ( ( ph /\ ps ) /\ ( ph /\ ch ) /\ ( ph /\ th ) ) ) $=
    wph wps wch wa wth wa wa wph wps wa wph wch wa wa wph wth wa wa wph wps wch
    wth w3a wa wph wps wa wph wch wa wph wth wa w3a wph wps wch wa wth wa wa
    wph wps wch wa wa wph wth wa wph wps wa wph wch wa wa wph wps wch wa wth
    anandi wph wps wch anandi bianbi wps wch wth w3a wps wch wa wth wa wph wps
    wch wth df-3an anbi2i wph wps wa wph wch wa wph wth wa df-3an 3bitr4i $.

  $( Rearrange a 9-fold conjunction.  (Contributed by Thierry Arnoux,
     14-Apr-2019.)  (Proof shortened by Wolf Lammen, 21-Apr-2024.) $)
  an33rean $p |- (
        ( ( ph /\ ps /\ ch ) /\ ( th /\ ta /\ et ) /\ ( ze /\ si /\ rh ) ) <->
    ( ( ph /\ ta /\ rh ) /\ ( ( ps /\ th ) /\ ( et /\ si ) /\ ( ch /\ ze ) ) )
    ) $=
    wph wps wch w3a wth wta wet w3a wze wsi wrh w3a w3a wph wps wch wa wa wta
    wth wet wa wa wrh wsi wze wa wa w3a wph wta wrh w3a wps wch wa wth wet wa
    wsi wze wa w3a wa wph wta wrh w3a wps wth wa wet wsi wa wch wze wa w3a wa
    wph wps wch w3a wph wps wch wa wa wth wta wet w3a wta wth wet wa wa wze wsi
    wrh w3a wrh wsi wze wa wa wph wps wch 3anass wth wta wet 3anan12 wze wsi
    wrh w3a wrh wsi wze w3a wrh wsi wze wa wa wze wsi wrh 3anrev wrh wsi wze
    3anass bitri 3anbi123i wph wps wch wa wta wth wet wa wrh wsi wze wa 3an6
    wps wch wa wth wet wa wsi wze wa w3a wps wth wa wet wsi wa wch wze wa w3a
    wph wta wrh w3a wps wch wa wth wet wa wa wsi wze wa wa wps wth wa wet wsi
    wa wa wch wze wa wa wps wch wa wth wet wa wsi wze wa w3a wps wth wa wet wsi
    wa wch wze wa w3a wps wch wa wth wet wa wa wsi wa wze wa wps wth wa wet wsi
    wa wa wch wa wze wa wps wch wa wth wet wa wa wsi wze wa wa wps wth wa wet
    wsi wa wa wch wze wa wa wps wch wa wth wet wa wa wsi wa wps wth wa wet wsi
    wa wa wch wa wze wps wch wa wth wet wa wsi wa wa wps wth wa wet wsi wa wch
    wa wa wps wch wa wth wet wa wa wsi wa wps wth wa wet wsi wa wa wch wa wps
    wch wa wth wet wa wsi wa wa wps wch wa wth wet wsi wa wa wa wps wth wa wet
    wsi wa wch wa wa wth wet wa wsi wa wth wet wsi wa wa wps wch wa wth wet wsi
    anass anbi2i wps wch wth wet wsi wa an42 bitri wps wch wa wth wet wa wsi
    anass wps wth wa wet wsi wa wch anass 3bitr4i anbi1i wps wch wa wth wet wa
    wa wsi wze anass wps wth wa wet wsi wa wa wch wze anass 3bitr3i wps wch wa
    wth wet wa wsi wze wa df-3an wps wth wa wet wsi wa wch wze wa df-3an
    3bitr4i anbi2i 3bitri $.

  $( Partial elimination of a triple disjunction by denial of a disjunct.
     (Contributed by Scott Fenton, 26-Mar-2011.)  (Proof shortened by Andrew
     Salmon, 25-May-2011.)  (Proof shortened by Eric Schmidt, 8-Oct-2025.) $)
  3orel2 $p |- ( -. ps -> ( ( ph \/ ps \/ ch ) -> ( ph \/ ch ) ) ) $=
    wph wps wch w3o wps wph wch w3o wps wn wph wch wo wph wps wch 3orcoma wps
    wph wch 3orel1 biimtrid $.

  $( Obsolete version of ~ 3orel2 as of 8-Oct-2025.  (Contributed by Scott
     Fenton, 26-Mar-2011.)  (Proof shortened by Andrew Salmon, 25-May-2011.)
     (Proof modification is discouraged.)  (New usage is discouraged.) $)
  3orel2OLD $p |- ( -. ps -> ( ( ph \/ ps \/ ch ) -> ( ph \/ ch ) ) ) $=
    wph wps wch w3o wps wch wph w3o wps wn wph wch wo wph wps wch 3orrot wps wn
    wps wch wph w3o wch wph wo wph wch wo wps wch wph 3orel1 wch wph orcom
    imbitrdi biimtrid $.

  $( Partial elimination of a triple disjunction by denial of a disjunct.
     (Contributed by Scott Fenton, 26-Mar-2011.) $)
  3orel3 $p |- ( -. ch -> ( ( ph \/ ps \/ ch ) -> ( ph \/ ps ) ) ) $=
    wph wps wch w3o wph wps wo wch wo wch wn wph wps wo wph wps wch df-3or wch
    wph wps wo orel2 biimtrid $.

  $( Elimination of two disjuncts in a triple disjunction.  (Contributed by
     Scott Fenton, 9-Jun-2011.) $)
  3orel13 $p |- ( ( -. ph /\ -. ch ) -> ( ( ph \/ ps \/ ch ) -> ps ) ) $=
    wch wn wph wps wch w3o wph wps wo wph wn wps wph wps wch 3orel3 wph wps
    orel1 sylan9r $.

  ${
    3pm3.2ni.1 $e |- -. ph $.
    3pm3.2ni.2 $e |- -. ps $.
    3pm3.2ni.3 $e |- -. ch $.
    $( Triple negated disjunction introduction.  (Contributed by Scott Fenton,
       20-Apr-2011.) $)
    3pm3.2ni $p |- -. ( ph \/ ps \/ ch ) $=
      wph wps wch w3o wph wps wo wch wo wph wps wo wch wph wps 3pm3.2ni.1
      3pm3.2ni.2 pm3.2ni 3pm3.2ni.3 pm3.2ni wph wps wch df-3or mtbir $.
  $}


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Logical "nand" (Sheffer stroke)
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
$)

  $( Declare connective for alternative denial ("nand"). $)
  $c -/\ $.  $( Overlined "wedge" (read:  "nand") $)

  $( Extend wff definition to include alternative denial ("nand"). $)
  wnan $a wff ( ph -/\ ps ) $.

  $( Define incompatibility, or alternative denial ("not-and" or "nand").  See
     ~ dfnan2 for an alternative.  This is also called the Sheffer stroke,
     represented by a vertical bar, but we use a different symbol to avoid
     ambiguity with other uses of the vertical bar.  In the second edition of
     Principia Mathematica (1927), Russell and Whitehead used the Sheffer
     stroke and suggested it as a replacement for the "or" and "not" operations
     of the first edition.  However, in practice, "or" and "not" are more
     widely used.  After we define the constant true ` T. ` ( ~ df-tru ) and
     the constant false ` F. ` ( ~ df-fal ), we will be able to prove these
     truth table values: ` ( ( T. -/\ T. ) <-> F. ) ` ( ~ trunantru ),
     ` ( ( T. -/\ F. ) <-> T. ) ` ( ~ trunanfal ), ` ( ( F. -/\ T. ) <-> T. ) `
     ( ~ falnantru ), and ` ( ( F. -/\ F. ) <-> T. ) ` ( ~ falnanfal ).
     Contrast with ` /\ ` ( ~ df-an ), ` \/ ` ( ~ df-or ), ` -> ` ( ~ wi ), and
     ` \/_ ` ( ~ df-xor ).  (Contributed by Jeff Hoffman, 19-Nov-2007.) $)
  df-nan $a |- ( ( ph -/\ ps ) <-> -. ( ph /\ ps ) ) $.

  $( Conjunction in terms of alternative denial.  (Contributed by Mario
     Carneiro, 9-May-2015.) $)
  nanan $p |- ( ( ph /\ ps ) <-> -. ( ph -/\ ps ) ) $=
    wph wps wnan wph wps wa wph wps df-nan con2bii $.

  $( Alternative denial in terms of our primitive connectives (implication and
     negation).  (Contributed by WL, 26-Jun-2020.) $)
  dfnan2 $p |- ( ( ph -/\ ps ) <-> ( ph -> -. ps ) ) $=
    wph wps wnan wph wps wa wn wph wps wn wi wph wps df-nan wph wps imnan
    bitr4i $.

  $( Alternative denial in terms of disjunction and negation.  This explains
     the name "alternative denial".  (Contributed by BJ, 19-Oct-2022.) $)
  nanor $p |- ( ( ph -/\ ps ) <-> ( -. ph \/ -. ps ) ) $=
    wph wps wnan wph wps wa wn wph wn wps wn wo wph wps df-nan wph wps ianor
    bitri $.

  $( Alternative denial is commutative.  Remark: alternative denial is not
     associative, see ~ nanass .  (Contributed by Mario Carneiro, 9-May-2015.)
     (Proof shortened by Wolf Lammen, 26-Jun-2020.) $)
  nancom $p |- ( ( ph -/\ ps ) <-> ( ps -/\ ph ) ) $=
    wph wps wn wi wps wph wn wi wph wps wnan wps wph wnan wph wps con2b wph wps
    dfnan2 wps wph dfnan2 3bitr4i $.

  $( Nested alternative denials.  (Contributed by Jeff Hoffman, 19-Nov-2007.)
     (Proof shortened by Wolf Lammen, 26-Jun-2020.) $)
  nannan $p |- ( ( ph -/\ ( ps -/\ ch ) ) <-> ( ph -> ( ps /\ ch ) ) ) $=
    wph wps wch wnan wnan wph wps wch wnan wn wi wph wps wch wa wi wph wps wch
    wnan dfnan2 wps wch wa wps wch wnan wn wph wps wch nanan imbi2i bitr4i $.

  $( Implication in terms of alternative denial.  (Contributed by Jeff Hoffman,
     19-Nov-2007.) $)
  nanim $p |- ( ( ph -> ps ) <-> ( ph -/\ ( ps -/\ ps ) ) ) $=
    wph wps wps wnan wnan wph wps wps wa wi wph wps wi wph wps wps nannan wph
    wps anidmdbi bitr2i $.

  $( Negation in terms of alternative denial.  (Contributed by Jeff Hoffman,
     19-Nov-2007.)  Use ~ dfnan2 .  (Revised by Wolf Lammen, 26-Jun-2020.) $)
  nannot $p |- ( -. ph <-> ( ph -/\ ph ) ) $=
    wph wph wnan wph wph wn wi wph wn wph wph dfnan2 wph pm4.8 bitr2i $.

  $( Biconditional in terms of alternative denial.  (Contributed by Jeff
     Hoffman, 19-Nov-2007.)  (Proof shortened by Wolf Lammen, 27-Jun-2020.) $)
  nanbi $p |- ( ( ph <-> ps ) <->
          ( ( ph -/\ ps ) -/\ ( ( ph -/\ ph ) -/\ ( ps -/\ ps ) ) ) ) $=
    wph wps wb wph wps wnan wph wph wnan wps wps wnan wa wi wph wps wnan wph
    wph wnan wps wps wnan wnan wnan wph wps wb wph wps wa wph wn wps wn wa wo
    wph wps wa wn wph wn wps wn wa wi wph wps wnan wph wph wnan wps wps wnan wa
    wi wph wps dfbi3 wph wps wa wph wn wps wn wa df-or wph wps wa wn wph wps
    wnan wph wn wps wn wa wph wph wnan wps wps wnan wa wph wps wnan wph wps wa
    wn wph wps df-nan bicomi wph wn wph wph wnan wps wn wps wps wnan wph nannot
    wps nannot anbi12i imbi12i 3bitri wph wps wnan wph wph wnan wps wps wnan
    nannan bitr4i $.

  $( Introduce a right anti-conjunct to both sides of a logical equivalence.
     (Contributed by Anthony Hart, 1-Sep-2011.)  (Proof shortened by Wolf
     Lammen, 27-Jun-2020.) $)
  nanbi1 $p |- ( ( ph <-> ps ) -> ( ( ph -/\ ch ) <-> ( ps -/\ ch ) ) ) $=
    wph wps wb wph wch wn wi wps wch wn wi wph wch wnan wps wch wnan wph wps
    wch wn imbi1 wph wch dfnan2 wps wch dfnan2 3bitr4g $.

  $( Introduce a left anti-conjunct to both sides of a logical equivalence.
     (Contributed by Anthony Hart, 1-Sep-2011.)  (Proof shortened by SF,
     2-Jan-2018.) $)
  nanbi2 $p |- ( ( ph <-> ps ) -> ( ( ch -/\ ph ) <-> ( ch -/\ ps ) ) ) $=
    wph wps wb wph wch wnan wps wch wnan wch wph wnan wch wps wnan wph wps wch
    nanbi1 wch wph nancom wch wps nancom 3bitr4g $.

  $( Join two logical equivalences with anti-conjunction.  (Contributed by SF,
     2-Jan-2018.) $)
  nanbi12 $p |- ( ( ( ph <-> ps ) /\ ( ch <-> th ) ) ->
                                       ( ( ph -/\ ch ) <-> ( ps -/\ th ) ) ) $=
    wph wps wb wph wch wnan wps wch wnan wch wth wb wps wth wnan wph wps wch
    nanbi1 wch wth wps nanbi2 sylan9bb $.

  ${
    nanbii.1 $e |- ( ph <-> ps ) $.
    $( Introduce a right anti-conjunct to both sides of a logical equivalence.
       (Contributed by SF, 2-Jan-2018.) $)
    nanbi1i $p |- ( ( ph -/\ ch ) <-> ( ps -/\ ch ) ) $=
      wph wps wb wph wch wnan wps wch wnan wb nanbii.1 wph wps wch nanbi1 ax-mp
      $.

    $( Introduce a left anti-conjunct to both sides of a logical equivalence.
       (Contributed by SF, 2-Jan-2018.) $)
    nanbi2i $p |- ( ( ch -/\ ph ) <-> ( ch -/\ ps ) ) $=
      wph wps wb wch wph wnan wch wps wnan wb nanbii.1 wph wps wch nanbi2 ax-mp
      $.

    nanbi12i.2 $e |- ( ch <-> th ) $.
    $( Join two logical equivalences with anti-conjunction.  (Contributed by
       SF, 2-Jan-2018.) $)
    nanbi12i $p |- ( ( ph -/\ ch ) <-> ( ps -/\ th ) ) $=
      wph wps wb wch wth wb wph wch wnan wps wth wnan wb nanbii.1 nanbi12i.2
      wph wps wch wth nanbi12 mp2an $.
  $}

  ${
    nanbid.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    $( Introduce a right anti-conjunct to both sides of a logical equivalence.
       (Contributed by SF, 2-Jan-2018.) $)
    nanbi1d $p |- ( ph -> ( ( ps -/\ th ) <-> ( ch -/\ th ) ) ) $=
      wph wps wch wb wps wth wnan wch wth wnan wb nanbid.1 wps wch wth nanbi1
      syl $.

    $( Introduce a left anti-conjunct to both sides of a logical equivalence.
       (Contributed by SF, 2-Jan-2018.) $)
    nanbi2d $p |- ( ph -> ( ( th -/\ ps ) <-> ( th -/\ ch ) ) ) $=
      wph wps wch wb wth wps wnan wth wch wnan wb nanbid.1 wps wch wth nanbi2
      syl $.

    nanbi12d.2 $e |- ( ph -> ( th <-> ta ) ) $.
    $( Join two logical equivalences with anti-conjunction.  (Contributed by
       Scott Fenton, 2-Jan-2018.) $)
    nanbi12d $p |- ( ph -> ( ( ps -/\ th ) <-> ( ch -/\ ta ) ) ) $=
      wph wps wch wb wth wta wb wps wth wnan wch wta wnan wb nanbid.1
      nanbi12d.2 wps wch wth wta nanbi12 syl2anc $.
  $}

  $( A characterization of when an expression involving alternative denials
     associates.  Remark: alternative denial is commutative, see ~ nancom .
     (Contributed by Richard Penner, 29-Feb-2020.)  (Proof shortened by Wolf
     Lammen, 23-Oct-2022.) $)
  nanass $p |- ( ( ph <-> ch ) <->
                 ( ( ( ph -/\ ps ) -/\ ch ) <-> ( ph -/\ ( ps -/\ ch ) ) ) ) $=
    wph wch wb wch wps wph wnan wnan wph wps wch wnan wnan wb wph wps wnan wch
    wnan wph wps wch wnan wnan wb wph wch wb wch wps wph wnan wnan wph wps wch
    wnan wnan wb wph wch wb wch wph wps wph wnan wps wch wnan wph wch bicom1
    wph wch wps nanbi2 nanbi12d wch wps wph wnan wnan wph wps wch wnan wnan wph
    wch wb wch wps wph wnan wnan wph wps wch wnan wnan wph wch wph wps wch wnan
    wnan wph wps wch wa wi wph wch wi wph wps wch nannan wps wch wa wch wph wps
    wch simpr imim2i sylbi wch wps wph wnan wnan wch wps wph wa wi wch wph wi
    wch wps wph nannan wps wph wa wph wch wps wph simpr imim2i sylbi impbid21d
    wph wps wch wnan wnan wn wph wch wps wph wnan wnan wn wch wph wch wb wph
    wps wch wnan wnan wn wph wps wch wnan wa wph wph wps wch wnan nanan wph wps
    wch wnan simpl sylbir wch wps wph wnan wnan wn wch wps wph wnan wa wch wch
    wps wph wnan nanan wch wps wph wnan simpl sylbir wph wch pm5.1im syl2imc
    bija impbii wch wps wph wnan wnan wph wps wnan wch wnan wph wps wch wnan
    wnan wch wps wph wnan wnan wch wph wps wnan wnan wph wps wnan wch wnan wps
    wph wnan wph wps wnan wch wps wph nancom nanbi2i wch wph wps wnan nancom
    bitri bibi1i bitri $.


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Logical "xor"
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
$)

  $( Declare connective for exclusive disjunction ("xor"). $)
  $c \/_ $.  $( Underlined "vee" (read:  "xor") $)

  $( Extend wff definition to include exclusive disjunction ("xor"). $)
  wxo $a wff ( ph \/_ ps ) $.

  $( Define exclusive disjunction (logical "xor").  Return true if either the
     left or right, but not both, are true.  After we define the constant true
     ` T. ` ( ~ df-tru ) and the constant false ` F. ` ( ~ df-fal ), we will be
     able to prove these truth table values: ` ( ( T. \/_ T. ) <-> F. ) `
     ( ~ truxortru ), ` ( ( T. \/_ F. ) <-> T. ) ` ( ~ truxorfal ),
     ` ( ( F. \/_ T. ) <-> T. ) ` ( ~ falxortru ), and
     ` ( ( F. \/_ F. ) <-> F. ) ` ( ~ falxorfal ).  Contrast with ` /\ `
     ( ~ df-an ), ` \/ ` ( ~ df-or ), ` -> ` ( ~ wi ), and ` -/\ `
     ( ~ df-nan ).  (Contributed by FL, 22-Nov-2010.) $)
  df-xor $a |- ( ( ph \/_ ps ) <-> -. ( ph <-> ps ) ) $.

  $( Two ways to write XNOR (exclusive not-or).  (Contributed by Mario
     Carneiro, 4-Sep-2016.) $)
  xnor $p |- ( ( ph <-> ps ) <-> -. ( ph \/_ ps ) ) $=
    wph wps wxo wph wps wb wph wps df-xor con2bii $.

  $( The connector ` \/_ ` is commutative.  (Contributed by Mario Carneiro,
     4-Sep-2016.)  (Proof shortened by Wolf Lammen, 21-Apr-2024.) $)
  xorcom $p |- ( ( ph \/_ ps ) <-> ( ps \/_ ph ) ) $=
    wph wps wxo wps wph wb wn wps wph wxo wph wps wxo wph wps wb wps wph wb wph
    wps df-xor wph wps bicom xchbinx wps wph df-xor bitr4i $.

  $( The connector ` \/_ ` is associative.  (Contributed by FL, 22-Nov-2010.)
     (Proof shortened by Andrew Salmon, 8-Jun-2011.)  (Proof shortened by Wolf
     Lammen, 20-Jun-2020.) $)
  xorass $p |- ( ( ( ph \/_ ps ) \/_ ch ) <-> ( ph \/_ ( ps \/_ ch ) ) ) $=
    wph wps wxo wch wb wn wph wps wch wxo wb wn wph wps wxo wch wxo wph wps wch
    wxo wxo wph wps wch wxo wb wn wph wps wch wxo wn wb wph wps wxo wn wch wb
    wph wps wxo wch wb wn wph wps wch wxo xor3 wph wps wb wch wb wph wps wch wb
    wb wph wps wxo wn wch wb wph wps wch wxo wn wb wph wps wch biass wph wps wb
    wph wps wxo wn wch wph wps xnor bibi1i wps wch wb wps wch wxo wn wph wps
    wch xnor bibi2i 3bitr3i wph wps wxo wch nbbn 3bitr2ri wph wps wxo wch
    df-xor wph wps wch wxo df-xor 3bitr4i $.

  $( This tautology shows that xor is really exclusive.  (Contributed by FL,
     22-Nov-2010.) $)
  excxor $p |- ( ( ph \/_ ps ) <-> ( ( ph /\ -. ps ) \/ ( -. ph /\ ps ) ) ) $=
    wph wps wxo wph wps wb wn wph wps wn wa wps wph wn wa wo wph wps wn wa wph
    wn wps wa wo wph wps df-xor wph wps xor wps wph wn wa wph wn wps wa wph wps
    wn wa wps wph wn ancom orbi2i 3bitri $.

  $( Two ways to express "exclusive or".  (Contributed by Mario Carneiro,
     4-Sep-2016.) $)
  xor2 $p |- ( ( ph \/_ ps ) <-> ( ( ph \/ ps ) /\ -. ( ph /\ ps ) ) ) $=
    wph wps wxo wph wps wb wn wph wps wo wph wps wa wn wa wph wps df-xor wph
    wps nbi2 bitri $.

  $( Exclusive disjunction implies disjunction ("XOR implies OR").
     (Contributed by BJ, 19-Apr-2019.) $)
  xoror $p |- ( ( ph \/_ ps ) -> ( ph \/ ps ) ) $=
    wph wps wxo wph wps wo wph wps wa wn wph wps xor2 simplbi $.

  $( Exclusive disjunction implies alternative denial ("XOR implies NAND").
     (Contributed by BJ, 19-Apr-2019.) $)
  xornan $p |- ( ( ph \/_ ps ) -> -. ( ph /\ ps ) ) $=
    wph wps wxo wph wps wo wph wps wa wn wph wps xor2 simprbi $.

  $( XOR implies NAND (written with the ` -/\ ` connector).  (Contributed by
     BJ, 19-Apr-2019.) $)
  xornan2 $p |- ( ( ph \/_ ps ) -> ( ph -/\ ps ) ) $=
    wph wps wxo wph wps wa wn wph wps wnan wph wps xornan wph wps df-nan sylibr
    $.

  $( The connector ` \/_ ` is negated under negation of one argument.
     (Contributed by Mario Carneiro, 4-Sep-2016.)  (Proof shortened by Wolf
     Lammen, 27-Jun-2020.) $)
  xorneg2 $p |- ( ( ph \/_ -. ps ) <-> -. ( ph \/_ ps ) ) $=
    wph wps wn wxo wph wps wn wb wn wph wps wb wph wps wxo wn wph wps wn df-xor
    wph wps pm5.18 wph wps xnor 3bitr2i $.

  $( The connector ` \/_ ` is negated under negation of one argument.
     (Contributed by Mario Carneiro, 4-Sep-2016.)  (Proof shortened by Wolf
     Lammen, 27-Jun-2020.) $)
  xorneg1 $p |- ( ( -. ph \/_ ps ) <-> -. ( ph \/_ ps ) ) $=
    wph wn wps wxo wps wph wn wxo wph wps wxo wn wph wn wps xorcom wps wph wn
    wxo wps wph wxo wph wps wxo wps wph xorneg2 wps wph xorcom xchbinx bitri $.

  $( The connector ` \/_ ` is unchanged under negation of both arguments.
     (Contributed by Mario Carneiro, 4-Sep-2016.) $)
  xorneg $p |- ( ( -. ph \/_ -. ps ) <-> ( ph \/_ ps ) ) $=
    wph wn wps wn wxo wph wps wn wxo wn wph wps wxo wph wps wn xorneg1 wph wps
    wn wxo wph wps wxo wph wps xorneg2 con2bii bitr4i $.

  ${
    xorbi12.1 $e |- ( ph <-> ps ) $.
    xorbi12.2 $e |- ( ch <-> th ) $.
    $( Equality property for exclusive disjunction.  (Contributed by Mario
       Carneiro, 4-Sep-2016.)  (Proof shortened by Wolf Lammen,
       21-Apr-2024.) $)
    xorbi12i $p |- ( ( ph \/_ ch ) <-> ( ps \/_ th ) ) $=
      wph wch wxo wps wth wb wn wps wth wxo wph wch wxo wph wch wb wps wth wb
      wph wch df-xor wph wps wch wth xorbi12.1 xorbi12.2 bibi12i xchbinx wps
      wth df-xor bitr4i $.
  $}

  ${
    xor12d.1 $e |- ( ph -> ( ps <-> ch ) ) $.
    xor12d.2 $e |- ( ph -> ( th <-> ta ) ) $.
    $( Equality property for exclusive disjunction.  (Contributed by Mario
       Carneiro, 4-Sep-2016.) $)
    xorbi12d $p |- ( ph -> ( ( ps \/_ th ) <-> ( ch \/_ ta ) ) ) $=
      wph wps wth wb wn wch wta wb wn wps wth wxo wch wta wxo wph wps wth wb
      wch wta wb wph wps wch wth wta xor12d.1 xor12d.2 bibi12d notbid wps wth
      df-xor wch wta df-xor 3bitr4g $.
  $}

  $( Conjunction distributes over exclusive-or.  In intuitionistic logic this
     assertion is also true, even though ~ xordi does not necessarily hold, in
     part because the usual definition of xor is subtly different in
     intuitionistic logic.  (Contributed by David A. Wheeler, 7-Oct-2018.) $)
  anxordi $p |- ( ( ph /\ ( ps \/_ ch ) ) <->
      ( ( ph /\ ps ) \/_ ( ph /\ ch ) ) ) $=
    wph wps wch wb wn wa wph wps wa wph wch wa wb wn wph wps wch wxo wa wph wps
    wa wph wch wa wxo wph wps wch xordi wps wch wxo wps wch wb wn wph wps wch
    df-xor anbi2i wph wps wa wph wch wa df-xor 3bitr4i $.

  $( Exclusive-or variant of the law of the excluded middle ( ~ exmid ).  This
     statement is ancient, going back to at least Stoic logic.  This statement
     does not necessarily hold in intuitionistic logic.  (Contributed by David
     A. Wheeler, 23-Feb-2019.) $)
  xorexmid $p |- ( ph \/_ -. ph ) $=
    wph wph wn wxo wph wph wn wb wn wph pm5.19 wph wph wn df-xor mpbir $.


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  Logical "nor"
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
$)

  $( Declare connective for joint denial ("nor"). $)
  $c -\/ $.  $( Overlined "vee" (read:  "nor") $)

  $( Extend wff definition to include joint denial ("nor"). $)
  wnor $a wff ( ph -\/ ps ) $.

  $( Define joint denial ("not-or" or "nor").  After we define the constant
     true ` T. ` ( ~ df-tru ) and the constant false ` F. ` ( ~ df-fal ), we
     will be able to prove these truth table values:
     ` ( ( T. -\/ T. ) <-> F. ) ` ( ~ trunortru ), ` ( ( T. -\/ F. ) <-> F. ) `
     ( ~ trunorfal ), ` ( ( F. -\/ T. ) <-> F. ) ` ( ~ falnortru ), and
     ` ( ( F. -\/ F. ) <-> T. ) ` ( ~ falnorfal ).  Contrast with ` /\ `
     ( ~ df-an ), ` \/ ` ( ~ df-or ), ` -> ` ( ~ wi ), ` -/\ ` ( ~ df-nan ),
     and ` \/_ ` ( ~ df-xor ).  (Contributed by Remi, 25-Oct-2023.) $)
  df-nor $a |- ( ( ph -\/ ps ) <-> -. ( ph \/ ps ) ) $.

  $( The connector ` -\/ ` is commutative.  (Contributed by Remi, 25-Oct-2023.)
     (Proof shortened by Wolf Lammen, 23-Apr-2024.) $)
  norcom $p |- ( ( ph -\/ ps ) <-> ( ps -\/ ph ) ) $=
    wph wps wnor wps wph wo wn wps wph wnor wph wps wnor wph wps wo wps wph wo
    wph wps df-nor wph wps orcom xchbinx wps wph df-nor bitr4i $.

  $( ` -. ` is expressible via ` -\/ ` .  (Contributed by Remi, 25-Oct-2023.)
     (Proof shortened by Wolf Lammen, 8-Dec-2023.) $)
  nornot $p |- ( -. ph <-> ( ph -\/ ph ) ) $=
    wph wph wnor wph wn wph wph wnor wph wph wo wph wph wph df-nor wph oridm
    xchbinx bicomi $.

  $( ` /\ ` is expressible via ` -\/ ` .  (Contributed by Remi, 26-Oct-2023.)
     (Proof shortened by Wolf Lammen, 8-Dec-2023.) $)
  noran $p |- ( ( ph /\ ps ) <-> ( ( ph -\/ ph ) -\/ ( ps -\/ ps ) ) ) $=
    wph wps wa wph wph wnor wps wps wnor wo wn wph wph wnor wps wps wnor wnor
    wph wps wa wph wn wps wn wo wph wph wnor wps wps wnor wo wph wps anor wph
    wn wph wph wnor wps wn wps wps wnor wph nornot wps nornot orbi12i xchbinx
    wph wph wnor wps wps wnor df-nor bitr4i $.

  $( ` \/ ` is expressible via ` -\/ ` .  (Contributed by Remi, 26-Oct-2023.)
     (Proof shortened by Wolf Lammen, 8-Dec-2023.) $)
  noror $p |- ( ( ph \/ ps ) <-> ( ( ph -\/ ps ) -\/ ( ph -\/ ps ) ) ) $=
    wph wps wo wph wps wnor wn wph wps wnor wph wps wnor wnor wph wps wnor wph
    wps wo wph wps df-nor con2bii wph wps wnor nornot bitri $.

  $( This lemma shows the equivalence of two expressions, used in ~ norass .
     (Contributed by Wolf Lammen, 18-Dec-2023.) $)
  norasslem1 $p |- ( ( ( ph \/ ps ) -> ch ) <-> ( ( ph -\/ ps ) \/ ch ) ) $=
    wph wps wo wch wi wph wps wo wn wch wo wph wps wnor wch wo wph wps wo wch
    imor wph wps wnor wph wps wo wn wch wph wps df-nor orbi1i bitr4i $.

  $( This lemma specializes ~ biimt suitably for the proof of ~ norass .
     (Contributed by Wolf Lammen, 18-Dec-2023.) $)
  norasslem2 $p |- ( ph -> ( ps <-> ( ( ph \/ ch ) -> ps ) ) ) $=
    wph wch wps wph wch wo wps wi wb wph wch wo wps biimt orcs $.

  $( This lemma specializes ~ biorf suitably for the proof of ~ norass .
     (Contributed by Wolf Lammen, 18-Dec-2023.) $)
  norasslem3 $p |- ( -. ph -> ( ( ps -> ch ) <-> ( ( ph \/ ps ) -> ch ) ) ) $=
    wph wn wps wph wps wo wch wph wps biorf imbi1d $.

  $( A characterization of when an expression involving joint denials
     associates.  This is identical to the case when alternative denial is
     associative, see ~ nanass .  Remark:  Like alternative denial, joint
     denial is also commutative, see ~ norcom .  (Contributed by RP,
     29-Oct-2023.)  (Proof shortened by Wolf Lammen, 17-Dec-2023.) $)
  norass $p |- ( ( ph <-> ch ) <->
                 ( ( ( ph -\/ ps ) -\/ ch ) <-> ( ph -\/ ( ps -\/ ch ) ) ) ) $=
    wph wps wnor wch wo wph wps wch wnor wo wb wph wps wnor wch wo wn wph wps
    wch wnor wo wn wb wph wch wb wph wps wnor wch wnor wph wps wch wnor wnor wb
    wph wps wnor wch wo wph wps wch wnor wo notbi wps wph wo wch wi wps wch wo
    wph wi wb wps wph wnor wch wo wps wch wnor wph wo wb wph wch wb wph wps
    wnor wch wo wph wps wch wnor wo wb wps wph wo wch wi wps wph wnor wch wo
    wps wch wo wph wi wps wch wnor wph wo wps wph wch norasslem1 wps wch wph
    norasslem1 bibi12i wps wph wch wb wps wph wo wch wi wps wch wo wph wi wb wb
    wph wch wb wch wph wb wps wps wph wo wch wi wps wch wo wph wi wb wph wch
    bicom wps wch wps wph wo wch wi wph wps wch wo wph wi wps wch wph
    norasslem2 wps wph wch norasslem2 bibi12d bitrid wph wch wb wph wch wi wch
    wph wi wb wps wn wps wph wo wch wi wps wch wo wph wi wb wph wch impimprbi
    wps wn wph wch wi wps wph wo wch wi wch wph wi wps wch wo wph wi wps wph
    wch norasslem3 wps wch wph norasslem3 bibi12d bitrid pm2.61i wph wps wnor
    wch wo wps wph wnor wch wo wph wps wch wnor wo wps wch wnor wph wo wph wps
    wnor wps wph wnor wch wph wps norcom orbi1i wph wps wch wnor orcom bibi12i
    3bitr4i wph wps wnor wch wnor wph wps wnor wch wo wn wph wps wch wnor wnor
    wph wps wch wnor wo wn wph wps wnor wch df-nor wph wps wch wnor df-nor
    bibi12i 3bitr4i $.


$(
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
  True and false constants
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
$)


