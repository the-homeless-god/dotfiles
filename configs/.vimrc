packloadall

call plug#begin()

" plugins:
Plug 'vim-airline/vim-airline'
Plug 'pangloss/vim-javascript'    " JavaScript support
Plug 'leafgarland/typescript-vim' " TypeScript syntax
Plug 'maxmellon/vim-jsx-pretty'   " JS and JSX syntax
Plug 'jparise/vim-graphql'        " GraphQL syntax
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Autocompetion
Plug 'prettier/vim-prettier', { 'do': 'npm ci' }
Plug 'rhysd/vim-healthcheck'
Plug 'voldikss/vim-floaterm'
Plug 'jremmen/vim-ripgrep'
Plug 'airblade/vim-gitgutter'

call plug#end()


function! s:initVimStartup()
	" VIM STARTUP: exec functions on start of vim
	" 1. initiate update of plugins on each start
	" 2. initiate autostart of Coc plugins
	" 3. Highlight the symbol and its references when holding the cursor
	"	autocmd VimEnter * silent! PlugUpdate
	autocmd VimEnter * silent! CocStart
	autocmd CursorHold * silent call CocActionAsync('highlight')

	" Open terminal by default at bottom
	augroup term_open
		autocmd VimEnter * :below terminal ++rows=15 ++close 
		autocmd VimEnter * command! Rg FloatermNew --width=0.8 --height=0.8 rg
	augroup END

	augroup disable_netrw_close
		autocmd!
		autocmd FileType netrw nnoremap <buffer> <silent> q :echo "Use :Nclose to close Netrw"<CR>
		autocmd FileType netrw nnoremap <buffer> <silent> x :echo "Use :Nclose to close Netrw"<CR>
	augroup END


	autocmd VimEnter * :Lexplore

endfunction

function! s:initVimVariables()
	" VIM VARIABLES: set variables on start of vim  
	" Terminal: set size of terminal with small hight to avoid taking a half of the screen
	set termwinsize = "10*0"
	let g:terminal_default_height = 10

	" Always show an empty buffer when a file is closed
	"	set hidden

	" Open new buffers on the right side
	"	 set splitright

	let g:airline#extensions#tabline#enabled = 1 
	let g:airline#extensions#tabline#formatter = 'jsformatter'
	let g:airline#extensions#branch#enabled = 1

	" Git lens
	let g:gitgutter_enabled = 1
	let g:gitgutter_sign_added = '+'
	let g:gitgutter_sign_modified = '~'
	let g:gitgutter_sign_removed = '-'

	" Fonts: usage of specific font with height 
	set guifont=FuraCodeNF:h10

	" Prettier: formatting on save
	let g:prettier#autoformat = 1

	" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
	" delays and poor user experience
	set updatetime=300

	" Always show the signcolumn, otherwise it would shift the text each time
	" diagnostics appear/become resolved
	set signcolumn=yes

	" Encoding: May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
	" utf-8 byte sequence
	set encoding=utf-8

	" File explorer: size of window by default and auto-setup for current directory
	let g:netrw_keepdir = 0
	let g:netrw_winsize = 35

	" Keep the side bar open by default
	let g:netrw_banner = 0
	let g:netrw_browse_split = 4
	let g:netrw_altv = 1
	let g:netrw_winsize = 25
	let g:netrw_liststyle = 3

	let g:netrw_banner = 0 | autocmd FileType netrw setlocal bufhidden=hide


	" Add (Neo)Vim's native statusline support
	" NOTE: Please see `:h coc-status` for integrations with external plugins that
	" provide custom statusline: lightline.vim, vim-airline
	set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

	" CoC extensions
	let g:coc_global_extensions = ['coc-tsserver', 'coc-json']
	
	" Add node.js path like
	" let g:coc_node_path = '/Users/developer/.nvm/versions/node/v18.9.0/bin/node'

	" Prettier and ESLint
	if isdirectory('./node_modules') && isdirectory('./node_modules/prettier')
		let g:coc_global_extensions += ['coc-prettier']
	endif

	if isdirectory('./node_modules') && isdirectory('./node_modules/eslint')
		let g:coc_global_extensions += ['coc-eslint']
	endif

	" status line:
	set titlestring="File: " + statusline + %F

	" tabline: 
	set tabline=2

	" tree:
	let g:netrw_altv=1

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
	set paste!
	set signcolumn=yes

	":remote-send("<ESC>:call remote_startserver('some_name')<CR>")

	" nmap <leader>g :FloatermNew --width=0.8 --height=0.8 rg)<CR>

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

	" [Leader + a +c]: emap keys for applying codeAction to the current line.
	nmap <leader>ac  <Plug>(coc-codeaction)

	" [Leader + q + f]: apply AutoFix to problem on the current line.
	nmap <leader>qf  <Plug>(coc-fix-current)

	" [Leader + g + d(efinition) | y(type-definition) | i(implementation)] 
	nmap <silent> gd <Plug>(coc-definition)
	nmap <silent> gy <Plug>(coc-type-definition)
	nmap <silent> gi <Plug>(coc-implementation)
	nmap <silent> gr <Plug>(coc-references)

	" Use `[g` and `]g` to navigate diagnostics
	" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
	nmap <silent> [g <Plug>(coc-diagnostic-prev)
	nmap <silent> ]g <Plug>(coc-diagnostic-next)
	" Applying code actions to the selected code block
	" Example: `<leader>aap` for current paragraph
	xmap <leader>a  <Plug>(coc-codeaction-selected)
	nmap <leader>a  <Plug>(coc-codeaction-selected)

	" [Leader + r + n]: symbol renaming
	nmap <leader>rn <Plug>(coc-rename)

	" Apply the most preferred quickfix action to fix diagnostic on the current line
	nmap <leader>qf  <Plug>(coc-fix-current)

	" Remap keys for applying refactor code actions
	nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
	xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
	nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

	" Run the Code Lens action on the current line
	nmap <leader>cl  <Plug>(coc-codelens-action)


	" Remap <C-f> and <C-b> to scroll float windows/popups
	if has('nvim-0.4.0') || has('patch-8.2.0750')
		nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
		nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
		inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
		inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
		vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
		vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
	endif

	" Use CTRL-S for selections ranges
	" Requires 'textDocument/selectionRange' support of language server
	nmap <silent> <C-s> <Plug>(coc-range-select)
	xmap <silent> <C-s> <Plug>(coc-range-select)
	" Mappings for CoCList
	" Show all diagnostics
	nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
	" Manage extensions
	nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
	" Show commands
	nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
	" Find symbol of current document
	nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
	" Search workspace symbols
	nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
	" Do default action for next item
	nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
	" Do default action for previous item
	nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
	" Resume latest coc list
	nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

	nnoremap   <silent>   <F7>    :FloatermNew<CR>
	tnoremap   <silent>   <F7>    <C-\><C-n>:FloatermNew<CR>
	nnoremap   <silent>   <F8>    :FloatermPrev<CR>
	tnoremap   <silent>   <F8>    <C-\><C-n>:FloatermPrev<CR>
	nnoremap   <silent>   <F9>    :FloatermNext<CR>
	tnoremap   <silent>   <F9>    <C-\><C-n>:FloatermNext<CR>
	nnoremap   <silent>   <F12>   :FloatermToggle<CR>
	tnoremap   <silent>   <F12>   <C-\><C-n>:FloatermToggle<CR>
	nmap <leader>lf :FloatermNew lf<CR>
	nmap <leader>rg :Rg<CR> 

