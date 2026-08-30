# Continuity

Agents do not fail one at a time. Session limits are per account and remove
every agent on that account at the same instant, mid-task, including agents that
had spawned their own children.

## Design for batch death

1. **State on disk as it is produced**, not at the end. A worker cut off
   mid-task must leave usable material behind. Findings written only into a
   final report are lost when there is no final report.
2. **Write the outcome into the task record as soon as it is measured.** Then an
   interruption costs one step instead of the whole task.
3. **Workers do not spawn workers unless instructed.** Children die with the
   parent and report to nobody; the parent's own report never mentions what they
   found. If work needs splitting, the worker says so and the overagent splits it.
4. **Distinguish dead from slow.** An interface listing elapsed time since start
   shows a long-dead agent as long-running. Check status, not duration, before
   concluding an agent is stuck.

## Handover

A successor receives the predecessor's measurements inline, never a pointer to
its report. Template in `task-brief.md`.

Handover is cheap when the stack lives in the task board rather than in the
lead's head. Keep it there: a lead that holds its assignment only in context
cannot be replaced.

## Rotation

| Who is exhausted | Action |
|---|---|
| Worker | overagent relaunches the cell with a resumption brief |
| Lead | promote a worker from that pool; the stack is in the board, so transfer costs nothing |
| Overagent | the cluster stops |

The last row is the reason for the next section. Everything else in this
document degrades gracefully; the overagent is a single point of failure by
construction, because it is the only party holding the whole picture.

## Separate limit pools

A limit that applies per account makes the account the failure domain. Splitting
across independent subscriptions buys continuity, not speed:

- **Overagent on its own pool.** While it survives, the cluster keeps deciding
  even with half the workers gone.
- **Leads on separate pools.** One stalls, the other stack proceeds.
- **Staggered reset windows.** Total standstill stops being possible.

A cluster that halts entirely for hours loses more than a smaller one that never
halts. Size the pools for the outage, not the throughput.

## Watching long work

Long jobs are watched by a monitoring process, not by an agent. An agent told to
watch ends its turn and stops watching; the job then runs unobserved while the
cluster believes it is supervised.

Give the agent preparatory work for that window instead: assemble the command
needed at the finish, and check in advance the things that could make the finish
worthless. Finding out that a run's premise is broken two hours before it ends
is worth more than finding out after.

The monitor must emit on **every** terminal state — success, non-zero exit,
crash, hang, resource kill. A monitor that greps only for the success marker
stays silent through a crash, and silence looks exactly like still-running.
