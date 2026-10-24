import SE.NeutralSubstrate
import IdentityRegimes.Profile.Admissibility

open SE.NeutralSubstrate

/-!
File: IdentityRegimes/Theorems.lean

Purpose:
Export-facing theorem statements for identity-regime theory.
-/

namespace IdentityRegimes

/-- A neutral substrate supports admissible regime application. -/
theorem regime_application_admissible_of_neutral
    (S : Ontology)
    (hS : Neutral S)
    (profile : RegimeProfile) :
    RegimeApplicationAdmissible S profile := by
  exact hS

end IdentityRegimes
