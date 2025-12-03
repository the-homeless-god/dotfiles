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
" \P           - открыть ripgrep + fzf поиск в новом окне
" \sf          - глобальный поиск
" \o           - быстрый поиск файлов через fd + fzf
"
" Редактирование:
" \f           - форматировать файл через Prettier
" \ca          - копировать содержимое всего файла
" \c           - копировать выделенное в системный буфер
" \cf          - очистить файл
" K            - показать документацию
" Space        - сворачивание/разворачивание кода
"
" Git команды:
" \gg          - открыть Git панель
" \gc          - сделать коммит
" \gp          - отправить изменения
" \gl          - получить изменения
"
" Терминал:
" F7           - новый терминал
" F8           - предыдущий терминал
" F9           - следующий терминал
" F12          - показать/скрыть терминал

packloadall
filetype plugin on
filetype plugin indent on

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
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
Plug 'gergap/vim-ollama'

Plug 'turbio/bracey.vim', {'do': 'npm install --prefix server'}
Plug 'elixir-editors/vim-elixir'
Plug 'elixir-lsp/coc-elixir', {'do': 'yarn install && yarn prepack'}

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
    " autocmd VimEnter * call which_key#register('/', "g:which_key_map")
augroup END

" Обновляем маппинги
nnoremap <silent> <leader> :<c-u>WhichKey '\'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '\'<CR>
" nnoremap <silent> / :<c-u>WhichKey '/'<CR>

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

" Prettier настройки
let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0
let g:prettier#exec_cmd_path = "prettier"
let g:prettier#quick_fix = 1

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

let g:ollama_use_venv = 1 
let g:ollama_logfile = '~/vim-ollama.log'
let g:ollama_openai_baseurl = 'http://localhost:1234/v1' " Use local OpenAI endpoint
let g:ollama_model_provider = 'openai_legacy'
let g:ollama_model = 'bartowski/codegemma-2b-GGUF'
let g:ollama_chat_provider = 'openai_legacy'
let g:ollama_chat_model = 'unsloth/Devstral-Small-2507-GGUF'
let g:ollama_edit_provider = 'openai_legacy'

let g:ollama_edit_model = 'unsloth/Devstral-Small-2507-GGUF'

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
	let g:lf_replace_netrw = 0 " Open lf when vim opens a directory

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

	let g:ale_linters = {'c': ['clang', 'cppcheck'], 'elixir': ['elixir-ls']}
	let g:ale_fixers = {'c': ['uncrustify', 'clang-format']}
	set completeopt=menu,menuone,preview,noselect,noinsert
	let g:ale_completion_enabled = 1
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
	nnoremap <silent> <Leader>w :w<CR>
	nmap <silent> <Leader>x :x<CR>
	nmap <silent> <Leader>q :qa<CR>
    nmap <silent> <Leader><F2> :map<CR>
    nmap <silent> <Leader>. <C-x><C-f><CR>

	" [Leader + g]: opens ripgrep + fzf
	nmap <leader>g :FloatermNew --width=0.8 --height=0.8 rgfzf.sh<CR>

	" [Leader + f]: format whole file
    command! -nargs=0 Prettier :CocCommand prettier.formatFile
    vmap <leader>f  <Plug>(coc-format-selected)
    nmap <leader>f  <Plug>(coc-format-selected)
    nnoremap <leader>f :Prettier<CR>

	" [Leader + c + a]: copy content of whole file
	nnoremap <leader>ca :%y+<CR>

	vnoremap <leader>c "+y<CR>
	" [K]: to show documentation in preview window
	nnoremap <silent> K :call ShowDocumentation()<CR>

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

  " Applying codeAction to the selected region.

" Example: \`<leader>aap\` for current paragraph

xmap <leader>a  <Plug>(coc-codeaction-selected)

nmap <leader>a  <Plug>(coc-codeaction-selected)


" My config

" Remap keys for applying codeAction to the current word.

" I add w mean select current word for codeaction.

nmap <leader>ac   <Plug>(coc-codeaction-selected)w

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

" Floaterm настройки
let g:floaterm_width = 0.8
let g:floaterm_height = 0.3
let g:floaterm_position = 'top'
let g:floaterm_title = ''
let g:floaterm_borderchars = '─│─│╭╮╯╰'
let g:floaterm_autoclose = 0
let g:floaterm_autoinsert = 1
let g:floaterm_wintype = 'float'
let g:floaterm_rootmarkers = ['.git', '.svn', '.hg', '.project', '.root']
let g:floaterm_opener = 'edit'
let g:floaterm_winblend = 0
let g:floaterm_autohide = 0
let g:floaterm_keymap_toggle = '<F12>'
let g:floaterm_keymap_next = '<F9>'
let g:floaterm_keymap_prev = '<F8>'
let g:floaterm_keymap_new = '<F7>'
let g:floaterm_keymap_kill = '<C-c>'
let g:floaterm_scrollback = 10000

