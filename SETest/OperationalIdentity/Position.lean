/-
Copyright (c) 2026 Denise M. Case. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Denise M. Case
-/
module -- shake: keep-all

import SE.OperationalIdentity

/-!
# Examples: Position Relative to a Supplied Alternative

SETest.OperationalIdentity.Position

Two finite examples over small carriers.

In the first, local alignment holds and substitution fails. The treatment
relation splits the declared class exactly as the alternative does, but it merges
two records the declaration separates and the alternative also separates. So
alignment does not imply substitution.

In the second, the treatment relation splits the declared class strictly more
finely than the alternative does, which is the sub-sibling position.

The alternatives here are supplied relations. No inventory of regimes is assumed.
-/

namespace SETest.OperationalIdentity.Position

open SE.OperationalIdentity

/-- Equal keys. -/
def sameKey (f : Fin 4 → Nat) (r s : Fin 4) : Prop := f r = f s

/-- Declared classes: `{0, 1, 2}` and `{3}`. -/
def keyD (r : Fin 4) : Nat := if r.val < 3 then 0 else 1

/-- Treatment classes: `{0, 1}` and `{2, 3}`. -/
def keyO (r : Fin 4) : Nat := if r.val < 2 then 0 else 1

/-- Alternative classes: `{0, 1}`, `{2}`, and `{3}`. -/
def keyS (r : Fin 4) : Nat := if r.val < 2 then 0 else r.val

theorem aligned_example : Aligned (sameKey keyD) (sameKey keyO) (sameKey keyS) := by
  unfold Aligned RelSame Restrict sameKey keyD keyO keyS
  decide

theorem not_substitution_example : ¬ Substitution (sameKey keyO) (sameKey keyS) := by
  unfold Substitution sameKey keyO keyS
  decide

theorem not_faithful_example : ¬ Faithful (sameKey keyD) (sameKey keyO) := by
  unfold Faithful sameKey keyD keyO
  decide

theorem alternative_splits_example : ¬ Faithful (sameKey keyD) (sameKey keyS) := by
  unfold Faithful sameKey keyD keyS
  decide

/-- Local alignment does not imply substitution. -/
theorem aligned_not_substitution :
    Aligned (sameKey keyD) (sameKey keyO) (sameKey keyS) ∧
      ¬ Substitution (sameKey keyO) (sameKey keyS) :=
  ⟨aligned_example, not_substitution_example⟩

/-- Everything related at one declared class, nothing declared elsewhere. -/
def declaredAll (_ _ : Fin 3) : Prop := True

/-- Treatment separates every record. -/
def treatmentDiscrete (r s : Fin 3) : Prop := r = s

/-- The alternative separates the last record only. -/
def alternativeLast (r s : Fin 3) : Prop := r.val < 2 ↔ s.val < 2

theorem subSibling_example :
    SubSibling declaredAll treatmentDiscrete alternativeLast := by
  unfold SubSibling RelStrictlyBelow RelLE Restrict declaredAll treatmentDiscrete alternativeLast
  decide

/-- In that example the alternative also separates the declared class, so the comparison is meaningful. -/
theorem subSibling_alternative_splits : ¬ Faithful declaredAll alternativeLast := by
  unfold Faithful declaredAll alternativeLast
  decide

end SETest.OperationalIdentity.Position
