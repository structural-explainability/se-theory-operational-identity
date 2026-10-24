# Changelog

<!-- markdownlint-disable MD024 -->

All notable changes to this project will be documented in this file.

The format is based on **[Keep a Changelog](https://keepachangelog.com/en/1.1.0/)**
and this project adheres to **[Semantic Versioning](https://semver.org/spec/v2.0.0.html)**.

---

## [Unreleased]

---

## [0.3.0] - 2026-05-02

### Added

ClassificationMatrix as named rows.
Each row is independently readable and testable.
NA→IGN CONVENTION block added at top of Transform/Core.lean.

Non-Collapsing def linked to paper:

1. A lemma noncollapse_of_prs_difference.
   If one profile classifies t as PRS and the other doesn't,
   they are non-collapsing.
   Operative step in every paper proof.

2. A note that for the 9 profiles, every matrix difference
   that appears in a proof involves a PRS cell for
   one of the profiles, so Lean definition is sufficient.

Scaffolding and verification for:

- .\reference\index.toml
- .\reference\proof-registry.json
- .\reference\regime-classification-matrix.toml
- .\reference\regime-classification-values.toml
- .\reference\regime-families.toml
- .\reference\regime-predicates.toml
- .\reference\regime-profile-derivation.toml
- .\reference\regime-profiles.toml
- .\reference\regime-theorems.toml
- .\reference\regime-transformations.toml
- .\reference\regime-types.toml
- .\reference\regime-vocabulary.toml

- `reference.py` - scaffold and validate reference artifacts against
  Lean 4 source
- `se-ref-scaffold` CLI command - adds stubs for new Lean symbols,
  preserves existing descriptions and cite_ids
- `se-ref-validate` CLI command - validates reference artifacts
  against Lean source, writes nothing
- `se-manifest-validate` and `se-manifest-version-sync` CLI entry points

### Changed

- README.md workflow commands
- pyproject.toml [project.scripts]
- `run_validate()` extended to include reference artifact validation
  as final step
- Release procedure simplified and updated to use CLI entry points.

---

## [0.2.0] - 2026-05-01

### Added

- Added curated public Lean surface via `IdentityRegimes.Surface`.
- Added single downstream import boundary:

  ```lean
  import IdentityRegimes
  open IdentityRegimes
  ```

- Added public exports for:
  - `Regime`
  - `RegimeProfile`
  - `RegimeProfileKind`
  - `Requirement`
  - `Transformation`
  - `TransformationClassification`
  - `IsCanonicalRegime`
  - `IsPreserving`
  - `IsBreaking`
  - `NonCollapsing`
  - `ProfileWellFormed`
  - `RequirementSatisfied`
  - `RegimeApplicationAdmissible`
  - `classify`
  - `derivedRegimeSet`
  - `classification_pattern_unique`
  - `nine_regime_lower_bound`

reference/ files (manual creation / Lean checking):

- regime-classification-values.toml
- regime-families.toml
- regime-profile-derivation.toml
- regime-profiles.toml
- regime-transformations.toml

### Changed

- Migrated Identity Regimes from the previous Neutral Substrate API
  to new public `NeutralSubstrate` import surface.
- Replaced legacy substrate references with `Ontology`.
- Replaced ontology-level `Admissible` usage with `Neutral`.
- Renamed transformation classification vocabulary to `TransformationClassification`.
- Clarified distinction between:
  - six canonical `Regime` values
  - nine derived `RegimeProfileKind` values
  - structured `RegimeProfile` objects

### Fixed

- Fixed Lean theorem binders incorrectly treating `Neutral S` as a typeclass.
- Fixed recursive proof error in `regime_application_admissible_of_neutral`.
- Corrected public surface exports to include only valid, stable identifiers.
- Restored successful `lake build` after Neutral Substrate interface migration.

### Notes

This release establishes a stable public Lean interface for identity-regime theory.

- the canonical classification matrix may be refined
- the reference certification layer may expand

---

## [0.1.0] - 2026-04-28

### Added

Initial Lean 4 formal contract structure (`SEFormalContract`)

- Core modules: `Basic`, `Regime`, `Neutrality`,
  `Relation`, `Export`, `ExportJson`
- Public library root with stable import surface

Canonical identity regimes (`IdentityRegimes.Basic`):

- Six canonical regimes: `OBL`, `NOR`, `OCC`, `CTX`, `REC`, `ENR`
- `DecidableEq`, `Repr` derived

Regime predicates (`IdentityRegimes.Regimes`):

- `IsCanonicalRegime` predicate
- `all_regimes_canonical` theorem

Requirement structure (`IdentityRegimes.Requirements`):

- `Requirement` structure over canonical regimes
- `RequirementSatisfied` predicate over admissible substrates

Nine derived regime profiles (`IdentityRegimes.Profiles`):

- `RegimeProfileKind`: `OBL`, `OCC`, `REC`, `ENR_L`, `ENR_I`, `CTX_E`, `CTX_S`, `NOR_C`, `NOR_S`
- `RegimeProfileKind.regime`: map from each profile to its parent canonical regime
- `IdentityBasis`: `single`, `content`, `structure`, `extension`, `locus`, `instrument`
- `SplitTransformation`: `none`, `RF`, `AD`, `BF`
- `ProfileAxes`: identity basis and split-forcing transformation per profile
- `RegimeProfileKind.axes`: canonical axes for all nine profiles
- `UnderSplitPressure` predicate with `Decidable` instance
- Split pressure theorems for all nine profiles (`by decide`)
- `splitPressure_iff_refined_regime`: split pressure iff parent is ENR, CTX, or NOR
- `regime_map_not_injective`: distinct profiles can share a parent regime
- `no_split_regime_injective`: stable regimes have unique profiles
- `all_profiles_canonical`: every profile maps to a canonical regime

Transformation basis (`IdentityRegimes.Transformations`):

- `Transformation`: ten-family basis RE, AN, RF, AD, RC, RA, SU, BF, PV, SE
- `TransformationClass`: IGN, PRS, BRK, NA
- `classify`: total classification function over all nine profiles
- OBL, OCC, REC rows verified against SE-300 Section 4 canonical classification tables
- ENR_L, ENR_I, CTX_E, CTX_S, NOR_C, NOR_S rows verified against SE-300 split sections
- `IsPreserving`, `IsBreaking` predicates with `Decidable` instances
- `enr_splits_on_BF`: ENR_L preserves, ENR_I breaks under BF
- `ctx_splits_on_AD`: CTX_E preserves, CTX_S breaks under AD
- `nor_splits_on_RF`: NOR_C preserves, NOR_S breaks under RF

Non-collapse proofs (`IdentityRegimes.NonCollapse`):

- `NonCollapsing` predicate
- `noncollapse_ENR_L_ENR_I`: separated by BF
- `noncollapse_CTX_E_CTX_S`: separated by AD
- `noncollapse_NOR_C_NOR_S`: separated by RF
- `noncollapse_of_distinct_regime`: cross-family separation by distinct parent regime
- `noncollapse_all_pairs`: all 36 unordered pairs non-collapsing

Lower bound (`IdentityRegimes.LowerBound`):

- `derivedRegimeSet`: list of all nine profiles
- `derivedRegimeSet_card`: exactly 9 elements
- `derivedRegimeSet_nodup`: no duplicates
- `derivedRegimeSet_complete`: every profile kind present
- `derivedRegimeSet_pairwise_noncollapse`: all pairs non-collapsing
- `classification_pattern_unique`: classify injective on profiles
- `lower_bound`: any substrate must realize at least 9 non-collapsing profiles

Embedding and representation (`IdentityRegimes.Embedding`):

- `AdmissibleRelation`: five admissible relation types
- `RegimeVertex`, `RegimeEdge`, `RegimeGraph`: regime-typed multigraph structure
- `regimeAssignment_determined_by_classification`: regime assignment injective up to classification
- `representation_theorem`: each profile uniquely determined by classification behavior
- `derived_regime_set_no_behavioral_collapse`: no two distinct profiles behaviorally equivalent
- `nine_regime_lower_bound`: derived regime set witnesses the nine-profile lower bound

Admissibility (`IdentityRegimes.Admissibility`):

- `RegimeApplicationAdmissible`: regime application requires admissible neutral substrate

Theorems (`IdentityRegimes.Theorems`):

- `canonical_of_profile_well_formed`
- `regime_application_admissible_of_neutral`

Witness (`IdentityRegimes.Witness`):

- `oblProfile`: canonical OBL profile witness
- `oblProfile_well_formed`: OBL profile is well formed

Structural relation primitives:

- `equivalent`, `narrower`, `broader`, `overlaps`, `none`

Lean-based contract export layer:

- JSON export via `ExportJson`
- invariant registry
- regime registry
- relation registry
- proof registry

Python validation and CLI interface:

- validation module (`se_formal_contract.app`)
- CLI interface (`se_formal_contract.cli`, `__main__`)

Generated contract artifacts under `data/contract/`

SE manifest (`SE_MANIFEST.toml`) defining repository role as formal contract root

Migration scaffolding:

- `docs/migration/from-existing-formalizations.md`

Repository governance and tooling:

- `AGENTS.md`
- `CITATION.cff`

### Design constraints recorded

- Six regimes and nine profiles are distinct layers; profiles refine regimes, they do not replace them
- Semantic richness lives inside Lean only; no Python validation surface
- No operational or export layer in theory repos
- OCC/AD classified as BRK; OBL/BF as IGN; REC/BF as PRS: decisions recorded in SE-300 Section 4

---

## Notes on versioning and releases

- We use **SemVer**:
  - **MAJOR** - breaking changes to artifact structure or validation semantics
  - **MINOR** - backward-compatible additions to schema or validation rules
  - **PATCH** - fixes, documentation, tooling
- Versions are driven by git tags. Tag `vX.Y.Z` to release.
- Docs are deployed per version tag and aliased to **latest**.

## Release Procedure (Required)

Follow these steps exactly when creating a new release.

### Task 1. Update release metadata (manual edits)

1.1. CITATION.cff: update version and date-released
1.2. lakefile.toml: update version
1.3. CHANGELOG.md: add section, move unreleased entries, update links
1.4. pyproject.toml: update build fallback-version (near end of the file)

### Task 2. Sync Validate

```shell
.\sit.ps1

elan self update
lake update

# build Lean (source of truth)
lake build
lake test

# validate reference artifacts against declared Lean public surface
uv run se-theory-reference validate
uv run se-theory-reference validate --strict

# add / try / regenerate generated JSON artifacts from reference TOML
uv run se-theory-reference scaffold
uv run se-theory-reference scaffold --dry-run
uv run se-theory-reference scaffold --overwrite

# regenerate / check generated JSON artifacts from reference TOML
uv run se-theory-reference export
uv run se-theory-reference export --check

# build / verify generated reference catalog
uv run se-theory-reference catalog
uv run se-theory-reference catalog --check

# inspect resolved repo configuration and reference declarations
uv run se-theory-reference inspect

# validate SE manifest file
uvx se-manifest-schema validate-manifest --path SE_MANIFEST.toml --strict

# type checks, tests, docs
uv run python -m pyright
uv run python -m pytest
uv run python -m zensical build
```

### Task 3. Commit, tag, push

```shell
git add -A
git commit -m "Prep X.Y.Z"
git push -u origin main
```

Verify actions run on GitHub. After success:

```shell
git tag vX.Y.Z -m "X.Y.Z"
git push origin vX.Y.Z
```

### Task 4. After tagging, verify tag consistency

```shell
uvx --from se-manifest-schema se-manifest check-version --require-tag
```

Confirms CITATION.cff version matches the pushed git tag.
Run this after `git push origin vX.Y.Z`; it will fail before that point.

## Only As Needed (delete a tag)

```shell
git tag -d vX.Z.Y
git push origin :refs/tags/vX.Z.Y
```

## Links

[Unreleased]: https://github.com/structural-explainability/se-theory-operational-identity/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/structural-explainability/se-theory-operational-identity/releases/tag/v0.3.0
[0.2.0]: https://github.com/structural-explainability/se-theory-operational-identity/releases/tag/v0.2.0
[0.1.0]: https://github.com/structural-explainability/se-theory-operational-identity/releases/tag/v0.1.0
