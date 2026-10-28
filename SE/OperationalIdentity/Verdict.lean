/-
Copyright (c) 2026 Denise M. Case. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.OperationalIdentity.Finite

set_option autoImplicit false

/-!
# Audit Verdict

SE.OperationalIdentity.Verdict

An audit has three outcomes.

- `pass`: the assumptions the audit needs are established, and faithfulness holds.
- `fail`: those assumptions are established, and a divergence witness exists.
- `indeterminate`: the assumptions are not established, so no conclusion is justified.

Whether the assumptions are established is an input, `warranted`. The
mathematics decides faithfulness once that input is given. It does not decide
the input, which concerns the declared relation, the examined domain, the
mechanisms, and their identified uses, and which no Lean build can establish.
An indeterminate verdict is not a pass.

Faithfulness to a generated relation is anti-monotone in the generating pairs
(`faithful_generated_anti_mono`). A passing verdict can therefore be lost when
the generating pairs grow, with the surface and the examined records unchanged,
and a verdict is relative to the declaration it was computed against.
-/

namespace SE.OperationalIdentity

@[expose] public section

variable {R : Type}

-- RR.DEFINES: OI.TYPE.VERDICT
/-- The three audit outcomes. -/
inductive Verdict where
  /-- Assumptions established and faithfulness holds. -/
  | pass
  /-- Assumptions established and a divergence witness exists. -/
  | fail
  /-- The assumptions are not established, so no conclusion is justified. -/
  | indeterminate
  deriving DecidableEq, Repr

-- RR.DEFINES: OI.DEF.AUDIT
/--
The verdict for a declared relation `D` and treatment relation `O` on an
enumerated domain, given whether the audit's assumptions are established.
-/
def audit (warranted : Bool) (dom : List R) (D O : R → R → Prop)
    [DecidableRel D] [DecidableRel O] : Verdict :=
  if warranted = true then
    if faithfulCheck dom D O = true then Verdict.pass else Verdict.fail
  else Verdict.indeterminate

-- RR.DEFINES: OI.THM.AUDIT_EQ_PASS_IFF
/-- A pass is exactly established assumptions together with faithfulness. -/
theorem audit_eq_pass_iff (warranted : Bool) (dom : List R) (D O : R → R → Prop)
    [DecidableRel D] [DecidableRel O] (hdom : ∀ r, r ∈ dom) :
    audit warranted dom D O = Verdict.pass ↔ warranted = true ∧ Faithful D O := by
  unfold audit
  cases warranted with
  | false => simp
  | true =>
    by_cases hf : faithfulCheck dom D O = true
    · have hfa := (faithfulCheck_eq_true_iff dom D O hdom).1 hf
      simp [hf, hfa]
    · have hnfa : ¬ Faithful D O :=
        fun hfa => hf ((faithfulCheck_eq_true_iff dom D O hdom).2 hfa)
      simp [hf, hnfa]

-- RR.DEFINES: OI.THM.AUDIT_EQ_FAIL_IFF
/-- A fail is exactly established assumptions together with a divergence witness. -/
theorem audit_eq_fail_iff (warranted : Bool) (dom : List R) (D O : R → R → Prop)
    [DecidableRel D] [DecidableRel O] (hdom : ∀ r, r ∈ dom) :
    audit warranted dom D O = Verdict.fail ↔
      warranted = true ∧ ∃ r s, DivergenceWitness D O r s := by
  unfold audit
  cases warranted with
  | false => simp
  | true =>
    by_cases hf : faithfulCheck dom D O = true
    · have hfa := (faithfulCheck_eq_true_iff dom D O hdom).1 hf
      have hno := (faithful_iff_not_exists_witness D O).1 hfa
      simp [hf, hno]
    · have hnfa : ¬ Faithful D O :=
        fun hfa => hf ((faithfulCheck_eq_true_iff dom D O hdom).2 hfa)
      have hex := (not_faithful_iff_exists_witness D O).1 hnfa
      simp [hf, hex]

-- RR.DEFINES: OI.THM.AUDIT_EQ_INDETERMINATE_IFF
/-- An indeterminate verdict is exactly unestablished assumptions. -/
theorem audit_eq_indeterminate_iff (warranted : Bool) (dom : List R) (D O : R → R → Prop)
    [DecidableRel D] [DecidableRel O] :
    audit warranted dom D O = Verdict.indeterminate ↔ warranted = false := by
  unfold audit
  cases warranted
  · simp
  · by_cases hf : faithfulCheck dom D O = true <;> simp [hf]

-- RR.DEFINES: OI.THM.INDETERMINATE_NE_PASS
/-- Unestablished assumptions never give a pass. -/
theorem audit_ne_pass_of_not_warranted (dom : List R) (D O : R → R → Prop)
    [DecidableRel D] [DecidableRel O] :
    audit false dom D O ≠ Verdict.pass := by
  simp [audit]

end

end SE.OperationalIdentity
