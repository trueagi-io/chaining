# Metamath port to MeTTa

Initial attempt to port some of [Metamath](https://us.metamath.org) to
MeTTa and the backward chainer.  For now only propositional logic
axioms are imported with the first three theorems proved/verified.

## Propositional Calculus Corpus

### Metamath format

The file [propositional-calculus.mm](propositional-calculus.mm)
contains 1517 theorems and uncompressed proofs about propositional
calculus obtained from `set.mm` as follows

1. Download [metamath](https://us.metamath.org/downloads/metamath.tar.bz2).
2. Unpack `metamath.tar.bz2`
   ```
   tar xvf metamath.tar.bz2
   ```
3. Open `metamath/set.mm` in your favorite text editor.
4. Delete everything from
   ```
   $(
   -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
     Universal quantifier for use by df-tru
   -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
   ```
   to keep only the propositional calculus part.
5. Additionally delete
   ```
   $( Begin $[ set-main.mm $] $)
   $( Begin $[ set-pred.mm $] $)
   ```
   at lines 308 and 309.
6. Save the result into a new file named `propositional-calculus.mm`.
7. Compile metamath
   ```bash
   cd metamath
   ./build.sh
   ```
8. Unpack all proofs (make sure `propositional-calculus.mm` is under the same folder as the metamath executable)
   ```bash
   ./metamath "read 'propositional-calculus.mm'" "save proof * / normal" "write source 'propositional-calculus.mm'" "exit"
   ```

### Conversion to MeTTa format

The file [propositional-calculus.mm](propositional-calculus.mm) has
been converted to
[propositional-calculus.metta](propositional-calculus.metta) using
[mm2metta](https://github.com/ngeiswei/mm2metta).
