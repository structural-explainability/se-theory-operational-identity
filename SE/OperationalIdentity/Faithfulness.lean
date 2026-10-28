/-
Copyright (c) 2026 Denise M. Case. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.OperationalIdentity.Declared
public import SE.OperationalIdentity.Surface

set_option autoImplicit false

/-!
# Faithfulness and Divergence

SE.OperationalIdentity.Faithfulness

A surface is faithful to a declared relation when it never splits a declared
class: whatever the declaration treats as the same, the surface treats the same.
The surface may merge declared classes.

A divergence witness is a pair that the declaration merges and the surface
separates. A surface is faithful exactly when no witness exists.

A witness is relative to the supplied declaration and the audited surface. It
does not show that the declaration is wrong, and it does not show that the
referents differ. The asymmetry is deliberate. A surface that merges records the
declaration separates has said only that this mechanism does not distinguish
them. Another mechanism may.
-/

namespace SE.OperationalIdentity

@[expose] public section

variable {R O : Type}

-- RR.DEFINES: OI.DEF.FAITHFUL
/-- `O` never separates a pair that `D` relates: the declared relation is contained in the treatment relation. -/
def Faithful (D O : R → R → Prop) : Prop :=
  ∀ r s, D r s → O r s

-- RR.DEFINES: OI.DEF.DIVERGENCE_WITNESS
/-- A pair that `D` relates and `O` separates. -/
def DivergenceWitness (D O : R → R → Prop) (r s : R) : Prop :=
  D r s ∧ ¬ O r s

-- RR.DEFINES: OI.THM.FAITHFUL_IFF_NO_WITNESS
/-- Faithfulness holds exactly when no divergence witness exists. -/
theorem faithful_iff_not_exists_witness (D O : R → R → Prop) :
    Faithful D O ↔ ¬ ∃ r s, DivergenceWitness D O r s := by
  constructor
  · rintro h ⟨r, s, hd, hn⟩
    exact hn (h r s hd)
  · intro h r s hd
    exact Classical.byContradiction fun hn => h ⟨r, s, hd, hn⟩

/-- A divergence witness refutes faithfulness. -/
theorem DivergenceWitness.not_faithful {D O : R → R → Prop} {r s : R}
    (h : DivergenceWitness D O r s) : ¬ Faithful D O :=
  fun hf => h.2 (hf r s h.1)

/-- Faithfulness fails exactly when some divergence witness exists. -/
theorem not_faithful_iff_exists_witness (D O : R → R → Prop) :
    ¬ Faithful D O ↔ ∃ r s, DivergenceWitness D O r s := by
  rw [faithful_iff_not_exists_witness]
  exact Classical.not_not

-- RR.DEFINES: OI.DEF.FAITHFUL_TO
/-- A surface is faithful to a declared relation when the declaration is contained in the surface's treatment relation. -/
def Declared.FaithfulTo (decl : Declared R) (d : Surface R O) : Prop :=
  Faithful decl.rel d.SameTreatment

/-- A surface is faithful exactly when the declaration has no divergence witness against it. -/
theorem Declared.faithfulTo_iff_not_exists_witness (decl : Declared R) (d : Surface R O) :
    decl.FaithfulTo d ↔ ¬ ∃ r s, DivergenceWitness decl.rel d.SameTreatment r s :=
  faithful_iff_not_exists_witness decl.rel d.SameTreatment

-- RR.DEFINES: OI.THM.WITNESS_MECHANISM_NE
/-- Every divergence witness for a surface is a pair on which the mechanism's values differ. -/
theorem Declared.witness_mechanism_ne {decl : Declared R} {d : Surface R O} {r s : R}
    (h : DivergenceWitness decl.rel d.SameTreatment r s) :
    d.mechanism r ≠ d.mechanism s :=
  d.mechanism_ne_of_not_sameTreatment h.2

-- RR.DEFINES: OI.THM.FAITHFUL_TO_RECORD_SURFACE_IFF
/--
The record surface is faithful to a declaration exactly when the declaration
relates no two distinct records.

So without a registry constraint on mechanisms, every declaration that merges
any two distinct records is divergent against some surface that Lean admits.
That is why the audit's mechanism registry is a precondition of the method and
not an optional refinement.
-/
theorem Declared.faithfulTo_record_iff (decl : Declared R) :
    decl.FaithfulTo (Surface.record R) ↔ ∀ r s, decl.rel r s → r = s := by
  unfold Declared.FaithfulTo Faithful
  constructor
  · intro h r s hd
    exact (Surface.record_sameTreatment_iff r s).1 (h r s hd)
  · intro h r s hd
    exact (Surface.record_sameTreatment_iff r s).2 (h r s hd)

end

end SE.OperationalIdentity
