# SE Theory: Operational Identity

> Lean 4 formalization of the Operational Identity layer of
> Structural Explainability theory.

This repository formalizes comparisons between declared identity
relations and identity-relevant treatment induced by examined
implementation mechanisms.

Lean source files under `SE/` are authoritative for formal definitions,
predicates, assumptions, theorems, and proof obligations.

- [GitHub Repository](https://github.com/structural-explainability/se-theory-operational-identity)
- [Paper: Operational Identity (arXiv:2607.20729)](https://arxiv.org/abs/2607.20729)
- [Finite-Core Verification](https://github.com/structural-explainability/se-verification-operational-identity)
- [Research Doubts and Open Questions](https://github.com/structural-explainability/se-theory-operational-identity/blob/main/DOUBTS.md)
- [Research Decisions](https://github.com/structural-explainability/se-theory-operational-identity/blob/main/DECISIONS.md)

## Operational Identity

Operational Identity distinguishes declared rules of sameness
from the identity-relevant behavior of an implementation.

The theory provides formal means to compare these relations,
characterize faithfulness, identify divergence witnesses,
and represent conclusions limited by the available evidence.

These results are conditional on the supplied identity criteria,
examined records, and modeled implementation behavior.

They do not independently establish that the declared identity
criterion correctly identifies real-world referents or that
every relevant implementation mechanism has been examined.

## Scope

Repository scope is defined in `SE_MANIFEST.toml`.

## Exclusions

Repository exclusions are defined in `SE_MANIFEST.toml`.

## Import

Downstream Lean projects should import the public surface:

`import SE.OperationalIdentity`
