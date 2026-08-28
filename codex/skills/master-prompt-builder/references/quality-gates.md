# Master prompt quality gates

Run these gates after drafting. Revise the prompt when a material item fails.

## Intent and scope

- The objective can be stated in one sentence.
- Outputs, outcomes, evidence, gates, and non-goals are distinct.
- User-supplied product choices and terminology are preserved.
- The prompt does not silently expand implementation scope.
- Optional/future work cannot be mistaken for the current Definition of Done.

## Evidence

- Every material current-state claim has a source or an uncertainty label.
- URLs and repository paths are treated as leads until inspected.
- Current code, documentation, inference, and proposal are distinguishable.
- Source conflicts have an explicit resolution order.
- Missing access degrades to a named gap rather than fabricated completion.

## Executability

- Another agent knows where to start, what to inspect, and what to produce.
- Phases follow dependency order and have observable exit criteria.
- Required files, tests, diagrams, and reports answer specific requirements.
- Retry and blocker behavior has a stopping condition.
- The final response contract is compact and auditable.

## Reasoning quality

- RCTF is concrete rather than ceremonial.
- ReAct actions are bounded and followed by observation/verification.
- Alternative analysis is required only for meaningful choices.
- Selection criteria prevent “choose the fanciest design” bias.
- Verification questions are derived independently from requirements.
- The prompt asks for public rationale and evidence, never hidden chain-of-thought.

## Safety and authorization

- Read-only research, local changes, and external mutations are separated.
- Destructive cleanup, deploy, publish, merge, secret changes, and production
  operations do not inherit authorization from the prompt.
- Dirty worktrees and unrelated edits are preserved.
- Secret values and sensitive payloads are excluded from logs, prompts, reports,
  screenshots, and committed artifacts.
- Identity, authorization, privacy, and rollback are explicit where relevant.

## Cross-repository work

- Every component is tied to an exact revision and instruction scope.
- Repository-model choice is justified rather than assumed.
- Component source changes cannot hide inside an umbrella-only deliverable.
- General and component-specific skills have different owners and locations.
- Technical debt is linked to a capability or has its own decomposed plan.

## Verification and completion

- Acceptance scenarios cover success, failure, degraded, and adversarial paths.
- Requirement-to-code/test/evidence traceability is possible.
- “Implemented”, “deployed”, “published”, and “verified in production” are
  separate states.
- A failed optional integration cannot corrupt deterministic/core output.
- Completion is based on evidence, not document length or confident prose.

## Compression pass

Delete or merge text that:

- repeats global agent policies without task-specific value;
- assigns decorative roles that do not change decisions;
- mandates tools or diagrams unrelated to requirements;
- duplicates the same rule across multiple sections;
- specifies an arbitrary number of steps, agents, tests, or alternatives;
- embeds source content that should instead be referenced;
- sounds sophisticated but has no observable effect on execution.

A “giant” master prompt is successful when it is comprehensive because the
initiative is complex, not because it maximizes tokens.
