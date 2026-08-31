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

Standard technical vocabulary, in the form the reader already knows it. When a
thing has an accepted name — `tail call`, `seed`, `exit code`, `peak RSS`,
`call graph`, `TCB` — use that name.

**Do not invent a native-language translation for a term that already has one.**
A calque reads as expertise to the writer and as noise to the reader, and the
failure is silent: readers stop asking rather than say they cannot parse it.
The same applies to vocabulary private to one project or one team — a state
report is read by people who were not in the room.

Test before sending: **if a term appears nowhere outside your own notes — not in
the code, not in a man page, not in anything the reader could look up — it is
invented. Replace it.**

Naming a concrete artifact is not jargon and is usually better than prose:
`parser.c:2317`, `exit 3`, `--no-verify`, `+48 LOC` let the reader go and check.
Prefer them.

Ordinary words for ordinary things. Jargon only where it carries meaning the
plain word does not.

## What this is not for

- A single fact. "Проход идёт, 8 ч 12 м" needs no five labels.
- A request for depth. When the reader asks how something works, answer that.
- Bad news that needs context. A report that must explain itself before it can
  be understood is not state; deliver it as prose and follow with state.
