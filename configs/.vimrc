" =============================================================================
" ГОРЯЧИЕ КЛАВИШИ
" =============================================================================
" Лидер клавиша = \
"
" Основные команды:
" \ot         - открыть терминал внизу
" \u          - обновить плагины
" \v          - вертикальное разделение
" \h          - горизонтальное разделение
" \w          - сохранить файл
" \x          - сохранить и выйти
" \q          - выйти из всех окон
" \<F2>       - показать все маппинги
" \.          - автодополнение путей файлов
"
" Навигация:
" Ctrl+h/j/k/l - перемещение между окнами
" Alt+h/j/k/l  - изменение размера окон
" Shift+h/j/k/l - перемещение курсора на 10 позиций
" gb           - следующий буфер
" gbp          - предыдущий буфер
" gbd          - удалить буфер
" \1-9         - переключение между вкладками по номеру
"
" Файлы и поиск:
" \dd          - открыть проводник в текущей директории файла
" \da          - открыть проводник в рабочей директории
" \lf          - открыть lf файловый менеджер
" \g           - открыть ripgrep + fzf поиск
"
" Редактирование:
" \f           - форматировать файл через Prettier
" \ca          - копировать содержимое всего файла
" \c           - копировать выделенное в системный буфер
" \cf          - очистить файл
" K            - показать документацию
" Space        - сворачивание/разворачивание кода
"
" Терминал:
" F7           - новый терминал
" F8           - предыдущий терминал
" F9           - следующий терминал
" F12          - показать/скрыть терминал

packloadall
filetype plugin on

call plug#begin()

" plugins:

Plug 'tpope/vim-obsession'
Plug 'dhruvasagar/vim-prosession'
Plug 'ptzz/lf.vim'
Plug 'tmux-plugins/vim-tmux'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'zhamlin/tiler.vim'
Plug 'pangloss/vim-javascript'    " JavaScript support
Plug 'leafgarland/typescript-vim' " TypeScript syntax
Plug 'maxmellon/vim-jsx-pretty'   " JS and JSX syntax
Plug 'jparise/vim-graphql'        " GraphQL syntax
Plug 'prettier/vim-prettier'
Plug 'rhysd/vim-healthcheck'
Plug 'voldikss/vim-floaterm'
Plug 'jremmen/vim-ripgrep'
Plug 'airblade/vim-gitgutter'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'vim-scripts/c.vim' " Syntax highlighting and indentation
Plug 'mbbill/undotree'
Plug 'jeetsukumaran/vim-buffergator' " [Leader + b] to list all windows: ctrl + v / t / s = vertical / tab / horizontal
Plug 'vim-scripts/SpellCheck' " Spell checking
Plug 'ryanoasis/vim-devicons'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'keremc/asyncomplete-clang.vim'
Plug 'prabirshrestha/async.vim'
Plug 'junegunn/goyo.vim'
Plug 'dense-analysis/ale'
Plug 'sheerun/vim-polyglot'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
Plug 'neoclide/coc.nvim'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'ap/vim-css-color'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'PhilRunninger/nerdtree-buffer-ops'
Plug 'rbgrouleff/bclose.vim'
Plug 'roman/golden-ratio'
Plug 'sainnhe/edge'
Plug 'liuchengxu/vim-which-key'
Plug 'voldikss/vim-floaterm'
Plug 'tpope/vim-fugitive'
Plug 'liuchengxu/vista.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'turbio/bracey.vim', {'do': 'npm install --prefix server'}

call plug#end()

" После call plug#end() добавляем базовые настройки WhichKey
" Which Key базовые настройки
let g:mapleader = "\\"
let g:maplocalleader = ','
let g:which_key_timeout = 100
let g:which_key_display_names = {'<CR>': '↵', '<TAB>': '⇆', ' ': 'SPC'}
let g:which_key_sep = '→'
let g:which_key_map = {}
let g:which_key_centered = 1
let g:which_key_use_floating_win = 1
let g:which_key_floating_relative_win = 1
let g:which_key_disable_default_offset = 1

" Отключаем стандартный timeout
set timeoutlen=500

" Инициализация which-key
call which_key#register('\', "g:which_key_map")
nnoremap <silent> <leader> :<c-u>WhichKey '\'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '\'<CR>

" Удаляем старую регистрацию which-key в конце файла и заменяем на:
augroup which_key_init
    autocmd!
    autocmd VimEnter * call which_key#register('\', "g:which_key_map")
    autocmd VimEnter * call which_key#register('/', "g:which_key_map")
