---
name: bilingual-documentation
description: Keep a repository's own documents in two languages as paired surfaces stating the same facts, with the README routing to them rather than restating them. Use when a tree documents itself in more than one language, when a document exists on one surface only, or when a number in a document can no longer be reproduced by the command it names; do not use for product UI localisation, marketing copy, or reference generated from source.
---

# Bilingual Documentation

Two surfaces, one set of facts. A reader who switches languages must land on the
same numbers, the same commands and the same refusals. When the surfaces
disagree, one of the two readers is being told something wrong with confidence,
and neither can find out which — the other surface was the only thing either of
them could have checked against.

## Boundary

The subject is the documents a repository writes about itself: README,
contributing rules, `doc/`, design notes, runbooks, specs. Product strings,
marketing pages and reference generated from source are not — they have their
own pipelines, reviewers and definition of correct.

The deliverable is the pairing rule, the router, and the check that catches
divergence. Producing a translation is separate work. Where there is no
translation yet the answer is a stub that says so, never a machine draft
published as a reading.

## Which surface takes the bare name

There is no repository-wide answer, and imposing one breaks whichever half of
the tree already had a rule. The suffix marks the **secondary** surface, and
which surface is secondary is decided per artifact class by the tool that reads
it. Three arrangements below are all live, and the first two are in one
repository:

| Artifact class | Bare name | Suffixed | Decided by |
|---|---|---|---|
| prose docs of a fork whose upstream and manual pages are English-only | English `x.md` | `x.ru.md` | the language an outside contributor arrives in |
| the executable specification the same repository owns | Russian `x.fts` | `x.en.fts` | the canonical model is written in Russian and the contributing rules name it the source of truth |
| a Hugo content tree | Russian `x.md` | `x.en.md` | `defaultContentLanguage = "ru"` with `defaultContentLanguageInSubdir = false` |

Read the tool's default before naming a file. Backwards in a site generator, the
build serves the wrong language at the bare URL; backwards in a prose tree, the
suffixed file is the one everyone reads while the bare one rots unnoticed.

When the bare name is already taken by a router — `README.md` pointing at
`docs/en.md` and `docs/ru.md` — both surfaces carry a suffix. Same rule, not a
fourth one: the router is not a member of the pair.

## Rules

**Pair, do not fork.** Each surface links to the other in its first lines. A
document reachable from one language only is a document the other language's
readers will re-derive, wrongly.

**A difference in facts is worse than a missing translation.** Write that rule
into the contributing document as a numbered step of the change itself, in the
wording it has to be obeyed in:

> **The documentation**, in both languages. `doc/*.md` and `doc/*.ru.md` must
> say the same thing: **a difference in facts is worse than a missing
> translation.**

A missing translation is visible to the reader. A divergence is not: it looks
like documentation right up to the moment someone acts on the wrong half. That
is why a stub beats a guess, and why a number changed on one surface is an
unfinished change rather than a small remaining task.

**Every number names the command that prints it, and a number no command prints
does not go in.** `| lines in ribbon.c | 1542 | wc -l ribbon.c |` can be refuted
in one line by any reader; "about 1500 lines" cannot, and it goes stale quietly.
One document carried "2871 vectors" on both surfaces for months — a conformance
count taken before a tenth model existed, plus a run no command in the tree
produces. Today the tree answers `jq -s 'map(length)|add' fts/vectors/*.json`
with 214. Nothing could contradict the old number, so nothing did.

**The README routes; it does not argue.** A short statement of what the thing
is, the commands a developer runs, and a table of documents with one line each
saying where to go. Reasoning, measurements and rejected alternatives belong in
`doc/`. A README that explains the design becomes a second place the facts are
stated, and a second statement drifts from the first.

**State a decision once and link to it.** A panel document promised the panel
starts from `~/.config/<wm>/autostart` while the session document had recorded
the opposite decision — it does not start at login, a key combination raises it.
Two surfaces times two documents is four places to be wrong in; one place and
three links is one.

**A stub is a promise not to pretend.** Generate one per untranslated source
page: a fixed 19-line body, an explicit `status: stub`, `noindex`, and a link to
the original — against sources of 138 to 399 lines. It exists so cross-references
resolve and the reader gets an honest page instead of a 404, not so a coverage
count can call it a translation. In the tree that pattern comes from, 1225 of
1269 second-surface files are stubs, 38 are machine output and 6 are human-read.
Report the three separately or the coverage number means nothing.

## What catches divergence, and what does not

| Mechanism | Catches | Misses |
|---|---|---|
| structural comparison of a translation against its source | code blocks, shortcodes, link targets, formulas and HTML byte-for-byte; pipe count per table row; heading-level sequence; script ratio ≤ 2 % per file and ≤ 30 % per paragraph; per-segment length corridor [0.7, 1.4] above 200 characters; cross-reference resolvability; glossary terms that must not be translated | meaning. Matching markup and matching length while the two assert different things passes clean |
| a `source_sha256` stamp on the translation | the source edited afterwards. Human-read plus stale hash fails the build; machine-drafted plus stale hash reports; stubs are exempt | a stamp moved by hand — so move it only by a command that re-runs the structural checks first and refuses when they fail |
| a skeleton check over two spellings of one model | numbers, operators, and the order of rules, in CI | prose. It reads the specification directory, not `doc/` |
| CI over the prose documents | in most trees, nothing at all — check before assuming otherwise | everything above. Prose divergence is caught by a person or not at all |
| a document table in README or CONTRIBUTING | nothing on its own | the directory growing past it |

The gap is the same everywhere: **no mechanical check compares two surfaces for
what they assert.** Everything automatable compares shape. So put the shape
checks in CI, and make the assertions the responsibility of the commit that
changes them — which is why the documentation is a numbered step of the change
and not a follow-up ticket.

## How it breaks

Each of these shipped on both surfaces and read as correct at the time.

| Failure | How it presents | Found by |
|---|---|---|
| A number diverges between surfaces | one surface says nine policies, the other ten | counting three ways — `grep -c '^ribbon_policy_' ribbon.c`, the declarations in the header, `nm ribbon.o \| grep -c ' T ribbon_policy_'` — all 10 |
| A self-checking number goes stale | the document names `wc -l ribbon.c` and prints 1221; the tree says 1542 after three merged changes | running the command the document itself names |
| A number nothing produces | "2871 vectors", where the tree prints 214 | asking which command prints it and getting no answer |
| The document table lags the directory | three documents present in `doc/` and linked from other documents, absent from the table | `ls doc/*.md` = 24 files = 12 pairs, compared against the table in both directions |
| The router misses a document in both languages | a whole porting plan unreachable from either README | walking the router as a reader, not as its author |
| A document contradicts another document | one promises autostart, another records the decision not to | reading the two together, which nothing forces |
| A stub counted as a translation | 7 files of 19 identical lines reported as coverage | splitting the count by translation status |
| A subtree outside the rule | a file in the bare-name slot, which in that tree means English, measuring 77.8 % Cyrillic against 0.2 % for every paired document | measuring the script ratio per file instead of trusting the extension |

## Verification

Before calling the documentation consistent, run and report:

- the pair inventory in both directions — every bare-name document has its
  counterpart and every counterpart has its source; unpaired ones as a number,
  not as "mostly done";
- the router against the directory both ways: no table row without a file, no
  file without a row;
- every command a document names, executed, its output set against the printed
  number;
- coverage split by status: translated, machine-drafted, stubbed, absent;
- for each cross-document claim, the single place the decision is recorded.

Report what diverged, what was reconciled, and what is untranslated. The last is
a result rather than a failure, and the one a stub count must never hide.
