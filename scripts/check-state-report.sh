#!/usr/bin/env bash
#
# Checks a state report against the shape in skills/state/SKILL.md.
#
# It checks shape, never truth: that the head a human reads is short, that every
# key result carries a threshold, a fact and one of the three statuses, that the
# blocker and the ask are present, and that nothing taken on trust is scored as
# achieved. A report can pass this and still be wrong; it cannot pass it and be
# unreadable.

set -uo pipefail

usage() {
  printf '%s\n' \
    'Usage: check-state-report.sh [--head-lines N] [--head-chars N] FILE [FILE ...]' \
    '' \
    'Exit 0 when every file passes, 1 when any fails, 2 on bad usage.' \
    '' \
    'The head is everything before the first horizontal rule (a line of exactly' \
    '---). It must hold, in either the report language or English:' \
    '  Цель / Objective            one line' \
    '  a table of key results      3..6 rows, each ending in ✓, ✗ or ?' \
    '  Вывод / Conclusion          one line' \
    '  Затык / Blocker             one line' \
    '  Нужно от тебя / Needed      one line' \
    '' \
    'Defaults: --head-lines 14 (non-empty), --head-chars 900.' \
    '' \
    '--selftest builds a good report and seven broken ones and asserts that this' \
    'script accepts the first and names the fault in each of the rest. A checker' \
    'nobody has seen fail is a checker nobody should trust.'
}

head_lines_max=14
head_chars_max=900
selftest=0
files=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --head-lines) head_lines_max="${2:-}"; shift 2 ;;
    --head-chars) head_chars_max="${2:-}"; shift 2 ;;
    --selftest) selftest=1; shift ;;
    --help|-h) usage; exit 0 ;;
    --*) printf 'Unknown option: %s\n' "$1" >&2; usage >&2; exit 2 ;;
    *) files+=("$1"); shift ;;
  esac
done

