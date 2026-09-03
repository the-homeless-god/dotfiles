#!/usr/bin/env bash
#
# Checks an article against the shape in skills/write-post/SKILL.md.
#
# It checks shape, never truth: that one title stands over the page, that the
# answer and its numbers are on the first screen while our own post-mortem is
# not, that a section names the border of the knowledge, that a negative result
# is stated, that something can be copied, and that every term the author
# declared is explained where the reader first meets it. An article can pass
# this and still be wrong; it cannot pass it and leave the reader with nothing
# to search for.

set -uo pipefail

usage() {
  printf '%s\n' \
    'Usage: check-post.sh [options] FILE [FILE ...]' \
    '' \
    'Exit 0 when every file passes, 1 when any fails, 2 on bad usage.' \
    '' \
    'Options:' \
    '  --term WORD        a term the article uses; repeatable.  Each must appear' \
    '                     in the prose and be explained where it first appears.' \
    '  --terms-file FILE  the same list, one term per line (# comments allowed).' \
    '  --first-screen N   cap on prose characters before the second ## heading' \
    '                     (default 3000).' \
    '  --numbers N        how many numbers the first screen must carry (default 3).' \
    '  --window N         characters after a first appearance in which the' \
    '                     explanation must start (default 220).' \
    '  --report           print every number the commit message has to answer.' \
    '  --selftest         build one good article and eight broken ones and assert' \
    '                     that this script accepts the first and names the fault' \
    '                     in each of the rest.  A checker nobody has seen fail is' \
    '                     a checker nobody should trust.' \
    '' \
    'PROSE is the file with the front matter, fenced blocks, inline code,' \
    'shortcode tags, HTML tags and link targets removed.  The MAIN LAYER is the' \
    'prose outside {{< perspective … >}} boxes; what is inside them is the BOX' \
    'LAYER, and the caps do not apply to it.' \
    '' \
    'The undeclared-term scan runs only on a file whose prose is mostly' \
    'Cyrillic: there the Latin words are the jargon.  On a Latin-script file it' \
    'is skipped and said to be skipped, because there every word is Latin.'
}

first_screen_max=3000
numbers_min=3
window=220
report=0
selftest=0
terms=()
files=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --term) terms+=("${2:-}"); shift 2 ;;
    --terms-file)
      while IFS= read -r line; do
        line="${line%%#*}"
        line="$(printf '%s' "${line}" | tr -d '[:space:]')"
        [[ -n "${line}" ]] && terms+=("${line}")
      done < "${2:-}"
      shift 2 ;;
    --first-screen) first_screen_max="${2:-}"; shift 2 ;;
    --numbers) numbers_min="${2:-}"; shift 2 ;;
    --window) window="${2:-}"; shift 2 ;;
    --report) report=1; shift ;;
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

if ! [[ "${first_screen_max}" =~ ^[0-9]+$ && "${numbers_min}" =~ ^[0-9]+$ && "${window}" =~ ^[0-9]+$ ]]; then
  printf 'Caps must be numbers\n' >&2
  exit 2
fi

# ── the three views of a file ────────────────────────────────────────────────

