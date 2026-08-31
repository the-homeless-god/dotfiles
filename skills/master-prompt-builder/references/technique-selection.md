# Technique selection

Every technique below buys one specific failure mode and charges for it. Pick
the cheapest one that closes the failure actually present in the initiative, and
name it in the generated prompt only if the executing agent will do something
differently because of it. A technique nobody can see in the agent's behaviour
belongs in a lecture, not in a prompt.

**Read the cost column as a multiple of one baseline request.** `1×` is a single
pass. `N×` means the agent runs the same work N times. `+1×` means one extra
pass over material it already has. Context cost is charged separately, because a
technique can be free in requests and still crowd out the facts the agent needs.

**The cheapest technique is the one you do not run.** Where a deterministic
check answers the question — run the test, grep the tree, read the file at its
revision, diff the artifact — require the check and no technique. Sampling,
branching, and second passes are for questions no command can settle.

## Catalogue

| Technique | Buys | Pays off when | Costs more than it buys when | Cost |
|---|---|---|---|---|
| **RCTF** | an executor that starts without asking who, what, where, and in what shape | always, as the prompt's skeleton | roles are decorative and the context section is material nobody reads | `1×`, paid in prompt length |
| **zero-shot** | one self-contained text that survives with no follow-up turn | the executor is capable, the format is conventional, and nobody will be there to answer — the unattended run of `prompt-blueprint.md` §13 | the required artifact has a shape prose keeps failing to pin down | `1×` |
| **few-shot** | agreement on the shape of the output *before* the work starts | the artifact's shape is idiosyncratic — report layout, commit subject, table columns, a bad→good rewrite — and one sentence of description keeps being read three ways | the shape is already conventional; examples then anchor the executor to their content and it solves the example's problem instead of yours | `1×` in requests; every example rides in every context |
| **Chain of Thought — public trace only** | a decision a second person can check without re-deriving it | alternatives existed and the choice between them is not self-evident | the task has one path; the trace becomes prose that hides the one line that mattered | `1×` + trace length in the answer |
| **self-consistency** | protection from one confident wrong answer that nothing downstream will contradict | the judgement has no deterministic check, is cheap to recompute, has a discrete answer, and a wrong value propagates silently into later work | a check exists, or the answer is long-form — there is no majority over paragraphs | `N×`, N odd and ≥ 3 |
| **least-to-most** | resumability: work that survives an interrupted session because each step landed | the initiative is long, the steps have a real dependency order, and each one can produce an artifact that outlives the turn | the subtasks must all be held in mind at once to be answered at all; splitting then costs a re-derivation per step | `S×` smaller requests for S steps, strictly sequential |
| **RAG** | current-state claims that survive being checked against the source | the facts live in repositories, revisions, and docs rather than in the model — which is every initiative this skill is for | the source is already inline in the prompt; re-retrieving it burns context to restate what was given | `1×` + one retrieval per claim, paid in tool calls and context |
| **ReAct** | a plan that meets reality every step instead of at the end | the environment can contradict the plan: builds, tests, deploys, live systems | the task is pure composition with no observable to react to | `1×` per step, plus its observation |
| **Tree of Thoughts** | a defensible choice among genuinely open designs | architecture or product direction is open, the options differ materially, and reversing later is expensive | the options are variations of one design, or the decision is cheap to reverse — then pick one and keep the exit criterion | `B×` for B branches, plus `+1×` to prune and publish the table |
| **Chain of Verification** | claims corrected before delivery rather than after | the deliverable asserts things about code, contracts, or state that a reader will act on | nothing is claimed beyond the artifact itself, e.g. a mechanical rename | `2×` minimum — draft plus verification — and `+1×` per correction round |
| **Reflexion / adversarial review** | the failure the happy path never shows | the change touches authorization, money, deletion, migration, or anything with a rollback | the surface has no adversary and no rollback: local formatting, docs | `+1×` per review round |
| **spec-driven development** | traceability from requirement to evidence, and a place to put a decision | the work outlives one session or one agent, and someone else must continue it | the initiative fits one session; the artifacts then outnumber the change | one front-loaded pass, plus keeping the artifacts true |

## Budget the combination

Four techniques at once is not thoroughness, it is `6×` before the first line of
code. When the generated prompt names more than two, state for each whether the
agent runs it **once for the initiative** or **per workstream**, and say which
one it drops first if the budget runs out. A prompt that never says what to drop
gets truncated at whatever the agent happened to be doing.

## Chain of Thought: two different asks, one of them banned

They are not the same request and only one is refused:

- **Hidden reasoning.** Asking the model to reveal, replay, or narrate its
  internal deliberation — “show your thinking”, “think step by step and print
  it”. Never request it, never require it in an output contract, and never
  build a gate on it. This does not change.
- **Public decision trace.** Requiring the *artifact* of the decision:
  alternatives, criteria, chosen option, evidence, residual uncertainty,
  verification results. This is required wherever a choice was made, and it is
  the substitute to write whenever a brief asks for Chain of Thought.

The test is what would happen if the agent decided well and only then wrote the
section. If the section would still be exactly as useful, it is a decision
trace. If it would be considered forged, the prompt was asking for hidden
reasoning — rewrite it.

## Already present under other names

Two of the named techniques are protocols this skill has always required. Use
the familiar name in one aside if it helps a reader place them; do not add a
second vocabulary for a rule that already has one, and never state the rule
twice.

- **least-to-most** is the phase decomposition of `prompt-blueprint.md` §11 plus
  the dependency-ordered `tasks.md` of §9: each step's output is the next step's
  input, and every step has an observable exit criterion.
- **RAG** is the discovery protocol of `prompt-blueprint.md` §5 with the
  knowledge labels of §3: retrieve first, answer from the retrieved text, cite
  the path and revision, and degrade an unretrievable claim to `UNKNOWN`
  instead of to memory.

Two more are demonstrated rather than described: this skill is itself written as
a **zero-shot** instruction — one text, no follow-up turn — and its worked
examples in `prompt-blueprint.md` §14 are its **few-shot** pass.
