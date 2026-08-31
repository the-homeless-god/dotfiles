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
criteria, selected option, evidence, uncertainty, and verification results. The
ban covers the hidden reasoning only; the public trace is required, not merely
allowed. Both halves are spelled out in
[references/technique-selection.md](references/technique-selection.md).

## Workflow

1. Normalize the brief into objective, users/actors, current state, target state,
   repositories/systems, authoritative sources, constraints, expected outputs,
   desired outcomes, and terminal condition. Worked normalizations of real
   briefs — what each one was missing and how it reads once fixed — are in
   [references/prompt-blueprint.md](references/prompt-blueprint.md) §14.
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
7. Choose techniques by the failure they close, not by reputation. RCTF, ReAct,
   Tree of Thoughts, Chain of Verification, Reflexion, spec-driven development,
   zero-shot, few-shot, self-consistency, least-to-most, RAG, and the
   public-trace-only form of Chain of Thought each buy one failure mode and each
   charge a multiple of the request; take the cheapest one that closes the
   failure actually present, and require none where a deterministic check
   already answers the question. Payoffs, costs, and the two techniques that
   already live here under other names:
   [references/technique-selection.md](references/technique-selection.md).
   Their operational form is in the blueprint; name a technique in the generated
   prompt only when the agent will visibly do something differently.
8. When the prompt must carry an agent for hours with nobody available to answer
   it — the default target, a self-contained zero-shot text — apply the
   unattended run contract in
   [references/prompt-blueprint.md](references/prompt-blueprint.md) §13. Length
   is not what keeps such a run alive: a machine-checkable completion condition,
   a rule for meeting the unknown, a write boundary, and a stated definition of
   failure are.
9. Preserve user terminology and supplied source links, but generalize examples
   only when the user asked for a reusable prompt. Use explicit placeholders for
   missing product choices rather than fabricating them.
10. Run [references/quality-gates.md](references/quality-gates.md) before delivery.

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
