" THAT'S MY OLD VIM CONFIGURATION, I BLOW IT OVER AND I'M STARTING A NEW ONE
" BECAUSE THIS ONE IS TOO BLOAT, I'LL KEEP IT HERE ONLY FOR REFERENCE.

" Plugins inicialization ==================={{{

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-surround'
Plug 'morhetz/gruvbox'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'lucasteles/SWTC.Vim', { 'on': 'SWTC .vim/plugged/SWTC.vim/intro.swtc' }
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive'
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': { -> coc#util#install()}}

call plug#end()

" }}}
" Global stuff ============================={{{
runtime macros/matchit.vim
colorscheme gruvbox                     " Use the gruvbox colorscheme: https://github.com/morhetz/gruvbox
set background=dark                     " Use a dark background
set scrolloff=5                         " Keep at least 3 lines above/below when scrolling
set lazyredraw                          " Don't update the display while executing macros
set tabstop=4                           " Tab indentation levels every four columns
set shiftwidth=4                        " Indent/outdent by four columns (when pressing >>)
set expandtab                           " Convert all tabs that are typed into spaces (it has a better compatibility with other computers)
set shiftround                          " Always indent/outdent to nearest tabstop
set smarttab                            " Use shiftwidths at left margin, tabstops everywhere else
set laststatus=2                        " Always show the statusline
set nonumber                            " Don't display line numbers
set relativenumber
set cursorline
set backspace=indent,eol,start          " Fix backspace
set hlsearch                            " Highlight search
set incsearch ignorecase                " Increase search
set noswapfile                          " Don't use swap file
set smartcase                           " Override the 'ignorecase' option if the search pattern contains upper case characters.
set showcmd                             " Show commands at bottom
set hidden                              " Switch buffers without the need of saving them
set path=.,**                           " Set path to the current and children directories
set undofile undodir=~/.vim/tmp/undo/   " Set undofiles (undo files even if you exited the file)
set splitbelow splitright               " Split belor and/or right when opening new buffers
set list listchars=eol:$,trail:∙ listchars+=tab:│\  fillchars+=vert:│,fold:\  
set foldenable foldmethod=marker
" }}}
" General mappings ========================={{{

" Set space as leader
map <space> <leader>

" Turn off the highlight search
nnoremap <silent> ,n :nohls<CR>

