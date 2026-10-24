/-!
File: IdentityRegimes/Vocab/Basic.lean

Purpose:
Basic vocabulary for identity-regime theory.

This file may name the six canonical regimes but must not define
domain mappings, operational validation, or runtime behavior.
-/

namespace IdentityRegimes

/-- Canonical identity regimes. -/
inductive Regime where
  | OBL
  | NOR
  | OCC
  | CTX
  | REC
  | ENR
deriving DecidableEq, Repr

end IdentityRegimes
