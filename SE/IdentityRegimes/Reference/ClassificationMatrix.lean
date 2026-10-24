import SE.NeutralSubstrate
import IdentityRegimes.Reference.Core

open SE.NeutralSubstrate

/-!
File: IdentityRegimes/Reference/ClassificationMatrix.lean

Purpose:
Lean-side certification of the 9 × 10 canonical classification matrix
defined in Transform/Core.lean.

The canonical matrix is derived from the regime profile definitions in
SE-300 Sections 4 and 5. N/A entries are mapped to IGN.

Verified structural properties:
  - Totality:         defined for all 90 pairs (by construction)
  - Universal columns: RE → IGN, SU → BRK for every profile
  - Value coverage:   all three values IGN/PRS/BRK appear in the matrix
  - Cell counts:      PRS=22, BRK=20, IGN=48, total=90

The canonical cell values are defined in Transform/Core.classificationMatrix.
This file certifies properties of that definition; it does not redefine it.

Status: Cell values are verified against SE-300 paper definitions.
        The REC × PV cell (resolved as PRS) is the only previously disputed cell.
-/

namespace IdentityRegimes

/- === Universal Column Constraints === -/

/-- RE → IGN for every profile: re-expression changes format but does not
    affect identity. The identity carrier persists across representation changes. -/
theorem matrix_RE_always_IGN
    (p : RegimeProfileKind) :
    classificationMatrix p .RE = .IGN := by
  cases p <;> native_decide

/-- SU → BRK for every profile: substitution replaces the identity carrier entirely. -/
theorem matrix_SU_always_BRK
    (p : RegimeProfileKind) :
    classificationMatrix p .SU = .BRK := by
  cases p <;> native_decide

/- === Value Coverage === -/

theorem matrix_IGN_nonempty :
    ∃ p t, classificationMatrix p t = .IGN :=
  ⟨.OBL, .RE, by native_decide⟩

theorem matrix_PRS_nonempty :
    ∃ p t, classificationMatrix p t = .PRS :=
  ⟨.OBL, .RF, by native_decide⟩

theorem matrix_BRK_nonempty :
    ∃ p t, classificationMatrix p t = .BRK :=
  ⟨.OBL, .SU, by native_decide⟩

/- === Cell Count Certification === -/

def allCells : List (RegimeProfileKind × Transformation) :=
  referenceProfiles.flatMap (fun p =>
    referenceTransformations.map (fun t => (p, t)))

theorem allCells_card : allCells.length = 90 := by
  native_decide

def countValue (v : ClassificationValue) : Nat :=
  (allCells.filter (fun ⟨p, t⟩ => classificationMatrix p t == v)).length

/-- Total cell count is exactly 90. -/
theorem matrix_counts :
    countValue .PRS + countValue .BRK + countValue .IGN = 90 := by
  native_decide

/-- PRS count: 22 cells. -/
theorem matrix_PRS_count : countValue .PRS = 22 := by native_decide

/-- BRK count: 20 cells. -/
theorem matrix_BRK_count : countValue .BRK = 20 := by native_decide

/-- IGN count: 48 cells (includes all N/A→IGN mappings). -/
theorem matrix_IGN_count : countValue .IGN = 48 := by native_decide

/- === Split-Pair Witnesses === -/

/-- ENR split: BF classifies differently between ENR-L (PRS) and ENR-I (BRK). -/
theorem matrix_enr_split_on_BF :
    classificationMatrix .ENR_L .BF = .PRS ∧
    classificationMatrix .ENR_I .BF = .BRK := by
  constructor <;> native_decide

/-- CTX split: AD classifies differently between CTX-E (PRS) and CTX-S (BRK). -/
theorem matrix_ctx_split_on_AD :
    classificationMatrix .CTX_E .AD = .PRS ∧
    classificationMatrix .CTX_S .AD = .BRK := by
  constructor <;> native_decide

/-- NOR split: RF classifies differently between NOR-C (PRS) and NOR-S (BRK). -/
theorem matrix_nor_split_on_RF :
    classificationMatrix .NOR_C .RF = .PRS ∧
    classificationMatrix .NOR_S .RF = .BRK := by
  constructor <;> native_decide

end IdentityRegimes
