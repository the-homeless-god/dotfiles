#!/usr/bin/env bash

set -euo pipefail

usage() {
  printf '%s\n' \
    'Usage: install-skills.sh [--dry-run] [--replace] [--destination DIR]' \
    '                         [--target NAME]... [SKILL ...]' \
    '' \
    'Installs the portable skills from skills/ into ONE shared directory and points' \
    'the agent clients at that directory with symbolic links. A skill then has a' \
    'single copy on disk and is edited in one place.' \
    '' \
    'Shared directory: ${AI_HOME:-$HOME/.ai}/skills. Override with --destination DIR.' \
    '' \
    'Targets - the vendor paths that become links to the shared directory:' \
    '  codex   ${CODEX_HOME:-$HOME/.codex}/skills' \
    '  claude  ${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills' \
    '  none    install into the shared directory only, link nothing' \
    '--target is repeatable. Default: every client whose home directory already' \
    'exists. Codex and Claude Code relocate their whole home with CODEX_HOME and' \
    'CLAUDE_CONFIG_DIR, and this script follows those variables; neither client has' \
    'a setting for the skills directory alone, which is why a link is needed.' \
    '' \
    'Without SKILL arguments, installs all bundled skills.' \
    '' \
    '--replace moves an existing skill, or an existing vendor skills directory, to a' \
    'timestamped backup before installing or linking. Without it the script refuses' \
    'and changes nothing: a link is never dropped over a directory that holds files.' \
    '' \
    'digit is not a link target and does not need to be: it reads extra skill' \
    'directories through skills.external_dirs in ~/.digit/config.yaml, which this' \
    'repository ships pointing at ~/.ai/skills. See README.md.' \
    '' \
    'Trade-off: with links every client depends on the shared directory. Remove it' \
    'and all clients lose their skills at once, where separate copies would have' \
    'lost one. That is the price of never having to remember three places.'
}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repository_root="$(cd "${script_dir}/.." && pwd)"
source_root="${repository_root}/skills"
bundled_skills=(master-prompt-builder umbrella-repository-setup cluster-agent-setup \
                bilingual-documentation tool-section-page write-post state)
known_targets=(codex claude)

destination_root=""
dry_run=0
replace_existing=0
link_nothing=0
requested_skills=()
requested_targets=()

target_home() {
  case "$1" in
    codex)
      printf '%s' "${CODEX_HOME:-${HOME}/.codex}"
      ;;
    claude)
      printf '%s' "${CLAUDE_CONFIG_DIR:-${HOME}/.claude}"
      ;;
    *)
      return 1
      ;;
  esac
}

physical_path() {
  if [[ -d "$1" ]]; then
    (cd "$1" && pwd -P)
  else
    printf '%s' "$1"
  fi
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      dry_run=1
      shift
      ;;
    --replace)
      replace_existing=1
      shift
      ;;
    --destination)
      if [[ $# -lt 2 ]]; then
        printf 'Missing value for --destination\n' >&2
        exit 2
      fi
      destination_root="$2"
      shift 2
      ;;
    --target)
      if [[ $# -lt 2 ]]; then
        printf 'Missing value for --target\n' >&2
        exit 2
      fi
      case "$2" in
        none)
          link_nothing=1
          ;;
        codex|claude)
          requested_targets+=("$2")
          ;;
        *)
          printf 'Unknown target: %s (expected codex, claude or none)\n' "$2" >&2
          exit 2
          ;;
      esac
      shift 2
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    --*)
      printf 'Unknown option: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
    *)
      requested_skills+=("$1")
      shift
      ;;
  esac
done

if [[ -z "${destination_root}" ]]; then
  destination_root="${AI_HOME:-${HOME}/.ai}/skills"
fi

if [[ "${destination_root}" == "/" ]]; then
  printf 'Refusing unsafe destination: %s\n' "${destination_root}" >&2
  exit 2
fi