" Улучшенные маппинги для терминала
" nnoremap <silent> <Leader>ot :FloatermNew --width=0.8 --height=0.3 --position=top --wintype=float --autoclose=0<CR>
" tnoremap <silent> <C-h> <C-\><C-n>:FloatermPrev<CR>
" tnoremap <silent> <C-l> <C-\><C-n>:FloatermNext<CR>
" tnoremap <silent> <C-n> <C-\><C-n>:FloatermNew<CR>
" tnoremap <silent> <C-c> <C-\><C-n>:FloatermKill<CR>
" tnoremap <silent> <Esc> <C-\><C-n>

" Автоматическое переключение в режим вставки при открытии терминала
autocmd TerminalOpen * startinsert

" Автоматическое сохранение сессии
let g:prosession_dir = '~/.vim/session/'
let g:prosession_on_startup = 1

" Новые маппинги в стиле VS Code (обновленные)
nnoremap <Leader>e :NERDTreeToggle<CR>
nnoremap <Leader>E :NERDTreeFind<CR>
nnoremap <Leader>l :FloatermNew lf --command 'set hidden'<CR>
nnoremap <Leader>P :FloatermNew --width=0.8 --height=0.3 --position=top rgfzf.sh<CR>
nnoremap <Leader>g :Git<CR>

" Настройки для постоянного отображения Vista
let g:vista_stay_on_open = 0
let g:vista_sidebar_position = 'right'
let g:vista_sidebar_width = 40
let g:vista_close_on_jump = 1
let g:vista_echo_cursor = 1
let g:vista_update_on_text_changed = 0
let g:vista_update_on_text_changed_delay = 500
let g:vista#renderer#enable_icon = 1
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista_fzf_preview = ['right:50%']
let g:vista_default_executive = 'coc'

" Улучшенные настройки для CoC
let g:coc_global_extensions = [
  \ 'coc-tsserver',
  \ 'coc-json',
  \ 'coc-html',
  \ 'coc-css',
  \ 'coc-python',
  \ 'coc-go',
  \ 'coc-rust-analyzer',
  \ 'coc-clangd',
  \ 'coc-snippets',
  \ 'coc-pairs',
  \ 'coc-highlight',
  \ 'coc-git',
  \ 'coc-elixir'
  \ ]

" Автоматическая установка расширений CoC
if empty(glob($HOME . '/.config/coc/extensions/node_modules/coc-tsserver'))
  autocmd VimEnter * CocInstall coc-tsserver
endif

" Улучшенная навигация по коду для TypeScript, Elixir
autocmd BufEnter *.{js,jsx,ts,tsx,ex,exs} :silent! call coc#config("suggest.autoTrigger", "always")
autocmd BufEnter *.{js,jsx,ts,tsx,ex,exs} :silent! call coc#config("suggest.triggerAfterInsertEnter", v:true)

" Улучшенные маппинги для навигации
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Используем K для показа документации
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Автоматическое обновление тегов при сохранении
autocmd BufWritePost *.{js,jsx,ts,tsx} :silent! call CocAction('reloadWorkspace')

" Настройка рабочего каталога
autocmd FileType typescript,elixir,javascript,typescriptreact,javascriptreact let b:coc_root_patterns = ['.git', '.env', 'package.json', 'tsconfig.json', 'jsconfig.json']

" Улучшенные настройки для airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#show_tab_type = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#buffer_nr_show = 0
let g:airline#extensions#tabline#buffer_nr_format = '%s:'
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#fnamecollapse = 1
let g:airline#extensions#tabline#fnametruncate = 0
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#right_sep = ' '
let g:airline#extensions#tabline#right_alt_sep = '|'
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_tab_count = 0
let g:airline#extensions#tabline#show_close_button = 0

" Настройки для devicons
let g:webdevicons_enable = 1
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_enable_airline_tabline = 1
let g:webdevicons_enable_airline_statusline = 1
let g:webdevicons_enable_ctrlp = 1
let g:webdevicons_enable_flagship_statusline = 1
let g:webdevicons_enable_flagship_statusline_fileformat_symbols = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:WebDevIconsUnicodeGlyphDoubleWidth = 1

" Отключаем наложение буферов
set nohidden
set bufhidden=wipe

" Показываем хоткеи при старте
function! ShowHotkeys()
  if exists('g:loaded_which_key')
    call which_key#register('\', "g:which_key_map")
    WhichKey '\'
  endif
