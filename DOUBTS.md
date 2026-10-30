# Research Doubts and Open Questions

This document records the current research assessment,
known limitations, unresolved questions, and safeguards
against overclaiming for this theory.

For the three research criteria, doubt classifications,
status definitions, and procedures, see the
[SE Research Doubts Standard](https://raw.githubusercontent.com/structural-explainability/.github/refs/heads/main/docs/en/research/doubts.md).

## Repository Summary

This assessment is a summary of the present evidence.

| Criterion                | Current assessment                                                                                                                                                                                                                                     |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Mathematical Correctness | Formal results are established under stated hypotheses. Faithfulness is equivalent to the absence of a divergence witness (`faithful_iff_not_exists_witness`). Audit verdicts are pass, fail, or indeterminate, relative to an explicit warrant input. |
| Scientific Adequacy      | Not established. The theory is under initial development. It does not establish that a declared identity criterion identifies its intended referents, or that every identity-relevant mechanism has been observed.                                     |
| Theoretical Contribution | The proposed contribution is a comparison of declared identity relations with the identity behavior induced by examined implementations. No related-work discussion is recorded in this repository.                                                    |

The doubts below identify specific issues affecting these assessments.

---

<!-- markdownlint-disable MD024 -->

## Register 1. Doubts About Assumptions (Undermining Doubts)

These questions concern the premises of an argument.
Even if a theorem is correctly proved, can we establish the assumptions necessary to apply it?

### UM-001. (OPEN) Declared Identity Criterion

#### Research criterion

Scientific Adequacy

#### Concern

Does the declared criterion identify the intended referents?

#### Current Knowledge

The theory does not establish this.
Scientific validation of declared identity criteria is outside its scope.

#### Remaining Work

Each application must justify its declared criterion.

### UM-002. (OPEN) Completeness of the Examined Surface

#### Research criterion

Scientific Adequacy

#### Concern

Has every identity-relevant mechanism or use been observed?

#### Current Knowledge

The theory does not certify complete implementation disclosure or observation.
The audit takes an explicit warrant input, and `audit_ne_pass_of_not_warranted` shows that without a warrant the result is not a pass.

#### Remaining Work

Each application must justify the warrant.

### UM-003. (OPEN) Examined Domain

#### Research criterion

Mathematical Correctness

#### Concern

A result over a finite domain may not hold over a larger one.

#### Current Knowledge

Faithfulness is decided over an enumerated domain.
A test records a pass lost when the generating pairs grow.

#### Remaining Work

State the domain and generating pairs with every pass.

## Register 2. Doubts About Conclusions (Rebutting Doubts)

These questions concern whether a claimed conclusion is false.
For example, a counterexample satisfying all the premises
but violating the conclusion would challenge the claimed theorem or its formalization.
A model that violates a required assumption does not
necessarily refute a conditional theorem.
If a counterexample is found,
we must identify the exact claim it challenges and
whether its assumptions are satisfied.

**None currently identified.**

## Register 3. Doubts About What Our Results Mean (Undercutting Doubts)

These questions concern the connection
between a formal theorem and the scientific claim made about it.
A theorem may be correct while its informal interpretation is too strong.
Some of these doubts are addressed by permanent documentation
rules rather than additional proofs.

### UC-001. (STANDING RULES) Relative Judgments

#### Research criterion

Scientific Adequacy

#### Concern

A reader might read a faithfulness verdict as absolute.

#### Current Knowledge

Judgments are relative to the supplied declaration, the examined domain, and the identified implementation behavior.

#### Standing Rules

1. State the declaration, domain, and implementation surface with every verdict.

### UC-002. (STANDING RULES) Equal Behavior Is Not Referent Identity

#### Research criterion

Scientific Adequacy

#### Concern

A reader might infer referent identity from equal implementation behavior.

#### Current Knowledge

Inference of referent identity from equal implementation behavior is outside the theory's scope.

#### Standing Rules

1. Do not present equal treatment as establishing referent identity.

### UC-003. (STANDING RULES) Indeterminate Verdicts

#### Research criterion

Scientific Adequacy

#### Concern

A reader might fold an indeterminate result into pass or fail.

#### Current Knowledge

`audit_eq_indeterminate_iff` characterizes the indeterminate outcome, which records insufficient evidence to decide.

#### Standing Rules

1. Do not report an indeterminate verdict as pass or fail.

<!-- markdownlint-enable MD024 -->
