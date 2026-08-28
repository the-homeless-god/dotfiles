#!/usr/bin/env bash

set -euo pipefail

usage() {
  printf '%s\n' \
    'Usage: install-codex-skills.sh [--dry-run] [--replace] [--destination DIR] [SKILL ...]' \
    '' \
    'Installs the portable skills from codex/skills into the Codex skills directory.' \
    'Without SKILL arguments, installs all bundled skills.' \
    '--replace moves an existing skill to a timestamped backup before installing.'
}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repository_root="$(cd "${script_dir}/.." && pwd)"
source_root="${repository_root}/codex/skills"
destination_root=""
dry_run=0
replace_existing=0
requested_skills=()

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
  codex_base="${CODEX_HOME:-${HOME}/.codex}"
  destination_root="${codex_base}/skills"
fi

if [[ -z "${destination_root}" || "${destination_root}" == "/" ]]; then
  printf 'Refusing unsafe destination: %s\n' "${destination_root:-<empty>}" >&2
  exit 2
fi

if [[ ${#requested_skills[@]} -eq 0 ]]; then
  requested_skills=(master-prompt-builder umbrella-repository-setup)
fi

timestamp="$(date -u +%Y%m%dT%H%M%SZ)"

for skill_name in "${requested_skills[@]}"; do
  if [[ ! "${skill_name}" =~ ^[a-z0-9-]+$ ]]; then
    printf 'Invalid skill name: %s\n' "${skill_name}" >&2
    exit 2
  fi

  source_skill="${source_root}/${skill_name}"
  target_skill="${destination_root}/${skill_name}"

  if [[ ! -f "${source_skill}/SKILL.md" ]]; then
    printf 'Bundled skill not found: %s\n' "${skill_name}" >&2
    exit 1
  fi

  if [[ -e "${target_skill}" && ${replace_existing} -eq 0 ]]; then
    printf 'Skill already exists, use --replace: %s\n' "${target_skill}" >&2
    exit 1
  fi

  if [[ ${dry_run} -eq 1 ]]; then
    if [[ -e "${target_skill}" ]]; then
      printf '[dry-run] backup %s\n' "${target_skill}"
    fi
    printf '[dry-run] install %s -> %s\n' "${source_skill}" "${target_skill}"
    continue
  fi

  mkdir -p "${destination_root}"
  if [[ -e "${target_skill}" ]]; then
    backup_skill="${target_skill}.backup.${timestamp}"
    if [[ -e "${backup_skill}" ]]; then
      printf 'Backup destination already exists: %s\n' "${backup_skill}" >&2
      exit 1
    fi
    mv "${target_skill}" "${backup_skill}"
    printf 'Backed up %s -> %s\n' "${target_skill}" "${backup_skill}"
  fi

  cp -R "${source_skill}" "${target_skill}"
  printf 'Installed %s\n' "${target_skill}"
done
