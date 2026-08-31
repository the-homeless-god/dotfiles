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

Require a technique only where it closes a failure this initiative actually has,
and state what it costs in extra passes. The payoff/cost table, including the
techniques that are cheaper to skip, is in
[technique-selection.md](technique-selection.md).

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

### Independent recomputation — self-consistency

Reserve this for a judgement that has no deterministic check, has a short
discrete answer, and would propagate silently if wrong: which component owns a
behaviour, which of two revisions introduced a change, which contract a caller
actually depends on. Require an odd number of recomputations, at least three,
each starting from the raw sources rather than from a re-read of the first
answer. Disagreement escalates to evidence — a command, a test, a file at its
revision — never to a fourth vote. Where a command can settle the question,
require the command and skip the sampling.

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

This is the retrieval discipline behind RAG: retrieve, then answer from what was
retrieved.

- Inspect repository authority files and working-tree state first.
- Answer from retrieved text, not from recall. A current-state claim names the
  path and revision it came from; a claim whose source could not be retrieved
  degrades to `UNKNOWN`, never to memory.
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

This ordering is the least-to-most decomposition: every phase consumes the
previous phase's output and has an exit criterion someone else can check. Order
it so the first checkable artifact lands early and on disk — a plan whose first
observable output arrives at the end loses everything when the session does.

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

## 13. Unattended run contract

The usual target is one self-contained zero-shot text that keeps a capable agent
working for hours with no further turn from the author: no clarification, no
second helping of context, no one to unblock it. Length does not produce that.
Seven contents do, and a prompt missing any of them stalls or invents.

1. **A completion condition a machine can evaluate.** Give the commands and the
   output that counts as done — a test that passes, a file that exists, a count
   that matches. “When the work is good” ends the run at whatever the agent
   happened to believe.
2. **A rule for meeting the unknown.** The agent will hit a fact nobody
   supplied. Require it to label the gap `UNKNOWN` or `BLOCKED`, write it to a
   named place, take the next independent step, and continue. Never let the
   prompt imply that waiting or asking is available; the questions accumulate in
   one file and are answered at handover.
3. **A write boundary.** Exactly which paths may be written, and that everything
   else — including neighbouring work in the same tree — is read-only. Name the
   branch. Without this the run's blast radius grows with its length.
4. **A definition of failure.** What makes this run a failure rather than a
   partial success, so a half-finished result is not delivered as done. Keep
   “could not verify” as a third outcome, folded into neither.
5. **Proof of readiness.** The exact commands whose output is the evidence, with
   their output pasted into the report. A claim without its command is a claim
   about the agent's confidence.
6. **State written as it is produced.** Results land on disk when measured, not
   in a final report that a session limit may prevent. A run cut off at hour
   three must leave a successor a starting point, not a transcript.
7. **Self-sufficiency.** Every fact the run needs is inline: measurements with
   their provenance, not links to reports; constraints restated, not cited. A
   prompt that depends on a document the agent may fail to open is not zero-shot.

Also set the run's stopping conditions: retries per failing action, what to do
when a job outlives the turn (wait with a process that wakes on an event, not an
agent asked to watch), and the budget beyond which the agent reports instead of
continuing.

The contract is met when the prompt itself answers three questions: how do I
know I am done, what do I do when I do not know, and what may I write.

## 14. Worked examples

Three real briefs, each failing in a different way. The rewrites show only what
the fix adds.

### Example 1 — unbounded scope

**As received.** “Improve the skills in this repository.”

**Why it fails.** No completion condition, so the run ends when the agent tires.
No write boundary, so it edits skills another agent is editing in the same
half-hour and both lose work. No falsifier, so “improved” is whatever was done.

**As a master prompt, add.** One skill directory as the only writable path, on a
named branch off the current trunk; the specific defect to close, stated so its
absence is observable; the falsifier — if the defect turns out to be already
covered under another name, report where it lives and add nothing; readiness as
command output: `git status --porcelain` empty, `wc -l` on the changed files
before and after, and a grep that finds the new material where it was placed.

### Example 2 — mechanism chosen before the decision

**As received.** “Set up an umbrella repository with submodules for these three
repositories.”

**Why it fails.** It names the mechanism, so the agent skips the choice and
inherits submodule onboarding costs nobody weighed. The three repositories are
leads, not verified context — their lifecycles decide the answer and no one has
looked at them.

**As a master prompt, add.** The decision as the task: compare umbrella with
pinned submodules, specification-only workspace, monorepo, and coordinated
independent repositories against the three repositories' actual release
cadence and ownership, at pinned revisions; publish the comparison table and the
exit criterion for reversing the choice; implement only the selected model. If
the user has already fixed the model, say so and verify its constraints instead
of re-opening it.

### Example 3 — no completion condition and no unknown-handling

**As received.** “Keep working until the build is green.”

**Why it fails.** Green is not defined against a command, so a partial pass is
reported as success. The first unsupplied fact stops the run, because nothing
tells the agent what to do with it. Nothing lands on disk, so a session limit at
hour three loses the whole run.

**As a master prompt, add.** The exact build and test commands with the output
that counts as green, and what counts as failure versus “could not verify”;
instruction to record each unresolved fact as `UNKNOWN` in a named file and move
to the next independent target rather than waiting; results appended to that
file as each one is measured, with tree, revision, and command; a retry ceiling
per failing step and a monitor process for jobs longer than a turn.
