# Dotfiles & Development Tools

This repository contains configuration files (dotfiles) and scripts for automatic setup of a developer's working environment. Supports macOS and Linux (via Docker for testing).

## Repository Contents

### Configuration Files
- `.zshrc` - Zsh shell configuration
- `.vimrc` - Vim settings
- `.vim/colors/digitable.vim` - a Vim colour scheme in the palette of the [Digitable Courses](https://courses.digitable.life) portal. Installed into `~/.vim/colors/`; `.vimrc` enables it with `colorscheme digitable`. The role mapping (keyword, string, comment) comes from the portal's single syntax-highlighting table, so code in Vim reads like code in a block on a portal page
- `.tmux.conf` - Tmux configuration
- `.alacritty.toml` - Alacritty terminal settings; the colours are the Digitable palette
- `.gitconfig` and `.gitignore` - Global Git settings
- `.editorconfig` - Code formatting settings
- Configurations for various utilities in `.config/`:
  - `bat` - the `digitable.tmTheme` theme for bat and delta. Both read user themes from `~/.config/bat/themes`, but only see them after `bat cache --build`, which the installer runs
  - `bpytop` - System monitoring; the `digitable.theme` theme plus the `bpytop.conf` that selects it (without which the theme file would sit there unused)
  - `lf` - File manager; `colors` holds the Digitable palette in lf's own format and `lfrc` the surfaces it does not cover - prompt, cursor row, frame, markers. lf reads both by itself; `~/.lfrc` it never reads
  - `tmux` - Session configurations
  - `vifm` - Vim-style file manager; `colors/digitable.vifm` is the colour scheme, `vifmrc` switches it on with `colorscheme digitable`. Both a 256-colour and a 24-bit value is given for every group, because vifm picks by what the terminal advertises
- `.digit/config.yaml` - Digit CLI settings: a local OpenAI-compatible model provider, `display.skin: digitable` (the skin ships inside digit; only the name is pinned here), plus `skills.external_dirs` pointing digit at the shared skills directory. Installed to `~/.digit/config.yaml`; secrets stay in `.env` and are never kept here
- `configs/tools.json` - Tool configuration for interactive installation mode

### Palette
One set of seventeen colours paints Vim, bat, delta, Alacritty, tmux, bpytop, lf, vifm, eza, GNU ls, zsh's suggestion line and three Logseq plugins. It has a single source: the `theme/digitable.flang` specification, which declares the colours themselves, the mapping of the nine highlighting roles and the contrast thresholds, and carries the checks. `scripts/check-theme.sh` holds the tree to it: every colour in the configs must either be declared in the spec or be derived from it as a "colour at N% over the background" blend, and every declared colour must be used somewhere. Colour is written two ways in the tree - `#rrggbb` and the 24-bit ANSI form `38;2;R;G;B` that lf and `EZA_COLORS` use - and the check reads both. `LS_COLORS` is not written a second time: `.zshrc` derives it from lf's own colours file, whose format is exactly `LS_COLORS`, so the two lists cannot drift apart. The WCAG 2.1 contrast is computed by flang itself (`flang check theme/digitable.flang`); with no compiler on the machine the check honestly prints "not measured" rather than "ok" - and `flang` is one of the tools the installer offers, so a machine can be brought up to the point of measuring.

The light-mode values of two Logseq plugins stay foreign on purpose: the Digitable palette is dark and has no light set of surfaces. `check-theme.sh` lists those three values by file and says so out loud rather than passing them over.

### Skills
- `skills/` - seven vendor-neutral agent skills (`master-prompt-builder`, `umbrella-repository-setup`, `cluster-agent-setup`, `bilingual-documentation`, `tool-section-page`, `write-post`, `state`). The directory name carries no vendor: the same `SKILL.md` and `references/` are read by Codex, Claude Code and digit alike

### Scripts
- `install-tools.sh` - Main installation script
- `install-skills.sh` - Installs `skills/` into one shared directory and points the agent clients at it
- `check-configs-install.sh` - Takes the `install_configs` function out of `install-tools.sh`, runs it against a throwaway `HOME` and confirms every file under `configs/` arrived in the home directory. The copy list there is written out line by line, so a new config is not installed by default - this check catches the forgotten line. `--selftest` drops one line and shows the check failing because of it
- `check-theme.sh` - Guards the Digitable palette across every config; `--selftest` feeds it a foreign colour and shows the check failing
- `check-vim-quiet.sh` - Guards Vim's silence: the AI helper `vim-ollama` is marked `{ 'on': [] }` in `.vimrc` and is not loaded at startup, so it never asks about its setup wizard, never takes `<Tab>` away from coc and never talks to a model on every keystroke. The check runs a real `vim` over the real `configs/.vimrc` in a throwaway `HOME` and measures three runs: a plain start (the plugin must be absent), `VIM_OLLAMA=1` and `:OllamaOn` at runtime (the plugin must load - otherwise the switch is a prop). `--selftest` restores eager loading and shows the check failing
- `check-state-report.sh` - Checks a state report against `skills/state/SKILL.md`: head within 14 lines and 900 characters, three to six key results each carrying a threshold, a fact and one of `✓ ✗ ?`, the blocker and the ask present, nothing taken on trust scored as achieved. `--selftest` proves the checker itself fails on eight prepared cases
- Custom scripts in `scripts/customs/`
- Scripts for lf in `scripts/lf/`
- `tmux.sh` - Script for managing tmux sessions
- `workbench-configs.sh` - Lays out the open Digitable Workbench configs, fetched over the public URL (the themes themselves are never stored in this repository)
- `install-codex-skills.sh` - Installs every Codex skill bundled in `codex/skills/` into `${CODEX_HOME:-$HOME/.codex}/skills`; the README section on those skills is written as the operating instruction an agent can be handed directly
- `codex/skills/` - The seven portable skills themselves, one directory each: `umbrella-repository-setup`, `master-prompt-builder`, `cluster-agent-setup`, `bilingual-documentation`, `tool-section-page`, `write-post`, `state`. The installer reads this directory, so a new skill needs no change to the script. When each applies, and in what order, is the table in the main README

## Key Features

### Development Tools
- Modern alternatives to standard utilities (eza, bat, ripgrep, etc.)
- Development tools (Git, Python, Node.js, asdf, etc.)
- File managers (lf, vifm)
- Terminal utilities (tmux, Alacritty)
- Support for various programming languages
- digitwm - window manager: on Linux/BSD the X11 build (cwm fork) is compiled from source, on macOS the ribbon build is installed from `digitable-lol/tap` and needs Accessibility permission granted by hand
- digitdisk - read-only disk and system reporter: where the space went, how the machine feels
- flang - the checkable language the theme specification is written in; `make check-theme` measures contrast with it, and without it the check prints "not measured"

### Configuration
- Configured Zsh with Oh My Zsh and Powerlevel10k
- Vim with development plugins; the AI helper (`vim-ollama` over LM Studio on `localhost:1234`) is turned on deliberately - `\i`, `:OllamaOn` or `VIM_OLLAMA=1 vim` - and neither loads nor reaches the network on its own
- Tmux with optimized settings
- Git integration with enhanced output

## Installation

### Direct Installation (macOS)

1. Clone the repository:
   ```bash
   git clone https://github.com/the-homeless-god/dotfiles.git ~/dotfiles
   ```

2. Run the installation script:
   ```bash
   cd ~/dotfiles/scripts
   ./install-tools.sh
   ```

3. Follow the interactive prompts for:
   - Selecting interface language (Russian/English)
   - Choosing components to install
   - Installing configuration files
   - Running post-installation setup

### Interactive Installation Mode

For more detailed control over the installation process, use the interactive mode:

```bash
./install-tools.sh --interactive
```

This mode provides a convenient checkbox interface for selecting:
- Tool categories (development, media, containers, etc.)
- Individual programs within each category

You can easily choose only the tools you need without having to answer multiple separate questions.

### Shared agent skills

The skills in `skills/` are installed once, into `~/.ai/skills`, and every agent
client is pointed at that one directory:

```bash
./scripts/install-skills.sh --dry-run
./scripts/install-skills.sh
```

| Client | How it reaches the shared directory |
| --- | --- |
| Codex | `${CODEX_HOME:-$HOME/.codex}/skills` becomes a symlink to `~/.ai/skills` |
| Claude Code | `${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills` becomes a symlink to `~/.ai/skills` |
| digit | `skills.external_dirs` in `~/.digit/config.yaml` lists `~/.ai/skills`, read-only |

Symlinks are used for Codex and Claude Code because neither has a setting for
the skills directory on its own: `CODEX_HOME` and `CLAUDE_CONFIG_DIR` relocate
the whole client home, and `--add-dir` has to be repeated on every run. digit
needs no link because it already supports external skill directories.

By default the script links every client whose home directory exists. Use
`--target codex`, `--target claude` (repeatable) or `--target none`, and
`--destination DIR` (or `AI_HOME`) to move the shared directory.

Nothing is overwritten. If a client's `skills` directory already holds files of
its own, the script refuses and changes nothing; `--replace` moves that
directory to a timestamped backup next to it first, prints what it moved, and
only then creates the link. Backups are moved, never deleted.

**The cost of sharing.** All clients now depend on one directory. Delete or
rename `~/.ai/skills` and they all lose their skills at the same moment, where
three separate copies would have lost one. This is the deliberate trade for
never having a skill fixed in one place and left broken in the other two - back
up `~/.ai`, not the vendor directories.

### Testing with Docker

1. Build the image:
   ```bash
   docker build -t dotfiles-test .
   ```

2. Run the container:
   ```bash
   docker run -it dotfiles-test
   ```

## Configuration Structure

### Terminal
- **Alacritty**: Modern GPU-accelerated terminal
- **Tmux**: Terminal multiplexer with custom key bindings
- **Zsh**: Configured shell with autocompletion and syntax highlighting

### Editors
- **Vim**: Configured for development with various plugins
- **VS Code**: Extension synchronization support

### File Managers
- **lf**: Modern ranger-style file manager, painted in the Digitable palette
- **vifm**: Vim-style file manager, painted in the Digitable palette

### Development Utilities
- **Git**: Extended configuration with aliases and integrations
- **asdf**: Programming language version management
- **Python**: Configured environment with pip
- **Node.js**: Installation via nvm with core tools

## Customization

1. Fork the repository
2. Modify configuration files to your needs
3. Add or remove tools in `install-tools.sh`
4. Configure your custom scripts in `scripts/customs/`

## Language Support

- Russian (primary)
- English (alternative)

Localization is configured through `scripts/locales.json`

## Requirements

- macOS or Linux
- Git
- Internet connection for downloading components
- For macOS: Command Line Tools

## Known Issues

- Some components may not be available on Linux
- Homebrew requires additional setup on Linux

## Contributing

1. Fork the repository
2. Create a branch for new functionality
3. Submit a pull request

## Acknowledgments

- Dotfiles community
- Developers of all tools used 

### Using Docker

#### Using Pre-built Image

We publish pre-built Docker images to GitHub Container Registry:

```bash
docker pull ghcr.io/the-homeless-god/dotfiles:latest
docker run -it ghcr.io/the-homeless-god/dotfiles:latest
```

Available tags:
- `latest` - Latest stable version
- `vX.Y.Z` - Specific version releases
- `main` - Latest development version
- `sha-XXXXXXX` - Specific commit builds

#### Local Build

If you want to build the image locally:

```bash
docker build -t dotfiles-test .
docker run -it dotfiles-test
``` 

## CI/CD

This repository uses GitHub Actions for continuous integration and delivery:

- Automatic Docker image builds on every push to main branch
- Automatic releases when tags are pushed
- Image publishing to GitHub Container Registry
- Build caching for faster builds
- Automated tagging system

### Automated Builds

The following events trigger builds:
- Push to main branch
- Creation of tags (vX.Y.Z)
- Pull requests

### Docker Tags

Available tags in the registry:
- `latest` - Latest stable version
- `vX.Y.Z` - Specific version releases
- `main` - Latest development version
- `sha-XXXXXXX` - Specific commit builds

### Registry

Images are published to GitHub Container Registry (ghcr.io):
```bash
ghcr.io/the-homeless-god/dotfiles
```

### Build Status

You can check the current build status on the [Actions tab](https://github.com/the-homeless-god/dotfiles/actions) or by the badge at the top of the main README. 
