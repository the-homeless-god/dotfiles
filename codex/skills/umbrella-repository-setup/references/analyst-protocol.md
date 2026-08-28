# Cross-repository analyst protocol

Use this protocol when an analyst, architect, or product engineer needs an
evidence-backed view across multiple components.

## 1. Freeze the analysis baseline

Create a revision manifest with one row per component:

| Component | Purpose | Remote/path | Revision | Branch context | Dirty state | Evidence status |
|---|---|---|---|---|---|---|

Never describe the portfolio as “current” without the timestamp and revisions.
Do not refresh component pointers during analysis unless the user requested it.

## 2. Merge instruction context without flattening it

Read root rules, then each component's instructions and skills. Produce a small
precedence map:

1. user instruction and explicit authorization;
2. umbrella-wide safety and output contract;
3. component-local rules inside that component;
4. initiative specs and accepted decisions;
5. inferred conventions.

Conflicts become decisions or blockers; do not silently pick the easiest rule.

## 3. Build AS-IS from evidence

For each capability, trace:

- actor and user journey;
- entrypoint/UI/API/command;
- component call path and dependency direction;
- data owner, storage, events, and external systems;
- authorization and sensitive-data boundaries;
- failure/degraded behavior;
- tests, observability, deployment, and operational ownership;
- exact file/symbol/contract evidence.

Generate a C3/component view and Event Storming only from confirmed entities.
Keep `UNKNOWN` explicit where access or evidence is missing.

## 4. Organize specifications by capability

The umbrella initiative spec covers the cross-repository objective. Create
additional capability specs only when they have independent behavior or
delivery. Each spec should distinguish:

- AS-IS proven from pinned code;
- TO-BE from accepted requirements;
- assumptions and unresolved product questions;
- component boundaries and PR order;
- contract changes and compatibility;
- tests and verification evidence.

For analyst-led initiatives, include a user journey/CJM when roles or handoffs
change. Link the journey steps to capabilities and requirements.

## 5. Technical-debt discipline

For every debt finding record:

- affected capability/feature and users;
- concrete code/operational evidence;
- failure mode or cost of delay;
- target boundary or engineering principle;
- remediation options and migration risk;
- owner, priority, verification, and exit criteria.

If no feature owns the debt, create a separately decomposed initiative or plan.
Do not put findings into a generic backlog without traceability.

## 6. Shared memory and decisions

Use versioned files:

- `sources.md` for source identity, revision, freshness, and coverage;
- `journal.md` for performed actions and observed results;
- `decisions.md` for accepted/rejected alternatives and consequences;
- `memory.md` for a compact working state that can be reconstructed from the
  other files;
- `traceability.md` for requirement-to-evidence delivery coverage.

Conversation history is not the system of record.

## 7. Verification

Before handoff:

- reconcile capability inventory against all component entrypoints;
- verify client/server or producer/consumer contracts at pinned revisions;
- render Mermaid diagrams and check that textual fallbacks remain useful;
- distinguish repository configuration, analysis artifacts, proposed changes,
  component implementations, deployments, and production proof;
- challenge readiness with stale revisions, inaccessible components, conflicting
  rules, partial contracts, and unowned debt;
- list exact next PRs and their dependency order without modifying component
  repositories unless separately authorized.
