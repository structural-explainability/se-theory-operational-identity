import SE.NeutralSubstrate
import IdentityRegimes.Profile.Core

open SE.NeutralSubstrate

/-!
File: IdentityRegimes/Transform/Core.lean

Purpose:
The canonical 9 × 10 classification matrix.

Transformation and ClassificationValue are defined in Vocab/TransformBasis.lean.
This file contains only the nine profile row functions and the matrix that
delegates to them.

Each row is a named private function (Transformation → ClassificationValue)
so that each profile's classification behavior is independently readable
and auditable. classificationMatrix delegates to these rows.

NA→IGN CONVENTION
N/A entries from the paper are mapped to IGN: "not applicable" is
semantically equivalent to "identity question does not arise" (IGN).
This mapping avoids introducing a fourth value while preserving the
induced equivalence relations that determine non-collapse.

Affected cells:
  OCC.RA = IGN  (N/A: time-indexed occurrences admit no bearer reassignment)
  OCC.BF = IGN  (N/A: time-indexed occurrences admit no forking)
  ENR-L.RA = IGN  (N/A: reassignment not applicable to locus-bound referents)
  ENR-I.RA = IGN  (N/A: reassignment not applicable to instrument-bound referents)
  CTX-E.SE = IGN  (N/A: normative structures do not undergo state evolution)
  CTX-S.SE = IGN  (N/A: normative structures do not undergo state evolution)
  NOR-C.SE = IGN  (N/A: normative structures do not undergo state evolution)
  NOR-S.SE = IGN  (N/A: normative structures do not undergo state evolution)

Verified counts: PRS=22, BRK=20, IGN=48, total=90.

Source: SE-300, Section 4 canonical classification tables and
        Sections 5.1-5.3 regime refinement definitions.
-/

namespace IdentityRegimes

-- ============================================================
-- PROFILE ROWS
-- Each row is a named function: Transformation → ClassificationValue.
-- Column order: RE  AN  RF  AD  RC  RA  SU  BF  PV  SE
-- ============================================================

/-- OBL: Obligation-bearing entity.
    Identity constituted by persistence as a responsible party.
    BF=IGN: obligation persists independently of representation forking.
    SE=IGN: identity not individuated by internal state transitions. -/
private def oblRow : Transformation → ClassificationValue
  | .RE => .IGN | .AN => .IGN | .RF => .PRS
  | .AD => .PRS | .RC => .IGN | .RA => .IGN
  | .SU => .BRK | .BF => .IGN | .PV => .IGN
  | .SE => .IGN

/-- OCC: Time-indexed occurrence.
    Identity constituted by temporal realization and provenance.
    AD=BRK: decomposition produces sub-occurrences with distinct temporal individuation.
    SE=PRS: an occurrence may have stages that constitute the same event.
    RA=IGN, BF=IGN: N/A→IGN; occurrence is fixed by its realization event. -/
private def occRow : Transformation → ClassificationValue
  | .RE => .IGN | .AN => .IGN | .RF => .PRS
  | .AD => .BRK | .RC => .IGN | .RA => .IGN  -- RA: N/A→IGN
  | .SU => .BRK | .BF => .IGN | .PV => .IGN  -- BF: N/A→IGN
  | .SE => .PRS

/-- REC: Descriptive record.
    Identity constituted by persistence as a descriptive referent.
    AN=PRS: a descriptive record survives annotation and enrichment.
    BF=PRS: a descriptive record persists across copying and forking.
    PV=PRS: provenance-tracking bridges the identity break in recovery
            (resolved: operative mechanism, not passive metadata). -/
private def recRow : Transformation → ClassificationValue
  | .RE => .IGN | .AN => .PRS | .RF => .PRS
  | .AD => .PRS | .RC => .IGN | .RA => .IGN
  | .SU => .BRK | .BF => .PRS | .PV => .PRS
  | .SE => .IGN

/-- ENR-L: Enduring non-normative referent, locus-bound.
    Identity constituted by persistence of the same locus.
    BF=PRS: locus persists through branching (split-forcing transformation for ENR).
    SE=PRS: state evolution preserves locus-bound referent identity.
    RA=IGN: N/A→IGN. -/
