import SE.NeutralSubstrate
import IdentityRegimes.Vocab.Regimes

open SE.NeutralSubstrate

/-!
File: IdentityRegimes/Vocab/Requirements.lean

Purpose:
Requirement structure for applying identity regimes over an admissible substrate.
-/

namespace IdentityRegimes

/-- A requirement associated with applying a regime. -/
structure Requirement where
  regime : Regime

/-- Predicate asserting that a requirement is satisfied over a substrate. -/
def RequirementSatisfied
    (_S : Ontology)
    (_req : Requirement) : Prop :=
  True

end IdentityRegimes
