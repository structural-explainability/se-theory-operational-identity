import SE.NeutralSubstrate
import IdentityRegimes.Vocab.Requirements
import IdentityRegimes.Vocab.TransformBasis

open SE.NeutralSubstrate

/-!
File: IdentityRegimes/Profile/Core.lean

Purpose:
Regime-profile structure derived from canonical regime requirements.

The nine derived regime profiles refine the six canonical regimes.
They do not replace them.

OBL, OCC, REC carry no split pressure.
ENR refines into ENR_L / ENR_I under Transformation.BF (branching).
CTX refines into CTX_E / CTX_S under Transformation.AD (decomposition).
NOR refines into NOR_C / NOR_S under Transformation.RF (refinement).

ProfileAxes.splitTransformation uses Option Transformation directly:
  none       — profile has no split pressure (OBL, OCC, REC)
  some .BF   — ENR split forced by branching
  some .AD   — CTX split forced by decomposition
  some .RF   — NOR split forced by refinement

This eliminates the need for a separate SplitTransformation type and
makes the connection to the forcing transformation explicit in the type.
The non-collapse proofs in Transform/NonCollapse.lean verify the
connection at the matrix level:
  noncollapse_ENR_L_ENR_I : classificationMatrix ENR_L .BF ≠ classificationMatrix ENR_I .BF
  noncollapse_CTX_E_CTX_S : classificationMatrix CTX_E .AD ≠ classificationMatrix CTX_S .AD
  noncollapse_NOR_C_NOR_S : classificationMatrix NOR_C .RF ≠ classificationMatrix NOR_S .RF
-/

namespace IdentityRegimes

/-- The nine derived regime profiles. -/
inductive RegimeProfileKind where
  | OBL
  | OCC
  | REC
  | ENR_L
  | ENR_I
  | CTX_E
  | CTX_S
  | NOR_C
  | NOR_S
deriving Repr, DecidableEq

/-- Map each profile back to its parent canonical regime. -/
def RegimeProfileKind.regime : RegimeProfileKind → Regime
  | .OBL   => Regime.OBL
  | .OCC   => Regime.OCC
  | .REC   => Regime.REC
  | .ENR_L => Regime.ENR
  | .ENR_I => Regime.ENR
  | .CTX_E => Regime.CTX
  | .CTX_S => Regime.CTX
  | .NOR_C => Regime.NOR
  | .NOR_S => Regime.NOR

/-- The six identity basis kinds.
    Each derived profile is assigned a canonical identity basis
    that determines what must persist for identity to be preserved. -/
inductive IdentityBasis where
  | single     -- singular referential continuity (OBL, OCC, REC)
  | content    -- normative content (NOR-C)
  | structure  -- structural organization (CTX-S, NOR-S)
  | extension  -- applicability extension (CTX-E)
  | locus      -- locus persistence (ENR-L)
  | instrument -- artifact persistence (ENR-I)
deriving DecidableEq, Repr

/-- The canonical axes of a regime profile.
    splitTransformation is the Transformation that forces the parent regime
    to split, or none if the profile is not under split pressure.
    Using Option Transformation directly connects the split-pressure concept
    to the transformation basis without a redundant type. -/
structure ProfileAxes where
  identityBasis       : IdentityBasis
  splitTransformation : Option Transformation

/-- Canonical axes for each derived profile.
    Profiles from the same split share a splitTransformation value
    but differ in identityBasis. -/
def RegimeProfileKind.axes : RegimeProfileKind → ProfileAxes
  | .OBL   => { identityBasis := .single,     splitTransformation := none        }
  | .OCC   => { identityBasis := .single,     splitTransformation := none        }
  | .REC   => { identityBasis := .single,     splitTransformation := none        }
  | .ENR_L => { identityBasis := .locus,      splitTransformation := some .BF   }
  | .ENR_I => { identityBasis := .instrument, splitTransformation := some .BF   }
  | .CTX_E => { identityBasis := .extension,  splitTransformation := some .AD   }
  | .CTX_S => { identityBasis := .structure,  splitTransformation := some .AD   }
  | .NOR_C => { identityBasis := .content,    splitTransformation := some .RF   }
  | .NOR_S => { identityBasis := .structure,  splitTransformation := some .RF   }

/-- A profile is under split pressure when its parent regime was forced to split
    by a specific transformation family.
    The forcing transformation is recorded in axes.splitTransformation. -/
def UnderSplitPressure (axes : ProfileAxes) : Prop :=
  axes.splitTransformation.isSome

instance (axes : ProfileAxes) : Decidable (UnderSplitPressure axes) :=
  inferInstanceAs (Decidable (axes.splitTransformation.isSome))

/-- OBL, OCC, REC are not under split pressure. -/
theorem no_split_OBL : ¬UnderSplitPressure (RegimeProfileKind.axes .OBL) := by decide
theorem no_split_OCC : ¬UnderSplitPressure (RegimeProfileKind.axes .OCC) := by decide
theorem no_split_REC : ¬UnderSplitPressure (RegimeProfileKind.axes .REC) := by decide

/-- The six refined profiles are under split pressure. -/
theorem split_ENR_L : UnderSplitPressure (RegimeProfileKind.axes .ENR_L) := by decide
theorem split_ENR_I : UnderSplitPressure (RegimeProfileKind.axes .ENR_I) := by decide
theorem split_CTX_E : UnderSplitPressure (RegimeProfileKind.axes .CTX_E) := by decide
theorem split_CTX_S : UnderSplitPressure (RegimeProfileKind.axes .CTX_S) := by decide
theorem split_NOR_C : UnderSplitPressure (RegimeProfileKind.axes .NOR_C) := by decide
theorem split_NOR_S : UnderSplitPressure (RegimeProfileKind.axes .NOR_S) := by decide

/-- Split pressure holds iff the parent regime is ENR, CTX, or NOR. -/
theorem splitPressure_iff_refined_regime (k : RegimeProfileKind) :
    UnderSplitPressure k.axes ↔
    k.regime = Regime.ENR ∨ k.regime = Regime.CTX ∨ k.regime = Regime.NOR := by
  cases k <;> simp [UnderSplitPressure, RegimeProfileKind.axes, RegimeProfileKind.regime]

/-- The regime map is not injective: distinct profiles can share a parent regime. -/
theorem regime_map_not_injective :
    ∃ p q : RegimeProfileKind, p ≠ q ∧ p.regime = q.regime :=
  ⟨.ENR_L, .ENR_I, by decide, by decide⟩

/-- Profiles without split pressure have distinct parent regimes. -/
theorem no_split_regime_injective (p q : RegimeProfileKind)
    (hp : ¬UnderSplitPressure p.axes)
    (hq : ¬UnderSplitPressure q.axes)
    (h  : p.regime = q.regime) : p = q := by
  cases p <;> cases q <;>
    simp_all [UnderSplitPressure, RegimeProfileKind.axes, RegimeProfileKind.regime]

/-- Every profile kind maps to a canonical regime. -/
theorem all_profiles_canonical (k : RegimeProfileKind) :
    IsCanonicalRegime k.regime :=
  all_regimes_canonical k.regime

/-- A regime profile is identified by its derived kind. -/
structure RegimeProfile where
  kind : RegimeProfileKind

/-- The canonical axes for a profile. -/
def RegimeProfile.axes (profile : RegimeProfile) : ProfileAxes :=
  profile.kind.axes

/-- A profile is well formed when its parent regime is canonical. -/
def ProfileWellFormed (profile : RegimeProfile) : Prop :=
  IsCanonicalRegime profile.kind.regime

end IdentityRegimes
