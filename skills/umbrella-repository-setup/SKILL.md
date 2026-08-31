---
name: umbrella-repository-setup
description: Design, bootstrap, or analyze an umbrella repository that coordinates multiple independently versioned component repositories. Use when a cross-repository initiative needs pinned revisions, shared agent rules, spec-driven artifacts, general and component-specific skills, or an analyst workspace; do not use when one repository already owns the whole change.
---

# Umbrella Repository Setup

Create a reproducible coordination and analysis plane without turning component
repositories into an accidental monorepo. Preserve component ownership, history,
CI/CD, and write boundaries.

## Select a mode

- For a first-time workspace, read
  [references/bootstrap-runbook.md](references/bootstrap-runbook.md).
- For product, architecture, or technical-debt analysis across existing
  components, also read
  [references/analyst-protocol.md](references/analyst-protocol.md).
- For a master prompt, embed the relevant invariants and artifacts from this
  skill instead of merely saying “use an umbrella repository”.

## Decide before creating

Compare at least these options when the repository model is not already chosen:

| Option | Prefer when | Main cost |
|---|---|---|
| Umbrella with pinned submodules | Components keep independent lifecycle but cross-repo work needs one reproducible revision set | Submodule onboarding and intentional pointer updates |
| Specification-only workspace | Source access is read-only or components change too frequently to pin locally | Weaker local code navigation and reproducibility |
| Monorepo | One owner, release process, permissions model, and build graph genuinely apply to all components | Migration and coupled CI/ownership |
| Coordinated independent repositories | The initiative is small and a shared analysis/spec layer adds no lasting value | Cross-repo decisions remain distributed |

Do not choose submodules by habit. Record the decision, alternatives, and exit
criteria. If the user already chose a model, verify its constraints rather than
silently replacing it.

## Core invariants

- The umbrella stores coordination artifacts and exact component revisions; it
  does not duplicate component source or become their release authority.
- Root `AGENTS.md` contains shared routing, safety, and workflow rules. Component
  `AGENTS.md` files remain authoritative for changes inside their paths.
- General skills live at the umbrella level. Functional/component-specific
  skills remain with the component when possible; adding them there is a
  separate component change.
- A constitution or project-principles document states durable cross-component
  constraints. Memory records evidence and decisions, not mutable folklore.
- Specs distinguish current behavior, target behavior, assumptions, and gaps.
- Every technical-debt item links to an affected capability/feature and evidence,
  or becomes a separately decomposed plan with owner, risk, verification, and
  exit criteria. Never create an unowned debt bucket.
- Component revisions are pinned and reported. Updating a pointer is an explicit
  reviewed change, never an invisible “latest” refresh.
- Writing inside a component repository requires its own authorization, branch,
  tests, and PR. An umbrella task does not grant that permission.
- No existing checkout, `.git` directory, branch, worktree, or uncommitted change
  is deleted to make submodules fit.

## Expected umbrella artifacts

Use the existing project convention when present. A useful default is:

```text
umbrella/
├── .gitmodules
├── AGENTS.md
├── README.md
├── CONSTITUTION.md                 # or tool-specific memory/constitution path
├── .agents/skills/                 # general cross-repository skills
├── specs/
│   └── 001-initiative/
│       ├── spec.md
│       ├── plan.md
│       ├── tasks.md
│       ├── tdr.md
│       ├── journey.md              # optional CJM/user journey
│       ├── memory.md
│       ├── traceability.md
│       ├── outputs-outcomes.md
│       └── research/
│           ├── sources.md
│           ├── journal.md
│           └── decisions.md
└── components/                     # or named top-level submodule paths
```

Generate only artifacts justified by the initiative. A small umbrella can use a
smaller layout.

## Verification

Before claiming readiness, verify:

- the revision manifest matches actual component HEADs;
- every component path, remote, branch policy, and dirty state is recorded;
- root and component instructions have a documented precedence order;
- fresh-clone initialization succeeds with recursive submodule commands;
- component-specific tests are mapped and run only where changes occurred;
- cross-repository contracts are checked at the pinned revisions;
- diagrams and traceability use evidence rather than inferred names;
- no component source change is hidden inside an umbrella-only PR;
- onboarding docs explain clone, init, update, analysis, and failure recovery.

Report separately what is configured, what is analyzed, what is changed in
components, and what is merely proposed.
