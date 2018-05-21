" Filetype support
filetype plugin indent on
syntax on

runtime macros/matchit.vim
colorscheme gruvbox
set background=dark

set tabstop=4
set autoindent		" Indent according to previous line
set softtabstop=4	" Tab key indents by 4 spaces
set shiftwidth=4	" >> indents by 4 spaces
set noexpandtab		" Use spaces instead of tabs
set laststatus=2
set number
set backspace=indent,eol,start
set hlsearch
set incsearch ignorecase
set noswapfile
set smartcase
set showcmd
set ruler
set hidden
set path=.,**
set wildmenu wildmode=full
set undofile undodir=~/.vim/tmp/undo/
set tags+=~/.vim/systags
set splitbelow splitright
set list listchars=eol:$ listchars+=tab:│\  fillchars+=vert:│,fold:-
set foldenable foldmethod=marker
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h

" Ergonomics
inoremap <C-H> (
inoremap <C-J> )
inoremap <C-K> [
inoremap <C-L> ]
inoremap <C-D> *
noremap ; :
noremap : ;
nnoremap ' `
nnoremap ,: *``cgn

" Juggling with buffers
nnoremap ,b         :buffer *
nnoremap ,B         :sbuffer *
nnoremap <PageUp>   :bprevious<CR>
nnoremap <PageDown> :bnext<CR>
nnoremap <BS>       :buffer#<CR>

" File navigation
nnoremap ,f :find *
nnoremap ,s :sfind *
nnoremap ,v :vert sfind *
nnoremap ,F :find <C-R>=fnameescape(expand('%:p:h')).'/**/*'<CR>
nnoremap ,S :sfind <C-R>=fnameescape(expand('%:p:h')).'/**/*'<CR>
nnoremap ,V :vert sfind <C-R>=fnameescape(expand('%:p:h')).'/**/*'<CR>
nnoremap gb :ls<CR>:buffer<Space>

" commands for adjusting indentation rules manually
command! -nargs=1 Spaces execute "setlocal tabstop=" . <args> . " shiftwidth=" . <args> . " softtabstop=" . <args> . " expandtab" | setlocal ts? sw? sts? et?
command! -nargs=1 Tabs   execute "setlocal tabstop=" . <args> . " shiftwidth=" . <args> . " softtabstop=" . <args> . " noexpandtab" | setlocal ts? sw? sts? et?

" better completion menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap        ,,      <C-n><C-r>=pumvisible() ? "\<lt>Down>\<lt>C-p>\<lt>Down>\<lt>C-p>" : ""<CR>
inoremap        ,:      <C-x><C-f><C-r>=pumvisible() ? "\<lt>Down>\<lt>C-p>\<lt>Down>\<lt>C-p>" : ""<CR>
inoremap        ,=      <C-x><C-l><C-r>=pumvisible() ? "\<lt>Down>\<lt>C-p>\<lt>Down>\<lt>C-p>" : ""<CR>

" Share text
command! -range=% IX  <line1>,<line2>w !curl -F 'f:1=<-' ix.io | tr -d '\n' | xclip -i -selection clipboard
" AutoCMD's {{{
if has('autocmd')
	augroup C_Files
		autocmd!
		"autocmd BufNewFile *.c 0r ~/.vim/snippets/skeleton.c | call cursor(8,17) " Call the skeleton.c for every new .c file
		" Just some shit to show the file creation time
		"autocmd BufNewFile *.c :r!date "+\%d/\%m/\%Y \%H:\%M"
		"autocmd BufNewFile *.c :norm kJ | call cursor(13,1)
		" When typing ';' marks a undo point, so when hit u, it won't undo the whole thing that you did in insert mode (nice when programming), and always save when press ;
		autocmd BufNewFile *.c inoremap ; ;<c-g>u
		autocmd BufNewFile,BufRead *.c inoremap {<CR> <CR>{<CR>}<Esc>O
		autocmd BufNewFile,BufWritePost,BufRead *.c inoremap /*<space> /*  */<Esc>2<Left>i
		"autocmd BufNewFile *.c inoremap ; :w<CR>
		autocmd BufRead,BufNewFile,BufWritePost *.c set colorcolumn=72
	augroup END

	augroup Prolog_Files
		autocmd!
		autocmd BufRead,BufNewFile,BufWritePost *.pl set filetype=prolog
	augroup END

	" Return to last edit position when opening files (You want this!)
	augroup Remember_cursor_position
		autocmd!
		autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
	augroup END

	" Automatic Open Quick Fix window
	augroup AutoQuickfix
		autocmd!
		" automatic location/quickfix window
		autocmd QuickFixCmdPost [^l]* cwindow
		autocmd QuickFixCmdPost    l* lwindow
		autocmd VimEnter            * cwindow
		" Git-specific settings
		autocmd FileType gitcommit nnoremap <buffer> { ?^@@<CR>|nnoremap <buffer> } /^@@<CR>|setlocal iskeyword+=-
	augroup END

	" Show spaces as red if there's nothing after it (from Greg Hurrel)
	augroup TrailWhiteSpaces
		highlight ColorColumn ctermbg=1
		autocmd BufWinEnter <buffer> match Error /\s\+$/
		autocmd InsertEnter <buffer> match Error /\s\+\%#\@<!$/
		autocmd InsertLeave <buffer> match Error /\s\+$/
		autocmd BufWinLeave <buffer> call clearmatches()
	augroup END
endif
" }}}
" Grep {{{
command! -nargs=+ -complete=file_in_path -bar Grep  silent! grep! <args> | redraw!
command! -nargs=+ -complete=file_in_path -bar LGrep silent! lgrep! <args> | redraw!

nnoremap <silent> ,G :Grep <C-r><C-w><CR>
xnoremap <silent> ,G :<C-u>let cmd = "Grep " . visual#GetSelection() <bar>
                        \ call histadd("cmd", cmd) <bar>
                        \ execute cmd<CR>

if executable("ag")
    set grepprg=ag\ --vimgrep
    set grepformat^=%f:%l:%c:%m
endif
" }}}
