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

**Write for a programmer. Standard technical vocabulary, in the form the reader
already knows it.** When a thing has an accepted name — `tail call`, `seed`,
`exit code`, `peak RSS`, `call graph`, `TCB`, `proof object` — use that name.

**Banned: inventing a native-language calque for a term that already has one.**
It reads as expertise to the writer and as nonsense to the reader. This is the
single most common way this format fails, and it fails silently: the reader
stops asking rather than admit they cannot parse it.

Measured examples of the failure, all from one session, all from the same
author, none of them caught by the author:

| invented | what it actually was |
|---|---|
| ячейка Ч127 | a subagent, one task |
| гейт | acceptance criterion |
| сторож | CI check / guard script |
| заявка | a claim in a report, still unverified |
| подделка | adversarial test case |
| изъятие | revert-and-recheck |
| запись / объект доказательства | proof object emitted by the compiler |
| чекер | independent checker (~1800 LOC C) |
| семя / перепечатка | bootstrap binary / rebuilding it from source |
| след ядра | derivation trace field |
| третий исход | exit 3, "could not verify" |

The reader in that session was a programmer and said, verbatim, "я тебя нихуя
не понимаю" — after nine reports. Nine reports of zero value, and each one
looked fine to the writer.

**Rule of thumb: if the term does not appear in the codebase, in a man page, or
in a paper the reader could look up, it is invented — replace it.** A private
vocabulary is not a shorthand; it is a second, undocumented language that only
the writer speaks.

Naming a specific artifact is not jargon: `sverschik.c:2317`, `exit 3`,
`.github/workflows/reprint.yml`, `+48 LOC` are all *more* readable than prose,
because the reader can go look. Prefer them.

Ordinary words for ordinary things. Jargon only where it carries meaning the
plain word does not.

## What this is not for

- A single fact. "Проход идёт, 8 ч 12 м" needs no five labels.
- A request for depth. When the reader asks how something works, answer that.
- Bad news that needs context. A report that must explain itself before it can
  be understood is not state; deliver it as prose and follow with state.
