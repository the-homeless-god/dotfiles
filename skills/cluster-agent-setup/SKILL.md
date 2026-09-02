---
name: cluster-agent-setup
description: Design and operate a multi-agent unit — one overagent, two lead agents, and worker pools — for long-running engineering initiatives. Use when work must split across many concurrent agents, when a shared account makes write collisions likely, or when agents die in batches on session limits and must resume without re-deriving measurements; do not use when one agent finishes the work in one session.
---

# Cluster Agent Setup

Run many agents on one initiative without duplicating work, losing measurements,
or exhausting the single context that holds the whole picture.

## Boundary

The deliverable is the operating structure — roles, write boundaries, briefs,
reporting contract, continuity plan — not the initiative itself. Spawning agents
costs real budget; size the cluster to the work, not to the pool.

A brief cannot grant a worker permissions the invoking user lacks. Irreversible
and outward-facing actions stay with the overagent regardless of who found the
need: merges to trunk, tags, releases, shared-tooling replacement, changes to the
user's own configuration, anything published.

## Roles

| Role | Count | Owns | Must not |
|---|---|---|---|
| Overagent | 1 | goal, priorities, merges, irreversible acts, cluster shape | search, read large files, run long jobs |
| Lead agent | 2 | one non-overlapping stack, one pool of ~20, triage of their reports | merge to trunk unprompted, write outside its stack |
| Worker | ~20 per pool | one cell of work, carried to a number | spawn further agents unless told to |

The overagent's context is the scarce resource, not tokens in aggregate: it is
the only party holding the whole picture, and every unnecessary word read
displaces the state needed to decide. Two leads, not one, because one recreates
the same bottleneck; not five, because stacks that never collide are rare.

## Workflow

1. Normalize the initiative into stacks. A stack is defined **by the files it
   writes**, never by topic. A long task may cite dozens of files as evidence —
   that is not overlap. Overlap is two agents writing one file.
2. Assign every contested file exactly one owner and record it. "They will
   coordinate" is not a boundary; on a shared account it becomes silent
   overwrites.
3. Build the work matrix: rows are stacks, columns are `measure | change |
   verify | publish`. A worker gets a **cell**, not a theme. "Measure what stage
   X costs" is a cell; "look into performance" is not.
4. Size effort per cell. Mechanical edits from a known recipe run cheap;
   diagnosis of an unexplained failure runs at the highest tier available. A bad
   diagnosis sends the whole cluster the wrong way for hours and always costs
   more than the diagnosis would have.
5. Write each brief with [references/task-brief.md](references/task-brief.md)
   (RCTF: role, verified context, concrete task, output format). For a brief
   that must survive without its author, generate it with
   `$master-prompt-builder`.
6. Plan continuity before launching, not after the first batch dies. See
   [references/continuity.md](references/continuity.md).
7. When the initiative spans several independently versioned repositories, apply
   `$umbrella-repository-setup` first and give every worker the umbrella's
   pinned revisions, instruction precedence, and component write boundaries.
   Cluster roles map onto that model directly: the overagent owns the umbrella,
   a lead owns a component group, and writing inside a component repository
   still requires that repository's own authorization, branch, and PR. Take the
   cells from the umbrella's tracker where one exists — see "Standing work
   between initiatives" — rather than re-deriving them from conversation.
8. Before declaring any cluster result, review it against
   [references/failure-catalogue.md](references/failure-catalogue.md). Every
   entry there presented as success at the time it happened.

## Standing work between initiatives

A cluster ends; the work it did not finish does not. A cluster board and the
reports under it die with the cluster, and a board kept outside version control
dies with the machine — so anything that outlives the initiative goes into a
tracker in the tree: one task per file, the status changed by a commit, `git
log` answering who and when.

Measured, not assumed: eight open items carried in conversation rather than in a
tree were checked against the trees a week later, and **three of the eight had a
wrong number or a wrong attribution** — 43 scenarios recalled as 23, 17 stale
pages recalled as 6, a fix attributed to a repository that had no such page at
all. Nothing was written down, so nothing could be refuted.

Three rules keep the tracker from becoming the next thing that lies:

- **A task names the component it belongs to, and that component is pinned.**
  Without a revision, a number in a task cannot be reproduced or refuted. This is
  the report's provenance rule, applied a week earlier.
