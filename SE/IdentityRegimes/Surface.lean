import SE.IdentityRegimes.Vocab.Basic
import IdentityRegimes.Vocab.Regimes
import IdentityRegimes.Vocab.Requirements
import IdentityRegimes.Profile.Core
import IdentityRegimes.Profile.Admissibility
import IdentityRegimes.Transform.Core
import IdentityRegimes.Transform.NonCollapse
import IdentityRegimes.Transform.LowerBound
import IdentityRegimes.Reference.Core
import IdentityRegimes.Reference.ClassificationMatrix
import IdentityRegimes.Embedding
import IdentityRegimes.Theorems
import IdentityRegimes.Witness

/-!
# Identity Regimes Surface

Curated public surface for downstream Structural Explainability regime users.

Downstream users should write:

```lean
import IdentityRegimes
open IdentityRegimes
```

This file is the public boundary. Internal files may be reorganized without
changing downstream code, provided the names exported here remain stable.

Dependency layers:
  Vocab/Basic               — Regime
  Vocab/Regimes             — IsCanonicalRegime, all_regimes_canonical
  Vocab/Requirements        — Requirement, RequirementSatisfied
  Profile/Core              — RegimeProfileKind, IdentityBasis, SplitTransformation,
                              ProfileAxes, UnderSplitPressure, RegimeProfile,
                              ProfileWellFormed
  Profile/Admissibility     — RegimeApplicationAdmissible
  Transform/Core            — ClassificationValue, Transformation, classificationMatrix
  Transform/NonCollapse     — NonCollapsing
  Transform/LowerBound      — derivedRegimeSet, lower-bound theorems
  Reference/Core            — RegimeFamily, reference lists
  Reference/ClassificationMatrix — matrix certification theorems
  Embedding                 — RegimeVertex, RegimeGraph, representation_theorem
  Theorems                  — regime_application_admissible_of_neutral
  Witness                   — oblProfile
-/

-- ============================================================
-- TYPES
-- ============================================================

export IdentityRegimes (Regime)
export IdentityRegimes (RegimeProfile)
export IdentityRegimes (RegimeProfileKind)
export IdentityRegimes (Requirement)
export IdentityRegimes (Transformation)
export IdentityRegimes (ClassificationValue)
export IdentityRegimes (IdentityBasis)
export IdentityRegimes (ProfileAxes)
export IdentityRegimes (RegimeFamily)
export IdentityRegimes (RegimeVertex)
export IdentityRegimes (RegimeEdge)
export IdentityRegimes (RegimeGraph)
export IdentityRegimes (AdmissibleRelation)

-- ============================================================
-- PREDICATES
-- ============================================================

export IdentityRegimes (IsCanonicalRegime)
export IdentityRegimes (NonCollapsing)
export IdentityRegimes (ProfileWellFormed)
export IdentityRegimes (RequirementSatisfied)
export IdentityRegimes (RegimeApplicationAdmissible)
export IdentityRegimes (UnderSplitPressure)
export IdentityRegimes (GraphWellFormed)

-- ============================================================
-- CLASSIFICATION VOCABULARY
-- ============================================================

export IdentityRegimes (classificationMatrix)
export IdentityRegimes (derivedRegimeSet)
export IdentityRegimes (referenceProfiles)
export IdentityRegimes (referenceTransformations)
export IdentityRegimes (referenceFamilies)
export IdentityRegimes (referenceClassificationValues)
export IdentityRegimes (profilesForFamily)
export IdentityRegimes (derivedProfilesFromFamilies)

-- ============================================================
-- WITNESSES
-- ============================================================

export IdentityRegimes (oblProfile)

-- ============================================================
-- THEOREMS
-- ============================================================

export IdentityRegimes (all_regimes_canonical)
export IdentityRegimes (classification_pattern_unique)
export IdentityRegimes (derivedRegimeSet_card)
export IdentityRegimes (derivedRegimeSet_nodup)
export IdentityRegimes (derivedRegimeSet_complete)
export IdentityRegimes (derivedRegimeSet_pairwise_noncollapse)
export IdentityRegimes (nine_regime_lower_bound)
export IdentityRegimes (regime_application_admissible_of_neutral)
export IdentityRegimes (representation_theorem)
