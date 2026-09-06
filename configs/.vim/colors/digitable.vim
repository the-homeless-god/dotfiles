" digitable.vim — тёмная схема Vim в палитре портала Digitable Courses.
"
" Maintainer:   the-homeless-god <mail@zimtir.com>
" License:      MIT, как и весь репозиторий (см. LICENSE).
"
" ОТКУДА ВЗЯТЫ ЦВЕТА. Ни одно значение здесь не подобрано на глаз. Их источника
" два, и они совпадают между собой байт в байт:
"
"   1. Токены портала — themes/github-style/static/css/digitable.tokens.css
"      в digitable-lol/courses: --digitable-bg-0/1/2, --digitable-white,
"      --digitable-muted, --digitable-border и семь акцентов (cyan, cyan-soft,
"      yellow, orange, purple, green, blue, red).
"   2. Палитра редакторов той же системы — products/workbench/themes/
"      focus-palettes.json, набор «carbon» (Digitable Focus Carbon). Все
"      четырнадцать значений там равны токенам портала; сверх них carbon даёт
"      три величины, которых в CSS портала нет, потому что в вёрстке они не
"      нужны, а в редакторе — нужны: subtle #718695, lineHighlight #07141E и
"      selection #15566A99.
"
" Проверка, что subtle — не выдумка: этим же #718695 портал красит подписи в
" макете рабочего места (static/css/workbench.css:3020 и :3538).
"
" ОТКУДА ВЗЯТА РАСКЛАДКА ПО РОЛЯМ. Какой цвет достаётся ключевому слову, какой
" строке, какой комментарию, решено не здесь. Портал держит РОВНО ОДНУ таблицу
" подсветки — themes/github-style/static/css/courses-v2.css:79-87, где девять
" ролей названы поимённо (шапка на :66-78 прямо запрещает заводить вторую):
"
"     declaration -> purple    keyword -> blue      operator -> cyan
"     type        -> green     literal -> orange    name     -> cyan
"     string      -> green     number  -> orange    comment  -> subtle
"
" Эти же девять ролей читают обе подсветки портала: Chroma в статьях
" (static/css/syntax.css:67-96) и собственный язык FTS/flang
" (static/css/fts.css:827-835, классы .f-*). Оттуда же взяты два начертания:
" объявление печатается полужирным (font-weight:650), комментарий — курсивом.
" Схема повторяет раскладку один в один, поэтому код в Vim выглядит так же,
" как тот же код в блоке на странице портала.
"
" Следствия, которые могут удивить, но они намеренные:
"   * Type и String — один цвет (зелёный). Так на портале: --course-syn-type и
"     --course-syn-string оба ссылаются на --course-code-green.
"   * Function и Operator — один цвет (бирюзовый), по той же причине.
"   * Identifier и Delimiter не окрашены вовсе. Портал не даёт правила ни для
"     .nv (переменная), ни для .p (пунктуация) — они наследуют цвет текста.
"     Здесь они получают цвет Normal явно, чтобы схема не оставляла группу на
"     умолчании Vim.
"
" ЧЕГО ПОРТАЛ НЕ ЗНАЕТ. У diff, поиска, всплывающего меню и статусной строки
" прямого прообраза в CSS нет. Для них взяты формулы самого портала:
" --fts-panel-ok-bg = «зелёный 12% поверх фона кода», --fts-panel-ok-line =
" «зелёный 30%» (static/css/fts.css:44-47), а подсветка совпадения поиска —
" «бирюзовый текст на 16-процентной подмеси бирюзового» (portal-search.css).
" Жёлтый в девятке ролей не занят ничем, поэтому он и достался поиску: спутать
" его с цветом синтаксиса нельзя.
"
" КОНТРАСТ. Каждая пара «текст / фон» измерена по WCAG 2.1. Весь синтаксис и
" вся статическая обвязка держат 4.5:1 и выше на фоне буфера (#05080d): худшее
" значение — 5.30 у комментария, дальше 5.70 у объявления. Ниже нормы намеренно
" оставлены три вещи, и только они:
"   * VertSplit, NonText, SpecialKey — 2.46:1. Это разделительная линия и знаки
"     listchars, то есть служебная графика, а не текст. Для сравнения: сам
"     портал рисует рамку панели ещё бледнее — 1.49:1 (--course-line #26303b
"     на --course-bg #07090d).
"   * ColorColumn — 1.06:1 к фону. Линейка полей обязана быть еле видной.
"   * EndOfBuffer — 1.00:1, то есть невидим. Это сохранённое намерение автора
"     .vimrc: там стояла попытка спрятать «~», не работавшая из-за неверной
"     записи цвета.
" Отдельно: пока текст выделен (Visual), комментарий даёт 3.36:1, объявление
" 3.61:1, ошибка 4.17:1 — ниже 4.5, но выше 3:1. Фон выделения не выдуман:
" это carbon.selection #15566A99, сведённый с фоном буфера (альфы у Vim нет).
" Тот же текст без выделения даёт 5.30, 5.70 и 6.59.
"
" 256 ЦВЕТОВ. У каждой группы есть ctermfg/ctermbg. Значения подобраны не на
" глаз, а как ближайшие к gui по CIEDE2000 в палитре xterm-256 (индексы 16-255;
" 0-15 не используются — их назначает сам терминал, и они не переносимы).
" Четыре отступления от «ближайшего», все вынужденные:
"   * bg-2 -> 234 вместо 233 (dE 6.57 против 5.71) и lineHighlight -> 235
"     вместо 233 (9.37 против 7.28): в gui это четыре РАЗНЫХ фона, а
"     ближайшим для трёх из них оказывается один и тот же 233. Лестница
"     232 < 233 < 234 < 235 < 236 сохраняет порядок яркостей оригинала.
"   * Подмешанные фоны (поиск, diff) в xterm-256 не существуют вовсе: самые
"     тёмные хроматические записи палитры — уровня 0x5f. Поэтому в терминале
"     подсветка поиска заливается самим бирюзовым, а diff — тёмными 22/52/58.
"     Каждая такая пара измерена отдельно и держит 4.5:1.
"   * DiffChange в 256 цветах пишется белым, а не жёлтым: жёлтый 214 на 58
"     даёт 3.64:1, белый — 6.72:1.