endfunction

augroup show_hotkeys_on_start
  autocmd!
  autocmd VimEnter * call ShowHotkeys()
augroup END

" Чтоб сделать как VS Code
" 1. Основные настройки интерфейса
set termguicolors
set cursorline
set number
set relativenumber
set signcolumn=yes
set cmdheight=2
set updatetime=300
set shortmess+=c
set mouse=a
set clipboard=unnamed
set hidden

" 2. Табы и отступы
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set smartindent

" 3. Поиск
set ignorecase
set smartcase
set incsearch
set hlsearch
nnoremap <Esc><Esc> :nohlsearch<CR>

" 4. VS Code-подобные хоткеи
" Сохранение (перемещаем в более приоритетное место)
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>

" Глобальный поиск (Ctrl+Shift+F)
nnoremap <Leader><S-f> :FloatermNew --width=0.8 --height=0.8 --title='Global Search' rgfzf.sh<CR>
" Для более удобного доступа также вариант через пробел
nnoremap <Leader>sf :FloatermNew --width=0.8 --height=0.8 --title='Global Search' rgfzf.sh<CR>

" Отмена/Повтор
nnoremap <C-z> u
inoremap <C-z> <Esc>ui
nnoremap <C-y> <C-r>
inoremap <C-y> <Esc><C-r>i

" Копировать/Вставить/Вырезать
vnoremap <C-c> "+y
vnoremap <C-x> "+d
inoremap <C-v> <Esc>"+pi

" Выделить все
nnoremap <C-a> ggVG

" Мультикурсор (надо ставить ещё vim-visual-multi)
let g:VM_maps = {}
let g:VM_maps['Find Under'] = '<C-d>'
let g:VM_maps['Find Subword Under'] = '<C-d>'

" 5. Автодополнение
" Улучшенные настройки CoC
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" 6. Быстрая навигация
" Переключение между файлами
nnoremap <C-p> :Files<CR>
nnoremap <C-f> :Rg<CR>
nnoremap <C-b> :Buffers<CR>

" Переключение между окнами
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" 7. Интеграция с Git
" Быстрый доступ к git командам
nnoremap <leader>gg :Git<CR>
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>gl :Git pull<CR>

" 8. Улучшенный статусбар
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

" 9. Автоматическое закрытие скобок и кавычек
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>
inoremap ' ''<Left>
inoremap " ""<Left>

" 10. Подсветка при копировании
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}
augroup END

" 11. VS Code-подобные команды через Command Palette
nnoremap <leader>p :Commands<CR>

" 12. Быстрый просмотр определения (hover)
nnoremap <silent> K :call CocAction('doHover')<CR>
nmap <leader>rn <Plug>(coc-rename)

" 13. Улучшенная навигация по ошибкам
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" 14. Автоматическое форматирование
command! -nargs=0 Format :call CocAction('format')
nmap <leader>f :Format<CR>

" 15. VS Code-подобные сниппеты
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" 16. Улучшенный поиск и замена
" Настройки для поиска и замены в обычном Vim
set incsearch
set hlsearch
nnoremap <C-h> :%s///g<Left><Left><Left>
nnoremap <C-r> :%s///gc<Left><Left><Left>
nnoremap <C-f> /
nnoremap <C-g> ?

" 26. Улучшенная стабильность
set nocompatible
set ttyfast
set lazyredraw

" 27. Улучшенная работа с буферами
" Предотвращаем потерю несохраненных изменений
set confirm
set autowrite
set autowriteall

" 28. Улучшенная работа с историей
set history=1000
set undolevels=1000
set undofile
set undodir=~/.vim/undodir

" 29. Улучшенная работа с поиском
set wrapscan
set showmatch
set matchtime=2
set matchpairs+=<:>

" 30. Улучшенная работа с отступами
set copyindent
set preserveindent
set shiftround
set smarttab

" 31. Улучшенная работа с окнами
set winminheight=0
set winminwidth=0
set equalalways
set splitbelow
set splitright

" 32. Улучшенная работа с курсором
set cursorline
set scrolloff=5
set sidescrolloff=5
set cursorlineopt=number  " Показываем номер строки для текущей строки
set cursorlineopt=screenline  " Подсвечиваем только экранную строку
set cursorlineopt=both  " Комбинируем оба эффекта

" 33. Улучшенная работа с буфером обмена
set clipboard+=unnamedplus
set clipboard+=unnamed

" 34. Улучшенная работа с терминалом
" TODO

" 35. Улучшенная работа с файлами
set fileencoding=utf-8
set encoding=utf-8
set fileformats=unix,dos,mac
set undodir=~/.vim/undo//
set undofile