if [[ ${#requested_skills[@]} -eq 0 ]]; then
  requested_skills=("${bundled_skills[@]}")
fi

if [[ ${link_nothing} -eq 1 ]]; then
  requested_targets=()
elif [[ ${#requested_targets[@]} -eq 0 ]]; then
  for candidate in "${known_targets[@]}"; do
    if [[ -d "$(target_home "${candidate}")" ]]; then
      requested_targets+=("${candidate}")
    fi
  done
  if [[ ${#requested_targets[@]} -eq 0 ]]; then
    printf 'No client home found; installing into %s only.\n' "${destination_root}"
    printf 'Name a client with --target codex or --target claude to link it anyway.\n'
  fi
fi

timestamp="$(date -u +%Y%m%dT%H%M%SZ)"

# Backups of replaced skills go NEXT TO the shared directory, never inside it:
# every client scans the shared directory for SKILL.md, and a backup left in
# there would be discovered as a second skill carrying the same frontmatter
# name, which makes the name ambiguous and the skill unusable.
backup_root="${destination_root%/}.backup/${timestamp}"

# --- Pre-flight: refuse before touching anything -----------------------------
#
# A real run stops at the first problem and changes nothing. A dry run reports
# every problem, prints the rest of the plan anyway, and exits non-zero, so one
# --dry-run shows the whole picture instead of the first obstacle.

preflight_failed=0

refuse() {
  printf '%s\n' "$@" >&2
  preflight_failed=1
  if [[ ${dry_run} -eq 0 ]]; then
    exit 1
  fi
}

for skill_name in "${requested_skills[@]}"; do
  if [[ ! "${skill_name}" =~ ^[a-z0-9-]+$ ]]; then
    printf 'Invalid skill name: %s\n' "${skill_name}" >&2
    exit 2
  fi

  if [[ ! -f "${source_root}/${skill_name}/SKILL.md" ]]; then
    printf 'Bundled skill not found: %s\n' "${skill_name}" >&2
    exit 1
  fi

  if [[ -e "${destination_root}/${skill_name}" && ${replace_existing} -eq 0 ]]; then
    refuse "Skill already exists, use --replace: ${destination_root}/${skill_name}"
  fi
done

shared_physical="$(physical_path "${destination_root}")"

for target_name in ${requested_targets[@]+"${requested_targets[@]}"}; do
  link_path="$(target_home "${target_name}")/skills"

  if [[ -L "${link_path}" ]]; then
    if [[ "$(physical_path "${link_path}")" == "${shared_physical}" ]]; then
      continue
    fi
    if [[ ${replace_existing} -eq 0 ]]; then
      refuse "${target_name} is a link to somewhere else, use --replace: ${link_path} -> $(readlink "${link_path}")"
    fi
    continue
  fi

  if [[ -e "${link_path}" ]]; then
    if [[ ! -d "${link_path}" ]]; then
      refuse "${target_name} skills path is a file, refusing: ${link_path}"
    elif [[ -n "$(ls -A "${link_path}")" && ${replace_existing} -eq 0 ]]; then
      refuse "${target_name} already keeps skills of its own, use --replace: ${link_path}" \
             "It holds: $(ls -A "${link_path}" | tr '\n' ' ')" \
             "--replace moves that directory to a timestamped backup next to it;" \
             "copy anything worth keeping into ${destination_root} afterwards."
    fi
  fi
done

if [[ ${preflight_failed} -eq 1 && ${dry_run} -eq 0 ]]; then
  exit 1
fi

# --- Install into the shared directory ---------------------------------------

for skill_name in "${requested_skills[@]}"; do
  source_skill="${source_root}/${skill_name}"
  target_skill="${destination_root}/${skill_name}"

  backup_skill="${backup_root}/${skill_name}"

  if [[ ${dry_run} -eq 1 ]]; then
    if [[ -e "${target_skill}" ]]; then
      printf '[dry-run] backup %s -> %s\n' "${target_skill}" "${backup_skill}"
    fi
    printf '[dry-run] install %s -> %s\n' "${source_skill}" "${target_skill}"
    continue
  fi

  mkdir -p "${destination_root}"
  if [[ -e "${target_skill}" ]]; then
    if [[ -e "${backup_skill}" ]]; then
      printf 'Backup destination already exists: %s\n' "${backup_skill}" >&2
      exit 1
    fi
    mkdir -p "${backup_root}"
    mv "${target_skill}" "${backup_skill}"
    printf 'Backed up %s -> %s\n' "${target_skill}" "${backup_skill}"
  fi

  cp -R "${source_skill}" "${target_skill}"
  printf 'Installed %s\n' "${target_skill}"
done

# --- Point the clients at it -------------------------------------------------

shared_physical="$(physical_path "${destination_root}")"

for target_name in ${requested_targets[@]+"${requested_targets[@]}"}; do
  client_home="$(target_home "${target_name}")"
  link_path="${client_home}/skills"

  if [[ -L "${link_path}" && "$(physical_path "${link_path}")" == "${shared_physical}" ]]; then
    printf 'Already linked %s -> %s\n' "${link_path}" "${destination_root}"
    continue
  fi

  if [[ ${dry_run} -eq 1 ]]; then
    if [[ -L "${link_path}" ]]; then
      printf '[dry-run] backup link %s -> %s\n' "${link_path}" "$(readlink "${link_path}")"
    elif [[ -d "${link_path}" && -n "$(ls -A "${link_path}")" ]]; then
      printf '[dry-run] backup %s\n' "${link_path}"
    fi
    printf '[dry-run] link %s -> %s\n' "${link_path}" "${destination_root}"
    continue
  fi

  mkdir -p "${client_home}"

  if [[ -L "${link_path}" ]]; then
    backup_link="${link_path}.backup.${timestamp}"
    if [[ -e "${backup_link}" || -L "${backup_link}" ]]; then
      printf 'Backup destination already exists: %s\n' "${backup_link}" >&2
      exit 1
    fi
    mv "${link_path}" "${backup_link}"
    printf 'Backed up %s -> %s\n' "${link_path}" "${backup_link}"
  elif [[ -d "${link_path}" ]]; then
    if [[ -z "$(ls -A "${link_path}")" ]]; then
      rmdir "${link_path}"
    else
      backup_dir="${link_path}.backup.${timestamp}"
      if [[ -e "${backup_dir}" ]]; then
        printf 'Backup destination already exists: %s\n' "${backup_dir}" >&2
        exit 1
      fi
      mv "${link_path}" "${backup_dir}"
      printf 'Backed up %s -> %s\n' "${link_path}" "${backup_dir}"
      printf 'Kept out of the way, not deleted: %s\n' "$(ls -A "${backup_dir}" | tr '\n' ' ')"
    fi
  fi

  ln -s "${destination_root}" "${link_path}"
  printf 'Linked %s -> %s\n' "${link_path}" "${destination_root}"
done

if [[ ${preflight_failed} -eq 1 ]]; then
  printf '[dry-run] the plan above would be refused; re-run with --replace\n' >&2
  exit 1
fi