hi clear
if exists('syntax_on')
  syntax reset
endif

set background=dark
let g:colors_name = 'digitable'

" Палитра: имя -> [gui, cterm]. Всё, что ниже, ссылается только на эти имена,
" поэтому шестнадцатеричное число встречается в файле ровно один раз.
let s:p = {}

" Поверхности. Порядок яркости: bg0 < bg1 < bg2 < line < sel.
let s:p.bg0      = ['#05080d', '232']  " --digitable-bg-0 / carbon.background
let s:p.bg1      = ['#071018', '233']  " --digitable-bg-1 / carbon.surface
let s:p.bg2      = ['#0b111a', '234']  " --digitable-bg-2 / carbon.surfaceRaised
let s:p.line     = ['#07141e', '235']  " carbon.lineHighlight — строка под курсором
let s:p.sel      = ['#0f3745', '236']  " carbon.selection #15566A99 поверх bg0

" Текст.
let s:p.white    = ['#f5f7fa', '231']  " --digitable-white / carbon.foreground
let s:p.muted    = ['#9baab8', '248']  " --digitable-muted
let s:p.subtle   = ['#718695',  '67']  " carbon.subtle — комментарий, номера строк
let s:p.border   = ['#15566a',  '24']  " --digitable-border — линии и рамки

" Акценты. Роли — из courses-v2.css:79-87.
let s:p.cyan     = ['#00e5e5',  '44']  " operator, name
let s:p.cyansoft = ['#00d8ff',  '45']  " --digitable-cyan-soft
let s:p.blue     = ['#3ca9ff',  '75']  " keyword, ссылка
let s:p.green    = ['#7cff6b', '119']  " type, string, «получилось»
let s:p.yellow   = ['#ffc247', '214']  " в девятке ролей не занят: поиск, TODO
let s:p.orange   = ['#ff8a2a', '208']  " literal, number, предупреждение
let s:p.purple   = ['#b65cff', '135']  " declaration
let s:p.red      = ['#ff5b5b', '203']  " ошибка