# strip_markup turns markdown into the text a reader reads: no front matter, no
# fenced blocks, no inline code, no shortcode tags, no HTML, no link targets.
# The optional second argument drops inline code as well: a word the author set
# in code font is an identifier, not a term the reader has to be taught, so the
# undeclared-jargon scan must not see `grep` or `host/internal` as jargon.
strip_markup() {
  awk '
    NR == 1 && $0 == "---" { in_front = 1; next }
    in_front && $0 == "---" { in_front = 0; next }
    in_front { next }
    /^[[:space:]]*```/ { in_fence = !in_fence; next }
    in_fence { next }
    { print }
  ' \
    | sed -E "s/\`([^\`]*)\`/$([[ "${1:-keep}" == drop ]] && printf '' || printf '\\1')/g; s/\{\{[<%][^}]*[>%]\}\}//g; s/<[^>]*>//g; s/\]\([^)]*\)/]/g"
}

# main_layer drops everything inside a perspective box; box_layer keeps only it.
split_layer() {
  awk -v want="$2" '
    /\{\{<[[:space:]]*perspective/ { inbox = 1; next }
    /\{\{<[[:space:]]*\/perspective/ { inbox = 0; next }
    { if ((want == "main") == (inbox == 0)) print }
  ' "$1"
}

# first_screen is the title and everything before the SECOND level-2 heading.

# first_screen is the title and everything before the SECOND level-2 heading.
first_screen() {
  awk '
    /^## / { seen++; if (seen == 2) exit }
    { print }
  ' "$1"
}

chars() { printf '%s' "$1" | wc -m | tr -d ' '; }
count_re() { printf '%s' "$1" | grep -oE "$2" | grep -c . ; }

# ── the self-test ────────────────────────────────────────────────────────────

good_article() {
  cat <<'ARTICLE'
---
title: "Как устроен рубанок: 12 правил решают, 40 команд делают"
---

# Как устроен рубанок: 12 правил решают, 40 команд делают

Рубанок делит работу надвое, и граница проведена там, где её не видно снаружи.
Ниже — где именно, чем это проверено и чего мы про него не знаем.

## Три ответа сразу

| вопрос | ответ | откуда |
|---|---|---|
| Кто решает? | 12 правил ядра | `grep -c правило core.txt` → 12 |
| Кто делает? | 40 команд хозяина | `grep -c команда host.txt` → 40 |
| Экран решает сам? | нет, зовёт то же ядро | `grep -n core host.txt` |

Одной строкой: правило меняется в ядре, а не в команде.

## Что можно скопировать

```sh
grep -c правило core.txt
```

Термин baseline — обычный прогон без единой настройки — дальше идёт только baseline.

## Чего мы не мерили

Скорости не мерили: замера нет, и числа тут не будет. На третьей платформе
различить нельзя, чей это отказ — наш или чужой.

## Что здесь стояло вчера

2 сентября вывод был обратным: правил считали 11, потому что счёт не видел
последней строки.
ARTICLE
}

run_selftest() {
  local dir good bad_texts bad_names i out rc failures=0
  dir="$(mktemp -d)"
  trap 'rm -rf "${dir}"' RETURN

  good_article > "${dir}/good.md"
  good="${dir}/good.md"

  bad_names=(
    "no H1 at all"
    "two H1 titles"
    "first screen over the cap"
    "no numbers on the first screen"
    "no border section"
    "no negative result named"
    "nothing to copy"
    "our post-mortem on the first screen"
  )
  bad_expect=(
    "level-1 titles"
    "level-1 titles"
    "first screen is"
    "numbers on the first screen"
    "border of the knowledge"
    "negative or undecided result"
    "fenced block"
    "post-mortem is on the first screen"
  )
  bad_texts=(
    "$(sed '/^# /d' "${good}")"
    "$(sed 's/^## Три ответа сразу/# Три ответа сразу/' "${good}")"
    "$(awk '{print} /^Одной строкой/ { for (i = 0; i < 60; i++) print "Ещё один абзац ни о чём, написанный только затем, чтобы первый экран перестал быть первым экраном и разъехался на много вёрст." }' "${good}")"
    "$(sed 's/12 правил/несколько правил/g; s/40 команд/много команд/g; s/| 12 |/| немного |/; s/→ 12/→ немного/; s/→ 40/→ много/; s/^title.*/title: \"Как устроен рубанок\"/; s/^# .*/# Как устроен рубанок/' "${good}")"
    "$(sed '/^## Чего мы не мерили$/,+3d' "${good}")"
    "$(sed 's/различить нельзя, чей это отказ — наш или чужой/это отдельная работа на потом/' "${good}")"
    "$(sed '/^```/d;/^grep -c правило core.txt$/d' "${good}")"
    "$(sed 's/^Рубанок делит работу надвое/Сначала мы ошиблись: правка от 2 сентября переписала половину/' "${good}")"
  )

  out="$("$0" --term baseline "${good}" 2>&1)"
  rc=$?
  if [[ ${rc} -ne 0 ]]; then
    printf 'selftest: the good article was rejected\n%s\n' "${out}"
    failures=$((failures + 1))
  fi

  for i in "${!bad_texts[@]}"; do
    printf '%s\n' "${bad_texts[i]}" > "${dir}/bad.md"
    out="$("$0" --term baseline "${dir}/bad.md" 2>&1)"
    rc=$?
    if [[ ${rc} -eq 0 ]]; then
      printf 'selftest: passed a broken article — %s\n' "${bad_names[i]}"
      failures=$((failures + 1))
    elif ! grep -qF -- "${bad_expect[i]}" <<<"${out}"; then
      printf 'selftest: %s failed for the wrong reason\n%s\n' "${bad_names[i]}" "${out}"
      failures=$((failures + 1))
    else
      printf 'caught: %-38s %s\n' "${bad_names[i]}" \
        "$(printf '%s' "${out}" | grep -F -- "${bad_expect[i]}" | sed 's/^ *- //')"
    fi
  done

  # An undeclared Latin term must be caught, and a declared one must not.
  sed 's/Термин baseline/Термин self-consistency/; s/дальше идёт только baseline/дальше идёт только self-consistency/' "${good}" > "${dir}/term.md"
  out="$("$0" "${dir}/term.md" 2>&1)"
  if [[ $? -eq 0 ]]; then
    printf 'selftest: passed an undeclared term\n'
    failures=$((failures + 1))
  else
    printf 'caught: %-38s %s\n' "undeclared Latin term" "$(printf '%s' "${out}" | sed -n '2s/^ *- //p')"
  fi

  if [[ ${failures} -eq 0 ]]; then
    printf 'selftest: 9 of 9 — the good article passes, every broken one is named\n'
    return 0
  fi
  printf 'selftest: %d failures\n' "${failures}"
  return 1
}

