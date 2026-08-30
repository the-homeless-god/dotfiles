---
name: state
description: Report the state of running work as a fixed-shape brief — Situation, Task, Action, Result, Not done — capped at 500 characters and closed by an explicit syllogism. Use for status on long-running work, standups, handovers, and any "where are we" question; do not use when the answer is a single fact or when the reader asked for depth.
---

# State

Answer "where are we" in a shape the reader can check, not skim. Five labels,
500 characters, one syllogism. Everything that does not fit is not state — it
is narration, and narration is what makes status reports unreadable.

## Shape

```
Обстановка. <what was true before this work>
Задача. <what had to be achieved>
Действия. <what was done — verbs, not intentions>
Результат. <numbers, with what they were measured against>
Вывод. <syllogism: two premises already stated above, one conclusion>
Не сделано. <what was left, and why>
```

Output language follows the conversation. Labels stay in that language too.

## The 500-character cap

Hard. Count them. The cap is the point: a state report competes with the
reader's attention against everything else in their day, and one that needs
scrolling gets skipped — which is worse than not writing it.

If it does not fit, the cut goes to **Действия** first: what was done matters
less than what is true now. Never cut **Не сделано** — an omission that hides
the gap is the one failure this format exists to prevent.

## The syllogism

One conclusion, drawn from **two premises already stated in the report**.
Not a summary. Not a feeling. A step the reader can refuse.

```
Вывод. Проверка прошла и удалила 2783 assert'а; прошлый успешный проход
удалил 1250. Значит доказано вдвое больше, чем неделю назад.
```

Rules that make it worth writing:

- **No smuggled premises.** If the conclusion needs a fact not in the report,
  the fact goes in the report or the conclusion goes out.
- **Refusable.** If no measurement could contradict it, it is not a conclusion,
  it is a mood. Delete it.
- **Not a restatement.** "Работа идёт, значит она идёт" wastes the only line
  the reader will actually think about.

## Numbers

Every number names what it was measured against — a previous run, a ceiling, a
declared target. A number alone ("1516 млн вызовов") tells the reader nothing
about whether that is good.

Say where it came from when the reader could not otherwise tell: which tree,
which binary, which commit. A number whose provenance is unstated cannot be
reproduced or refuted.

## Language

Standard technical vocabulary. When a thing already has an accepted name —
`tail call`, `seed`, `runtime assert`, `exit code`, `peak RSS` — use it.
Inventing a native-language translation for a term that already has a name is
the failure this rule exists to stop: it reads as expertise and lands as
nonsense.

Ordinary words for ordinary things. Jargon only where it carries meaning the
plain word does not.

## What this is not for

- A single fact. "Проход идёт, 8 ч 12 м" needs no five labels.
- A request for depth. When the reader asks how something works, answer that.
- Bad news that needs context. A report that must explain itself before it can
  be understood is not state; deliver it as prose and follow with state.