" Производные. gui — по формулам портала; cterm — вынужденная замена, потому
" что тёмных подмесей в xterm-256 нет (пояснение в шапке).
let s:p.hitbg    = ['#042b30',  '44']  " бирюзовый 16% | в 256: заливка бирюзовым
let s:p.hitfg    = ['#00e5e5', '232']  " бирюзовый текст | в 256: тёмный по заливке
let s:p.addbg    = ['#132618',  '22']  " зелёный 12%
let s:p.addfg    = ['#7cff6b', '119']
let s:p.chgbg    = ['#231e14',  '58']  " жёлтый 12%
let s:p.chgfg    = ['#ffc247', '231']  " в 256 белым: жёлтый на 58 даёт 3.64
let s:p.delbg    = ['#231216',  '52']  " красный 12%
let s:p.delfg    = ['#ff5b5b', '203']
let s:p.txtbg    = ['#50401e', '214']  " жёлтый 30% | в 256: заливка жёлтым
let s:p.txtfg    = ['#f5f7fa', '232']
let s:p.txtaddbg = ['#295229', '119']  " зелёный 30% | в 256: заливка зелёной
let s:p.txtaddfg = ['#f5f7fa', '232']

" ctermul появился в 8.2.0863. Без него подчёркивание в терминале останется
" одноцветным — это лучше, чем ошибка E416 на каждой группе орфографии.
let s:ctermul = has('patch-8.2.0863')

" fg, bg, sp — имена из s:p либо пустая строка «не задавать».
" attr — список начертаний через запятую либо пустая строка (тогда NONE).
"
" Особый случай — 'NONE': он не наследует, а СНИМАЕТ цвет. Без него после
" `hi clear` в группе остаётся умолчание Vim: у Visual это guifg=LightGrey
" (выделенный текст терял бы цвет синтаксиса), у Spell* — ctermbg=9..13, то
" есть яркая цветная заливка опечатки в терминале на 256 цветов.
function! s:hi(group, fg, bg, sp, attr) abort
  let l:cmd = 'highlight ' . a:group
  if a:fg ==# 'NONE'
    let l:cmd .= ' guifg=NONE ctermfg=NONE'
  elseif !empty(a:fg)
    let l:cmd .= ' guifg=' . s:p[a:fg][0] . ' ctermfg=' . s:p[a:fg][1]
  endif
  if a:bg ==# 'NONE'
    let l:cmd .= ' guibg=NONE ctermbg=NONE'
  elseif !empty(a:bg)
    let l:cmd .= ' guibg=' . s:p[a:bg][0] . ' ctermbg=' . s:p[a:bg][1]
  endif
  let l:attr = empty(a:attr) ? 'NONE' : a:attr
  let l:cmd .= ' gui=' . l:attr . ' cterm=' . l:attr . ' term=' . l:attr
  if !empty(a:sp)
    let l:cmd .= ' guisp=' . s:p[a:sp][0]
    if s:ctermul
      let l:cmd .= ' ctermul=' . s:p[a:sp][1]
    endif
  endif
  execute l:cmd
endfunction

" =============================================================================
" Синтаксис. Раскладка ролей — courses-v2.css:79-87.
" =============================================================================

"                группа            fg          bg     sp    начертание
call s:hi('Normal',            'white',    'bg0',  '', '')

" comment -> subtle, курсивом (fts.css:835). 5.30:1
call s:hi('Comment',           'subtle',   '',     '', 'italic')
call s:hi('SpecialComment',    'muted',    '',     '', 'italic')

" literal -> orange. 8.52:1
call s:hi('Constant',          'orange',   '',     '', '')
call s:hi('Boolean',           'orange',   '',     '', '')
call s:hi('Number',            'orange',   '',     '', '')
call s:hi('Float',             'orange',   '',     '', '')
call s:hi('Debug',             'orange',   '',     '', '')

" string -> green. 15.64:1
call s:hi('String',            'green',    '',     '', '')
call s:hi('Character',         'green',    '',     '', '')
" .se (экранированный символ) отнесён порталом к строке — fts.css:927-929
call s:hi('SpecialChar',       'green',    '',     '', '')

" type -> green, тот же цвет что и у строки: так на портале
call s:hi('Type',              'green',    '',     '', '')

" name -> cyan. 12.74:1
call s:hi('Function',          'cyan',     '',     '', '')
" operator -> cyan
call s:hi('Operator',          'cyan',     '',     '', '')

" keyword -> blue. 7.94:1
call s:hi('Statement',         'blue',     '',     '', '')
call s:hi('Conditional',       'blue',     '',     '', '')
call s:hi('Repeat',            'blue',     '',     '', '')
call s:hi('Label',             'blue',     '',     '', '')
call s:hi('Keyword',           'blue',     '',     '', '')
call s:hi('Exception',         'blue',     '',     '', '')