augroup END

" Обновляем маппинги
nnoremap <silent> <leader> :<c-u>WhichKey '\'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '\'<CR>
nnoremap <silent> / :<c-u>WhichKey '/'<CR>

" Добавляем описание для пробела
let g:which_key_map['<Space>'] = ['za', 'fold/unfold']

" Markdown Preview настройки
let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 1
let g:mkdp_refresh_slow = 0
let g:mkdp_command_for_global = 0
let g:mkdp_open_to_the_world = 0
let g:mkdp_open_ip = ''
let g:mkdp_browser = ''
let g:mkdp_echo_preview_url = 1
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {},
    \ 'content_editable': v:false,
    \ 'disable_filename': 0,
    \ 'toc': {}
    \ }
let g:mkdp_markdown_css = ''
let g:mkdp_highlight_css = ''
let g:mkdp_port = ''
let g:mkdp_page_title = '「${name}」'
let g:mkdp_filetypes = ['markdown']

" HTML Live Preview настройки
let g:bracey_browser_command = 'open'
let g:bracey_auto_start_browser = 1
let g:bracey_refresh_on_save = 1
let g:bracey_eval_on_save = 1

function! s:initVimStartup()
	" VIM STARTUP: exec functions on start of vim
	" 1. initiate update of plugins on each start
	" 2. Highlight the symbol and its references when holding the cursor
	autocmd VimEnter * silent! 

	autocmd User asyncomplete_setup call asyncomplete#register_source(
				\ asyncomplete#sources#clang#get_source_options())

  augroup disable_netrw_close
		autocmd!
		autocmd FileType netrw nnoremap <buffer> <silent> q :echo "Use :Nclose to close Netrw"<CR>
		autocmd FileType netrw nnoremap <buffer> <silent> x :echo "Use :Nclose to close Netrw"<CR>
	augroup END

	if has("gui_running") && (&enc == 'utf-8' || &enc == 'utf-16' || &enc == 'ucs-4')
		let s:treedepthstring= "O "
	else
		let s:treedepthstring= "1 "
	endif
endfunction

function! s:initVimVariables()
	" VIM VARIABLES: set variables on start of vim  
	" Terminal: set size of terminal with small hight to avoid taking a half of the screen
	set termwinsize = "10*0"
	let g:terminal_default_height = 10


	" Always show an empty buffer when a file is closed
	set hidden

	" Open new buffers on the right side
	set splitright

	let g:airline#extensions#obsession#enabled = 1
	let g:airline#extensions#tabline#enabled = 1 
	let g:airline#extensions#branch#enabled = 1

	" Git lens
	let g:gitgutter_enabled = 1
	let g:gitgutter_sign_added = '+'
	let g:gitgutter_sign_modified = '~'
	let g:gitgutter_sign_removed = '-'

	" Fonts: usage of specific font with height 
	set guifont=FiraCodeNF:h10

	" Prettier: formatting on save
	let g:prettier#autoformat = 1

	" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
	" delays and poor user experience
	set updatetime=300

	" Always show the signcolumn, otherwise it would shift the text each time
	" diagnostics appear/become resolved
	set signcolumn=yes

	" utf-8 byte sequence
	set encoding=utf-8

	" File explorer: size of window by default and auto-setup for current directory
	let g:netrw_keepdir = 0
	let g:netrw_winsize = 15
	let g:netrw_altv = 1

	" Keep the side bar open by default
	let g:netrw_banner = 0
	let g:netrw_browse_split = 2 
	let g:netrw_liststyle = 3

	let g:netrw_banner = 0 | autocmd FileType netrw setlocal bufhidden=hide
	let g:netrw_altv=1
	let g:netrw_list_hide='.*\.swp$'
	let g:NERDTreeHijackNetrw = 0 " Add this line if you use NERDTree
	let g:lf_replace_netrw = 1 " Open lf when vim opens a directory

	" status line:
	set titlestring="File: " + statusline + %F

	" tabline: 
	set tabline=2

	
if v:version < 802
    packadd! dracula_pro
