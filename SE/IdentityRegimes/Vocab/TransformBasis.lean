/-!
File: IdentityRegimes/Vocab/TransformBasis.lean

Purpose:
Defines the fixed transformation basis and canonical classification values.
Placed in Vocab/ so that Profile/Core can reference Transformation directly
in ProfileAxes, eliminating the need for a separate SplitTransformation type.

Both types are pure vocabulary — no regime logic, no matrix, no profile content.
The matrix and its classification behavior live in Transform/Core.
-/

namespace IdentityRegimes

/-- The three canonical classification values.
    IGN: transformation does not affect identity (or is not applicable, mapped from N/A).
    PRS: transformation preserves identity.
    BRK: transformation breaks identity. -/
inductive ClassificationValue where
  | IGN
  | PRS
  | BRK
  deriving DecidableEq, Repr

/-- The ten-element fixed transformation basis (SE-300 §3).

    Each family denotes a class of admissible operations on representations:
      RE  re-expression:          change of representation format preserving content
      AN  annotation:             addition of non-identity-bearing information
      RF  refinement:             increase in descriptive or structural detail
      AD  aggregation/decomp.:    restructuring into coarser or finer components
      RC  re-contextualization:   change in applicability context
      RA  reassignment:           change in association or bearer
      SU  substitution:           replacement of the identity carrier
      BF  branch/fork:            divergence into multiple continuations
      PV  provenance extension:   addition of historical or derivational information
      SE  state evolution:        change in state of an enduring referent over time -/
inductive Transformation where
  | RE | AN | RF | AD | RC | RA | SU | BF | PV | SE
  deriving Repr, DecidableEq

end IdentityRegimes