" declaration -> purple, полужирным (fts.css:827). 5.70:1
call s:hi('PreProc',           'purple',   '',     '', 'bold')
call s:hi('Include',           'purple',   '',     '', 'bold')
call s:hi('Define',            'purple',   '',     '', 'bold')
call s:hi('Macro',             'purple',   '',     '', 'bold')
call s:hi('PreCondit',         'purple',   '',     '', 'bold')
call s:hi('StorageClass',      'purple',   '',     '', 'bold')
call s:hi('Structure',         'purple',   '',     '', 'bold')
call s:hi('Typedef',           'purple',   '',     '', 'bold')
call s:hi('Tag',               'purple',   '',     '', 'bold')

" Портал не красит .nv и .p — они наследуют цвет текста. Здесь то же самое,
" но записано явно, чтобы группа не осталась на умолчании Vim.
call s:hi('Identifier',        'white',    '',     '', '')
call s:hi('Delimiter',         'white',    '',     '', '')

" Прямого прообраза нет: второй акцент палитры. 11.72:1
call s:hi('Special',           'cyansoft', '',     '', '')

" Ссылка на портале — синяя с подчёркиванием (courses-v2.css:6634-6638)
call s:hi('Underlined',        'blue',     '',     '', 'underline')

" Chroma-класс .err портал намеренно не красит (fts.css:938), но группа Error
" в Vim — это не «непонятый лексером токен», а настоящая ошибка. Красная, без
" заливки: заливка достаётся сообщению об ошибке, а не куску текста. 6.59:1
call s:hi('Error',             'red',      'bg0',  '', 'bold')
call s:hi('Todo',              'bg0',      'yellow', '', 'bold')
call s:hi('Ignore',            'bg0',      'bg0',  '', '')

" Строчные пометки vim-9 для diff/patch-синтаксиса
call s:hi('Added',             'green',    '',     '', '')
call s:hi('Changed',           'yellow',   '',     '', '')
call s:hi('Removed',           'red',      '',     '', '')

" =============================================================================
" Курсор, строка курсора, номера строк
" =============================================================================

call s:hi('Cursor',            'bg0',      'cyan', '', '')
call s:hi('lCursor',           'bg0',      'yellow', '', '')
call s:hi('CursorLine',        '',         'line', '', '')
call s:hi('CursorColumn',      '',         'line', '', '')
" Линейка полей: 1.06:1 к фону — намеренно на грани видимости
call s:hi('ColorColumn',       '',         'bg2',  '', '')

" 5.30:1 — номер строки читается, но не спорит с текстом
call s:hi('LineNr',            'subtle',   'bg0',  '', '')
call s:hi('LineNrAbove',       'subtle',   'bg0',  '', '')
call s:hi('LineNrBelow',       'subtle',   'bg0',  '', '')
call s:hi('CursorLineNr',      'cyan',     'line', '', 'bold')
call s:hi('SignColumn',        'subtle',   'bg0',  '', '')
call s:hi('CursorLineSign',    'subtle',   'line', '', '')
call s:hi('FoldColumn',        'subtle',   'bg0',  '', '')
call s:hi('CursorLineFold',    'subtle',   'line', '', '')
call s:hi('Folded',            'muted',    'bg2',  '', '')
call s:hi('Conceal',           'subtle',   'bg0',  '', '')

" =============================================================================
" Служебная графика. Ниже 4.5:1 намеренно — это линии, а не текст.
" =============================================================================

" 2.46:1. Портал рисует свою рамку панели ещё бледнее — 1.49:1.
call s:hi('VertSplit',         'border',   'bg0',  '', '')
call s:hi('NonText',           'border',   'bg0',  '', '')
call s:hi('SpecialKey',        'border',   'bg0',  '', '')
" 1.00:1 — «~» за концом файла спрятан, как и хотел автор .vimrc
call s:hi('EndOfBuffer',       'bg0',      'bg0',  '', '')

" =============================================================================
" Выделение, поиск, скобки
" =============================================================================

" Фон — carbon.selection, сведённый с фоном буфера. Цвет текста не задан
" нарочно: синтаксис обязан оставаться виден и под выделением.
call s:hi('Visual',            'NONE',     'sel',  '', '')
call s:hi('VisualNOS',         'NONE',     'sel',  '', '')

