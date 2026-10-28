/-
Copyright (c) 2026 Denise M. Case. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Denise M. Case
-/
module

public import SE.OperationalIdentity.Faithfulness

set_option autoImplicit false

/-!
# Finite Faithfulness Check

SE.OperationalIdentity.Finite

On a finite examined domain, given as a list that enumerates every record,
faithfulness and divergence witnesses are decidable by enumerating pairs.

`faithfulCheck` decides faithfulness, and `findWitness` returns a divergence
witness when one exists. Both need the two relations to be decidable. The list
must contain every record of the carrier; a list that omits records
decides faithfulness only on the records it lists, and the theorems below require
completeness explicitly.

That the examined domain is the domain the system actually uses is a disclosure
claim. The theorems say what the enumeration decides, not that it is the right
enumeration.
-/

namespace SE.OperationalIdentity

@[expose] public section

variable {R : Type}

-- RR.DEFINES: OI.DEF.FAITHFUL_CHECK
/-- Check faithfulness of `O` to `D` on every pair of an enumerated domain. -/
def faithfulCheck (dom : List R) (D O : R → R → Prop) [DecidableRel D] [DecidableRel O] :
    Bool :=
  dom.all fun r => dom.all fun s => !(decide (D r s)) || decide (O r s)

-- RR.DEFINES: OI.THM.FAITHFUL_CHECK_EQ_TRUE_IFF
/-- On a complete enumeration, the check succeeds exactly when `O` is faithful to `D`. -/
theorem faithfulCheck_eq_true_iff (dom : List R) (D O : R → R → Prop)
    [DecidableRel D] [DecidableRel O] (hdom : ∀ r, r ∈ dom) :
    faithfulCheck dom D O = true ↔ Faithful D O := by
  unfold faithfulCheck Faithful
  simp only [List.all_eq_true, Bool.or_eq_true, Bool.not_eq_true', decide_eq_false_iff_not,
    decide_eq_true_eq]
  constructor
  · intro h r s hd
    rcases h r (hdom r) s (hdom s) with hn | ho
    · exact absurd hd hn
    · exact ho
  · intro h r _ s _
    by_cases hd : D r s
    · exact Or.inr (h r s hd)
    · exact Or.inl hd

-- RR.DEFINES: OI.DEF.FIND_WITNESS
/-- Search the enumerated pairs for a divergence witness. -/
def findWitness (dom : List R) (D O : R → R → Prop) [DecidableRel D] [DecidableRel O] :
    Option (R × R) :=
  (dom.flatMap fun r => dom.map fun s => (r, s)).find? fun p =>
    decide (D p.1 p.2 ∧ ¬ O p.1 p.2)

/-- A pair returned by the search is a divergence witness. -/
theorem findWitness_sound (dom : List R) (D O : R → R → Prop)
    [DecidableRel D] [DecidableRel O] {p : R × R}
    (h : findWitness dom D O = some p) : DivergenceWitness D O p.1 p.2 := by
  have h' := List.find?_some h
  simp only [decide_eq_true_eq] at h'
  exact h'

-- RR.DEFINES: OI.THM.FIND_WITNESS_EQ_NONE_IFF
/-- On a complete enumeration, the search finds nothing exactly when `O` is faithful to `D`. -/
theorem findWitness_eq_none_iff (dom : List R) (D O : R → R → Prop)
    [DecidableRel D] [DecidableRel O] (hdom : ∀ r, r ∈ dom) :
    findWitness dom D O = none ↔ Faithful D O := by
  unfold findWitness
  rw [List.find?_eq_none]
  constructor
  · intro h r s hd
    have hmem : (r, s) ∈ dom.flatMap fun r => dom.map fun s => (r, s) := by
      simp only [List.mem_flatMap, List.mem_map]
      exact ⟨r, hdom r, s, hdom s, rfl⟩
    have h' := h (r, s) hmem
    simp at h'
    exact h' hd
  · intro h p hp
    simp only [List.mem_flatMap, List.mem_map] at hp
    obtain ⟨r, _, s, _, rfl⟩ := hp
    simp
    exact fun hd => h r s hd

end

end SE.OperationalIdentity
