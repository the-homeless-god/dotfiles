" digitable.vim — тёмная схема Vim в палитре портала Digitable Courses.
"
" Maintainer:   the-homeless-god <zimtir@mail.ru>
" License:      MIT, как и весь репозиторий (см. LICENSE).
"
" Палитра, раскладка ролей и пороги контраста заданы не здесь, а в спеке
" theme/digitable.flang, и оттуда же проверяются: scripts/check-theme.sh
" сверяет каждый цвет этого файла со спекой и пересчитывает контрасты.

hi clear
if exists('syntax_on')
  syntax reset
endif

set background=dark
let g:colors_name = 'digitable'

" Палитра: имя -> [gui, cterm]. Ниже всё ссылается только на эти имена.
let s:p = {}

" Поверхности. Порядок яркости: bg0 < bg1 < bg2 < line < sel.
let s:p.bg0      = ['#05080d', '232']
let s:p.bg1      = ['#071018', '233']
let s:p.bg2      = ['#0b111a', '234']
let s:p.line     = ['#07141e', '235']
let s:p.sel      = ['#0f3745', '236']

" Текст.
let s:p.white    = ['#f5f7fa', '231']
let s:p.muted    = ['#9baab8', '248']
let s:p.subtle   = ['#718695',  '67']
let s:p.border   = ['#15566a',  '24']

" Акценты.
let s:p.cyan     = ['#00e5e5',  '44']
let s:p.cyansoft = ['#00d8ff',  '45']
let s:p.blue     = ['#3ca9ff',  '75']
let s:p.green    = ['#7cff6b', '119']
let s:p.yellow   = ['#ffc247', '214']
let s:p.orange   = ['#ff8a2a', '208']
let s:p.purple   = ['#b65cff', '135']
let s:p.red      = ['#ff5b5b', '203']

" Производные: цвет N% поверх фона. В xterm-256 таких подмесей нет, поэтому
" cterm там — заливка самим акцентом.
let s:p.hitbg    = ['#042b30',  '44']
let s:p.hitfg    = ['#00e5e5', '232']
let s:p.addbg    = ['#132618',  '22']
let s:p.addfg    = ['#7cff6b', '119']
let s:p.chgbg    = ['#231e14',  '58']
let s:p.chgfg    = ['#ffc247', '231']
let s:p.delbg    = ['#231216',  '52']
let s:p.delfg    = ['#ff5b5b', '203']
let s:p.txtbg    = ['#50401e', '214']
let s:p.txtfg    = ['#f5f7fa', '232']
let s:p.txtaddbg = ['#295229', '119']
let s:p.txtaddfg = ['#f5f7fa', '232']

" ctermul появился в 8.2.0863; без него была бы E416 на каждой группе орфографии.
let s:ctermul = has('patch-8.2.0863')

" fg/bg/sp — имена из s:p, пустая строка — «не задавать», 'NONE' — снять цвет
" (не то же самое: без 'NONE' в группе остаётся умолчание Vim после hi clear).
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
" Синтаксис
" =============================================================================

"                группа            fg          bg     sp    начертание
call s:hi('Normal',            'white',    'bg0',  '', '')

call s:hi('Comment',           'subtle',   '',     '', 'italic')
call s:hi('SpecialComment',    'muted',    '',     '', 'italic')

call s:hi('Constant',          'orange',   '',     '', '')
call s:hi('Boolean',           'orange',   '',     '', '')
call s:hi('Number',            'orange',   '',     '', '')
call s:hi('Float',             'orange',   '',     '', '')
call s:hi('Debug',             'orange',   '',     '', '')

call s:hi('String',            'green',    '',     '', '')
call s:hi('Character',         'green',    '',     '', '')
call s:hi('SpecialChar',       'green',    '',     '', '')

call s:hi('Type',              'green',    '',     '', '')

call s:hi('Function',          'cyan',     '',     '', '')
call s:hi('Operator',          'cyan',     '',     '', '')

call s:hi('Statement',         'blue',     '',     '', '')
call s:hi('Conditional',       'blue',     '',     '', '')
call s:hi('Repeat',            'blue',     '',     '', '')
call s:hi('Label',             'blue',     '',     '', '')
call s:hi('Keyword',           'blue',     '',     '', '')
call s:hi('Exception',         'blue',     '',     '', '')