" Ровно как совпадение поиска на портале: бирюзовый текст на 16-процентной
" подмеси бирюзового. 9.57:1
call s:hi('Search',            'hitfg',    'hitbg', '', '')
" «Вы здесь» — жёлтая заливка. 12.47:1
call s:hi('IncSearch',         'bg0',      'yellow', '', 'bold')
call s:hi('CurSearch',         'bg0',      'yellow', '', 'bold')
call s:hi('QuickFixLine',      'white',    'sel',  '', '')
" 8.07:1, с подчёркиванием — чтобы не спутать с подсветкой поиска
call s:hi('MatchParen',        'cyan',     'sel',  '', 'bold,underline')

" =============================================================================
" Статусная строка, вкладки
" =============================================================================

call s:hi('StatusLine',        'white',    'border', '', 'bold')
call s:hi('StatusLineNC',      'subtle',   'bg2',  '', '')
" Живой терминал — залит зелёным: у портала зелёный значит «получилось»
call s:hi('StatusLineTerm',    'bg0',      'green', '', 'bold')
call s:hi('StatusLineTermNC',  'subtle',   'bg2',  '', '')
call s:hi('MsgArea',           'white',    'bg0',  '', '')

call s:hi('TabLine',           'muted',    'bg1',  '', '')
call s:hi('TabLineSel',        'white',    'bg0',  '', 'bold')
call s:hi('TabLineFill',       'subtle',   'bg1',  '', '')
call s:hi('TabPanel',          'muted',    'bg1',  '', '')
call s:hi('TabPanelSel',       'white',    'bg0',  '', 'bold')
call s:hi('TabPanelFill',      'subtle',   'bg1',  '', '')
call s:hi('ToolbarLine',       '',         'bg1',  '', '')
call s:hi('ToolbarButton',     'white',    'bg2',  '', 'bold')

" =============================================================================
" Всплывающее меню. Выбранная строка залита акцентом — так портал красит
" первичную кнопку (--course-on-accent поверх --course-cyan).
" =============================================================================

call s:hi('Pmenu',             'white',    'bg2',  '', '')
call s:hi('PmenuSel',          'bg0',      'cyan', '', 'bold')
call s:hi('PmenuKind',         'blue',     'bg2',  '', '')
call s:hi('PmenuKindSel',      'bg0',      'cyan', '', '')
call s:hi('PmenuExtra',        'subtle',   'bg2',  '', '')
call s:hi('PmenuExtraSel',     'bg0',      'cyan', '', '')
call s:hi('PmenuMatch',        'yellow',   'bg2',  '', 'bold')
call s:hi('PmenuMatchSel',     'bg0',      'cyan', '', 'bold,underline')
call s:hi('PmenuSbar',         '',         'bg1',  '', '')
call s:hi('PmenuThumb',        '',         'border', '', '')
call s:hi('PmenuBorder',       'border',   'bg2',  '', '')
call s:hi('PmenuShadow',       'NONE',     'bg0',  '', '')
call s:hi('WildMenu',          'bg0',      'cyan', '', 'bold')
call s:hi('PopupSelected',     'bg0',      'cyan', '', '')
call s:hi('MessageWindow',     'white',    'bg2',  '', '')
call s:hi('PopupNotification', 'white',    'bg2',  '', '')
call s:hi('ComplMatchIns',     'subtle',   '',     '', '')
call s:hi('PreInsert',         'subtle',   '',     '', '')

" =============================================================================
" Сообщения
" =============================================================================

call s:hi('ErrorMsg',          'bg0',      'red',  '', 'bold')
call s:hi('WarningMsg',        'orange',   '',     '', '')
call s:hi('ModeMsg',           'cyan',     '',     '', 'bold')
call s:hi('MoreMsg',           'green',    '',     '', '')
call s:hi('Question',          'green',    '',     '', '')
call s:hi('Title',             'cyan',     '',     '', 'bold')
call s:hi('Directory',         'cyan',     '',     '', '')

" =============================================================================
" Diff. Фоны — по формулам портала для панелей «получилось» и «не получилось»:
" цвет 12% поверх фона, усиление 30% (fts.css:44-47). Цвет текста задан явно,
" как в .fts-playground__verdict, где зелёный текст лежит на зелёной подмеси.
" =============================================================================

call s:hi('DiffAdd',           'addfg',    'addbg', '', '')
call s:hi('DiffChange',        'chgfg',    'chgbg', '', '')
call s:hi('DiffDelete',        'delfg',    'delbg', '', '')
call s:hi('DiffText',          'txtfg',    'txtbg', '', 'bold')
call s:hi('DiffTextAdd',       'txtaddfg', 'txtaddbg', '', 'bold')

