---
name: write-post
description: Write or repair an article on a documentation portal — a page a stranger opens to learn something, where the conclusion and its numbers stand on the first screen, terms keep the spelling the reader can search for, and one section names where the knowledge ends. Use for a study, a write-up of how something works, or any post handed back as "not written for humans", "a small article about nothing" or "AI slop"; do not use for a tool's own section (that is $tool-section-page), for reference generated from source, or for a status report (that is $state).
---

# Write Post

An article is read by a stranger who came for an answer. Six rules; each is
priced by a rewrite that was sent back the same day it shipped.

One article, `/post/prompting-study/`, was rewritten four times in two days.
Four failures, four rules. Rules 5 and 6 are what finally held.

## Shape

```
# Title — the conclusion the page holds TODAY, in searchable terms
  two paragraphs: why a stranger would read this
## N answers up front      <- table: question | answer | where the number came from
  one sentence of rule, for the reader who stops here
## …the body…              <- what worked and what did not, side by side
## Чего мы не мерили       <- the border of the knowledge. Never optional
  one closing line: what this page said yesterday, if it said something else
```

Method — thresholds, intervals, provenance, how to repeat the run — lives in
boxes for the reader who asked for it, never in the main layer.

## 1. The title carries the conclusion the page holds today

A title outlives the paragraph it was taken from. When the numbers change, the
title is the first thing rewritten, not the last.

*Price.* `prompting-study` was remeasured and its text corrected, and the title
stayed `Ни один приём не выиграл` — the conclusion we had ourselves declared
wrong. In the article list the reader saw the refuted claim and nothing else;
the standing conclusion lay three screens down, behind our own post-mortem
(`a7e3052f`).

## 2. The first screen is the answer, not our history

The reader did not come for the story of how we got it wrong. Put the answer,
its numbers and one line of "what to do with this" above everything else.

Hiding the correction is worse than leading with it — yesterday somebody read
the opposite claim here. It gets **one line**, at the end, and the old numbers
go in a box, printed in full.

*Price.* A version opened with `правка от 2 сентября`, a section called
`Ошибка`, and a paragraph headed `короткий ответ, если читать нечего больше`.
Returned as "not written for humans at all". The rewrite pushed the post-mortem
to the last section and cut the main layer from 13 199 to 9 546 characters,
`ru`, with 8 821 moved into boxes rather than deleted (`30a0eb88`).

## 3. Keep the term the reader will search for

Use the accepted spelling — `self-consistency`, `baseline`, `few-shot`,
`cgo`, `submodule`. Explain it once, in one sentence, at its first appearance,
and use only the term after that. A term of your own invention is named as
yours, so nobody goes looking for it in someone else's writing.

*Price.* One pass translated every term into Russian: `ответ большинством из
пяти` for self-consistency, `голый вопрос` for baseline. Both are unsearchable
and appear in no other article — the reader lost the one handle they had for
digging further. The repair reduced `голый вопрос` to 0 occurrences and
introduced nine techniques by name, each with a one-line gloss (`70faf63d`).

## 4. Show where the knowledge ends

A section that lists what you did **not** measure, in the reader's words, with
no softening. Negative and undecided results stand beside the positive ones in
the same table, not in a footnote.

Without it a reader cannot tell a narrow result from a general one, and the
article reads as small whether it is or not.

*Price.* A version showed one measurement out of nine and said nothing about
the other eight — returned as "a small article about nothing". The fix brought
in all nine, added `Чего мы не мерили` (11 items, including a flat "we never
once measured this") and `Где наши отчёты спорят сами с собой` (7 divergences,
both numbers named for each), and grew the file by 884 lines (`5aa68840`).

## 5. Give something to copy, and a command behind every number

Print the real thing — the prompt, the command, the block of code — so the
reader can copy it and get the same result. A description of a prompt is not a
prompt.

Every number in the article names the command or the file that prints it. A
number no command prints cannot be refuted, so it ages silently and nobody
notices. Prefer a run over a claim: `wc -l`, `grep -c`, an exit code.

## 6. Method goes in the developer's box

Two reading modes, declared in the front matter. The main layer answers "what
do I do"; the box answers "how do you know". The main layer carries no interval
notation, no threshold vocabulary and no provenance strings — those are what
the box is for, and the article is still complete without opening one.

*Price.* Both failures 2 and 4 were the same layering error from opposite
sides: method in the main layer once, method missing entirely the next time.

## Checking it

`scripts/check-post.sh <file>`, in the dotfiles repository — one H1, a first
screen inside its cap and carrying numbers, a border section, a negative result
named, something copyable, our own history not on the first screen, and every
Latin term declared and explained at first use. The gloss test is proximity —
it sees that an explanation *could* stand where the term first appears, not that
it does — so read the first appearance yourself. It checks shape, never truth;
`--selftest` shows it failing on eight prepared cases, and the seven rejected
versions of `prompting-study` in git history all fail it while the accepted one
passes — a checker nobody has seen fail on real work is one nobody should trust.

Numbers the author answers before publishing, in the commit message — the
script prints all of them with `--report`:

- prose characters in the main layer, and in the boxes, per edition;
- numbers on the first screen (never 0);
- terms declared, and terms explained at first use (the two must be equal);
- items in `Чего мы не мерили` (never 0);
- claims about code, and how many of them a command in the tree confirms;
- diagrams, and for each one, what it shows that the prose does not.

## Checklist

- [ ] the title states today's conclusion, in searchable terms;
- [ ] answer and numbers above the first `##`, our post-mortem below the last;
- [ ] each term glossed once at first use; invented terms marked as ours;
- [ ] `Чего мы не мерили` present, with the flat "we never measured this" cases;
- [ ] negative results in the same table as the positive ones;
- [ ] every number names the command that prints it;
- [ ] both editions rebuilt, translation fingerprint restamped, gates compared
      against the same run on the trunk before calling a red one yours.

## Where this was learned

The Digitable courses portal (Hugo): `content/post/prompting-study.md` and its
`.en.md` pair are the article those four rewrites produced — read the commits
`a7e3052f`, `30a0eb88`, `70faf63d`, `5aa68840` for the failures in order.
`AGENTS.md` §4 holds the paired-language rules and the "a number names the
command that prints it" rule this skill borrows.