private def enrLRow : Transformation → ClassificationValue
  | .RE => .IGN | .AN => .IGN | .RF => .PRS
  | .AD => .PRS | .RC => .IGN | .RA => .IGN  -- RA: N/A→IGN
  | .SU => .BRK | .BF => .PRS | .PV => .IGN
  | .SE => .PRS

/-- ENR-I: Enduring non-normative referent, instrument-bound.
    Identity constituted by persistence of the same artifact.
    BF=BRK: branching produces distinct artifact continuations (split-forcing transformation for ENR).
    SE=PRS: state evolution preserves instrument-bound referent identity.
    RA=IGN: N/A→IGN. -/
private def enrIRow : Transformation → ClassificationValue
  | .RE => .IGN | .AN => .IGN | .RF => .PRS
  | .AD => .PRS | .RC => .IGN | .RA => .IGN  -- RA: N/A→IGN
  | .SU => .BRK | .BF => .BRK | .PV => .IGN
  | .SE => .PRS

/-- CTX-E: Applicability context, extension-sensitive.
    Identity constituted by persistence of the same applicability extension.
    AD=PRS, BF=PRS: extension preserved under decomposition and forking.
    RC=PRS: re-contextualization preserves applicability extension by definition.
    SE=IGN: N/A→IGN; normative structures do not undergo state evolution. -/
private def ctxERow : Transformation → ClassificationValue
  | .RE => .IGN | .AN => .IGN | .RF => .PRS
  | .AD => .PRS | .RC => .PRS | .RA => .IGN
  | .SU => .BRK | .BF => .PRS | .PV => .IGN
  | .SE => .IGN  -- SE: N/A→IGN

/-- CTX-S: Applicability context, structure-sensitive.
    Identity constituted by persistence of the same structure.
    RF=BRK, AD=BRK, RC=BRK, RA=BRK, BF=BRK: all alter applicability structure.
    SE=IGN: N/A→IGN; normative structures do not undergo state evolution. -/
private def ctxSRow : Transformation → ClassificationValue
  | .RE => .IGN | .AN => .IGN | .RF => .BRK
  | .AD => .BRK | .RC => .BRK | .RA => .BRK
  | .SU => .BRK | .BF => .BRK | .PV => .IGN
  | .SE => .IGN  -- SE: N/A→IGN

/-- NOR-C: Normative structure, composition-sensitive (content-preserving).
    Identity constituted by persistence of the same normative content.
    RF=PRS, AD=PRS: refinement and decomposition preserve normative content.
    BF=BRK: branching breaks normative structure identity.
    SE=IGN: N/A→IGN; normative structures do not undergo state evolution. -/
private def norCRow : Transformation → ClassificationValue
  | .RE => .IGN | .AN => .IGN | .RF => .PRS
  | .AD => .PRS | .RC => .IGN | .RA => .IGN
  | .SU => .BRK | .BF => .BRK | .PV => .IGN
  | .SE => .IGN  -- SE: N/A→IGN

/-- NOR-S: Normative structure, substitution-sensitive (structural).
    Identity constituted by persistence of the same structure.
    RF=BRK, AD=BRK: refinement and decomposition alter structural organization.
    BF=BRK: branching breaks normative structure identity.
    SE=IGN: N/A→IGN; normative structures do not undergo state evolution. -/
private def norSRow : Transformation → ClassificationValue
  | .RE => .IGN | .AN => .IGN | .RF => .BRK
  | .AD => .BRK | .RC => .IGN | .RA => .IGN
  | .SU => .BRK | .BF => .BRK | .PV => .IGN
  | .SE => .IGN  -- SE: N/A→IGN

-- ============================================================
-- CANONICAL MATRIX
-- Delegates to named row functions.
-- Source: SE-300 Section 4 canonical classification tables.
-- ============================================================

/-- The canonical 9 × 10 classification matrix.
    Each profile delegates to its named row function.
    Verified counts: PRS=22, BRK=20, IGN=48, total=90. -/
def classificationMatrix : RegimeProfileKind → Transformation → ClassificationValue
  | .OBL,   t => oblRow  t
  | .OCC,   t => occRow  t
  | .REC,   t => recRow  t
  | .ENR_L, t => enrLRow t
  | .ENR_I, t => enrIRow t
  | .CTX_E, t => ctxERow t
  | .CTX_S, t => ctxSRow t
  | .NOR_C, t => norCRow t
  | .NOR_S, t => norSRow t

end IdentityRegimes