" =============================================================================
" Орфография. Цвет уходит в волну, слово сохраняет свой цвет.
" =============================================================================

call s:hi('SpellBad',          'NONE', 'NONE', 'red',    'undercurl')
call s:hi('SpellCap',          'NONE', 'NONE', 'yellow', 'undercurl')
call s:hi('SpellRare',         'NONE', 'NONE', 'purple', 'undercurl')
call s:hi('SpellLocal',        'NONE', 'NONE', 'cyan',   'undercurl')

" =============================================================================
" Отладчик (termdebug)
" =============================================================================

call s:hi('debugPC',           '',         'sel',  '', '')
call s:hi('debugBreakpoint',   'bg0',      'red',  '', 'bold')

" =============================================================================
" Плагины, которые ставит этот же .vimrc. Без них колонка знаков осталась бы
" в цветах плагина, а не схемы: signcolumn там включён всегда.
" =============================================================================

" dense-analysis/ale
call s:hi('ALEErrorSign',      'red',      'bg0',  '', 'bold')
call s:hi('ALEWarningSign',    'orange',   'bg0',  '', 'bold')
call s:hi('ALEInfoSign',       'blue',     'bg0',  '', 'bold')
call s:hi('ALEError',          'NONE', 'NONE', 'red',    'undercurl')
call s:hi('ALEWarning',        'NONE', 'NONE', 'orange', 'undercurl')
call s:hi('ALEInfo',           'NONE', 'NONE', 'blue',   'undercurl')

" airblade/vim-gitgutter
call s:hi('GitGutterAdd',          'green',  'bg0', '', '')
call s:hi('GitGutterChange',       'yellow', 'bg0', '', '')
call s:hi('GitGutterDelete',       'red',    'bg0', '', '')
call s:hi('GitGutterChangeDelete', 'orange', 'bg0', '', '')

" neoclide/coc.nvim
call s:hi('CocErrorSign',      'red',      'bg0',  '', 'bold')
call s:hi('CocWarningSign',    'orange',   'bg0',  '', 'bold')
call s:hi('CocInfoSign',       'blue',     'bg0',  '', 'bold')
call s:hi('CocHintSign',       'cyan',     'bg0',  '', 'bold')
call s:hi('CocErrorHighlight',   'NONE', 'NONE', 'red',    'undercurl')
call s:hi('CocWarningHighlight', 'NONE', 'NONE', 'orange', 'undercurl')
call s:hi('CocInfoHighlight',    'NONE', 'NONE', 'blue',   'undercurl')
call s:hi('CocHintHighlight',    'NONE', 'NONE', 'cyan',   'undercurl')
call s:hi('CocFloating',       'white',    'bg2',  '', '')
call s:hi('CocMenuSel',        'bg0',      'cyan', '', 'bold')

" preservim/nerdtree
call s:hi('NERDTreeDir',       'cyan',     '',     '', '')
call s:hi('NERDTreeDirSlash',  'border',   '',     '', '')
call s:hi('NERDTreeOpenable',  'subtle',   '',     '', '')
call s:hi('NERDTreeClosable',  'subtle',   '',     '', '')
call s:hi('NERDTreeFile',      'white',    '',     '', '')
call s:hi('NERDTreeExecFile',  'green',    '',     '', '')
call s:hi('NERDTreeCWD',       'muted',    '',     '', 'bold')

" =============================================================================
" Встроенный терминал (:terminal). carbon называет только два из шестнадцати
" цветов — terminalBlack и terminalBrightBlack; остальные взяты из акцентов той
" же палитры. Ярких вариантов у палитры нет, поэтому 9-13 и 15 повторяют 1-5 и
" 7: выдумывать более светлые оттенки было бы отсебятиной. Исключение — 14,
" где у палитры действительно два бирюзовых: cyan и cyan-soft.
" =============================================================================

let g:terminal_ansi_colors = [
      \ '#05080d', '#ff5b5b', '#7cff6b', '#ffc247',
      \ '#3ca9ff', '#b65cff', '#00e5e5', '#9baab8',
      \ '#718695', '#ff5b5b', '#7cff6b', '#ffc247',
      \ '#3ca9ff', '#b65cff', '#00d8ff', '#f5f7fa',
      \ ]

delfunction s:hi
unlet s:p s:ctermul

" vim: set et sw=2 ts=2:
