# Task brief (RCTF)

A worker brief has four parts and five required contents. A brief missing any of
them returns an unverifiable answer.

## Role

Name what the worker is and what it decides. Name the actions reserved to the
overagent so the worker does not stall waiting for permission it will not get,
and does not take permission it does not have.

## Context

Everything already established, stated as fact with provenance, so the worker
does not re-derive it:

```
KNOWN: <numbers, with tree / binary / commit>
NEIGHBOURS: <who else writes these files right now>
BOUNDARIES: <what must not be touched, and why it costs others>
```

Give measurements, not links to reports. A worker sent to read a predecessor's
report spends its context on prose instead of work.

## Task

One cell of the matrix, phrased so its completion is observable:

- `measure` — which number, by which command, compared against what;
- `change` — which behaviour, proven by which failing-then-passing check;
- `verify` — which claim, and what would refute it;
- `publish` — which artifact, checked live rather than at the source.

State the falsifier. "Find out whether X causes Y" must be accompanied by "if X
does not cause Y, the run shows Z instead."

## Format

- Situation → Task → Action → Result, capped at 40 lines.
- Provenance for every number.
- Final paragraph: what was not done and why.
- Negative and "could not verify" outcomes reported as results, never as
  failure or silence.

## Required contents

1. **The cell**, not the theme.
2. **What is already known**, so nothing is re-opened.
3. **Boundaries and neighbours** on the same files.
4. **Site rules** whose breach costs other people's work — process-killing
   commands, forbidden temp locations, generated files that must not be
   hand-edited, naming rules, resource declaration for scheduled jobs.
5. **The definition of done** as a number or a command's output.

## Resumption brief

When relaunching after a batch death, the brief carries the predecessor's
measurements inline:

```
Continuation of work cut short by a session limit.
FOUND: <predecessor's measured numbers, with provenance>
STOPPED AT: <the next single action>
DO NOT RE-OPEN: <what is already confirmed>
```

This is the difference between losing one step and losing the whole task.

## Anti-patterns

| Brief says | Worker returns |
|---|---|
| "look into performance" | a survey, no number |
| "the report is in /path" | context spent reading prose |
| "fix if needed" | a change nobody can evaluate |
| "verify it works" | the success path only |
| no falsifier | confirmation of whatever was assumed |
