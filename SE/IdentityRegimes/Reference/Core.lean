import SE.IdentityRegimes.Transform.LowerBound

/-!
File: IdentityRegimes/Reference/Core.lean

Purpose:
Lean-side certification that the canonical reference sets are complete,
duplicate-free, and aligned with the derived theory.

ClassificationValue is defined in Transform/Core and available here
transitively via Transform/LowerBound.

TOML sources:
  regime-classification-values.toml  → referenceClassificationValues
  regime-families.toml               → RegimeFamily / referenceFamilies
  regime-profiles.toml               → referenceProfiles
  regime-profile-derivation.toml     → profilesForFamily / derivedProfilesFromFamilies
  regime-transformations.toml        → referenceTransformations

Note on ordering:
  regime-families.toml orders families as OBL NOR OCC CTX REC ENR.
  regime-profiles.toml orders profiles by its own `order` field (OBL OCC REC ENR_L …).
  These orderings differ; cross-list theorems assert membership equivalence, not list equality.
-/

namespace IdentityRegimes

/- === Classification Values (regime-classification-values.toml) === -/

-- ClassificationValue is defined in Transform/Core.
-- referenceClassificationValues certifies the canonical three-value set.
def referenceClassificationValues : List ClassificationValue :=
  [.IGN, .PRS, .BRK]

theorem referenceClassificationValues_card :
    referenceClassificationValues.length = 3 := by
  native_decide

theorem referenceClassificationValues_nodup :
    List.Nodup referenceClassificationValues := by
  native_decide

theorem referenceClassificationValues_complete
    (v : ClassificationValue) :
    v ∈ referenceClassificationValues := by
  cases v <;> native_decide

/- === Regime Families (regime-families.toml) === -/

inductive RegimeFamily
  | OBL
  | NOR
  | OCC
  | CTX
  | REC
  | ENR
  deriving DecidableEq, Repr

-- Order matches declaration order in regime-families.toml.
def referenceFamilies : List RegimeFamily :=
  [.OBL, .NOR, .OCC, .CTX, .REC, .ENR]

theorem referenceFamilies_card :
    referenceFamilies.length = 6 := by
  native_decide

theorem referenceFamilies_nodup :
    List.Nodup referenceFamilies := by
  native_decide

theorem referenceFamilies_complete
    (f : RegimeFamily) :
    f ∈ referenceFamilies := by
  cases f <;> native_decide

/- === Regime Profiles (regime-profiles.toml) === -/

-- Order matches the `order` field in regime-profiles.toml:
-- OBL(1) OCC(2) REC(3) ENR_L(4) ENR_I(5) CTX_E(6) CTX_S(7) NOR_C(8) NOR_S(9)
def referenceProfiles : List RegimeProfileKind :=
  [.OBL, .OCC, .REC, .ENR_L, .ENR_I, .CTX_E, .CTX_S, .NOR_C, .NOR_S]

theorem referenceProfiles_card :
    referenceProfiles.length = 9 := by
  native_decide

theorem referenceProfiles_nodup :
    List.Nodup referenceProfiles := by
  native_decide

theorem referenceProfiles_complete
    (p : RegimeProfileKind) :
    p ∈ referenceProfiles := by
  cases p <;> native_decide

-- Membership-based alignment with derived theory (ordering differs from derivedRegimeSet).
theorem referenceProfiles_match_derived
    (p : RegimeProfileKind) :
    p ∈ referenceProfiles ↔ p ∈ derivedRegimeSet := by
  cases p <;> native_decide

/- === Profile Derivation (regime-profile-derivation.toml) === -/

-- Mirrors the `profiles` arrays in regime-profile-derivation.toml exactly.
-- split = false: OBL, OCC, REC
-- split = true:  ENR → [ENR_L, ENR_I], CTX → [CTX_E, CTX_S], NOR → [NOR_C, NOR_S]
def profilesForFamily : RegimeFamily → List RegimeProfileKind
  | .OBL => [.OBL]
  | .NOR => [.NOR_C, .NOR_S]
  | .OCC => [.OCC]
  | .CTX => [.CTX_E, .CTX_S]
  | .REC => [.REC]
  | .ENR => [.ENR_L, .ENR_I]

-- flatMap over referenceFamilies (family-declaration order).
-- Produces: OBL, NOR_C, NOR_S, OCC, CTX_E, CTX_S, REC, ENR_L, ENR_I
def derivedProfilesFromFamilies : List RegimeProfileKind :=
  referenceFamilies.flatMap profilesForFamily

theorem derivedProfilesFromFamilies_card :
    derivedProfilesFromFamilies.length = 9 := by
  native_decide

theorem derivedProfilesFromFamilies_nodup :
    List.Nodup derivedProfilesFromFamilies := by
  native_decide

theorem derivedProfilesFromFamilies_complete
    (p : RegimeProfileKind) :
    p ∈ derivedProfilesFromFamilies := by
  cases p <;> native_decide

-- Membership-based alignment with referenceProfiles.
theorem derivedProfilesFromFamilies_match_reference
    (p : RegimeProfileKind) :
    p ∈ derivedProfilesFromFamilies ↔ p ∈ referenceProfiles := by
  cases p <;> native_decide

-- Membership-based alignment with the derived theory set.
theorem derivedProfilesFromFamilies_match_derived
    (p : RegimeProfileKind) :
    p ∈ derivedProfilesFromFamilies ↔ p ∈ derivedRegimeSet := by
  cases p <;> native_decide

-- Exactly 3 families split (ENR, CTX, NOR) and 3 do not (OBL, OCC, REC).
theorem profilesForFamily_split_count :
    (referenceFamilies.filter (fun f => (profilesForFamily f).length > 1)).length = 3 := by
  native_decide

-- Every unsplit family produces exactly one profile.
theorem profilesForFamily_nosplit_singleton
    (f : RegimeFamily)
    (h : (profilesForFamily f).length = 1) :
    ∃ p, profilesForFamily f = [p] := by
  cases f <;> simp_all [profilesForFamily]

/- === Transformations (regime-transformations.toml) === -/

-- Order matches `order` field in regime-transformations.toml (1 .. 10).
def referenceTransformations : List Transformation :=
  [.RE, .AN, .RF, .AD, .RC, .RA, .SU, .BF, .SE, .PV]

theorem referenceTransformations_card :
    referenceTransformations.length = 10 := by
  native_decide

theorem referenceTransformations_nodup :
    List.Nodup referenceTransformations := by
  native_decide

theorem referenceTransformations_complete
    (t : Transformation) :
    t ∈ referenceTransformations := by
  cases t <;> native_decide

end IdentityRegimes