if [[ ${selftest} -eq 0 && ${#files[@]} -eq 0 ]]; then
  usage >&2
  exit 2
fi

if ! [[ "${head_lines_max}" =~ ^[0-9]+$ && "${head_chars_max}" =~ ^[0-9]+$ ]]; then
  printf 'Caps must be numbers\n' >&2
  exit 2
fi

run_selftest() {
  local dir failures=0
  dir="$(mktemp -d)"
  trap 'rm -rf "${dir}"' RETURN

  cat > "${dir}/good.md" <<'EOF'
**Цель.** Лента не должна брать имена у X11 напрямую.

| Ключевой результат | порог | факт | |
|---|---|---|---|
| имён X11 в `ribbon.o` | 0 (на базе 3) | 0, `nm -u ribbon.o` | ✓ |
| поведение не изменилось | 592 б | те же 592 б, `cmp` пуст | ✓ |
| операций в контракте | 11 из 11 | 10 из 11 | ✗ |
| `check.mjs` | rc=0 | не мерил: падает и на базе | ? |

**Вывод.** Имён ноль, а вывод побайтно тот же — значит шов провести можно.
**Затык.** Нет.
**Нужно от тебя.** Ничего.

---

**Провенанс.** `work/m1-seam` @ `0512520`, база `0d71b21`.
EOF

  local -a names=(
    "no-rule"
    "no-blocker"
    "no-ask"
    "trust-scored-achieved"
    "threshold-without-number"
    "unmeasured-without-reason"
    "too-few-key-results"
  )
  local -a bad
  bad+=("$(sed '/^---$/d' "${dir}/good.md")")
  bad+=("$(sed '/^\*\*Затык\./d' "${dir}/good.md")")
  bad+=("$(sed '/^\*\*Нужно от тебя\./d' "${dir}/good.md")")
  bad+=("$(sed 's|0, `nm -u ribbon.o`|принято на веру|' "${dir}/good.md")")
  bad+=("$(sed 's_| поведение не изменилось | 592 б |_| поведение не изменилось | как раньше |_' "${dir}/good.md")")
  bad+=("$(sed 's|не мерил: падает и на базе|падает и на базе|' "${dir}/good.md")")
  bad+=("$(sed '/^| операций в контракте/d;/^| `check.mjs`/d' "${dir}/good.md")")

  if "$0" --head-lines "${head_lines_max}" --head-chars "${head_chars_max}" "${dir}/good.md" >/dev/null; then
    printf 'selftest  ok      good report accepted\n'
  else
    printf 'selftest  FAILED  good report rejected\n' >&2
    failures=$((failures + 1))
  fi

  local i=0
  for case_name in "${names[@]}"; do
    printf '%s\n' "${bad[${i}]}" > "${dir}/bad.md"
    if "$0" --head-lines "${head_lines_max}" --head-chars "${head_chars_max}" "${dir}/bad.md" >/dev/null 2>&1; then
      printf 'selftest  FAILED  %s went unnoticed\n' "${case_name}" >&2
      failures=$((failures + 1))
    else
      printf 'selftest  ok      %s caught\n' "${case_name}"
    fi
    i=$((i + 1))
  done

  if (( failures > 0 )); then
    printf 'selftest: %d of %d cases wrong\n' "${failures}" "$(( ${#names[@]} + 1 ))" >&2
    return 1
  fi
  printf 'selftest: %d of %d cases right\n' "$(( ${#names[@]} + 1 ))" "$(( ${#names[@]} + 1 ))"
  return 0
}

if [[ ${selftest} -eq 1 ]]; then
  run_selftest || exit 1
  [[ ${#files[@]} -eq 0 ]] && exit 0
fi

exit_code=0

for file in "${files[@]}"; do
  if [[ ! -f "${file}" ]]; then
    printf '%s: NOT FOUND\n' "${file}" >&2
    exit_code=1
    continue
  fi

  problems=()

  # The head: everything before the first horizontal rule. A YAML frontmatter
  # block at the very top is skipped first, so its closing --- is not mistaken
  # for the rule.
  head="$(awk '
    NR == 1 && $0 == "---" { in_front = 1; next }
    in_front && $0 == "---" { in_front = 0; next }
    in_front { next }
    $0 == "---" { exit }
    { print }
  ' "${file}")"

  if [[ "${head}" == "$(cat "${file}")" ]]; then
    problems+=("no horizontal rule: the head must end at a line of exactly ---, evidence goes below it")
  fi

  head_lines="$(printf '%s\n' "${head}" | grep -c '[^[:space:]]')"
  head_chars="$(printf '%s' "${head}" | wc -m)"

  (( head_lines > head_lines_max )) && problems+=("head is ${head_lines} non-empty lines, cap ${head_lines_max}")
  (( head_chars > head_chars_max )) && problems+=("head is ${head_chars} characters, cap ${head_chars_max}")

  grep -qE '^\*{0,2}(Цель|Objective)\*{0,2}\.' <<<"${head}" \
    || problems+=("no objective line (Цель / Objective)")
  grep -qE '^\*{0,2}(Вывод|Conclusion)\*{0,2}\.' <<<"${head}" \
    || problems+=("no conclusion line (Вывод / Conclusion)")
  grep -qE '^\*{0,2}(Затык|Blocker)\*{0,2}\.' <<<"${head}" \
    || problems+=("no blocker line (Затык / Blocker) — say «нет» rather than omit it")
  grep -qE '^\*{0,2}(Нужно от тебя|Нужно|Needed from you|Needed)\*{0,2}\.' <<<"${head}" \
    || problems+=("no ask line (Нужно от тебя / Needed from you) — say «ничего» rather than omit it")

  # Key results: table rows whose last cell is one of the three statuses.
  rows="$(grep -nE '^\|.*\|[[:space:]]*(✓|✗|\?)[[:space:]]*\|[[:space:]]*$' <<<"${head}")"
  row_count="$(grep -c . <<<"${rows}")"
  [[ -z "${rows}" ]] && row_count=0

  if (( row_count < 3 )); then
    problems+=("${row_count} key results, need at least 3 (a row ends in | ✓ |, | ✗ | or | ? |)")
  elif (( row_count > 6 )); then
    problems+=("${row_count} key results, more than 6 stops being a head")
  fi

  while IFS= read -r row; do
    [[ -z "${row}" ]] && continue
    line_no="${row%%:*}"
    body="${row#*:}"

    # Cells: | name | threshold | fact | status |
    threshold="$(awk -F'|' '{print $3}' <<<"${body}")"
    fact="$(awk -F'|' '{print $4}' <<<"${body}")"
    status="$(awk -F'|' '{print $5}' <<<"${body}" | tr -d '[:space:]')"

    [[ "${threshold}" =~ [0-9] ]] \
      || problems+=("key result on head line ${line_no}: threshold has no number — «${threshold## }»")

    [[ "${fact}" =~ [^[:space:]] ]] \
      || problems+=("key result on head line ${line_no}: fact is empty")

    if [[ "${status}" == "?" ]]; then
      grep -qiE 'не мерил|не проверял|не гонял|unmeasured|not run|not measured' <<<"${fact}" \
        || problems+=("key result on head line ${line_no}: ? must say why it was not measured (не мерил: …)")
    else
      [[ "${fact}" =~ [0-9] ]] \
        || problems+=("key result on head line ${line_no}: ${status} with no number in the fact — «${fact## }»")
    fi

    if [[ "${status}" == "✓" ]] && grep -qiE 'на веру|объявлено, не доказано|on trust|asserted' <<<"${fact}"; then
      problems+=("key result on head line ${line_no}: taken on trust, so it is ?, not ✓")
    fi
  done <<<"${rows}"

  if [[ ${#problems[@]} -eq 0 ]]; then
    printf 'OK   %s  (head %s lines, %s chars, %s key results)\n' \
      "${file}" "${head_lines}" "${head_chars}" "${row_count}"
  else
    printf 'FAIL %s\n' "${file}"
    printf '       - %s\n' "${problems[@]}"
    exit_code=1
  fi
done

exit "${exit_code}"
