---
name: state
description: Report where work stands as an OKR-shaped brief a busy human reads in ten seconds — one objective line, key results scored achieved / missed / unmeasured, the blocker, and what is needed from the reader, with the evidence below a rule. Use for status on long-running work, standups, handovers, and any "where are we" question; do not use when the answer is a single fact or when the reader asked for depth.
---

# State

The reader gets ten seconds. In them they must see **what is done, what is
stuck, and what is needed from them**. Everything else is evidence: it belongs
in the report, below the rule, where it costs the reader nothing.

Objectives and key results, borrowed as a *shape*, not as a planning cycle. The
key results are not invented per report — they are the cell's acceptance
criteria from the brief (`$cluster-agent-setup` → `task-brief.md`), re-scored
each time. That is what makes two reports on the same work comparable.

## Shape

```
**Цель.** <why this work exists — one sentence, unchanged between reports>

| Ключевой результат | порог | факт | |
|---|---|---|---|
| <what is measured> | <number to beat> | <number measured, and where from> | ✓ |
| <…> | <…> | <…> | ✗ |
| <…> | <…> | не мерил: <why> | ? |

**Вывод.** <syllogism: two premises from the rows above, one conclusion>
**Затык.** <what is blocking — or «нет»>
**Нужно от тебя.** <the decision or access wanted — or «ничего»>

---

**Действия.** <what was done — verbs, not intentions>
**Не сделано.** <what was left, and why>
**Провенанс.** <tree / commit / command behind every number above>
```

Output language follows the conversation; labels with it. The rule `---` and
the three glyphs `✓ ✗ ?` do not translate — a checker reads them.

## The cap is on the head only

**Head: 14 lines, 900 characters, hard.** The tail below `---` is uncapped.

The old cap was 500 characters for the whole report, and it failed: across 79
reports in one initiative not one obeyed it (shortest 1868, median 7833,
longest 58607 — `wc -m` over `reports/*.md`). Evidence had nowhere to go, so
the format was dropped rather than the evidence. Capping only the part a human
reads keeps both.

If the head does not fit, cut a key result — three that matter beat six that
crowd. Never cut **Затык** or **Нужно от тебя**: a report that hides the
blocker is the one failure this format exists to prevent.

## Key results

Three to six rows. Each is a threshold that was declared before the run, and a
number measured against it. "Improve", "faster", "mostly working" are not key
results; `241 s → 76.5 s против порога 120 s` is.

Every number names what it was measured against and where it came from — which
tree, which binary, which commit. A number alone tells the reader nothing about
whether it is good, and one without provenance cannot be refuted.

## The three statuses

| | means | rule |
|---|---|---|
| `✓` | achieved | the fact is `доказано` or `сетка N` with N stated |
| `✗` | missed | it was measured, and the number is short of the threshold |
| `?` | unmeasured | say `не мерил:` and why — never a guess dressed as a verdict |

`?` never collapses into `✗`. "Not run" and "run and failed" are different
facts, and a reader who cannot tell them apart plans the wrong next step.

The evidence words stay: `доказано` (over all inputs), `сетка N` (checked on N
of the author's values, which is not a proof), `на веру` (asserted, not
measured). **A row whose fact is `на веру` is `?`, never `✓`** — that is the
single rule that keeps the third status alive.

## Вывод — a syllogism, not a summary

One conclusion from **two premises already in the rows above**. No smuggled
facts: if the conclusion needs something not in the report, put it in the report
or drop the conclusion. Refusable: if no measurement could contradict it, it is
a mood — delete it. Not a restatement: "работа идёт, значит она идёт" wastes the
one line the reader will actually think about.

## Filled well, filled badly

| Field | Good | Bad |
|---|---|---|
| Цель | `Перестановка окна в стопке должна работать, не отбирая прежних привязок` | `Улучшение оконного менеджера` — no one can score it |
| порог | `rc=0 на ветке и rc=1 на базе` | `должно работать` — no number, no comparison |
| факт | `4 предупреждения, те же, что на базе 0c1621e` | `сборка зелёная` — against what? measured where? |
| статус | `?` + `не мерил: нет мака ни у кого` | `✗` for something never run |
| Вывод | `Ворота дают числа базы, а красная проба на базе падает — значит поведение добавлено, старое не тронуто` | `Всё идёт по плану` |
| Затык | `Ждёт решения: скрипт вне объявленной доли файлов` | omitted because it felt like an excuse |
| Нужно от тебя | `Ничего` | a paragraph of options with no question in it |

## Language

Use the accepted name for a thing — `tail call`, `exit code`, `peak RSS`. Do not
invent a native-language translation for a term that already has one, and do not
use vocabulary private to one project: a state report is read by people who were
not in the room. **If a term appears nowhere outside your own notes, it is
invented — replace it.** Naming an artifact beats prose: `parser.c:2317`,
`exit 3`, `+48 LOC` let the reader go and check.

## Checking it

`scripts/check-state-report.sh <file>`, in the dotfiles repository — head
within cap, every key result carrying a threshold number and a status glyph,
`Затык` and `Нужно от тебя` present, no `✓` on a fact taken `на веру`. It
checks shape, never truth; `--selftest` shows it failing on eight prepared
cases, because a checker nobody has seen fail is one nobody should trust.

## What this is not for

- A single fact. `Проход идёт, 8 ч 12 м` needs no table.
- A request for depth. When the reader asks how something works, answer that.
- Bad news that needs context. Deliver it as prose, then follow with state.
