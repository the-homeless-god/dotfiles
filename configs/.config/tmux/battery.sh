#!/bin/sh
#
# Блок заряда для нижней панели tmux.
#
# Почему не плагин. У dracula/tmux виджет батареи есть, но он красит блок ОДНИМ
# цветом на все проценты: scripts/dracula.sh читает @dracula-battery-colors
# (по умолчанию "pink dark_gray") один раз при загрузке и подставляет в строку
# как константу. 5% и 95% выглядят одинаково — цвет ничего не сообщает. Здесь
# цвет и есть сообщение, поэтому блок собирается сам.
#
# Почему цвет — заливка, а не текст. Оранжевый и красный как ТЕКСТ на фоне самой
# панели (#15566a) дают 3.47:1 и 2.68:1 — ниже порога 4.5. Те же цвета заливкой
# под тёмным текстом дают 8.52:1 и 6.59:1. Поэтому блок залит, а текст на нём —
# фон темы, как у всех остальных блоков панели.
#
# Откуда цвета. Из @dracula-colors — из того же места, откуда их берёт сам
# плагин. Числами здесь не записан ни один: единственное место с ними в дереве
# tmux — configs/.config/tmux/.tmux.conf, и его сторожит scripts/check-theme.sh.
#
# Пороги. Заданы в theme/digitable.flang, функция «Пороги заряда»; там же
# доказано, что текст на каждой из четырёх плашек берёт 4.5:1. Числа
# продублированы здесь по необходимости (sh не читает flang) — что они не
# разъедутся со спекой и с .zshrc, проверяет scripts/check-theme.sh.
#
# Значок уровень не показывает — его показывает цвет; значок только отличает
# «идёт зарядка» от «идёт разряд».
#
# $1 — имя цвета блока слева (из @dracula-colors). Под него красится фон
#      разделителя, иначе между блоками осталась бы дыра цвета панели.

set -u

left_name="${1:-gray}"

# Палитра берётся у tmux, а не пишется здесь.
palette="$(tmux show -gqv @dracula-colors 2>/dev/null)"
[ -n "$palette" ] || exit 0
eval "$palette"

# Не задана палитра целиком — молчим, а не красим чужим.
for name in green yellow orange red cyan dark_gray; do
    eval "value=\${$name:-}"
    [ -n "$value" ] || exit 0
done
eval "left=\${$left_name:-}"
[ -n "$left" ] || exit 0

percent=""
state=""

case "$(uname -s)" in
    Darwin)
        raw="$(pmset -g batt 2>/dev/null)"
        case "$raw" in
            *InternalBattery*) ;;
            *) exit 0 ;;
        esac
        percent="$(printf '%s\n' "$raw" | sed -n 's/.*[^0-9]\([0-9][0-9]*\)%.*/\1/p' | head -1)"
        state="$(printf '%s\n' "$raw" | sed -n '2p' | cut -d';' -f2 | tr -d ' ')"
        ;;
    Linux)
        for dir in /sys/class/power_supply/BAT* /sys/class/power_supply/*battery*; do
            [ -r "$dir/capacity" ] || continue
            percent="$(cat "$dir/capacity")"
            state="$(cat "$dir/status" 2>/dev/null | tr -d ' ')"
            break
        done
        # Машины без sysfs-батареи (и часть ноутбуков) отдают заряд через acpi —
        # тем же способом, что и dracula.
        if [ -z "$percent" ] && command -v acpi > /dev/null 2>&1; then
            line="$(acpi -b 2>/dev/null | head -1)"
            percent="$(printf '%s' "$line" | sed -n 's/.*, *\([0-9][0-9]*\)%.*/\1/p')"
            state="$(printf '%s' "$line" | cut -d: -f2- | cut -d, -f1 | tr -d ' ')"
        fi
        ;;
    *)
        exit 0
        ;;
esac

# Батареи нет вовсе — блока тоже нет. Настольная машина не должна получать
# пустую плашку в панели.
case "$percent" in
    "" | *[!0-9]*) exit 0 ;;
esac

case "$state" in
    [Cc]harging | ACattached | finishingcharge)
        fill="$cyan"
        icon="󰂄"
        ;;
    [Ff]ull | charged | [Nn]otcharging)
        fill="$green"
        icon="󰁹"
        ;;
    *)
        # Пороги. Каждая полоса — одной строкой: и граница, и цвет. Так их
        # читает и человек, и сторож scripts/check-theme.sh, который сверяет
        # эти четыре строки со спекой и с .zshrc.
        if   [ "$percent" -lt 20 ]; then level="$red"
        elif [ "$percent" -lt 30 ]; then level="$orange"
        elif [ "$percent" -lt 60 ]; then level="$yellow"
        else                             level="$green"
        fi
        fill="$level"
        icon="󰁾"
        ;;
esac

# Разделитель — тот же, которым плагин сшивает свои блоки; U+E0B2 из шрифта
# MesloLGS NF, который ставит этот же репозиторий.
sep="$(tmux show -gqv @dracula-show-right-sep 2>/dev/null)"
[ -n "$sep" ] || sep=""

# tmux разбирает #[...] в выводе #(), поэтому блок красит себя сам. Знак
# процента здесь одинарный: strftime tmux применяет к самой строке состояния, а
# не к выводу #(), — проверено снимком панели.
printf '#[fg=%s]#[bg=%s]%s#[fg=%s]#[bg=%s] %s %s%%#[default]' \
    "$fill" "$left" "$sep" "$dark_gray" "$fill" "$icon" "$percent"
