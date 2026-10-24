-- test/TestImport.lean
import NeutralSubstrate
open SE.NeutralSubstrate

/-!
File: test/TestImport.lean

Purpose:
Test import of NeutralSubstrate.

Must be listed in lakefile.toml to be run as part of CI.

Run with  `lake build TestImport`.
-/

-- See the main theorem?
#check @ontological_neutrality_theorem

-- Construct an ontology?
#check @Neutral

-- Use the surface?
example : Neutral [] := by
  apply neutral_if_only_neutral; rfl
