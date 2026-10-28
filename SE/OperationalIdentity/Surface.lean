/-
Copyright (c) 2026 Denise M. Case. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

set_option autoImplicit false

/-!
# Surfaces and Treatment

SE.OperationalIdentity.Surface

An implementation mechanism, the identity-relevant uses found for it, and the
treatment relation those uses induce.

A surface has a mechanism, a value function on the records, and a finite list
of identified uses. Each use gives a record an outcome. The treatment signature
of a record is the list of its outcomes, and two records are treated the same by
the surface exactly when their signatures are equal.

Surface control says that each use depends on a record only through the
mechanism value. It is an admissibility condition on how the surface was
identified. Whether the listed uses are all the identity-relevant uses of the
mechanism is a disclosure claim that this module does not discharge.

Outcomes are one type `O`. A finer vocabulary of typed outcomes can be encoded
as a sum type without changing anything here.

Equality of treatment is not identity of the represented referents.
-/

namespace SE.OperationalIdentity

@[expose] public section

variable {R O : Type}

-- RR.DEFINES: OI.TYPE.SURFACE
/--
A surface over records `R` with outcomes `O`: a mechanism, the uses identified
for it, and the surface-control condition that each use factors through the
mechanism value.
-/
structure Surface (R O : Type) where
  /-- The values the mechanism takes. -/
  Value : Type
  /-- The mechanism's value for each record. -/
  mechanism : R → Value
  /-- The identity-relevant uses identified for the mechanism. -/
  uses : List (R → O)
  /-- Surface control: records with equal mechanism values get equal outcomes from every use. -/
  controlled : ∀ u, u ∈ uses → ∀ r s, mechanism r = mechanism s → u r = u s

-- RR.DEFINES: OI.DEF.SIGNATURE
/-- The identity-treatment signature of a record: its outcome under each identified use. -/
def Surface.signature (d : Surface R O) (r : R) : List O :=
  d.uses.map (fun u => u r)

-- RR.DEFINES: OI.DEF.SAME_TREATMENT
/-- The surface gives two records the same identity-relevant treatment. -/
def Surface.SameTreatment (d : Surface R O) (r s : R) : Prop :=
  d.signature r = d.signature s

-- RR.DEFINES: OI.THM.SIGNATURE_EQ_IFF
/-- Two signatures are equal exactly when every use gives the two records the same outcome. -/
theorem signature_map_eq_iff (l : List (R → O)) (r s : R) :
    l.map (fun u => u r) = l.map (fun u => u s) ↔ ∀ u, u ∈ l → u r = u s := by
  induction l with
  | nil => simp
  | cons u l ih => simp [ih]

/-- Equal treatment is agreement of every identified use. -/
theorem Surface.sameTreatment_iff (d : Surface R O) (r s : R) :
    d.SameTreatment r s ↔ ∀ u, u ∈ d.uses → u r = u s :=
  signature_map_eq_iff d.uses r s

-- RR.DEFINES: OI.THM.SAME_TREATMENT_EQUIVALENCE
/-- Equal treatment is an equivalence relation. -/
theorem Surface.sameTreatment_equivalence (d : Surface R O) :
    Equivalence d.SameTreatment :=
  ⟨fun _ => rfl, fun h => h.symm, fun h₁ h₂ => h₁.trans h₂⟩

-- RR.DEFINES: OI.THM.SAME_TREATMENT_OF_MECHANISM_EQ
/-- Surface control: records with equal mechanism values are treated the same. -/
theorem Surface.sameTreatment_of_mechanism_eq (d : Surface R O) {r s : R}
    (h : d.mechanism r = d.mechanism s) : d.SameTreatment r s :=
  (d.sameTreatment_iff r s).2 fun u hu => d.controlled u hu r s h

-- RR.DEFINES: OI.THM.MECHANISM_NE_OF_NOT_SAME_TREATMENT
/-- A difference in treatment is carried by a difference in mechanism value. -/
theorem Surface.mechanism_ne_of_not_sameTreatment (d : Surface R O) {r s : R}
    (h : ¬ d.SameTreatment r s) : d.mechanism r ≠ d.mechanism s :=
  fun hm => h (d.sameTreatment_of_mechanism_eq hm)

/-- Treatment is decidable when outcomes have decidable equality. -/
instance Surface.decidableSameTreatment [DecidableEq O] (d : Surface R O) :
    DecidableRel d.SameTreatment :=
  fun r s => inferInstanceAs (Decidable (d.signature r = d.signature s))

-- RR.DEFINES: OI.DEF.RECORD_SURFACE
/--
The record surface: the mechanism is the record itself, and the one use returns
it. It treats two records the same exactly when they are equal.

It satisfies surface control, so Lean admits it. It is not an implementation
artifact. The requirement that a mechanism be drawn from a disclosed registry is
what excludes it, and that requirement is a disclosure claim, not a Lean
condition.
-/
def Surface.record (R : Type) : Surface R R where
  Value := R
  mechanism r := r
  uses := [fun r => r]
  controlled u hu _ _ h := by
    simp at hu
    subst hu
    exact h

-- RR.DEFINES: OI.THM.RECORD_SURFACE_SAME_TREATMENT_IFF
/-- The record surface treats two records the same exactly when they are equal. -/
theorem Surface.record_sameTreatment_iff (r s : R) :
    (Surface.record R).SameTreatment r s ↔ r = s := by
  rw [Surface.sameTreatment_iff]
  simp [Surface.record]

-- RR.DEFINES: OI.DEF.JOINT
/--
The joint surface of two surfaces: the pair of their mechanisms, with the uses
of both. Its control holds because equal pairs have equal components.
-/
def Surface.joint (d₁ d₂ : Surface R O) : Surface R O where
  Value := d₁.Value × d₂.Value
  mechanism r := (d₁.mechanism r, d₂.mechanism r)
  uses := d₁.uses ++ d₂.uses
  controlled u hu r s h := by
    rcases List.mem_append.1 hu with hu | hu
    · exact d₁.controlled u hu r s (congrArg Prod.fst h)
    · exact d₂.controlled u hu r s (congrArg Prod.snd h)

-- RR.DEFINES: OI.THM.JOINT_SAME_TREATMENT_IFF
/-- A joint surface treats two records the same exactly when both surfaces do. -/
theorem Surface.joint_sameTreatment_iff (d₁ d₂ : Surface R O) (r s : R) :
    (d₁.joint d₂).SameTreatment r s ↔ d₁.SameTreatment r s ∧ d₂.SameTreatment r s := by
  rw [Surface.sameTreatment_iff, Surface.sameTreatment_iff, Surface.sameTreatment_iff]
  simp only [Surface.joint]
  constructor
  · intro h
    exact ⟨fun u hu => h u (List.mem_append.2 (Or.inl hu)),
      fun u hu => h u (List.mem_append.2 (Or.inr hu))⟩
  · rintro ⟨h₁, h₂⟩ u hu
    rcases List.mem_append.1 hu with hu | hu
    · exact h₁ u hu
    · exact h₂ u hu

end

end SE.OperationalIdentity
