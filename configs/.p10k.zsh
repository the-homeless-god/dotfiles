# Приглашение оболочки в палитре Digitable.
#
# Файл читает powerlevel10k. Подключает его `.zshrc` строкой
# `[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh` — последней из всего, что
# задаёт цвета, поэтому заданное здесь не перекрывается ничем.
#
# Почему конфиг, а не форк темы. Все точки настройки p10k — это переменные
# POWERLEVEL9K_*, а свой сегмент пишется функцией `prompt_<имя>` прямо в этом
# файле через открытую команду `p10k segment` (см. «Свой сегмент» в конце).
# Иначе говоря, менять код темы не за чем: цвет, состав, значки и свои
# сегменты берутся отсюда. Форк обязал бы вечно тянуть чужой апстрим — за то
# же самое.
#
# Почему стиль lean, а не classic или rainbow. Lean не заливает сегменты
# фоном совсем (POWERLEVEL9K_BACKGROUND пуст), то есть весь текст лежит на
# фоне терминала — а он у нас bg0 (configs/.alacritty.toml). Значит контраст
# каждого цвета здесь — это ровно «Контраст цвета» из theme/digitable.flang,
# уже посчитанный и уже проверенный порогом 4.5. Ни одной новой пары
# «текст на подложке» этот файл в спеку не добавляет. Classic заливает всё
# одной подложкой, rainbow — своей на каждый сегмент (111 параметров
# BACKGROUND против нуля у lean): и то и другое потребовало бы измерить
# заново каждый цвет на каждой новой подложке.
#
# Цвета названы шестнадцатеричными числами, а не именами вроде `red` и не
# номерами 256-цветной палитры. Имя достаёт из палитры ТЕРМИНАЛА не тема, а
# сам терминал: под чужим профилем `red` — чужой красный. Hex p10k понимает
# сам (internal/p10k.zsh, _p9k_translate_color); на 256-цветном терминале его
# подменяет ближайшим цветом модуль zsh/nearcolor, который включает `.zshrc`.
#
# Задано 151 значение цвета — все 87 сегментов p10k и все их состояния. Это
# больше, чем в шаблоне мастера (118 у lean): шаблон молчит про конфликт
# слияния, про режимы vi, про каталог только для чтения, про ssh, про
# пользователя и хост — там цвет достаётся из палитры терминала по имени
# (`yellow1`, `blue`, `white`) или по номеру ANSI. Прогон под настоящим zsh
# показывает 152 принятых параметра цвета (два p10k выводит из массива
# заряда) и ни одного значения не из палитры.
#
# Значения — из theme/digitable.flang, оттуда же и контрасты в скобках:
#   white    #f5f7fa  18.69   green   #7cff6b  15.64   cyan   #00e5e5  12.74
#   yellow   #ffc247  12.47   cyansoft #00d8ff 11.72   orange #ff8a2a   8.52
#   muted    #9baab8   8.44   blue    #3ca9ff   7.94   red    #ff5b5b   6.59
#   purple   #b65cff   5.70   subtle  #718695   5.30
# Порог AA для обычного текста — 4.5; самый тусклый здесь subtle с 5.30.
# Сверяет всё это scripts/check-theme.sh.
#
# ⛔ `p10k configure` перезапишет этот файл мастером — со 118 цветами из
# 256-цветной палитры и ни одним нашим. Правьте руками.

