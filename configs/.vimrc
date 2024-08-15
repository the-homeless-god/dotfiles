packloadall
filetype plugin on

call plug#begin()

" plugins:
Plug 'vim-airline/vim-airline'
Plug 'pangloss/vim-javascript'    " JavaScript support
Plug 'leafgarland/typescript-vim' " TypeScript syntax
Plug 'maxmellon/vim-jsx-pretty'   " JS and JSX syntax
Plug 'jparise/vim-graphql'        " GraphQL syntax
Plug 'prettier/vim-prettier', { 'do': 'npm ci' }
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



call plug#end()

function! s:initVimStartup()
	" VIM STARTUP: exec functions on start of vim
	" 1. initiate update of plugins on each start
	" 2. Highlight the symbol and its references when holding the cursor
	" autocmd VimEnter * silent! FloatermNew --width=0.8 --height=0.8 vim +PlugUpdate +qall

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

	let g:airline#extensions#tabline#enabled = 1 
	let g:airline#extensions#tabline#formatter = 'jsformatter'
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
	let g:netrw_winsize = 50
	let g:netrw_altv = 1

	" Keep the side bar open by default
	let g:netrw_banner = 0
	let g:netrw_browse_split = 2 
	let g:netrw_liststyle = 3

	let g:netrw_banner = 0 | autocmd FileType netrw setlocal bufhidden=hide
	let g:netrw_altv=1
	let g:netrw_list_hide='.*\.swp$'


	" status line:
	set titlestring="File: " + statusline + %F

	" tabline: 
	set tabline=2

	" themes (dracula pro):
	packadd! dracula_pro

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
	set spell
	set spelllang=en
	" Highlight the current line
	set cursorline
	" Show white space characters and tab characters
	set list

	" This enables the use of the mouse in all modes (normal, visual, insert,
	" command-line, etc.).
	set mouse=a

	let g:ale_linters = {'c': ['clang', 'cppcheck']}
	let g:ale_fixers = {'c': ['uncrustify', 'clang-format']}
	let g:ale_fixers_always_run = 1
	let g:ale_fixers_on_save = 1
	let g:ale_sign_priority = 50
endfunction

function! s:initVimHotkeys()
	" My keymaps

	" [Leader + ot]: open terminal below
	nnoremap <silent> <Leader>ot :below terminal ++rows=15 ++close<CR>
	set number!
	set signcolumn=yes

	nmap <silent> <Leader>v :vsplit<CR>
	nmap <silent> <Leader>h :split<CR>
	nmap <silent> <Leader>w :w<CR>
	nmap <silent> <Leader>x :x<CR>
	nmap <silent> <Leader>q :qa<CR>
  nmap <silent> <Leader><F2> :map<CR>
  nmap <silent> <Leader>. <C-x><C-f><CR>
	":remote-send("<ESC>:call remote_startserver('some_name')<CR>")

	" [Leader + rg]: opens ripgrep + fzf
	nmap <leader>rg :FloatermNew --width=0.8 --height=0.8 rg<CR>

	" [Leader + f]: format whole file
	nnoremap <leader>f :Format<CR>

	" [Leader + c + a]: copy content of whole file
	nnoremap <leader>ca :%y+<CR>

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

map gb :bnext<cr>
map gbp :bprevious<cr>
map gbd :bdelete<cr>
map gtn :tabnext<cr>
map gtp :tabprevious<cr>
map gtd :tabdelete<cr>
endfunction

call s:initVimVariables()
call s:initVimStartup()
call s:initVimHotkeys()

if exists(":AirlineRefresh")
	:AirlineRefresh
endif