endif
syntax enable
let g:dracula_colorterm = 0
colorscheme dracula_pro

	set fillchars+=vert:\│
	hi VertSplit ctermfg=Black ctermbg=DarkGray
	highlight EndOfBuffer ctermfg=282A36 ctermbg=282A36

	" This disables the creation of backup files.
	set nobackup
	" This disables the creation of swap files.
	set noswapfile
	" Automatically reload files when they change
	set autoread
	" Enable spell checking
	set spelllang=en
	" Highlight the current line
	set cursorline
	" Show white space characters and tab characters
	set list

	" This enables the use of the mouse in all modes (normal, visual, insert,
	" command-line, etc.).
	set mouse=a


	" This enabled to resize buffers using mouse
	set ttymouse=xterm2

	" Add folding: za, zc, zo
	set foldmethod=indent   
	set foldnestmax=10
	set nofoldenable
	set foldlevel=2
  set paste

	let g:ale_linters = {'c': ['clang', 'cppcheck']}
	let g:ale_fixers = {'c': ['uncrustify', 'clang-format']}
	let g:ale_fixers_always_run = 1
	let g:ale_fixers_on_save = 1
	let g:ale_sign_priority = 50

	if has("termguicolors")
		  set termguicolors
	endif

	set number!
	set signcolumn=yes
	
	"Ultisnips Settings
  let g:UltiSnipsExpandTrigger="<tab>"
  let g:UltiSnipsJumpForwardTrigger="<c-b>"
  let g:UltiSnipsJumpBackwardTrigger="<c-z>"

	" If you want :UltiSnipsEdit to split your window.
	let g:UltiSnipsEditSplit="vertical"
endfunction

function! s:initVimHotkeys()
	" My keymaps

	" [Leader + ot]: open terminal below
	nnoremap <silent> <Leader>ot :below terminal ++rows=15 ++close<CR>
	nnoremap <silent> <Leader>u :FloatermNew --width=0.8 --height=0.8 vim +PlugUpdate +qall<CR>
	nmap <silent> <Leader>v :vsplit<CR>
	nmap <silent> <Leader>h :split<CR>
	nmap <silent> <Leader>w :w<CR>
	nmap <silent> <Leader>x :x<CR>
	nmap <silent> <Leader>q :qa<CR>
  nmap <silent> <Leader><F2> :map<CR>
  nmap <silent> <Leader>. <C-x><C-f><CR>
	":remote-send("<ESC>:call remote_startserver('some_name')<CR>")

	" [Leader + g]: opens ripgrep + fzf
	nmap <leader>g :FloatermNew --width=0.8 --height=0.8 rgfzf.sh<CR>

	" [Leader + f]: format whole file
	nnoremap <leader>f :Prettier<CR>

	" [Leader + c + a]: copy content of whole file
	nnoremap <leader>ca :%y+<CR>

	vnoremap <leader>c "+y<CR>
	" [K]: to show documentation in preview window
	nnoremap <silent> K :call ShowDocumentation()<CR>

	" [Leader + d + d]: open explorer at the file path
	nnoremap <leader>dd :Lexplore %:p:h<CR>
	" [Leader + d + a]: open explorer at the working directory
	nnoremap <Leader>da :Lexplore<CR>

	" [Leader + l + f]: look for a file
	nmap <leader>lf :FloatermNew lf --command 'set hidden'<CR>

	" [Leader + r]: reload vimrc 
	nmap <leader>r :so ~/.vimrc<CR>

	" [Leader + c + f]: clear file
	nmap <leader>cf gg dG<CR> 
	nmap <leader>nt :tabnew<CR> 
  nmap <leader>mt :tab split<CR>
	nnoremap   <silent>   <F7>    :FloatermNew<CR>
	tnoremap   <silent>   <F7>    <C-\><C-n>:FloatermNew<CR>
	nnoremap   <silent>   <F8>    :FloatermPrev<CR>
	tnoremap   <silent>   <F8>    <C-\><C-n>:FloatermPrev<CR>
	nnoremap   <silent>   <F9>    :FloatermNext<CR>
	tnoremap   <silent>   <F9>    <C-\><C-n>:FloatermNext<CR>
	nnoremap   <silent>   <F12>   :FloatermToggle<CR>
	tnoremap   <silent>   <F12>   <C-\><C-n>:FloatermToggle<CR

	" The next four lines define key mappings for switching between windows using
	" Ctrl + hjkl keys
	nmap <silent> <c-k> :wincmd k<CR>
	nmap <silent> <c-j> :wincmd j<CR>
	nmap <silent> <c-h> :wincmd h<CR>
	nmap <silent> <c-l> :wincmd l<CR>

	" The next four lines define key mappings for resizing windows using Alt +
	" hjkl keys:
	map <a-l> :vertical res -5<CR>
	map <a-h> :vertical res +5<CR>
	map <a-j> :res -5<CR>
	map <a-k> :res +5<CR>

	" These lines define key mappings for moving the cursor 10 spaces at a time
	" using Shift + arrow keys:
	nmap <S-l> 10l<CR>
	nmap <S-h> 10h<CR>
	nmap <S-j> 10j<CR>
	nmap <S-k> 10k<CR>

	" This maps the '<' and '>' keys in visual mode to shift the selected text one
	" shift width to the left or right and reselect the shifted text.
	vnoremap < <gv
	vnoremap > >gv

	inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
	inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
	inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
	
	" Go to tab by number
  	noremap <leader>1 1gt
  	noremap <leader>2 2gt
  	noremap <leader>3 3gt
  	noremap <leader>4 4gt
  	noremap <leader>5 5gt
  	noremap <leader>6 6gt
  	noremap <leader>7 7gt
  	noremap <leader>8 8gt
  	noremap <leader>9 9gt
  	noremap <leader>0 :tablast<cr>

	" Add folding by Space
  	vnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

  	map gb :bnext<cr>
  	map gbp :bprevious<cr>
  	map gbd :bdelete<cr>
  	map gtn :tabnext<cr>
  	map gtp :tabprevious<cr>
  	map gtd :tabdelete<cr>


	" Make <CR> to accept selected completion item or notify coc.nvim to format
	" <C-g>u breaks current undo, please make your own choice.
	inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
									\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

	"CoC Settings
	" Use tab for trigger completion with characters ahead and navigate.
	" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
	" other plugin before putting this into your config.
	inoremap <silent><expr> <TAB>
	      \ pumvisible() ? "\<C-n>" :
	      \ <SID>check_back_space() ? "\<TAB>" :
	      \ coc#refresh()
	inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"	

	function! s:check_back_space() abort
	  let col = col('.') - 1
	  return !col || getline('.')[col - 1]  =~# '\s'
	endfunction

