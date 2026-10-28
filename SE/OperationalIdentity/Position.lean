/-
Copyright (c) 2026 Denise M. Case. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.OperationalIdentity.Faithfulness

set_option autoImplicit false

/-!
# Position Relative to a Supplied Alternative

SE.OperationalIdentity.Position

Given a declared relation `D`, a treatment relation `O`, and an independently
supplied alternative relation `S`, this module locates the divergence of `O`
from `D` relative to `S`, inside the declared classes.

Both `O` and `S` are restricted to the pairs `D` relates. The restricted relations
are compared by containment, and exactly one of four positions holds: aligned,
sub-sibling, super-sibling, or incomparable.

The comparison is local. It says nothing about pairs the declaration separates.
Local alignment with `S` therefore does not say that `O` and `S` agree
everywhere. That stronger condition is `Substitution`. Substitution implies local
alignment, but alignment does not imply substitution.

Nothing here fixes what `S` is. The alternative is a supplied relation, and any
claim that it is a sibling of the declared one in some inventory belongs to
whoever supplies it. No inventory of regimes is assumed.
-/

namespace SE.OperationalIdentity

@[expose] public section

variable {R : Type}

-- RR.DEFINES: OI.DEF.RESTRICT
/-- A relation restricted to the pairs a declared relation relates. -/
def Restrict (D O : R → R → Prop) : R → R → Prop :=
  fun r s => D r s ∧ O r s

/-- One relation is contained in another. -/
def RelLE (A B : R → R → Prop) : Prop :=
  ∀ r s, A r s → B r s

/-- Two relations have the same pairs. -/
def RelSame (A B : R → R → Prop) : Prop :=
  ∀ r s, A r s ↔ B r s

/-- `A` is strictly contained in `B`. -/
def RelStrictlyBelow (A B : R → R → Prop) : Prop :=
  RelLE A B ∧ ¬ RelLE B A

/-- Neither relation is contained in the other. -/
def RelIncomparable (A B : R → R → Prop) : Prop :=
  ¬ RelLE A B ∧ ¬ RelLE B A

-- RR.DEFINES: OI.THM.REL_POSITION_EXACTLY_ONE
/-- Exactly one of four positions holds for two relations under containment. -/
theorem relPosition_exactlyOne (A B : R → R → Prop) :
    (RelSame A B ∨ RelStrictlyBelow A B ∨ RelStrictlyBelow B A ∨ RelIncomparable A B) ∧
    ¬ (RelSame A B ∧ RelStrictlyBelow A B) ∧
    ¬ (RelSame A B ∧ RelStrictlyBelow B A) ∧
    ¬ (RelSame A B ∧ RelIncomparable A B) ∧
    ¬ (RelStrictlyBelow A B ∧ RelStrictlyBelow B A) ∧
    ¬ (RelStrictlyBelow A B ∧ RelIncomparable A B) ∧
    ¬ (RelStrictlyBelow B A ∧ RelIncomparable A B) := by
  have hsame : RelSame A B ↔ RelLE A B ∧ RelLE B A :=
    ⟨fun h => ⟨fun r s hr => (h r s).1 hr, fun r s hr => (h r s).2 hr⟩,
      fun h r s => ⟨h.1 r s, h.2 r s⟩⟩
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · by_cases h1 : RelLE A B <;> by_cases h2 : RelLE B A
    · exact Or.inl (hsame.2 ⟨h1, h2⟩)
    · exact Or.inr (Or.inl ⟨h1, h2⟩)
    · exact Or.inr (Or.inr (Or.inl ⟨h2, h1⟩))
    · exact Or.inr (Or.inr (Or.inr ⟨h1, h2⟩))
  · rintro ⟨h, _, h2⟩
    exact h2 (hsame.1 h).2
  · rintro ⟨h, _, h2⟩
    exact h2 (hsame.1 h).1
  · rintro ⟨h, h1, _⟩
    exact h1 (hsame.1 h).1
  · rintro ⟨⟨_, h1⟩, ⟨h2, _⟩⟩
    exact h1 h2
  · rintro ⟨⟨h1, _⟩, ⟨h2, _⟩⟩
    exact h2 h1
  · rintro ⟨⟨h1, _⟩, ⟨_, h3⟩⟩
    exact h3 h1

-- RR.DEFINES: OI.DEF.ALIGNED
/-- Inside the declared classes, `O` splits exactly as `S` does. -/
def Aligned (D O S : R → R → Prop) : Prop :=
  RelSame (Restrict D O) (Restrict D S)

-- RR.DEFINES: OI.DEF.SUB_SIBLING
/-- Inside the declared classes, `O` splits strictly more finely than `S`. -/
def SubSibling (D O S : R → R → Prop) : Prop :=
  RelStrictlyBelow (Restrict D O) (Restrict D S)

-- RR.DEFINES: OI.DEF.SUPER_SIBLING
/-- Inside the declared classes, `O` makes some but not all of the distinctions `S` makes. -/
def SuperSibling (D O S : R → R → Prop) : Prop :=
  RelStrictlyBelow (Restrict D S) (Restrict D O)

-- RR.DEFINES: OI.DEF.SIBLING_INCOMPARABLE
/-- Inside the declared classes, `O` and `S` each make a distinction the other lacks. -/
def SiblingIncomparable (D O S : R → R → Prop) : Prop :=
  RelIncomparable (Restrict D O) (Restrict D S)

-- RR.DEFINES: OI.THM.POSITION_EXACTLY_ONE
/-- The four positions of `O` relative to `S` inside the declared classes are exhaustive and mutually exclusive. -/
theorem position_exactlyOne (D O S : R → R → Prop) :
    (Aligned D O S ∨ SubSibling D O S ∨ SuperSibling D O S ∨ SiblingIncomparable D O S) ∧
    ¬ (Aligned D O S ∧ SubSibling D O S) ∧
    ¬ (Aligned D O S ∧ SuperSibling D O S) ∧
    ¬ (Aligned D O S ∧ SiblingIncomparable D O S) ∧
    ¬ (SubSibling D O S ∧ SuperSibling D O S) ∧
    ¬ (SubSibling D O S ∧ SiblingIncomparable D O S) ∧
    ¬ (SuperSibling D O S ∧ SiblingIncomparable D O S) :=
  relPosition_exactlyOne (Restrict D O) (Restrict D S)

-- RR.DEFINES: OI.DEF.SUBSTITUTION
/-- The treatment relation equals the supplied alternative everywhere. -/
def Substitution (O S : R → R → Prop) : Prop :=
  ∀ r s, O r s ↔ S r s

-- RR.DEFINES: OI.THM.SUBSTITUTION_ALIGNED
/-- Substitution implies local alignment. -/
theorem Substitution.aligned {D O S : R → R → Prop} (h : Substitution O S) :
    Aligned D O S :=
  fun r s => ⟨fun ⟨hd, ho⟩ => ⟨hd, (h r s).1 ho⟩, fun ⟨hd, hs⟩ => ⟨hd, (h r s).2 hs⟩⟩

-- RR.DEFINES: OI.THM.SUBSTITUTION_WITNESS
/--
If the alternative also fails to be faithful to the declaration, substitution
gives a divergence witness: the treatment relation separates a declared pair.
-/
theorem Substitution.exists_witness {D O S : R → R → Prop} (h : Substitution O S)
    (hs : ¬ Faithful D S) : ∃ r s, DivergenceWitness D O r s := by
  obtain ⟨r, s, hd, hn⟩ := (not_faithful_iff_exists_witness D S).1 hs
  exact ⟨r, s, hd, fun ho => hn ((h r s).1 ho)⟩

end

end SE.OperationalIdentity
