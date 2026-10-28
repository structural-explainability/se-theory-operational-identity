# Changelog

<!-- markdownlint-disable MD024 -->

All notable changes to this project will be documented in this file.

The format is based on **[Keep a Changelog](https://keepachangelog.com/en/1.1.0/)**
and this project adheres to **[Semantic Versioning](https://semver.org/spec/v2.0.0.html)**.

---

## [Unreleased]

---

## [0.1.0] - 2026-10-28

### Added

- `SE.OperationalIdentity.Declared`: a declared identity relation as a supplied
  equivalence, with constructors from generating pairs, from a Persistence
  licence, and from a Persistence classification.
- `SE.OperationalIdentity.Surface`: implementation surfaces (mechanism,
  identified uses, surface control), treatment signatures, the induced
  treatment equivalence, joint surfaces, and the record surface.
- `SE.OperationalIdentity.Faithfulness`: faithfulness as containment of the
  declared relation in the treatment relation, divergence witnesses, and the
  equivalence of faithfulness with the absence of a witness.
- `SE.OperationalIdentity.Licensed`: faithfulness over generated identity
  stated in the Persistence calculus, the identification with Persistence
  presentation soundness, and localization of a divergence to one licensed step.
- `SE.OperationalIdentity.Composition`: store-level faithfulness over a finite
  family of examined surfaces.
- `SE.OperationalIdentity.Position`: local position of a treatment relation
  relative to a supplied alternative, exhaustive and exclusive, and the
  separate condition of substitution.
- `SE.OperationalIdentity.Finite`: decision of faithfulness and witness search
  over an enumerated domain.
- `SE.OperationalIdentity.Verdict`: the three-valued audit verdict relative to
  an explicit warrant input.
- Tests: a finite example with a faithful surface and a divergent surface, the
  loss of a pass when the generating pairs grow, and the position examples.
- Reference registries for types, vocabulary, predicates, theorems,
  dependencies, and traceability, with generated JSON artifacts and catalog.
- Lint package with the Batteries environment linters.
- Direct dependency on se-theory-persistence only.

---

## Notes on versioning and releases

- We use **SemVer**:
  - **MAJOR** - breaking changes
  - **MINOR** - backward-compatible additions
  - **PATCH** - fixes, documentation, tooling
- Versions are driven by git tags.
- Tag `vX.Y.Z` to release.
- During `0.x` development, breaking formal-surface changes
  may occur in a **MINOR** release.

## Release Procedure (Required)

Follow these steps exactly when creating a new release.

### One-Time Zenodo Authorization

1. Sign in to Zenodo.
2. Open your profile menu in the upper-right.
3. Select GitHub.
4. Click Sync now.
5. Find structural-explainability/ this repo.
6. Turn on the repository toggle/slider.
7. Refresh the page and confirm it appears as enabled.
8. Zenodo will ingest future GitHub Releases from this repo.

### Task 1. Update release metadata (manual edits)

1.1. CITATION.cff: update version and date-released
1.2. lakefile.toml: update version
1.3. CHANGELOG.md: add section, move unreleased entries, update links, release command
1.4. pyproject.toml: update version (near top of the file)

### Task 2. Set up and Validate

```shell
# set up or update Python environment
# Run repository checks.
.\sit.ps1

# Update GitHub Actions and pin all action references to immutable SHAs.
uvx gha-tools autoupdate --pin=all --write .github/workflows

# Audit the resulting GitHub configuration for security findings.
# NO .github\workflows\deploy-zensical.yml
# YES  .github\workflows\deploy-zensical-lean.yml
uvx zizmor@latest .github/
# Some suppressed are still okay

# Validate.
uvx cffconvert --validate
uvx se-manifest-schema validate-manifest --strict

# Format Markdown.
npx markdownlint-cli2 --fix

.\rel.ps1
.\sit.ps1
```

Review all generated and modified files before committing.

### Task 3. Commit and Push

```shell
git add -A
git commit -m "Prep X.Y.Z"
git push -u origin main
```

Verify that all required GitHub Actions complete successfully.

### Task 4. Tag and Push the Release

After the required GitHub Actions succeed:

```shell
git tag vX.Y.Z -m "X.Y.Z"
git push origin vX.Y.Z
```

Create GitHub Release after pushing tag, for example with a command like this:

```shell
gh release create v0.1.0 --verify-tag --title "0.1.0 " --generate-notes
```

## Only As Needed (delete a tag)

```shell
git tag -d vX.Z.Y
git push origin :refs/tags/vX.Z.Y
```

## Links

[Unreleased]: https://github.com/structural-explainability/se-theory-operational-identity/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/structural-explainability/se-theory-operational-identity/releases/tag/v0.1.0
