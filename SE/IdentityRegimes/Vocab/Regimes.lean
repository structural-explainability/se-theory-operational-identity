import SE.IdentityRegimes.Vocab.Basic

/-!
File: IdentityRegimes/Vocab/Regimes.lean

Purpose:
Canonical regime declarations and regime-level predicates.
-/

namespace IdentityRegimes

/-- Predicate marking a regime as canonical. -/
def IsCanonicalRegime (_r : Regime) : Prop :=
  True

/-- Every declared regime is canonical. -/
theorem all_regimes_canonical (r : Regime) : IsCanonicalRegime r := by
  trivial

end IdentityRegimes