" Pontuation binding in insert mode (Ergonomics)
inoremap <C-H> (
inoremap <C-J> )
inoremap <C-K> [
inoremap <C-L> ]
inoremap <C-D> *
inoremap <C-F> _
inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "\'" ? "\<Right>" : "\'\'\<Left>""""""")))
inoremap <expr> )  strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")""""""")))
inoremap " ""<Left>
inoremap ( ()<Left>

" File navigation
nnoremap ,f :find *
nnoremap ,e :e %:h/
nnoremap ,s :sfind *
nnoremap ,v :vert sfind *
nnoremap ,F :find <C-R>=fnameescape(expand('%:p:h')).'/**/*'<CR>
nnoremap ,S :sfind <C-R>=fnameescape(expand('%:p:h')).'/**/*'<CR>
nnoremap ,V :vert sfind <C-R>=fnameescape(expand('%:p:h')).'/**/*'<CR>
nnoremap gb :ls<CR>:buffer<Space>

" Opens an edit command with the path of the currently edited file filled in
nnoremap ,e :e <C-R>=expand("%:p:h") . "/" <CR>

" Find faster
nnoremap ,f :find <C-R>=fnameescape(expand('%:p:h')). '/'<CR>

"Change directory to the dir of the current buffer
noremap ,cd :cd %:p:h<CR>

" Complete the current path in command mode
cnoremap <C-P> <C-R>=expand("%:p:h") . "/" <CR>

" Window buffer navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Make ; works like a : in normal mode, then i don't have to press <S-;> to go to the command line
nnoremap ; :
nnoremap : ;

" Fix the go to next line if wrap is enabled
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

" Quickly search
nnoremap ,s :g//#<Left><Left>

" A better search (search for the letters under cursor)
vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR>
nnoremap * *``
nnoremap g* g*``

" Surround text with pontuation in visual mode
vnoremap $( <esc>`>a)<esc>`<i(<esc>
vnoremap $[ <esc>`>a]<esc>`<i[<esc>
vnoremap ${ <esc>`>a}<esc>`<i{<esc>
vnoremap $" <esc>`>a"<esc>`<i"<esc>
vnoremap $' <esc>`>a'<esc>`<i'<esc>
vnoremap $\ <esc>`>o*/<esc>`<O/*<esc>
vnoremap $< <esc>`>a><esc>`<i<<esc>

" Change the word under cursor, highlight the others in the file, and you can repeat the change pressing dot
nnoremap c*  *Ncgn
nnoremap c*c #``cgN
vnoremap c*  *Ncgn

" A replacement to vim-surround but i still prefer the plugin
"nnoremap cs"' ci'"<C-r><C-o>""<Esc>

" Remove all trailing whitespace by pressing F5
nnoremap <silent> <F5> :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>

" Keep selection after indenting
vnoremap < <gv
vnoremap > >gv

" Move selected line in visual mode
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Remove the Windows ^M - when the encodings gets messed up
nnoremap ,m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Allow saving of files as sudo
command! W silent w !sudo tee > /dev/null %

" Select last inserted text
nnoremap gV `[v`]

" Fix indentation, changed the map, so that if i have the mark 'm', this map won't destroy it
"nnoremap g= mmgg=G`m
nnoremap g= gg=G``

" A cool mapping that insert current time info
inoremap <silent> <C-G><C-T> <C-R>=repeat(complete(col('.'),map(["%Y-%m-%d %H:%M:%S","%a, %d %b %Y %H:%M:%S %z","%Y %b %d","%d-%b-%y","%a %b %d %T %Z %Y","%Y-%m-%d %a %I:%M %p"],'strftime(v:val)')+[localtime()]),0)<CR>

" Insert new line, but stay in normal mode
" Ref: https://www.reddit.com/r/vim/comments/7yzblt/what_was_your_best_vimrc_addition/dumcoya/?utm_content=permalink&utm_medium=front&utm_source=reddit&utm_name=vim
nnoremap <silent> [<space>  :<c-u>put!=repeat([''],v:count)<bar>']+1<cr>
nnoremap <silent> ]<space>  :<c-u>put =repeat([''],v:count)<bar>'[-1<cr>

" Make 0 go to the first character rather than the beginning
" of the line. When we're programming, we're almost always
" interested in working with text rather than empty space. If
" you want the traditional beginning of line, use ^
nnoremap 0 ^
nnoremap ^ 0

" These are very similar keys. Typing 'a will jump to the line in the current
" file marked with ma. However, `a will jump to the line and column marked
" with ma.  It’s more useful in any case I can imagine, but it’s located way
" off in the corner of the keyboard. The best way to handle this is just to
" swap them: http://items.sjbach.com/319/configuring-vim-right
nnoremap ' `
nnoremap ` '

" Resize windows with arrow keys
nnoremap <C-Left> :vertical resize +2<CR>
nnoremap <C-Right> :vertical resize -2<CR>
nnoremap <C-Up> :resize -2<CR>
nnoremap <C-Down> :resize +2<CR>

" move up/down quickly by using Alt-j, Alt-k
" which will move us around by functions
nnoremap <silent> <C-q> }
nnoremap <silent> <C-t> {

" [G]oto [m]idle of line
nnoremap gm :call cursor(0, len(getline('.'))/2)<CR>

" Switch buffer
nnoremap <bs> <c-^>

" Make C-A/C-x still works in visual mode
xnoremap <C-a> <C-a>gv
xnoremap <C-x> <C-x>gv

nnoremap <space>xv :!nohup mpv <C-R><C-F><CR>
"map <F8> :exec '!nohup mpv ' . shellescape(getline('.'), 1) . ' >/dev/null 2>&1&'<CR><CR>

" copy current 'filename into system clipboard - mnemonic:' (c)urrent(f)ilename
" this is helpful to paste someone the path you're looking at
" ~/.c-vimrc
nnoremap <silent> ,cf :let @* = expand("%:~")<CR>
" /home/leonardo/.c-vimrc
nnoremap <silent> ,cr :let @* = expand("%")<CR>
" .c-vimrc
nnoremap <silent> ,cn :let @* = expand("%:t")<CR>

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

" Source this line, place your cursor on ), press zl and you'll understand
"    println()foo
nnoremap zl :let @z=@"<cr>x$p:let @"=@z<cr>

" }}}
" NERDTree ================================={{{
" Toggle NERDTree with F6
nnoremap <tab> :NERDTreeToggle<CR>

" Close NERDTree with Shift-TAB
nnoremap <S-Tab> :NERDTreeClose<CR>

" Open NERDTree in the right side
let g:NERDTreeWinPos = "right"

" Show the bookmarks table on startup
let NERDTreeShowBookmarks = 1

" Autoclose nerdtree if it is the only open buffer
augroup nerdtree_close
	autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END
" }}}
" Most Recent Used files ==================={{{

" MRU command-line completion
function! s:MRUComplete(ArgLead, CmdLine, CursorPos)
	return filter(copy(v:oldfiles), 'v:val =~ a:ArgLead')
endfunction

" MRU function
function! s:MRU(command, arg)
	if a:command == "tabedit"
		execute a:command . " " . a:arg . "|lcd %:p:h"
	else
		execute a:command . " " . a:arg
	endif
endfunction

" commands
command! -nargs=1 -complete=customlist,<sid>MRUComplete ME call <sid>MRU('edit', <f-args>)
command! -nargs=1 -complete=customlist,<sid>MRUComplete MS call <sid>MRU('split', <f-args>)
command! -nargs=1 -complete=customlist,<sid>MRUComplete MV call <sid>MRU('vsplit', <f-args>)
command! -nargs=1 -complete=customlist,<sid>MRUComplete MT call <sid>MRU('tabedit', <f-args>)

" }}}
" Functions ================================{{{

" Makes vim like a real notepad
nnoremap <F3> :call Minimalify()<CR>
function Minimalify()
	if &laststatus
		setlocal laststatus=0
	else
		setlocal laststatus=2
	endif
	set noshowmode list! number! cursorline! noru! relativenumber! spell!
	set spelllang=en    " Turn on spell lang in en (there's in pt_BR also)
endfunction
augroup txt_files
	autocmd!
	autocmd BufRead,BufNewFile *.txt call Minimalify()
augroup END

" map '<CR>' in command-line mode to execute the function below
cnoremap <expr> <CR> CCR()
function! CCR()       " See https://gist.github.com/romainl/047aca21e338df7ccf771f96858edb86
	" grab the current command-line
	let cmdline = getcmdline()

	" does it end with '#' or 'number' or one of its abbreviations?
	if cmdline =~ '\v\C/(#|nu|num|numb|numbe|number)$'
		" press '<CR>' then ':' to enter command-line mode
		return "\<CR>:"
	else
		" press '<CR>'
		return "\<CR>"
	endif
endfunction

" Search by the word visual selected, see: http://got-ravings.blogspot.com.br/2008/07/vim-pr0n-visual-search-mappings.html
function! s:VSetSearch()
	let temp = @@
	norm! gvy
	let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
	let @@ = temp
endfunction

" Select some text to put it in termbin and send the url to clipboard
if executable('nc') && executable('tr') && executable('cat')
	command! -range=% TB <line1>,<line2>w !nc termbin.com 9999 | tr -d '\n' | xclip -i -selection clipboard
endif

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
	let col = col('.') - 1
	if !col || getline('.')[col - 1] !~ '\k'
		return "\<Tab>"
	else
		return "\<C-p>"
	endif
endfunction
inoremap <Tab> <C-r>=InsertTabWrapper()<CR>
inoremap <S-Tab> <C-n>

" It lets '%' works for other things, like if/endif, tags, etc
" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
	runtime! macros/matchit.vim
endif

" Enable undo changes to a file after closing and reopening
if has('persistent_undo')
	silent call system('mkdir -p ~/.vim/tmp/undo')
	set undofile
	set undodir=~/.vim/tmp/undo/
endif

" }}}
" AutoCMD's ================================{{{
if has('autocmd')
	augroup Prolog_Files
		autocmd!
		autocmd BufRead,BufNewFile,BufWritePost *.pl set filetype=prolog
	augroup END

	" Show spaces as red if there's nothing after it (from Greg Hurrel)
	augroup TrailWhiteSpaces
        highlight ColorColumn ctermbg=1
		autocmd BufWinEnter <buffer> match Error /\s\+$/
		autocmd InsertEnter <buffer> match Error /\s\+\%#\@<!$/
		autocmd InsertLeave <buffer> match Error /\s\+$/
		autocmd BufWinLeave <buffer> call clearmatches()
	augroup END

	" Quickfix options, see: https://gist.github.com/romainl/ce55ce6fdc1659c5fbc0f4224fd6ad29
	augroup AutoMake
		autocmd!
		:command -nargs=* Make make  <args> | cwindow 3    " Enable the Make command
		autocmd QuickFixCmdPost [^l]* nested cwindow   " Set AutoMake up
"		autocmd BufWritePost *.c, silent make! <afile> | silent redraw!   " Auto open the quickfix window
		" Compile c files with gcc (-lm to compile <math.h> header)
		autocmd FileType c set makeprg=gcc\ -o\ %<\ %\ -lm
		autocmd Filetype qf setlocal errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%# " Error format of quickfix window
	augroup END

	" Save folders automatically
	augroup AutoSaveFolds
		autocmd!
		autocmd BufWinLeave *.* mkview
		autocmd BufWinEnter *.* silent loadview
	augroup END

	" Ref: https://github.com/thoughtbot/dotfiles/blob/master/vimrc#L35
	" When editing a file, always jump to the last known cursor position.
	" Don't do it for commit messages, when the position is invalid, or when
	" inside an event handler (happens when dropping a file on gvim).
	augroup vimrc-remember-cursor-position
		autocmd BufReadPost *
					\ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
					\   exe "normal g`\"" |
					\ endif
	augroup END

	"	" Return to last edit position when opening files (You want this!)
	"	augroup vimrc-remember-cursor-position
	"		autocmd!
	"		autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
	"	augroup END

	" Ref: https://jeffkreeftmeijer.com/vim-number/
	"augroup numbertoggle
	"  autocmd!
	"  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
	"  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
	"augroup END

endif

" }}}
" Plugins {{{

" Lightline {{{
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'filetype'] ]
      \ },
      \ }

" }}}
" Fzf ======================================{{{

" File preview using Highlight (http://www.andre-simon.de/doku/highlight/en/highlight.php)
let g:fzf_files_options =
			\ '--preview "(highlight -O ansi {} || cat {}) 2> /dev/null | head -'.&lines.'"'

" Mapping selecting mappings
" Show avaliable mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" Advanced customization using autoload functions
inoremap <expr> <c-x><c-m> fzf#vim#complete#word({'left': '15%'})

command! Plugs call fzf#run({
			\ 'source':  map(sort(keys(g:plugs)), 'g:plug_home."/".v:val'),
			\ 'options': '--delimiter / --nth -1',
			\ 'down':    '~40%',
			\ 'sink':    'Explore'})

let g:fzf_colors =
			\ { 'fg':      ['fg', 'Normal'],
			\ 'bg':      ['bg', 'Normal'],
			\ 'hl':      ['fg', 'Comment'],
			\ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
			\ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
			\ 'hl+':     ['fg', 'Statement'],
			\ 'info':    ['fg', 'PreProc'],
			\ 'border':  ['fg', 'Ignore'],
			\ 'prompt':  ['fg', 'Conditional'],
			\ 'pointer': ['fg', 'Exception'],
			\ 'marker':  ['fg', 'Keyword'],
			\ 'spinner': ['fg', 'Label'],
			\ 'header':  ['fg', 'Comment'] }

let g:fzf_action = {
			\ 'ctrl-s': 'split',
			\ 'ctrl-v': 'vsplit'
			\ }
nnoremap <space>ff  :FZF<CR>
nnoremap <space>fl  :Lines<CR>
nnoremap <space>fbl :BLines<CR>
nnoremap <space>fh  :FZF ~<CR>
nnoremap <space>fu  :FZF /<CR>
nnoremap <space>fc  :Commits <CR>

" }}}
" Coc {{{

" use <tab> for trigger completion and navigate next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

" use <c-space>for trigger completion
imap <c-space> coc#refresh()

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" }}}

" }}}
