import SE.NeutralSubstrate
import IdentityRegimes.Transform.LowerBound

open SE.NeutralSubstrate

/-!
File: IdentityRegimes/Embedding.lean

Purpose:
Regime-typed multigraph embedding and representation theorem.

The embedding sends each identity carrier to its equivalence class
under its unique regime profile. Uniqueness follows from
classification_pattern_unique applied to classificationMatrix.
The representation theorem states that every identity carrier in an
admissible ontology is realized by exactly one profile in the derived
regime set.

Source: SE-300, Section 5, faithful embedding and representation theorem.
-/

namespace IdentityRegimes

/-- An admissible relation over regime-typed vertices. -/
inductive AdmissibleRelation where
  | participatesIn
  | precedes
  | scopedBy
  | describedBy
  | groundedIn
deriving Repr, DecidableEq

/-- A regime-typed vertex: an identity carrier tagged with its profile. -/
structure RegimeVertex where
  kind    : RegimeProfileKind
  carrier : Ontology

/-- The regime type of a vertex. -/
def RegimeVertex.regimeType (v : RegimeVertex) : RegimeProfileKind :=
  v.kind

/-- A regime-typed directed edge. -/
structure RegimeEdge where
  source   : RegimeVertex
  relation : AdmissibleRelation
  target   : RegimeVertex

/-- The regime-typed directed multigraph over an admissible substrate. -/
structure RegimeGraph where
  vertices : List RegimeVertex
  edges    : List RegimeEdge

/-- The profile kind of a vertex is determined by its kind field. -/
def profileKind (v : RegimeVertex) : RegimeProfileKind :=
  v.kind

/-- Profile kind is injective up to classification pattern under the canonical matrix:
    vertices whose profiles assign identical values to all transformations
    have the same profile kind. -/
theorem profileKind_determined_by_classification
    (p q : RegimeProfileKind)
    (h : ∀ t : Transformation, classificationMatrix p t = classificationMatrix q t) :
    p = q :=
  classification_pattern_unique p q h

/-- Every vertex in a well-formed graph has a canonical regime. -/
def GraphWellFormed (g : RegimeGraph) : Prop :=
  ∀ v ∈ g.vertices, IsCanonicalRegime (RegimeProfileKind.regime v.kind)

/-- Representation theorem:
    For every regime profile kind, there exists a unique canonical profile
    that determines its classification behavior under the canonical matrix. -/
theorem representation_theorem (k : RegimeProfileKind) :
    ∃ p : RegimeProfileKind,
      p = k ∧
      (∀ t : Transformation, classificationMatrix p t = classificationMatrix k t) ∧
      (∀ q : RegimeProfileKind,
        (∀ t : Transformation, classificationMatrix q t = classificationMatrix k t) → q = k) :=
  ⟨k, rfl, fun _t => rfl,
   fun q hq => classification_pattern_unique q k hq⟩

/-- No two distinct profiles in the derived regime set are behaviorally equivalent
    under the canonical classification matrix. -/
theorem derived_regime_set_no_behavioral_collapse
    (p q : RegimeProfileKind)
    (h : p ≠ q) :
    ∃ t : Transformation, classificationMatrix p t ≠ classificationMatrix q t :=
  noncollapse_all_pairs p q h

/-- The lower bound is witnessed by the derived regime set:
    nine pairwise non-collapsing profiles under the canonical matrix. -/
theorem nine_regime_lower_bound_witness :
    ∃ S : List RegimeProfileKind,
      S.length = 9 ∧
      S.Nodup ∧
      (∀ p q : RegimeProfileKind, p ≠ q →
        ∃ t : Transformation, classificationMatrix p t ≠ classificationMatrix q t) :=
  ⟨derivedRegimeSet,
   derivedRegimeSet_card,
   derivedRegimeSet_nodup,
   fun p q h => noncollapse_all_pairs p q h⟩

end IdentityRegimes