" 36. Улучшенная работа с поиском
set ignorecase
set smartcase
set incsearch
set hlsearch
set wrapscan
set showmatch
set matchtime=2

" 37. Улучшенная работа с отступами
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set smartindent
set copyindent
set preserveindent
set shiftround
set smarttab

" 38. Улучшенная работа с окнами
set winminheight=0
set winminwidth=0
set equalalways
set splitbelow
set splitright

" 39. Улучшенная работа с курсором
set cursorline
" set cursorcolumn  " Отключаем вертикальную линию
set scrolloff=5
set sidescrolloff=5

" 40. Улучшенная работа с буфером обмена
set clipboard+=unnamedplus
set clipboard+=unnamed

" Навигация назад/вперед как в VS Code
nnoremap <silent> <C-o> <C-o>zz
nnoremap <silent> <C-i> <C-i>zz

" Контекстное меню и навигация мышью, а также через \ + m
" Лучшая фича из лучших не удалять
nnoremap <silent> <RightMouse> :call <SID>ShowContextMenu()<CR>
nnoremap <silent> <Leader>m :call <SID>ShowContextMenu()<CR>
vnoremap <silent> <RightMouse> :<C-U>call <SID>ShowContextMenu()<CR>
vnoremap <silent> <Leader>m :<C-U>call <SID>ShowContextMenu()<CR>

function! s:ShowContextMenu()
  " Проверка, что это нормальный буфер
  if &buftype != '' || !buflisted(bufnr('%'))
    return
  endif

  let l:menu = []
  call add(l:menu, ['Перейти к определению (gd)', 'normal! gd'])
  call add(l:menu, ['Перейти к типу (gy)', 'normal! gy'])
  call add(l:menu, ['Перейти к реализации (gi)', 'normal! gi'])
  call add(l:menu, ['Показать ссылки (gr)', 'normal! gr'])
  call add(l:menu, ['Показать документацию (K)', 'normal! K'])
  call add(l:menu, ['-', ''])
  call add(l:menu, ['Открыть справа', 'vsplit | normal! gd'])
  call add(l:menu, ['Открыть снизу', 'split | normal! gd'])
  call add(l:menu, ['Открыть в новой вкладке', 'tab split | normal! gd'])
  call add(l:menu, ['-', ''])
  call add(l:menu, ['Переименовать символ', 'call CocActionAsync("rename")'])
  call add(l:menu, ['Форматировать', 'call CocAction("format")'])
  call add(l:menu, ['Исправить (Quick Fix)', 'call CocActionAsync("doQuickfix")'])
  
  let l:choice = popup_menu(map(copy(l:menu), 'v:val[0]'), #{
        \ line: line('.'),
        \ col: col('.'),
        \ callback: function('s:ExecuteContextMenuChoice', [l:menu])
        \ })
endfunction

function! s:ExecuteContextMenuChoice(menu, id, choice)
  if a:choice <= 0 || a:menu[a:choice-1][0] == '-'
    return
  endif
  
  try
    let l:cmd = a:menu[a:choice-1][1]
    if l:cmd =~# '^normal!'
      execute l:cmd
    elseif l:cmd =~# '^call'
      execute l:cmd
    else
      execute 'silent! ' . l:cmd
    endif
  catch
    echohl ErrorMsg
    echo "Ошибка при выполнении команды: " . v:exception
    echohl None
  endtry
endfunction

" Маппинги навигации для использования в меню
nmap gd <Plug>(coc-definition)
nmap gy <Plug>(coc-type-definition)
nmap gi <Plug>(coc-implementation)
nmap gr <Plug>(coc-references)
nnoremap <silent> K :call <SID>ShowDocumentation()<CR>

function! s:ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Airline настройки для отображения пути файла
let g:airline_section_c = '%{expand("%:p:h")} %#__accent_bold#%{expand("%:t")}%#__restore__#'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

" Добавляем кликабельный путь файла в верхней панели
function! OpenLfInCurrentFileDir()
  let path = expand('%:p:h')
  execute 'FloatermNew lf ' . path
endfunction

" Маппинг для клика по пути файла
nnoremap <expr> <C-LeftMouse> ':call OpenLfInCurrentFileDir()<CR>'

" Настройка statusline с кликабельным путем
set statusline=%#StatusLine#%{expand('%:p:h')}/%#StatusLineBold#%{expand('%:t')}%#StatusLine#
set laststatus=2

" Быстрый поиск файлов через fd + fzf
nnoremap <silent> <Leader>o :let $FZF_DEFAULT_COMMAND = "fd -H -t f -E '.git/'"<CR>:Files<CR>