- **The number of a task is derived from its name, never taken as "next free".**
  Two branches cut from one base, each computing the free numbers, handed out
  seven identical task numbers in one day; a number derived from the name has no
  shared mutable state and so has none of what breaks around one.
- **The tracker's check has been seen to fail.** A guard that has only ever been
  green is indistinguishable from one that checks nothing — see the failure
  catalogue. Break a temporary copy on purpose and require red on each fault.

The circle, both ways:

| stage | what moves |
|---|---|
| lead takes a task | status → in progress, owner, branch — in its own commit, **before** dispatch, or a neighbour takes the same one |
| task becomes a brief | body with numbers → `KNOWN`; component and its write boundaries → `BOUNDARIES`; other open tasks on the same component → `NEIGHBOURS`; the task's "how to know it is done" → the key results, with their thresholds |
| worker returns | a `$state` report scoring those same thresholds `✓ ✗ ?` — the thresholds are not re-invented per report, which is what makes two reports on one task comparable |
| lead closes the task | status → done, naming the component commit that did it, verified at the artifact, not at the source |
| what did not fit the cell | a new task, not a paragraph in a report nobody will re-read |

A task in the umbrella grants no write access to the component it names: that
still goes through the component's own branch, authorization and PR.

## Core invariants

- **Claims are falsifiable or they are not claims.** Every reported number names
  the tree, the binary, and the commit it was measured on. Without that a result
  cannot be reproduced or refuted — and an agent that reports a correct fact
  measured in the wrong repository is indistinguishable from one that is right.
- **A hypothesis is stated before the measurement that tests it**, and a measure
  that could disconfirm it is named in advance. Post-hoc explanation of a number
  already seen is not evidence.
- **Two variables never change at once.** When a run differs from its
  predecessor in both tooling and input, its result attributes to neither until
  they are separated.
- **Negative results are results** and are reported with the same weight. So is
  "could not verify", which is a third outcome and never folded into failure: a
  check that cannot distinguish *bad* from *not checked* is not a check.
- **Merged is not working.** An optimization that reached source but never
  reached the built artifact has not been tested. Verify at the artifact.
- **Done but invisible is not done.** Work that is finished and unmerged,
  unpublished, or unreported is indistinguishable from work never started, and
  is the most common way a cluster loses days.
- **Wait with a process, not an agent.** An agent asked to watch ends its turn
  and stops watching. Long jobs are watched by a monitor that wakes on an event.
- **A watcher matches every terminal state**, not the success marker alone.
  Silence on crash is indistinguishable from silence while running.
- **Search for the string the tool actually emits.** Grepping for a word invented
  by the operator produces a permanently green watchdog.

## Reporting contract

Every report at every level is written to `$state`, and that skill is the only
place the shape is defined — a second shape stated here would drift from it.
What this skill adds is where the key results come from: **the brief declares
them, the report scores them.** A cell whose brief named no threshold cannot be
reported on, only narrated about.

Two parts of the evidence tail are mandatory and their absence makes a report
incomplete:

- **Provenance** — tree, binary, commit for every number.
- **What I did not do and why** — including scope deliberately left, blocked
  actions, and anything believed on someone else's word rather than measured.
  Believed-on-word is `?`, never `✓`.

Numbers come from runs. A number that cannot be confirmed is named unconfirmed
rather than printed. "Faster" is as defective as "seems fine"; report `241 s →
76.5 s`.

## Overagent economy

- Never read a worker's transcript. It overflows the one context that matters.
- Workers return conclusions and commands, not material to be read.
- The overagent does not do what can be delegated. Reading a file to learn
  something is the signal that the wrong party is working.

## Output contract

Unless asked otherwise, return:

1. the stack split with contested-file owners named;
2. the work matrix with cells assigned and effort tiers;
3. briefs ready to dispatch, one per cell;
4. the continuity plan: state location, handover template, rotation rule;
5. the failure catalogue this cluster must not repeat;
6. where standing work goes when the cluster ends — the tracker entries opened
   for what was found and not finished, named by number.

Record the structure in the project's existing convention. Root `AGENTS.md`
carries shared routing and safety rules; component `AGENTS.md` files stay
authoritative inside their paths.
