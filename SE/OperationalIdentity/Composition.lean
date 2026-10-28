/-
Copyright (c) 2026 Denise M. Case. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.OperationalIdentity.Licensed

set_option autoImplicit false

/-!
# Composition over Examined Surfaces

SE.OperationalIdentity.Composition

A single surface carries part of a system's identity treatment. The audit
examines a finite family of surfaces, and two records are treated the same by
the store when every examined surface treats them the same.

Store-level faithfulness is faithfulness of every examined surface, and a
divergence witness for any one surface is a witness for the store. The audit
can therefore proceed one surface at a time.

The family is the examined family, not the set of all implementation artifacts.
A use jointly controlled by two mechanisms and by neither alone is carried by a
joint surface (`Surface.joint`). A store that lists only the single mechanisms
omits it, and the equivalence below then says nothing about it.
-/

namespace SE.OperationalIdentity

open SE.Persistence

@[expose] public section

variable {R O : Type}

-- RR.DEFINES: OI.DEF.STORE_TREATMENT
/-- The store treats two records the same when every examined surface does. -/
def StoreTreatment (A : List (Surface R O)) (r s : R) : Prop :=
  ∀ d, d ∈ A → d.SameTreatment r s

-- RR.DEFINES: OI.THM.STORE_TREATMENT_EQUIVALENCE
/-- Store treatment is an equivalence relation. -/
theorem storeTreatment_equivalence (A : List (Surface R O)) :
    Equivalence (StoreTreatment A) :=
  ⟨fun _ d _ => (d.sameTreatment_equivalence).refl _,
    fun h d hd => (d.sameTreatment_equivalence).symm (h d hd),
    fun h₁ h₂ d hd => (d.sameTreatment_equivalence).trans (h₁ d hd) (h₂ d hd)⟩

-- RR.DEFINES: OI.THM.FAITHFUL_STORE_IFF
/-- Store-level faithfulness is faithfulness of every examined surface. -/
theorem faithful_store_iff (D : R → R → Prop) (A : List (Surface R O)) :
    Faithful D (StoreTreatment A) ↔ ∀ d, d ∈ A → Faithful D d.SameTreatment := by
  constructor
  · intro h d hd r s hD
    exact h r s hD d hd
  · intro h r s hD d hd
    exact h d hd r s hD

-- RR.DEFINES: OI.THM.EXISTS_WITNESS_STORE_IFF
/-- A divergence witness for the store is a divergence witness for some examined surface. -/
theorem exists_witness_store_iff (D : R → R → Prop) (A : List (Surface R O)) :
    (∃ r s, DivergenceWitness D (StoreTreatment A) r s) ↔
      ∃ d, d ∈ A ∧ ∃ r s, DivergenceWitness D d.SameTreatment r s := by
  rw [← not_faithful_iff_exists_witness, faithful_store_iff]
  constructor
  · intro h
    refine Classical.byContradiction fun hno => h ?_
    intro d hd
    refine Classical.byContradiction fun hn => hno ⟨d, hd, ?_⟩
    exact (not_faithful_iff_exists_witness _ _).1 hn
  · rintro ⟨d, hd, w⟩ h
    exact ((not_faithful_iff_exists_witness _ _).2 w) (h d hd)

-- RR.DEFINES: OI.THM.FAITHFUL_STORE_OF_LICENCE_IFF_STEPS
/--
A store is faithful to the identity a licence generates exactly when every
examined surface treats the endpoints of every licensed step the same.
-/
theorem faithful_ofLicence_store_iff_steps {T : Type} (L : Licence T R)
    (dyn : Dynamics T R) (A : List (Surface R O)) :
    Faithful (Declared.ofLicence L dyn).rel (StoreTreatment A) ↔
      ∀ d, d ∈ A → ∀ t x y, dyn.step t x y → L.licensed t x y → d.SameTreatment x y := by
  rw [faithful_store_iff]
  exact ⟨fun h d hd => (faithfulTo_ofLicence_iff_steps L dyn d).1 (h d hd),
    fun h d hd => (faithfulTo_ofLicence_iff_steps L dyn d).2 (h d hd)⟩

end

end SE.OperationalIdentity
