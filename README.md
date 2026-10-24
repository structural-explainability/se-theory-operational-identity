# SE Theory: Operational Identity

[![Docs Site](https://img.shields.io/badge/docs-site-blue?logo=github)](https://structural-explainability.github.io/se-theory-operational-identity/)
[![Repo](https://img.shields.io/badge/repo-GitHub-black?logo=github)](https://github.com/structural-explainability/se-theory-operational-identity)
[![Tooling](https://img.shields.io/badge/python-3.15%2B-blue?logo=python)](./pyproject.toml)
[![License](https://img.shields.io/badge/license-MIT-yellow.svg)](./LICENSE)

[![CI-Lean](https://github.com/structural-explainability/se-theory-operational-identity/actions/workflows/ci-lean.yml/badge.svg?branch=main)](https://github.com/structural-explainability/se-theory-operational-identity/actions/workflows/ci-lean.yml)
[![CI](https://github.com/structural-explainability/se-theory-operational-identity/actions/workflows/ci-python-zensical.yml/badge.svg?branch=main)](https://github.com/structural-explainability/se-theory-operational-identity/actions/workflows/ci-python-zensical.yml)
[![Docs](https://github.com/structural-explainability/se-theory-operational-identity/actions/workflows/deploy-zensical.yml/badge.svg?branch=main)](https://github.com/structural-explainability/se-theory-operational-identity/actions/workflows/deploy-zensical.yml)
[![Links](https://github.com/structural-explainability/se-theory-operational-identity/actions/workflows/links.yml/badge.svg?branch=main)](https://github.com/structural-explainability/se-theory-operational-identity/actions/workflows/links.yml)

> Lean 4 development of declared and implemented identity comparison.

This repository formalizes comparison of declared identity relations
with operational relations induced by examined implementation surfaces,
including conformance conditions and divergence witnesses.

For the full documentation, see [`docs/en/index.md`](./docs/en/index.md).

## Authority

Lean source files are authoritative for formal definitions, predicates, axioms,
theorems, proof obligations, and reference rules.

Reference artifacts under `reference/` and generated artifacts under
`data/` mirror the Lean public surface.
They do not define theory semantics independently of Lean.

## Import

Downstream Lean projects should import the public surface:

```text
import SE.IdentityRegimes
```

The public import surface is curated in:

```text
SE.IdentityRegimes.lean
SE.IdentityRegimes/Surface.lean
```

## Scope

This repository covers:

- six canonical identity regimes,
- nine canonical regime profile kinds after splits,
- regime requirement structure,
- regime-profile structure,
- admissibility conditions for regime application over neutral substrates,
- transformation basis and classification structure,
- split pressure predicates and theorems,
- pairwise non-collapse proofs,
- lower-bound and classification-uniqueness theorem structure,
- regime-typed multigraph structure,
- representation theorem structure,
- machine-checked Lean theorems.

## Owns

This repository owns the identity-regime theory layer, including:

- six canonical identity regimes:
  - OBL
  - NOR
  - OCC
  - CTX
  - REC
  - ENR
- nine canonical regime profile kinds after splits:
  - OBL
  - OCC
  - REC
  - ENR_L
  - ENR_I
  - CTX_E
  - CTX_S
  - NOR_C
  - NOR_S
- transformations:
  - RE
  - AN
  - RF
  - AD
  - RC
  - RA
  - SU
  - BF
  - PV
  - SE

## Does not own

This repository does not own:

- neutral substrate primitives; see `se-theory-operational-identity`,
- path grammar and expressive adequacy,
- domain mappings,
- operational validation,
- runtime systems,
- contract artifact generation.

## Command Reference

<details>
<summary>Show command reference</summary>

### In a machine terminal

Open a machine terminal where you want the project:

```shell
git clone https://github.com/structural-explainability/se-theory-operational-identity

cd se-theory-operational-identity
code .
```

### In a VS Code terminal

Use VS Code Menu:
View / Command Palette / `Developer: Reload Window` to refresh.

```shell
elan self update
lake update

uv self update
uv python pin 3.15
uv lock --upgrade
uv sync --extra dev --extra docs --upgrade

# install git hooks once per clone
uvx pre-commit install

# build Lean source of truth
lake build
lake test

# inspect shared theory-reference command surface
uv run se-theory-reference --help
uv run se-theory-reference validate --help
uv run se-theory-reference scaffold --help
uv run se-theory-reference export --help
uv run se-theory-reference catalog --help
uv run se-theory-reference inspect --help

# validate reference artifacts against the declared Lean public surface
uv run se-theory-reference validate
uv run se-theory-reference validate --strict

# scaffold reference artifacts from Lean public declarations
uv run se-theory-reference scaffold
uv run se-theory-reference scaffold --dry-run
uv run se-theory-reference scaffold --overwrite

# regenerate or check generated JSON artifacts from reference TOML
uv run se-theory-reference export
uv run se-theory-reference export --check

# build or verify the generated reference catalog
uv run se-theory-reference catalog
uv run se-theory-reference catalog --check

# inspect resolved repository configuration and reference declarations
uv run se-theory-reference inspect

# validate SE manifest file
uvx se-manifest-schema validate-manifest --path SE_MANIFEST.toml --strict

# fix issues
git add -A
uvx pre-commit run --all-files
# repeat if changes were made
uvx pre-commit run --all-files

# type checks, tests, docs
uv run python -m pyright
uv run python -m pytest
uv run python -m zensical build

# save progress
git add -A
git commit -m "update"
git push -u origin main
```

</details>

## Authority Manifest

[.accountability/surfaces.toml](./.accountability/surfaces.toml)

## Citation

[CITATION.cff](./CITATION.cff)

## License

[MIT](./LICENSE)

## Repository Manifest

[SE_MANIFEST.toml](./SE_MANIFEST.toml)