'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  # Всё заданное раньше — сбрасывается. Иначе останки прошлой настройки
  # (или чужого ~/.p10k.zsh) продолжили бы красить.
  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  # ── Состав приглашения ────────────────────────────────────────────────
  # Слева — где я и чем кончилась прошлая команда; справа — чем занята
  # машина. Список короче исходного: сегменты для инструментов, которых
  # этот набор не ставит (asdf, aws, gcloud, azure, kubectl, terraform,
  # chezmoi, taskwarrior и прочие), в него не входят. Цвета им ниже всё
  # равно заданы — чтобы добавленный сюда сегмент сразу оказался в палитре,
  # а не в чужой.
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    os_icon                 # значок системы
    dir                     # текущий каталог
    vcs                     # состояние git
    newline                 #
    prompt_char             # знак приглашения
  )
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    status                  # код возврата прошлой команды
    command_execution_time  # сколько она шла
    background_jobs         # фоновые задачи
    direnv                  # direnv
    virtualenv              # окружение python
    anaconda                # окружение conda
    pyenv                   # версия python
    goenv                   # версия go
    nodenv                  # версия node из nodenv
    nvm                     # версия node из nvm
    nodeenv                 # окружение node
    rbenv                   # версия ruby из rbenv
    rvm                     # версия ruby из rvm
    fvm                     # версия flutter
    context                 # пользователь@машина
    nordvpn                 # состояние nordvpn
    ranger                  # оболочка ranger
    yazi                    # оболочка yazi
    nnn                     # оболочка nnn
    lf                      # оболочка lf
    xplr                    # оболочка xplr
    vim_shell               # оболочка из vim (:sh)
    midnight_commander      # оболочка mc
    nix_shell               # оболочка nix
    todo                    # незакрытые дела
    per_directory_history   # история: своя или общая
    battery                 # заряд
    time                    # часы
    newline                 #
  )

  # ── Общее ─────────────────────────────────────────────────────────────
  # Значки берутся из шрифта MesloLGS NF — его ставит install_configs
  # вместе с остальными шрифтами из configs/fonts.
  typeset -g POWERLEVEL9K_MODE=nerdfont-complete
  typeset -g POWERLEVEL9K_ICON_PADDING=none

  # Подложки нет ни у одного сегмента — это и есть lean. Отсюда же и
  # довод про контраст в шапке: весь текст лежит на фоне терминала.
  typeset -g POWERLEVEL9K_BACKGROUND=
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR=
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=

  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_SUFFIX=
  typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_SUFFIX=
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR=' '

  # Мастер p10k пишет сюда `verbose` — предупреждение о выводе до
  # приглашения. Оставлено: молчаливый режим прячет ровно ту ошибку, из-за
  # которой мгновенное приглашение и ломается.
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose
  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=off

  # ── Где я ─────────────────────────────────────────────────────────────
  # Бирюзовый — роль «имя» из спеки: тем же цветом схема Vim красит имена.
  typeset -g POWERLEVEL9K_DIR_FOREGROUND='#00e5e5'
  typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND='#00e5e5'
  typeset -g POWERLEVEL9K_CPU_ARCH_FOREGROUND='#00e5e5'
  typeset -g POWERLEVEL9K_HOST_LOCAL_FOREGROUND='#00e5e5'
  typeset -g POWERLEVEL9K_USER_DEFAULT_FOREGROUND='#00e5e5'
  # Обычный режим vi — «командую», а не «печатаю»: тот же цвет, что у места.
  typeset -g POWERLEVEL9K_VI_MODE_NORMAL_FOREGROUND='#00e5e5'

  # Якорь пути — каталог с признаком корня проекта (список ниже). Белый:
  # это самое нужное слово в строке, 18.69 — самый высокий контраст палитры.
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND='#f5f7fa'
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
  local anchor_files=(
    .git .node-version .python-version .ruby-version .go-version .shorten_folder_marker
    package.json Cargo.toml go.mod Makefile CMakeLists.txt mix.exs
  )
  typeset -g POWERLEVEL9K_SHORTEN_FOLDER_MARKER="(${(j:|:)anchor_files})"
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
  typeset -g POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER=false
  typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=80
  typeset -g POWERLEVEL9K_DIR_HYPERLINK=false

  # ── Тихое служебное ───────────────────────────────────────────────────
  # Приглушённый — роль «комментарий»: 5.30 на bg0, выше порога, но заметно
  # тише всего остального. Тем же цветом красит комментарии схема Vim и
  # подсказку ввода — ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE в .zshrc.
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND='#718695'
  typeset -g POWERLEVEL9K_TIME_FOREGROUND='#718695'
  typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'
  typeset -g POWERLEVEL9K_RULER_FOREGROUND='#718695'
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_FOREGROUND='#718695'
  typeset -g POWERLEVEL9K_VCS_LOADING_VISUAL_IDENTIFIER_COLOR='#718695'
  typeset -g POWERLEVEL9K_PER_DIRECTORY_HISTORY_GLOBAL_FOREGROUND='#718695'
  typeset -g POWERLEVEL9K_DATE_FOREGROUND='#718695'
  typeset -g POWERLEVEL9K_HISTORY_FOREGROUND='#718695'
  # Состояние git ещё считается. У p10k здесь ANSI-цвет 8 — «яркий чёрный»
  # из палитры терминала, на тёмном фоне читаемый как повезёт.
  typeset -g POWERLEVEL9K_VCS_LOADING_FOREGROUND='#718695'

  # ── Постоянные величины ───────────────────────────────────────────────
  # Значок системы и объём памяти новостей не несут: они одни и те же на
  # каждом приглашении. Приглушённый посветлее — 8.44, вдвое выше порога.
  typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND='#9baab8'
  typeset -g POWERLEVEL9K_RAM_FOREGROUND='#9baab8'

  # ── Связь наружу ──────────────────────────────────────────────────────
  # Второй бирюзовый — в спеке он назван цветом ссылок и документов; сеть
  # ровно это и есть: адрес, по которому лежит не здешнее.
  typeset -g POWERLEVEL9K_IP_FOREGROUND='#00d8ff'
  typeset -g POWERLEVEL9K_PUBLIC_IP_FOREGROUND='#00d8ff'
  typeset -g POWERLEVEL9K_VPN_IP_FOREGROUND='#00d8ff'
  typeset -g POWERLEVEL9K_WIFI_FOREGROUND='#00d8ff'
  typeset -g POWERLEVEL9K_PROXY_FOREGROUND='#00d8ff'
  typeset -g POWERLEVEL9K_NORDVPN_FOREGROUND='#00d8ff'
  typeset -g POWERLEVEL9K_SSH_FOREGROUND='#00d8ff'
  typeset -g POWERLEVEL9K_DROPBOX_FOREGROUND='#00d8ff'

  # ── Всё на месте ──────────────────────────────────────────────────────
  # Зелёный — «сошлось»: чистое дерево, нулевой код возврата, нагрузка в
  # норме. Он же у версий среды: закреплённая версия — это тоже «сошлось»,
  # роль «тип» из спеки.
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_COLOR='#7cff6b'
  typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_STATUS_OK=false
  typeset -g POWERLEVEL9K_STATUS_OK_PIPE=true
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIVIS_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIOWR_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_LOAD_NORMAL_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_DISK_USAGE_NORMAL_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_DIRENV_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_PACKAGE_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_VIRTUALENV_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_ANACONDA_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_PYENV_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_GOENV_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_GO_VERSION_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_NODENV_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_NODEENV_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_NVM_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_NODE_VERSION_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_RBENV_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_RVM_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_LUAENV_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_JENV_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_JAVA_VERSION_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_PLENV_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_PERLBREW_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_PHPENV_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_PHP_VERSION_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_LARAVEL_VERSION_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_SCALAENV_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_HASKELL_STACK_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_RUST_VERSION_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_DOTNET_VERSION_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_FVM_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_ASDF_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_ASDF_DOTNET_CORE_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_ASDF_ELIXIR_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_ASDF_ERLANG_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_ASDF_FLUTTER_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_ASDF_GOLANG_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_ASDF_HASKELL_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_ASDF_JAVA_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_ASDF_JULIA_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_ASDF_LUA_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_ASDF_NODEJS_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_ASDF_PERL_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_ASDF_PHP_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_ASDF_POSTGRES_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_ASDF_PYTHON_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_ASDF_RUBY_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_ASDF_RUST_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_CHRUBY_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_SWIFT_VERSION_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_SYMFONY2_VERSION_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_OPENFOAM_FOREGROUND='#7cff6b'
  # Ввод в режиме vi — «печатаю», то же «всё идёт как надо».
  typeset -g POWERLEVEL9K_VI_MODE_INSERT_FOREGROUND='#7cff6b'
  # Доля пройденных тестов: те же четыре ступени, что у заряда, только
  # ступеней три. Базовый параметр задавать не нужно — p10k спрашивает
  # сначала <СЕГМЕНТ>_<СОСТОЯНИЕ>_FOREGROUND и лишь потом <СЕГМЕНТ>_FOREGROUND.
  typeset -g POWERLEVEL9K_RSPEC_STATS_GOOD_FOREGROUND='#7cff6b'
  typeset -g POWERLEVEL9K_SYMFONY2_TESTS_GOOD_FOREGROUND='#7cff6b'

  # ── Изменено, но не сломано ───────────────────────────────────────────
  # Жёлтый — предупреждение: правки не сохранены, нагрузка подросла, своп
  # тронут, команда шла дольше порога (сегмент появляется только тогда —
  # само его появление и есть сообщение «долго»), сессия не на своей машине.
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='#ffc247'
  typeset -g POWERLEVEL9K_LOAD_WARNING_FOREGROUND='#ffc247'
  typeset -g POWERLEVEL9K_DISK_USAGE_WARNING_FOREGROUND='#ffc247'
  typeset -g POWERLEVEL9K_SWAP_FOREGROUND='#ffc247'
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND='#ffc247'
  typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE=false
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#ffc247'
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
  typeset -g POWERLEVEL9K_CONTEXT_REMOTE_FOREGROUND='#ffc247'
  typeset -g POWERLEVEL9K_TODO_FOREGROUND='#ffc247'
  typeset -g POWERLEVEL9K_TASKWARRIOR_FOREGROUND='#ffc247'
  typeset -g POWERLEVEL9K_TIMEWARRIOR_FOREGROUND='#ffc247'
  typeset -g POWERLEVEL9K_HOST_REMOTE_FOREGROUND='#ffc247'
  typeset -g POWERLEVEL9K_RSPEC_STATS_AVG_FOREGROUND='#ffc247'
  typeset -g POWERLEVEL9K_SYMFONY2_TESTS_AVG_FOREGROUND='#ffc247'
  # Выделение в режиме vi. Жёлтый — по спеке отметка выбранного; тем же
  # цветом помечают выбранное файловые менеджеры.
  typeset -g POWERLEVEL9K_VI_MODE_VISUAL_FOREGROUND='#ffc247'

  # ── Новое, ещё не сосчитанное ─────────────────────────────────────────
  # Синий — роль «ключевое слово»: файл в дереве есть, а git его пока не
  # знает. Своя история каталога — из той же породы: она есть, но только
  # здесь.
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='#3ca9ff'
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'
  typeset -g POWERLEVEL9K_PER_DIRECTORY_HISTORY_LOCAL_FOREGROUND='#3ca9ff'

  # ── Прицел не туда, куда обычно ───────────────────────────────────────
  # Оранжевый — тот же, что у заряда между 20 и 30: «не беда, но смотри
  # внимательно». Эти сегменты говорят, КУДА пойдёт следующая команда;
  # ошибиться здесь дороже всего.
  typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_FOREGROUND='#ff8a2a'
  typeset -g POWERLEVEL9K_TERRAFORM_VERSION_FOREGROUND='#ff8a2a'
  typeset -g POWERLEVEL9K_TERRAFORM_OTHER_FOREGROUND='#ff8a2a'
  typeset -g POWERLEVEL9K_AWS_DEFAULT_FOREGROUND='#ff8a2a'
  typeset -g POWERLEVEL9K_AWS_EB_ENV_FOREGROUND='#ff8a2a'
  typeset -g POWERLEVEL9K_AZURE_OTHER_FOREGROUND='#ff8a2a'
  typeset -g POWERLEVEL9K_GCLOUD_FOREGROUND='#ff8a2a'
  typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_DEFAULT_FOREGROUND='#ff8a2a'
  typeset -g POWERLEVEL9K_DOCKER_MACHINE_FOREGROUND='#ff8a2a'
  # Замена вместо вставки в режиме vi: печатаешь поверх написанного.
  typeset -g POWERLEVEL9K_VI_MODE_OVERWRITE_FOREGROUND='#ff8a2a'
  #
  # Ловушка на все остальные состояния этих сегментов. Имя состояния у них
  # берётся из самого значения — из имени профиля AWS, контекста kubernetes,
  # рабочего пространства terraform. Строчкой выше покрашено только состояние
  # «default»; профиль с любым другим именем спрашивает
  # <СЕГМЕНТ>_<ИМЯ>_FOREGROUND, не находит и падает на <СЕГМЕНТ>_FOREGROUND —
  # а без него уходит в цвет p10k по умолчанию. То есть в проде, где имя
  # профиля как раз не «default», приглашение красил бы не мы.
  typeset -g POWERLEVEL9K_AWS_FOREGROUND='#ff8a2a'
  typeset -g POWERLEVEL9K_AZURE_FOREGROUND='#ff8a2a'
  typeset -g POWERLEVEL9K_KUBECONTEXT_FOREGROUND='#ff8a2a'
  typeset -g POWERLEVEL9K_TERRAFORM_FOREGROUND='#ff8a2a'
  typeset -g POWERLEVEL9K_GOOGLE_APP_CRED_FOREGROUND='#ff8a2a'

  # ── Ты внутри другой оболочки ─────────────────────────────────────────
  # Фиолетовый — роль «объявление»; в EZA_COLORS тем же цветом помечено
  # особое: сокеты, ссылки на устройства, медиа. Здесь то же по смыслу —
  # оболочка не обычная, и `exit` вернёт не туда, куда кажется.
  typeset -g POWERLEVEL9K_NIX_SHELL_FOREGROUND='#b65cff'
  typeset -g POWERLEVEL9K_CHEZMOI_SHELL_FOREGROUND='#b65cff'
  typeset -g POWERLEVEL9K_VIM_SHELL_FOREGROUND='#b65cff'
  typeset -g POWERLEVEL9K_MIDNIGHT_COMMANDER_FOREGROUND='#b65cff'
  typeset -g POWERLEVEL9K_TOOLBOX_FOREGROUND='#b65cff'
  typeset -g POWERLEVEL9K_RANGER_FOREGROUND='#b65cff'
  typeset -g POWERLEVEL9K_LF_FOREGROUND='#b65cff'
  typeset -g POWERLEVEL9K_NNN_FOREGROUND='#b65cff'
  typeset -g POWERLEVEL9K_YAZI_FOREGROUND='#b65cff'
  typeset -g POWERLEVEL9K_XPLR_FOREGROUND='#b65cff'
  # Работа внутри виртуальной машины или контейнера — то же самое, только
  # оболочка не своя целиком.
  typeset -g POWERLEVEL9K_DETECT_VIRT_FOREGROUND='#b65cff'

  # ── Беда ──────────────────────────────────────────────────────────────
  # Красный — тот же, что у заряда ниже 20. Корень и sudo на чужой машине
  # тоже здесь: это единственный контекст, где опечатка не отменяется.
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND='#ff5b5b'
  typeset -g POWERLEVEL9K_STATUS_ERROR_PIPE_FOREGROUND='#ff5b5b'
  typeset -g POWERLEVEL9K_STATUS_ERROR_SIGNAL_FOREGROUND='#ff5b5b'
  typeset -g POWERLEVEL9K_STATUS_ERROR=false
  typeset -g POWERLEVEL9K_STATUS_VERBOSE_SIGNAME=false
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND='#ff5b5b'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_FOREGROUND='#ff5b5b'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIVIS_FOREGROUND='#ff5b5b'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIOWR_FOREGROUND='#ff5b5b'
  typeset -g POWERLEVEL9K_LOAD_CRITICAL_FOREGROUND='#ff5b5b'
  typeset -g POWERLEVEL9K_DISK_USAGE_CRITICAL_FOREGROUND='#ff5b5b'
  typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND='#ff5b5b'
  typeset -g POWERLEVEL9K_CONTEXT_REMOTE_SUDO_FOREGROUND='#ff5b5b'
  # Незаконченное действие в git — слияние, перебазирование, сбор по частям.
  # Единственный цвет, который остаётся у p10k своим, если его не задать:
  # шаблон мастера про него молчит, а внутри стоит ANSI-цвет 1 — красный не
  # наш, а терминала. Нашёлся прогоном, а не чтением шаблона.
  typeset -g POWERLEVEL9K_VCS_ACTIONFORMAT_FOREGROUND='#ff5b5b'
  # Конфликт слияния. У p10k здесь ANSI-цвет 3 — тот же, что у «изменено»:
  # конфликт и правку не отличить, пока цвет красит терминал.
  typeset -g POWERLEVEL9K_VCS_CONFLICTED_FOREGROUND='#ff5b5b'
  # Каталог только для чтения. Умолчание p10k — имя цвета yellow1, то есть
  # снова палитра терминала.
  typeset -g POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_FOREGROUND='#ff5b5b'
  typeset -g POWERLEVEL9K_ROOT_INDICATOR_FOREGROUND='#ff5b5b'
  typeset -g POWERLEVEL9K_USER_ROOT_FOREGROUND='#ff5b5b'
  typeset -g POWERLEVEL9K_USER_SUDO_FOREGROUND='#ff5b5b'
  typeset -g POWERLEVEL9K_RSPEC_STATS_BAD_FOREGROUND='#ff5b5b'
  typeset -g POWERLEVEL9K_SYMFONY2_TESTS_BAD_FOREGROUND='#ff5b5b'

  # Знак приглашения: форма та же, что у мастера, цвет — наш (выше).
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_CONTENT_EXPANSION='❯'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_CONTENT_EXPANSION='❯'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VICMD_CONTENT_EXPANSION='❮'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VICMD_CONTENT_EXPANSION='❮'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIVIS_CONTENT_EXPANSION='V'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIVIS_CONTENT_EXPANSION='V'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIOWR_CONTENT_EXPANSION='▶'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIOWR_CONTENT_EXPANSION='▶'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=

  # ── Заряд батареи ─────────────────────────────────────────────────────
  # Своего цвета у батареи в p10k нет. По умолчанию (internal/p10k.zsh,
  # _p9k_battery_states) она красится ИМЕНАМИ ANSI-цветов: LOW — red,
  # CHARGING — yellow, CHARGED — green, а «на батарее, заряда хватает» —
  # цветом 7, то есть просто белым. Имена достаёт из палитры терминала сам
  # терминал, не тема.
  #
  # Пороги те же, что у блока батареи в нижней панели tmux
  # (configs/.config/tmux/battery.sh). Источник — функция «Пороги заряда» в
  # theme/digitable.flang, там же посчитан контраст каждой плашки. Что три
  # места не разъедутся, сторожит scripts/check-theme.sh.
  #
  # Цвет состояния бьёт цвет уровня: _p9k_param ищет
  # POWERLEVEL9K_BATTERY_<состояние>_FOREGROUND раньше, чем берёт то, что
  # сегмент подставил из массива. Мастер p10k пишет туда 160, 70 и 178 —
  # числа 256-цветной палитры, ни одного нашего. Здесь эти четыре
  # переменные НЕ задаются вовсе: массив ниже красит те же четыре
  # состояния, только по проценту, а не по одному цвету на состояние.
  #
  # Массив читается по проценту: p10k берёт элемент с номером
  # «процент * длина / 100 + 1». При ста элементах номер равен проценту,
  # поэтому порог оказывается ровно там, где написан. Короткий массив
  # (скажем, из четырёх) резал бы шкалу на четверти — 25/50/75, а это уже
  # другие числа.
  typeset -ga POWERLEVEL9K_BATTERY_LEVEL_FOREGROUND=()
  local -i p
  for (( p = 0; p < 100; p++ )); do
    if   (( p < 20 )); then POWERLEVEL9K_BATTERY_LEVEL_FOREGROUND+='#ff5b5b'
    elif (( p < 30 )); then POWERLEVEL9K_BATTERY_LEVEL_FOREGROUND+='#ff8a2a'
    elif (( p < 60 )); then POWERLEVEL9K_BATTERY_LEVEL_FOREGROUND+='#ffc247'
    else                    POWERLEVEL9K_BATTERY_LEVEL_FOREGROUND+='#7cff6b'
    fi
  done

  # Ниже этого числа p10k считает состояние LOW. По умолчанию у него 10 —
  # то есть красный зажигается позже, чем система успевает предупредить.
  typeset -gi POWERLEVEL9K_BATTERY_LOW_THRESHOLD=20

  # Питание от сети: цвет говорит не про уровень, а про «не твоя забота».
  # Массив из одного элемента — номер всегда 1, процент на цвет не влияет.
  typeset -ga POWERLEVEL9K_BATTERY_CHARGING_LEVEL_FOREGROUND=('#00e5e5')
  typeset -ga POWERLEVEL9K_BATTERY_CHARGED_LEVEL_FOREGROUND=('#7cff6b')

  # Полоска заряда. У мастера её незаполненная часть залита цветом 232 —
  # почти чёрным из 256-цветной палитры, но не нашим фоном; на bg0 это
  # видно как чужой прямоугольник. Здесь она залита самим bg0.
  typeset -g POWERLEVEL9K_BATTERY_VERBOSE=false
  typeset -g POWERLEVEL9K_BATTERY_STAGES=(
    '%K{#05080d}▁' '%K{#05080d}▂' '%K{#05080d}▃' '%K{#05080d}▄'
    '%K{#05080d}▅' '%K{#05080d}▆' '%K{#05080d}▇' '%K{#05080d}█')

  # ── Свой сегмент ──────────────────────────────────────────────────────
  # Тот самый довод, ради которого форк не нужен: сегмент пишется здесь же
  # функцией prompt_<имя>, а рисуется открытой командой `p10k segment`
  # (`p10k help segment`). Цвет ему задаётся так же, как встроенным, —
  # переменной POWERLEVEL9K_<ИМЯ>_FOREGROUND. Чтобы включить, допишите
  # `digitable` в один из двух списков сегментов выше.
  #
  # function prompt_digitable() {
  #   p10k segment -f '#b65cff' -i '◆' -t 'digitable'
  # }
  # function instant_prompt_digitable() { prompt_digitable }
  # typeset -g POWERLEVEL9K_DIGITABLE_FOREGROUND='#b65cff'
}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
