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
Plug 'TabbyML/vim-tabby'

call plug#end()

function! s:initVimStartup()
	" VIM STARTUP: exec functions on start of vim
	" 1. initiate update of plugins on each start
	" 2. initiate autostart of Coc plugins
	" 3. Highlight the symbol and its references when holding the cursor
	" autocmd VimEnter * silent! FloatermNew --width=0.8 --height=0.8 vim +PlugUpdate +qall

	" Open terminal by default at bottom
	" augroup term_open
	"	autocmd VimEnter * :below terminal ++rows=15 ++close 
	"	autocmd VimEnter * command! Rg FloatermNew --width=0.8 --height=0.8 rg
	" augroup END

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
	
	" autocmd VimEnter * :Lexplore
endfunction

function! s:initVimVariables()
	" VIM VARIABLES: set variables on start of vim  
	" Terminal: set size of terminal with small hight to avoid taking a half of the screen
	set termwinsize = "10*0"
	let g:terminal_default_height = 10

	" Setup Tabby
	let g:tabby_trigger_mode = 'manual'
	let g:tabby_keybinding_accept = '<Tab>'

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
	let g:netrw_winsize = 35
	let g:netrw_altv = 1

	" Keep the side bar open by default
	let g:netrw_banner = 0
	let g:netrw_browse_split = 2 
	let g:netrw_altv = 1
	let g:netrw_winsize = 25
	let g:netrw_liststyle = 3

	let g:netrw_banner = 0 | autocmd FileType netrw setlocal bufhidden=hide
	let g:netrw_altv=1

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

	nmap <leader>lf :FloatermNew lf --command 'set hidden'<CR>
	nmap <leader>Rg :FloatermNew --width=0.8 --height=0.8 rg<CR> 
	nmap <leader>cf gg dG<CR> 

	nnoremap   <silent>   <F7>    :FloatermNew<CR>
	tnoremap   <silent>   <F7>    <C-\><C-n>:FloatermNew<CR>
	nnoremap   <silent>   <F8>    :FloatermPrev<CR>
	tnoremap   <silent>   <F8>    <C-\><C-n>:FloatermPrev<CR>
	nnoremap   <silent>   <F9>    :FloatermNext<CR>
	tnoremap   <silent>   <F9>    <C-\><C-n>:FloatermNext<CR>
	nnoremap   <silent>   <F12>   :FloatermToggle<CR>
	tnoremap   <silent>   <F12>   <C-\><C-n>:FloatermToggle<CR
endfunction


function! s:showDocumentation()
	if CocAction('hasProvider', 'hover')
		call CocActionAsync('doHover')
	else
		call feedkeys('K', 'in')
	endif
endfunction


call s:initVimVariables()
call s:initVimStartup()
call s:initVimHotkeys()

if exists(":AirlineRefresh")
	:AirlineRefresh
endif

