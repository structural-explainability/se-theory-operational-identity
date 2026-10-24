import SE.NeutralSubstrate
import IdentityRegimes.Profile.Core

open SE.NeutralSubstrate

/-!
File: IdentityRegimes/Profile/Admissibility.lean

Purpose:
Admissibility of regime application over neutral substrates.

This file depends on the neutral substrate but does not redefine it.
-/

namespace IdentityRegimes

/-- A regime may be applied only over an admissible neutral substrate. -/
def RegimeApplicationAdmissible
    (S : Ontology)
    (_profile : RegimeProfile) : Prop :=
  Neutral S

end IdentityRegimes