call s:hi('PreProc',           'purple',   '',     '', 'bold')
call s:hi('Include',           'purple',   '',     '', 'bold')
call s:hi('Define',            'purple',   '',     '', 'bold')
call s:hi('Macro',             'purple',   '',     '', 'bold')
call s:hi('PreCondit',         'purple',   '',     '', 'bold')
call s:hi('StorageClass',      'purple',   '',     '', 'bold')
call s:hi('Structure',         'purple',   '',     '', 'bold')
call s:hi('Typedef',           'purple',   '',     '', 'bold')
call s:hi('Tag',               'purple',   '',     '', 'bold')

call s:hi('Identifier',        'white',    '',     '', '')
call s:hi('Delimiter',         'white',    '',     '', '')

call s:hi('Special',           'cyansoft', '',     '', '')

call s:hi('Underlined',        'blue',     '',     '', 'underline')

call s:hi('Error',             'red',      'bg0',  '', 'bold')
call s:hi('Todo',              'bg0',      'yellow', '', 'bold')
call s:hi('Ignore',            'bg0',      'bg0',  '', '')

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
call s:hi('ColorColumn',       '',         'bg2',  '', '')

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
" Служебная графика — линии, а не текст: контраст ниже 4.5:1 намеренно
" =============================================================================

call s:hi('VertSplit',         'border',   'bg0',  '', '')
call s:hi('NonText',           'border',   'bg0',  '', '')
call s:hi('SpecialKey',        'border',   'bg0',  '', '')
call s:hi('EndOfBuffer',       'bg0',      'bg0',  '', '')

" =============================================================================
" Выделение, поиск, скобки
" =============================================================================

call s:hi('Visual',            'NONE',     'sel',  '', '')
call s:hi('VisualNOS',         'NONE',     'sel',  '', '')

call s:hi('Search',            'hitfg',    'hitbg', '', '')
call s:hi('IncSearch',         'bg0',      'yellow', '', 'bold')
call s:hi('CurSearch',         'bg0',      'yellow', '', 'bold')
call s:hi('QuickFixLine',      'white',    'sel',  '', '')
call s:hi('MatchParen',        'cyan',     'sel',  '', 'bold,underline')

" =============================================================================
" Статусная строка, вкладки
" =============================================================================

call s:hi('StatusLine',        'white',    'border', '', 'bold')
call s:hi('StatusLineNC',      'subtle',   'bg2',  '', '')
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
" Всплывающее меню
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
" Diff
" =============================================================================

call s:hi('DiffAdd',           'addfg',    'addbg', '', '')
call s:hi('DiffChange',        'chgfg',    'chgbg', '', '')
call s:hi('DiffDelete',        'delfg',    'delbg', '', '')
call s:hi('DiffText',          'txtfg',    'txtbg', '', 'bold')
call s:hi('DiffTextAdd',       'txtaddfg', 'txtaddbg', '', 'bold')

" =============================================================================
" Орфография — цвет уходит в волну, слово сохраняет свой
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
" Плагины, которые ставит этот же .vimrc
" =============================================================================

call s:hi('ALEErrorSign',      'red',      'bg0',  '', 'bold')
call s:hi('ALEWarningSign',    'orange',   'bg0',  '', 'bold')
call s:hi('ALEInfoSign',       'blue',     'bg0',  '', 'bold')
call s:hi('ALEError',          'NONE', 'NONE', 'red',    'undercurl')
call s:hi('ALEWarning',        'NONE', 'NONE', 'orange', 'undercurl')
call s:hi('ALEInfo',           'NONE', 'NONE', 'blue',   'undercurl')

call s:hi('GitGutterAdd',          'green',  'bg0', '', '')
call s:hi('GitGutterChange',       'yellow', 'bg0', '', '')
call s:hi('GitGutterDelete',       'red',    'bg0', '', '')
call s:hi('GitGutterChangeDelete', 'orange', 'bg0', '', '')

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

call s:hi('NERDTreeDir',       'cyan',     '',     '', '')
call s:hi('NERDTreeDirSlash',  'border',   '',     '', '')
call s:hi('NERDTreeOpenable',  'subtle',   '',     '', '')
call s:hi('NERDTreeClosable',  'subtle',   '',     '', '')
call s:hi('NERDTreeFile',      'white',    '',     '', '')
call s:hi('NERDTreeExecFile',  'green',    '',     '', '')
call s:hi('NERDTreeCWD',       'muted',    '',     '', 'bold')

" =============================================================================
" Встроенный терминал (:terminal). Ярких вариантов у палитры нет, поэтому
" 9-13 и 15 повторяют 1-5 и 7; исключение — 14, второй бирюзовый.
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
