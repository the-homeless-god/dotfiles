# Master prompt blueprint

Use this as a compositional checklist, not a mandatory wall of headings. Keep
the resulting prompt self-contained and remove sections that do not affect the
task.

## 1. Invocation context

- Prompt purpose and intended agent/runtime.
- Repository roots, branches, environments, and supplied source links.
- Explicit invocation inputs and placeholders.
- Definition of the final terminal condition.

## 2. RCTF

### Role

Name the few roles that materially change decisions: for example lead engineer,
architect, researcher, product analyst, or security reviewer. Avoid decorative
role inflation.

### Context

State the problem, current verified baseline, users, constraints, dependencies,
known decisions, and unresolved questions.

### Task

Express the objective as outcomes and bounded workstreams. Separate research,
design, implementation, documentation, rollout, and external publication.

### Format

Define required repository artifacts, documents, reports, diagrams, PRs,
verification evidence, and the final handoff format.

## 3. Authority, evidence, and safety

- Source priority and conflict resolution.
- Knowledge labels: `VERIFIED`, `INFERRED`, `ASSUMED`, `UNKNOWN`, `BLOCKED`.
- Allowed read-only actions and ordinary local implementation actions.
- External writes, deploys, merges, destructive cleanup, secret handling, and
  other actions requiring explicit authorization.
- Dirty-worktree policy and preservation of unrelated user changes.
- Privacy, payload, logging, and credential boundaries.

Never let the prompt itself imply permission to mutate production, publish,
merge, delete, or discard local changes.

## 4. Reasoning and execution engine

### ReAct loop

For each workstream require:

1. state the next testable objective;
2. select the smallest bounded action;
3. observe actual output;
4. update facts, assumptions, and plan;
5. verify the result before claiming completion.

Set stopping conditions for retries and risky external operations.

### Alternative analysis — Tree of Thoughts

Require 2–4 distinct viable approaches when architecture or product direction
is genuinely open. Compare them in a public table using relevant criteria such
as user value, correctness, security, operability, migration cost, reversibility,
time-to-value, and evidence strength. Do not publish hidden scratch reasoning.

### Chain of Verification

After drafting or implementation:

1. derive verification questions independently from requirements;
2. answer them from code, tests, configs, runtime evidence, or documentation;
3. find contradictions and unsupported claims;
4. correct the artifact;
5. rerun the affected verification;
6. report residual uncertainty precisely.

### Adversarial reflection

Test relevant cases: partial source failure, malicious/untrusted input,
authorization confusion, retry/idempotency failure, stale data, rollback,
observability gaps, and a false-positive “done” state.

## 5. Discovery protocol

- Inspect repository authority files and working-tree state first.
- Build a source/evidence map before making architecture claims.
- Trace contracts and call paths across repositories at exact revisions.
- Separate current implementation, documented intent, and proposed target.
- Prefer primary sources; record inaccessible sources as gaps.
- Ask only questions whose answers materially change the solution and cannot be
  discovered safely.

## 6. Umbrella repository mode

When the initiative spans independently versioned repositories, do not assume
that submodules or a monorepo are automatically correct. Require a decision
between an umbrella with pinned revisions, a specification-only workspace, a
monorepo, and coordinated independent repositories.

If an umbrella is selected or already exists, the master prompt must require:

- an exact component revision/access manifest;
- root-versus-component instruction precedence;
- shared `AGENTS.md`, project principles/constitution, and general skills;
- component-specific skills and rules to remain component-owned;
- one initiative spec plus capability specs where behavior warrants them;
- source register, journal, decisions, memory, tasks, and traceability;
- README onboarding and a Mermaid C3/component view when useful;
- component changes, tests, commits, and PRs to remain separate;
- every technical-debt item to link to a capability/feature or become a
  separately decomposed plan.

For analyst-led work, also require AS-IS evidence at pinned revisions, CJM/user
journeys where roles or handoffs change, Event Storming, contract checks, and
clear separation of analysis, proposal, implementation, deployment, and proof.

## 7. Product and domain model

When applicable include:

- actors and role-dependent scenarios;
- jobs-to-be-done, happy paths, edge cases, and support paths;
- domain terms, aggregates, states, transitions, commands, events, and policies;
- use-case lifecycle and measurable success;
- outputs versus outcomes.

## 8. Architecture and delivery

Require only diagrams that answer a real question:

- C1/C2/C3 or equivalent system/component views;
- as-is versus target-state boundaries;
- sequence diagrams for sensitive or distributed flows;
- Event Storming for domain commands, events, policies, actors, and external
  systems;
- migration stages and rollback path.

For implementation specify contracts, dependency direction, data ownership,
authorization, failure policy, observability, capacity, and compatibility.

## 9. Spec-driven artifacts

A complex initiative commonly needs:

- `spec.md`: functional/non-functional requirements and acceptance scenarios;
- `plan.md`: architecture choice, phases, dependencies, rollout;
- `tasks.md`: dependency-ordered executable checklist;
- `data-model.md` or contract schemas when state matters;
- `tdr.md`/ADR: evidence, alternatives, decision, risks, migration;
- `traceability.md`: requirement → source/design → code → test/evidence;
- prompt/examples/evidence directories when they add reproducibility;
- outputs/outcomes summary.

Use the repository's existing convention rather than imposing these names.

## 10. Quality, security, and operations

- Unit, contract, integration, end-to-end, negative, and regression tests as
  appropriate.
- Threat model and privacy review proportional to data sensitivity.
- Metrics, logs, traces, dashboards, alerts, SLOs, runbook, and cardinality
  constraints.
- Feature flags, rollout strategy, migration, rollback, and proof of work.
- Explicit degraded behavior and handling of missing dependencies.

## 11. Execution phases

A useful default ordering is:

1. baseline, access map, and evidence;
2. scenarios, requirements, and alternatives;
3. repository-model and architecture decisions;
4. deterministic walking skeleton;
5. integrations and optional model boundary;
6. tests, security, observability, and documentation;
7. local/staging proof;
8. PRs in dependency order;
9. authorized rollout and post-deploy verification.

Adjust this ordering to actual dependencies. Do not claim rollout steps were
performed when access or authorization was absent.

## 12. Definition of Done and final response

Define completion through observable evidence:

- required artifacts exist and are internally consistent;
- code paths compile and targeted tests pass;
- cross-repository contracts and permissions agree;
- quality gates and negative cases are exercised;
- outputs and outcomes are documented;
- PR/merge order and remaining rollout gates are explicit;
- unsupported claims and blocked external actions are disclosed;
- unrelated user work remains untouched.

The final response should lead with achieved status, then changed artifacts,
verification, external actions actually performed, blockers, and the smallest
next step. It must not expose hidden chain-of-thought.
