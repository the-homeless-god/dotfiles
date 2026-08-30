# Failure catalogue

Failure modes observed in production clusters. Each one looked like success at
the time. Use as a review checklist before declaring a cluster result.

## Measurement

| Failure | How it presents | Guard |
|---|---|---|
| Measured in the wrong tree | a correct fact, confidently wrong conclusion — "that commit does not exist" when it exists in the sibling repository | provenance: tree, binary, commit, on every number |
| Two variables changed at once | a run differs from its predecessor in both tooling and input; the result attributes to neither | change one, or measure the isolating case first |
| Summing nested totals | a per-file total that also counts everything the file imports; tree-wide inflation of several times over | know what the tool's total covers before adding any two |
| Quoting the small half | a table where one entry is 93% — of the counter that is 8% of the work | always state what the percentage is a share of |
| Wall-clock across days | the same file takes 9 minutes and 7 hours on a loaded machine | report load beside duration, or compare counters instead |

## Verification

| Failure | How it presents | Guard |
|---|---|---|
| Decorative check | a test that passes against deliberately broken code | demonstrate every new check failing before accepting it |
| Bad and unchecked collapsed | a non-zero exit reported as "broken" when it meant "could not run" | three outcomes, never two |
| Watchdog on an invented string | a monitor grepping for a word the tool never emits; permanently green | take the string from the tool's source |
| False alarm from quoted errors | searching whole output for an error code, which reports quote | match the response's top-level key, not a substring |
| Success-only watcher | silence through a crash, indistinguishable from running | match every terminal state |

## Build and artifact

| Failure | How it presents | Guard |
|---|---|---|
| Merged but not built | an optimization in source that never reached the artifact; two consecutive runs pay the old cost by construction | verify at the artifact, not the diff |
| Built outside its tree | module resolution is relative to build location; the binary finds nothing and fails after tens of hours | build in-tree |
| Missing an exemption by path | a resource watchdog spares exactly one command pattern; a job run from another directory is unprotected and survives by luck | check what the guard actually matches |
| Output overwritten by the next step | the only clean profile in the project's history, overwritten six seconds after the run finished | snapshot valuable output at the moment it exists |
| Settings block dropped | a stack array silently shrinks and smashes the stack | copy the whole settings header, not the parts that looked relevant |

## Coordination

| Failure | How it presents | Guard |
|---|---|---|
| Advisory lock believed binding | nothing reads the lock file; it is a note to humans, and its records expire before the job does | verify what enforces a boundary before relying on it |
| Overlap defined by topic | two agents write one file, last writer wins, silently | define overlap by files written |
| Blocking on a gate that no longer exists | tasks marked "ask the run lead" after the run finished | mark with a condition, not a person; clear marks when the condition lifts |
| Shared account, broad process kill | one pattern-matched kill removes an entire shift's jobs | never kill by pattern; use the scheduler's own release |
| Sweep rollback | touching generated paths during an automated merge discards every other merge in that pass | land such changes under the same lock the sweep uses |

## Reporting

| Failure | How it presents | Guard |
|---|---|---|
| Done but invisible | finished work uncommitted, unpublished, or unreported for days | "merged and visible" is the definition of done |
| Recommendation read as event | a tool printing a suggested next version every run, quoted as if it had happened | distinguish state from event in both directions |
| Over-correction | a claim retracted for weak evidence, then confirmed by a clean measurement | retract the evidence, not the hypothesis; say which |
| Rule written, never run | checks referenced in documentation for months after being deleted | a rule nothing executes is not a rule |