endfunction


" Plugin [coc.nvim]
function! s:initCocSettings()
	" Use tab for trigger completion with characters ahead and navigate
	" NOTE: There's always complete item selected by default, you may want to enable
	" no select by `"suggest.noselect": true` in your configuration file
	" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
	" other plugir before putting this into your config
	inoremap <silent><expr> <TAB>
				\ coc#pum#visible() ? coc#pum#next(1) :
				\ CheckBackspace() ? "\<Tab>" :
				\ coc#refresh()
	inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

	" Make <CR> to accept selected completion item or notify coc.nvim to format
	" <C-g>u breaks current undo, please make your own choice
	inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
				\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

	function! CheckBackspace() abort
		let col = col('.') - 1
		return !col || getline('.')[col - 1]  =~# '\s'
	endfunction

	" Use <c-space> to trigger completion
	if has('nvim')
		inoremap <silent><expr> <c-space> coc#refresh()
	else
		inoremap <silent><expr> <c-@> coc#refresh()
	endif

	augroup mygroup
		autocmd!
		" Setup formatexpr specified filetype(s)
		autocmd FileType svg,typescript,json setl formatexpr=CocAction('formatSelected')
		" Update signature help on jump placeholder
		autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
	augroup end

	" Add `:Format` command to format current buffer
	command! -nargs=0 Format :call CocActionAsync('format')

	" Add `:Fold` command to fold current buffer
	command! -nargs=? Fold :call     CocAction('fold', <f-args>)

	" Add `:OR` command for organize imports of the current buffer
	command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

endfunction

function! s:showDocumentation()
	if CocAction('hasProvider', 'hover')
		call CocActionAsync('doHover')
	else
		call feedkeys('K', 'in')
	endif
endfunction


call s:initVimVariables()
call s:initCocSettings()
call s:initVimStartup()
call s:initVimHotkeys()

command! Rg FloatermNew --width=0.8 --height=0.8 rg

if exists(":AirlineRefresh")
	:AirlineRefresh
endif
