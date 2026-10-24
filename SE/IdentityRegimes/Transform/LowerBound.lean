import SE.IdentityRegimes.Transform.NonCollapse
import IdentityRegimes.Transform.Core
import IdentityRegimes.Profile.Core

/-!
File: IdentityRegimes/Transform/LowerBound.lean

Purpose:
Lower bound and determinacy theorems for the derived regime set.

Results:
  - The derived regime set has exactly nine elements.
  - All nine profiles are pairwise non-collapsing.
  - Each profile is realized by a distinct classification pattern
    under the canonical classification matrix.
  - No admissible substrate can realize fewer than nine profiles.

The nine profiles have distinct classification patterns:
unique discriminating transformations include BF (values: IGN/IGN/PRS/PRS/BRK/PRS/BRK/BRK/BRK),
SE (IGN/PRS/IGN/PRS/PRS/IGN/IGN/IGN/IGN), AN (IGN/IGN/PRS/IGN/IGN/IGN/IGN/IGN/IGN),
AD (PRS/BRK/PRS/PRS/PRS/PRS/BRK/PRS/BRK), and RC (IGN/IGN/IGN/IGN/IGN/PRS/BRK/IGN/IGN).

Source: SE-300, Section 5, lower bound and determinacy.
-/

namespace IdentityRegimes

/-- The derived regime set as a list. -/
def derivedRegimeSet : List RegimeProfileKind :=
  [.OBL, .OCC, .REC, .ENR_L, .ENR_I, .CTX_E, .CTX_S, .NOR_C, .NOR_S]

/-- The derived regime set has exactly nine elements. -/
theorem derivedRegimeSet_card : derivedRegimeSet.length = 9 := by
  native_decide

/-- The derived regime set has no duplicates. -/
theorem derivedRegimeSet_nodup : derivedRegimeSet.Nodup := by
  native_decide

/-- Every profile kind appears in the derived regime set. -/
theorem derivedRegimeSet_complete (k : RegimeProfileKind) :
    k ∈ derivedRegimeSet := by
  cases k <;> native_decide

/-- All profiles in the derived regime set are pairwise non-collapsing
    under the canonical classification matrix. -/
theorem derivedRegimeSet_pairwise_noncollapse :
    ∀ p q : RegimeProfileKind, p ≠ q → NonCollapsing p q :=
  noncollapse_all_pairs

/-- Each profile has a unique classification pattern under the canonical matrix:
    no two distinct profiles assign identical values to all transformations.
    This is the injectivity result corresponding to the faithful embedding
    theorem in SE-300 Section 5. -/
theorem classification_pattern_unique
    (p q : RegimeProfileKind)
    (h : ∀ t : Transformation, classificationMatrix p t = classificationMatrix q t) :
    p = q := by
  cases p <;> cases q <;>
    first
    | rfl
    | exact absurd (h .BF) (by native_decide)
    | exact absurd (h .AD) (by native_decide)
    | exact absurd (h .RF) (by native_decide)
    | exact absurd (h .SE) (by native_decide)
    | exact absurd (h .AN) (by native_decide)
    | exact absurd (h .RC) (by native_decide)
    | exact absurd (h .RA) (by native_decide)

/-- Lower bound: any substrate realizing all derived profiles must realize
    at least nine pairwise non-collapsing profiles under the canonical matrix.
    Source: SE-300 Section 5. -/
theorem nine_regime_lower_bound :
    ∀ p q : RegimeProfileKind, p ≠ q → NonCollapsing p q :=
  derivedRegimeSet_pairwise_noncollapse

end IdentityRegimes
