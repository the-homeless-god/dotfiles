---
name: tool-section-page
description: Build or repair a tool's own section on a documentation site — a page that opens with the tool working, fits one viewport, and claims nothing the tool does not do. Use when a tool needs a section, when an existing one reads as an article, or when its screenshots, claims or panel links have gone stale; do not use for course chapters, blog posts or reference docs, which are prose by design.
---

# Tool Section Page

A tool's section shows the tool. Six rules; each was paid for by a section that
shipped broken and stayed broken for months.

## Shape

Tabs on one shared module, one panel visible, **the demonstration first**:

```
[ In action ] [ What it is ] [ Getting started ] [ Limits ]
      ^ opens by default — real frames of a real run
```

Order is narrative, not alphabetical: show, explain, let them start, bound it.
The sentence answering "why would I want this" lives in the page header, visible
on every panel — not on a tab the reader has to find.

## 1. Show first

The first thing on screen is the working thing, not a paragraph.

*Price.* Three sections in one day had it backwards. `/digitdisk/` kept its
frames on the third tab and opened with prose — they were served, 200, 52/40/22
KB, and nobody saw them. `/digit/` still does. `/digitwm/` was a 25.9-viewport
document with its first frame 60 px below the fold. Which panel opens first is a
free choice, and all three made it against the reader.

## 2. The page must not lie

Every claim is one the tool keeps *today*; frames and prose name one version.

*Price.* `/digitdisk/` promised "deletes nothing" in 19 places for half a year
after the tool learned to delete. `/ouroboros/` carried a whole experiment copied
word for word from a course chapter, so the same numbers had two homes and drifted.

Numbers come **from the tool's own measured state** — read them out of the file
its own gate writes and carry them into the page through the shot manifest.
A number typed into a template goes stale silently.

## 3. Direct links are verified by a run

Every panel has an address, and every address is opened in a browser before you
claim it works — long form and short form.

*Price.* On `/digitdisk/` four addresses out of four opened the first panel: the
tabs module was initialised without the hash. A year, under a green gate.

Contract: the server prints plain `<a href="#name">` and **no `hidden`**; the
module assigns roles, `hidden` and focus; the address is rewritten by
`replaceState` only. With JavaScript off the section unrolls into a readable
strip — that is the test that nothing was hidden server-side.

## 4. One viewport is a rule, and it is measured

```js
documentElement.scrollHeight <= documentElement.clientHeight + 1   // at 1280×800
```

Both editions, both widths (1280×800 and 390×844), before and after, four numbers
in the commit message. A panel may scroll inside its own box; the **document**
may not. Overflow inside a panel gets a second rail, one item per switch, with
nothing removed from the DOM — hide only the inactive panel, or the section
leaves print, in-page search and search results.

*Price.* `/digitwm/` measured 20 746 px — 25.93 viewports — while its own suite
checked only width. A green gate proves what it measures and nothing more.

## 5. Frames are shot by a script that lives in the tree

The script runs the released build, captures its real output into a data file,
and renders the frames from that file. Script and data are both committed.

- Shoot the **tagged release the prose talks about**, not `HEAD`. If a release
  changes what the page says in words, fix the words first.
- Sandbox the run when the output would carry your paths, hostnames or
  processes: a sandbox changes the *scene*, editing the text changes the *truth*.
- Keep the same output as text beside the frame, collapsed — for in-page search,
  screen readers and copying.
- The caption names what came from the run and what rendering added (font,
  colour, line wrapping).

*Price.* Frames typed by hand, or shot once by a person, age silently: nothing
fails, the page just stops being true.

## 6. The English edition shows English output

Translate the site's own words, never the tool's printout — a retelling is not
output. Which frame the English page gets follows the tool, not the page:

- the tool prints one language only → the same frame in both editions, and the
  caption says why it is the same;
- the tool takes a locale → shoot every frame twice and pick by reader language.

*Price.* An English page showed Russian output under a caption that admitted it
— "digitdisk prints Russian only". The caption was honest and the page was still
wrong: the tool had grown a `--lang` flag, and nobody re-shot.

## Checklist

- [ ] heights before and after, both editions, 1280×800 and 390×844;
- [ ] every panel address opened in a browser, plus what opens with no address;
- [ ] frames re-shot by the script; version and commit printed under them;
- [ ] every claim traced to the tool's current behaviour;
- [ ] gates run with exit codes, and any failure compared against the same run
      on the trunk before calling it yours.

## Where this was learned

The Digitable courses portal (Hugo): `AGENTS.md` §1 holds the measuring recipe
and the shared tabs module, `docs/sdd/portal-one-viewport.md` the tab-addressing
contract. `layouts/digitdisk/list.html` and `layouts/ouroboros/list.html` are
working sections built to these six rules — copy the parts, not the file.