if [[ ${selftest} -eq 1 ]]; then
  run_selftest || exit 1
  [[ ${#files[@]} -eq 0 ]] && exit 0
fi

# ── the checks ───────────────────────────────────────────────────────────────

exit_code=0

for file in "${files[@]}"; do
  problems=()

  if [[ ! -f "${file}" ]]; then
    printf 'FAIL %s\n       - not a file\n' "${file}"
    exit_code=1
    continue
  fi

  # Layers are split on the RAW file — the shortcode that marks a box is the
  # first thing strip_markup would delete — and each layer is stripped after.
  work="${TMPDIR:-/tmp}/check-post.$$"
  split_layer "${file}" main > "${work}.main"
  split_layer "${file}" box  > "${work}.box"
  main="$(strip_markup < "${work}.main")"
  box="$(strip_markup < "${work}.box")"
  main_prose="$(strip_markup drop < "${work}.main")"
  printf '%s\n' "${main}" > "${work}.screen"
  screen="$(first_screen "${work}.screen")"

  main_chars="$(chars "${main}")"
  box_chars="$(chars "${box}")"
  screen_chars="$(chars "${screen}")"
  screen_numbers="$(count_re "${screen}" '[0-9]+')"

  # 1. one title, and only one.  Counted on the PROSE: a `# comment` inside a
  # fenced block is not a title, and an article full of shell listings has many.
  h1="$(printf '%s\n' "${main}" | grep -c '^# ')"
  (( h1 == 1 )) || problems+=("${h1} level-1 titles, need exactly 1 — the title is what the article list shows")

  # 2 and 3. the first screen holds the answer, and the answer has numbers.
  (( screen_chars > first_screen_max )) \
    && problems+=("first screen is ${screen_chars} prose characters, cap ${first_screen_max} — the answer is below the fold")
  (( screen_numbers < numbers_min )) \
    && problems+=("${screen_numbers} numbers on the first screen, need ${numbers_min} — an answer without numbers cannot be refuted")

  # 4. the border of the knowledge is a section, not a footnote.
  grep -qiE '^#{2,3} .*(не мерил|не знаем|не проверял|границ|did not measure|we did not|not measured|limits)' "${file}" \
    || problems+=("no section naming the border of the knowledge (Чего мы не мерили / What we did not measure)")

  # 5. a negative or undecided result is stated somewhere.
  grep -qiE 'не выигр|не подня|проигр|вред|различить (нельзя|не удалось)|не удалось|не устоял|не окупил|ни разу|хуже|did not win|lost|worse|no difference|cannot be told apart|does harm|never' <<<"${main}" \
    || problems+=("no negative or undecided result anywhere in the main layer — an article where everything worked is an advertisement")

  # 6. something to copy that is not a picture.
  copyable="$(awk '/^[[:space:]]*```/ { if (!inf) { inf = 1; if ($0 !~ /mermaid/) n++ } else inf = 0 } END { print n + 0 }' "${file}")"
  (( copyable > 0 )) \
    || problems+=("no fenced block a reader could copy (mermaid diagrams do not count)")

  # 7. our own history is not what meets the reader.
  if grep -qiE 'наша ошибка|мы ошиблись|правка от|почему вчера|наш разбор|our mistake|we were wrong|correction of' <<<"${screen}"; then
    problems+=("our own post-mortem is on the first screen — it belongs in one line at the end")
  fi

  # 8. every declared term is used and explained where it first appears.
  explained=0
  for term in "${terms[@]}"; do
    [[ -z "${term}" ]] && continue
    if ! grep -qiF -- "${term}" <<<"${main}"; then
      problems+=("declared term «${term}» never appears in the main layer")
      continue
    fi
    # The gloss is either the phrase that FOLLOWS the term — «baseline — это …» —
    # or the sentence the term is a parenthetical of: «прогон тестов (HumanEval)».
    around="$(printf '%s' "${main}" | tr '\n' ' ' | awk -v t="${term}" -v w="${window}" '
      { i = index(tolower($0), tolower(t)); if (i == 0) exit;
        print substr($0, i - 1, 1) substr($0, i + length(t), w) }')"
    if printf '%s' "${around}" | grep -qE '^\(|[—–(:]|[[:space:]]-[[:space:]]'; then
      explained=$((explained + 1))
    else
      problems+=("term «${term}» is not explained where it first appears — one sentence, then use the term")
    fi
  done

  # 8b. jargon the author forgot to declare, in a mostly-Cyrillic file only.
  cyr="$(count_re "${main_prose}" '[А-Яа-яЁё]')"
  lat="$(count_re "${main_prose}" '[A-Za-z]')"
  undeclared=""
  if (( cyr > lat )); then
    declared_re="$(printf '%s\n' "${terms[@]}" | grep -c . )"
    undeclared="$(printf '%s' "${main_prose}" \
      | grep -oE '[A-Za-z][A-Za-z0-9]{2,}(-[A-Za-z0-9]+)*' \
      | sort | uniq -c | sort -rn \
      | awk '$1 >= 2 { print $2 }' \
      | while IFS= read -r word; do
          hit=0
          for term in "${terms[@]:-}"; do
            [[ -z "${term}" ]] && continue
            if printf '%s' "${term}" | grep -qiF -- "${word}" || printf '%s' "${word}" | grep -qiF -- "${term}"; then
              hit=1; break
            fi
          done
          (( hit == 0 )) && printf '%s ' "${word}"
        done)"
    if [[ -n "${undeclared}" ]]; then
      problems+=("Latin terms used twice or more and never declared: ${undeclared}— declare them with --term and gloss each at first use")
    fi
    : "${declared_re}"
  fi

  rm -f "${work}.main" "${work}.box" "${work}.screen"

  if [[ ${report} -eq 1 ]]; then
    printf 'NUMBERS %s\n' "${file}"
    printf '       prose characters, main layer   %s\n' "${main_chars}"
    printf '       prose characters, boxes        %s\n' "${box_chars}"
    printf '       first screen, characters       %s (cap %s)\n' "${screen_chars}" "${first_screen_max}"
    printf '       first screen, numbers          %s (floor %s)\n' "${screen_numbers}" "${numbers_min}"
    printf '       terms declared / explained     %s / %s\n' "$(printf '%s\n' "${terms[@]:-}" | grep -c .)" "${explained}"
    printf '       copyable blocks                %s\n' "${copyable}"
    printf '       mermaid diagrams               %s\n' "$(grep -c '^[[:space:]]*```mermaid' "${file}")"
  fi

  if [[ ${#problems[@]} -eq 0 ]]; then
    printf 'OK   %s  (first screen %s chars, %s numbers; main %s, boxes %s; %s copyable, %s terms)\n' \
      "${file}" "${screen_chars}" "${screen_numbers}" "${main_chars}" "${box_chars}" \
      "${copyable}" "$(printf '%s\n' "${terms[@]:-}" | grep -c .)"
  else
    printf 'FAIL %s\n' "${file}"
    printf '       - %s\n' "${problems[@]}"
    exit_code=1
  fi
done

exit "${exit_code}"
