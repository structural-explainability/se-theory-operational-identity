import SE.IdentityRegimes.Theorems

/-!
File: test/TestExport.lean

Purpose:
Test that the main definitions and theorems are visible from the surface.

Must be listed in lakefile.toml to be run as part of CI.

Run with  `lake build TestExport`.
-/

#check IdentityRegimes.Regime
#check IdentityRegimes.RegimeProfile
#check IdentityRegimes.Requirement
#check IdentityRegimes.IsCanonicalRegime
#check IdentityRegimes.ProfileWellFormed
#check IdentityRegimes.RequirementSatisfied
#check IdentityRegimes.RegimeApplicationAdmissible
#check IdentityRegimes.all_regimes_canonical
#check IdentityRegimes.regime_application_admissible_of_neutral