endfunction

call s:initVimVariables()
call s:initVimStartup()
call s:initVimHotkeys()

if exists(":AirlineRefresh")
	:AirlineRefresh
endif

" Основные настройки для VS Code-подобного поведения
set splitright
set splitbelow
let g:golden_ratio_autocommand = 0
let g:golden_ratio_default_split_ratio = 0.5

" Настройка NERDTree как VS Code Explorer
let g:NERDTreeWinPos = "right"
let g:NERDTreeWinSize = 40
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeStatusline = ''

" Floaterm настройки в стиле VS Code
let g:floaterm_width = 0.8
let g:floaterm_height = 0.3
let g:floaterm_position = 'top'
let g:floaterm_title = ''

" Автоматическое сохранение сессии
let g:prosession_dir = '~/.vim/session/'
let g:prosession_on_startup = 1

" Новые маппинги в стиле VS Code (обновленные)
nnoremap <Leader>e :NERDTreeToggle<CR>
nnoremap <Leader>E :NERDTreeFind<CR>
nnoremap <Leader>p :FloatermNew lf --command 'set hidden'<CR>
nnoremap <Leader>P :FloatermNew --width=0.8 --height=0.3 --position=top rgfzf.sh<CR>
nnoremap <Leader>g :Git<CR>

" Убираем автоматическое разделение окна, которое вызывает дублирование
" autocmd BufWinEnter * if winnr('$') > 3 | tabe | else | vsplit | endif

" Настройка для автоматического открытия в вертикальном режиме только для новых буферов
" augroup AutoSplit
  "  autocmd!
   " autocmd BufWinEnter * if &buftype == '' && winnr('$') > 3 | tabe | elseif &buftype == '' && winnr('$') <= 3 | wincmd L | endif
" augroup END

" Vista настройки
let g:vista_default_executive = 'coc'
let g:vista_sidebar_width = 40
let g:vista_stay_on_open = 1
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista_fzf_preview = ['right:50%']
let g:vista#renderer#enable_icon = 1
let g:vista_update_on_text_changed = 1
let g:vista_close_on_jump = 0
let g:vista_echo_cursor = 1
let g:vista_blink = [2, 100]

" Relative numbers
set number
set relativenumber

" Folding settings
set foldmethod=indent
set foldlevel=99
nnoremap <space> za
vnoremap <space> za

