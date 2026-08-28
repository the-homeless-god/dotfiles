---
name: master-prompt-builder
description: Create or substantially revise reusable, evidence-backed master prompts for complex implementation initiatives from rough briefs, links, repositories, and expected outcomes. Use for cross-repository or spec-driven work that needs alternative analysis, verification, safety boundaries, artifacts, rollout, and a precise completion contract; do not use for a small one-off prompt rewrite.
---

# Master Prompt Builder

Turn an informal initiative into a self-contained prompt that another capable
agent can execute without inventing product facts, permissions, or completion.
Optimize for decision quality and verifiability, not raw length.

## Boundary

The default deliverable is the master prompt, not implementation of the
initiative described by it. Inspect sources and edit or commit files only when
the user also authorizes those actions. A generated prompt cannot grant the
future agent broader permissions than the invoking user has.

Do not request or expose hidden chain-of-thought. Convert requests for Chain of
Thought into private reasoning plus a public decision trace: alternatives,
criteria, selected option, evidence, uncertainty, and verification results.

## Workflow

1. Normalize the brief into objective, users/actors, current state, target state,
   repositories/systems, authoritative sources, constraints, expected outputs,
   desired outcomes, and terminal condition.
2. Separate facts from wishes. Label material knowledge as `VERIFIED`,
   `INFERRED`, `ASSUMED`, `UNKNOWN`, or `BLOCKED`. A URL or path is only a lead
   until its content is inspected.
3. Identify authority and mutation boundaries: read-only research, local edits,
   external writes, secrets, deploys, merges, destructive cleanup, and actions
   requiring renewed approval.
4. Choose prompt depth proportional to the initiative. A “giant” prompt may be
   long, but each section must change execution, validation, or handoff.
5. When work spans multiple independently versioned repositories, decide whether
   an umbrella workspace adds lasting value. If an umbrella exists or is selected,
   apply `$umbrella-repository-setup` and embed pinned-revision, instruction
   precedence, component write-boundary, capability-spec, and technical-debt
   traceability requirements into the master prompt.
6. Compose the prompt using
   [references/prompt-blueprint.md](references/prompt-blueprint.md). Omit
   irrelevant optional sections instead of filling them with generic prose.
7. Apply advanced techniques as operational protocols:
   - **RCTF:** establish role, verified context, concrete task, and output format;
   - **ReAct:** iterate `plan → bounded action → observation → update → verify`;
   - **Tree of Thoughts:** compare 2–4 materially different approaches against
     explicit criteria, prune dominated options, publish only the decision table;
   - **Chain of Verification:** derive independent verification questions from
     requirements, check them against code/tests/sources, then correct claims;
   - **Reflexion/adversarial review:** test the selected design against failure,
     misuse, partial data, rollback, and “looks done but is not” scenarios;
   - **spec-driven development:** map requirements to artifacts, code, tests,
     evidence, rollout gates, and PRs.
8. Preserve user terminology and supplied source links, but generalize examples
   only when the user asked for a reusable prompt. Use explicit placeholders for
   missing product choices rather than fabricating them.
9. Run [references/quality-gates.md](references/quality-gates.md) before delivery.

## Output contract

Unless the user asks otherwise, return:

1. a short assumptions/source-gap note only when material gaps exist;
2. one copy-paste-ready master prompt in a fenced block;
3. a compact explanation of how to invoke it and which placeholders remain.

Inside the generated master prompt, require observable outputs such as files,
specifications, diagrams, code, tests, reports, PRs, or published pages only
when they belong to the requested initiative. Distinguish:

- **outputs:** concrete artifacts and system changes;
- **outcomes:** user or business value and measurable success;
- **evidence:** how completion is proven;
- **gates:** what prevents the next rollout stage;
- **non-goals:** what the agent must not silently expand into.

If the user asks to store the prompt, place it under the project's existing
spec/documentation convention and update the nearest index or traceability file
when applicable. Commit or open a PR only when explicitly requested.