" Dashboard function
function! OpenDashboard()
    " Создаем новую вкладку и называем её
    tabnew
    let t:dashboard = 1  " Помечаем таб как дашборд
    
    " Закрываем начальный буфер и отключаем UI
    only
    set showtabline=0
    set laststatus=0
    
    " Создаем базовое разделение: вертикальное на две части
    vsplit
    
    " Настраиваем левую часть (bpytop)
    wincmd h
    terminal bpytop
    file Dashboard-System
    
    " Настраиваем правую часть
    wincmd l
    " Создаем три окна в правой части
    split
    split
    
    " Настраиваем верхнее окно (календарь)
    wincmd k
    wincmd k
    terminal cal -3
    file Dashboard-Calendar
    
    " Настраиваем среднее окно (часы)
    wincmd j
    terminal watch -n 1 date
    file Dashboard-Clock
    
    " Настраиваем нижнее окно (cmus)
    wincmd j
    terminal cmus
    file Dashboard-Music
    
    " Устанавливаем размеры окон
    " Настраиваем левую часть (bpytop)
    wincmd h
    resize 30
    vertical resize 100
    
    " Настраиваем правую часть
    wincmd l
    wincmd k
    wincmd k
    resize 10  " Размер для календаря
    
    wincmd j
    resize 3   " Размер для часов
    
    " Отключаем UI элементы для всех окон
    windo setlocal nonumber norelativenumber
    windo setlocal signcolumn=no
    windo setlocal nocursorline
    windo setlocal nocursorcolumn
    windo setlocal noshowmode
    windo setlocal noruler
    windo setlocal laststatus=0
    windo setlocal noshowcmd
    
    " Устанавливаем режим терминала и скрываем буферы
    windo setlocal buftype=terminal
    windo setlocal nobuflisted
    
    " Очищаем все неиспользуемые буферы в текущем табе
    let l:buffers = filter(range(1, bufnr('$')), 'buflisted(v:val)')
    for l:buf in l:buffers
        if bufname(l:buf) !~# '^Dashboard-'
            execute 'bdelete ' . l:buf
        endif
    endfor
    
    " Возвращаемся в окно с bpytop
    wincmd h
    
    " Переименовываем таб
    set titlestring=Dashboard
    let t:title = 'Dashboard'
    
    " Отключаем возможность закрытия окон
    windo nnoremap <buffer> q <NOP>
    windo nnoremap <buffer> <C-w> <NOP>
endfunction

" Автоматически восстанавливаем UI при выходе из дашборда
augroup dashboard_exit
    autocmd!
    autocmd BufWinLeave * if exists('t:dashboard') | 
                \ set showtabline=2 |
                \ set laststatus=2 |
                \ endif
augroup END

" Маппинг для dashboard
nnoremap <Leader>D :call OpenDashboard()<CR>

" Which Key настройки для отображения доступных команд
let g:which_key_map = {
      \ 'name': 'Leader Commands',
      \ 'ot': [':below terminal ++rows=15 ++close', 'открыть терминал'],
      \ 'u': [':FloatermNew --width=0.8 --height=0.8 vim +PlugUpdate +qall', '��бновить плагины'],
      \ 'v': [':Vista!!', 'структура кода'],
      \ 'h': [':split', 'разделить горизонтально'],
      \ 'w': [':w', 'сохранить'],
      \ 'x': [':x', 'сохранить и выйти'],
      \ 'q': [':qa', 'выйти из всех окон'],
      \ '<F2>': [':map', 'показать маппинги'],
      \ '.': ['<C-x><C-f>', 'автодополнение путей'],
      \ 'p': [':FloatermNew lf --command "set hidden"', 'файловый менеджер'],
      \ 'P': [':FloatermNew --width=0.8 --height=0.3 --position=top rgfzf.sh', 'поиск в файлах'],
      \ 'e': [':NERDTreeToggle', 'дерево файлов'],
      \ 'E': [':NERDTreeFind', 'найти текущий файл'],
      \ 'H': [':ShowHotkeys', 'показать все хоткеи'],
      \ 'D': [':call OpenDashboard()', 'открыть дашборд'],
      \ }

" Git команды
let g:which_key_map.g = {
      \ 'name': '+git',
      \ 's': [':G', 'статус'],
      \ 'p': [':Git push', 'push'],
      \ 'c': [':Git commit', 'commit'],
      \ 'd': [':Git diff', 'diff'],
      \ 'b': [':Git blame', 'blame'],
      \ 'l': [':Git log', 'log'],
      \ }

" GitGutter команды
let g:which_key_map.h = {
      \ 'name': '+hunk',
      \ 'p': ['<Plug>(GitGutterPreviewHunk)', 'предпросмотр изменений'],
      \ 'u': ['<Plug>(GitGutterUndoHunk)', 'отменить изменения'],
      \ 's': ['<Plug>(GitGutterStageHunk)', 'добавить изменения'],
      \ }

" Файлы и директории
let g:which_key_map.d = {
      \ 'name': '+directory',
      \ 'd': [':Lexplore %:p:h', 'открыть директорию файла'],
      \ 'a': [':Lexplore', 'открыть рабочую директорию'],
      \ }

" Буферы и вкладки
let g:which_key_map.b = {
      \ 'name': '+buffer',
      \ 'd': [':Bclose', 'закрыть буфер'],
      \ '<S-Down>': [':BuffergatorMruCycleNext rightbelow sbuffer', 'следующий буфер вниз'],
      \ '<S-Right>': [':BuffergatorMruCycleNext rightbelow vert sbuffer', 'следующий буфер вправо'],
      \ '<S-Up>': [':BuffergatorMruCycleNext leftabove sbuffer', 'следующий буфер вверх'],
      \ '<S-Left>': [':BuffergatorMruCycleNext leftabove vert sbuffer', 'следующий буфер влево'],
      \ '<Down>': [':BuffergatorMruCyclePrev rightbelow sbuffer', 'предыдущий буфер вниз'],
      \ '<Right>': [':BuffergatorMruCyclePrev rightbelow vert sbuffer', 'предыдущий буфер вправо'],
      \ '<Up>': [':BuffergatorMruCyclePrev leftabove sbuffer', 'предыдущий буфер вверх'],
      \ '<Left>': [':BuffergatorMruCyclePrev leftabove vert sbuffer', 'предыдущий буфер влево'],
      \ }

" Вкладки
let g:which_key_map.t = {
      \ 'name': '+tabs',
      \ 'c': [':BuffergatorTabsClose', 'закрыть вкладки'],
      \ 'o': [':BuffergatorTabsOpen', 'открыть вкладки'],
      \ 'n': [':tabnew', 'новая вкладка'],
      \ 'm': [':tab split', 'разделить в новую вкладку'],
      \ }

" Нумерация вкладок
for i in range(1, 9)
  let g:which_key_map[string(i)] = [string(i) . 'gt', 'вкладка ' . string(i)]
endfor
let g:which_key_map['0'] = [':tablast', 'последняя вкла��ка']

" Проверяем, загружен ли which-key плагин
if exists('g:loaded_which_key')
  " Регистрация which-key
  call which_key#register('\', "g:which_key_map")
  call which_key#register('/', "g:which_key_map")
  nnoremap <silent> <leader> :<c-u>WhichKey '\'<CR>
  vnoremap <silent> <leader> :<c-u>WhichKeyVisual '\'<CR>
  nnoremap <silent> / :<c-u>WhichKey '/'<CR>
endif

" Добавляем в which-key маппинги для превью
let g:which_key_map.m = {
      \ 'name': '+markdown',
      \ 'p': [':MarkdownPreview', 'открыть превью'],
      \ 's': [':MarkdownPreviewStop', 'остановить превью'],
      \ 't': [':MarkdownPreviewToggle', 'переключить превью'],
      \ }

let g:which_key_map.l = {
      \ 'name': '+live-preview',
      \ 'h': [':Bracey', 'запустить HTML превью'],
      \ 's': [':BraceyStop', 'остановить HTML превью'],
      \ 'r': [':BraceyReload', 'перезагрузить HTML превью'],
      \ }

" Автоматическое открытие превью для markdown и html файлов
augroup preview_files
    autocmd!
    " Для Markdown файлов
    autocmd FileType markdown nmap <buffer><Leader>mp <Plug>MarkdownPreview
    autocmd FileType markdown nmap <buffer><Leader>ms <Plug>MarkdownPreviewStop
    autocmd FileType markdown nmap <buffer><Leader>mt <Plug>MarkdownPreviewToggle
    
    " Для HTML файлов
    autocmd FileType html nmap <buffer><Leader>lh :Bracey<CR>
    autocmd FileType html nmap <buffer><Leader>ls :BraceyStop<CR>
    autocmd FileType html nmap <buffer><Leader>lr :BraceyReload<CR>
augroup END

