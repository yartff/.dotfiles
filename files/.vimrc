filetype on
filetype plugin on
filetype indent on

set runtimepath^=~/.vim/bundle/ctrlp.vim

" _
""""""""""""""""""""""""
"" GENERAL
""""""""""""""""""""""""
" Syntax
set shiftwidth=2
syntax on
" Search
set hlsearch
set incsearch
set wrapscan
set ignorecase
set smartcase
" GUI
set scrolloff=4
set nowrap
set laststatus=2
set showcmd
set showmode
set number
set showmatch "nts
set matchtime=3 "nts
set t_Co=256
" System

""""""""""""
"" BASIC NAVIGATION
nmap		h			<Backspace>
nmap		l			<Space>
vmap		h			<Backspace>
vmap		l			<Space>
noremap		<buffer> <silent> k	gk
noremap		<buffer> <silent> j	gj

""""""""""""
"" BINDS
nmap		U			:redo <CR>
nmap		Q			:call ToggleCopy()<CR>
nmap		Z			:call ToggleWrap()<CR>
map		Y			"+y

""""""""""""
"" INSERT-MODE EDIT
inoremap	<C-k>			<C-o>C
inoremap	<C-x>			<C-o>:w <CR>
inoremap	<C-d>			<Del>
inoremap	<C-a>			<Esc>I
inoremap	<C-e>			<End>

""""""""""""
"" FOLDING
map		z[			<ESC>$zf%
map		z]			<ESC>?{<CR>zf% :noh <CR>
vmap		zo			:fo<CR>
set foldopen-=block

""""""""""""
"" WINDOWS/TABS
nnoremap	<silent> <C-left>	:bp <CR>
nnoremap	<silent> <C-right>	:bn <CR>
nnoremap	<silent> <C-j>		:tabn <CR>
nnoremap	<silent> <C-k>		:tabp <CR>
nnoremap	<silent> <C-w><C-w>	:lcl <CR><C-w>c
nnoremap	<C-w><C-t>		<C-w>T
nnoremap	<C-w>j			<C-w>J
nnoremap	<C-w>h			<C-w>H

nnoremap	<silent> <M-down>	:resize +1 <CR>
nnoremap	<silent> <M-up>		:resize -1 <CR>
nnoremap	<silent> <M-left>	:vertical resize -1 <CR>
nnoremap	<silent> <M-right>	:vertical resize +1 <CR>

nnoremap	<silent> <C-r>		:silent! call ToggleLoc()<CR>

""""""""""""
"" CODE NAVIGATION
nmap		<silent> <C-n>		<C-]>
nnoremap	<silent> <C-h>		:pop <CR>
nnoremap	<C-t>			:call ClearTags() <CR>
vnoremap	*			"*y:call SearchSelection() <CR>
nnoremap	<silent> vi/		T/vt/
nnoremap	<silent> va/		F/vf/

"" TODO open tags in new windows
"" Call generic functions overriden in ftplugin files
"" nnoremap	<buffer> <silent> <C-w><C-n>	:call defJump "vsplit"<CR>
"" nnoremap	<buffer> <silent> <C-w>N	:call defJump "split"<CR>

""""""""""""
"" UNBINDS
nnoremap	<C-w>n			<Nop>

""""""""""""
"" DESIGN
if filereadable($HOME . "/.vim/colors/railscasts.vim")
  colorscheme railscasts
endif
" Highlight 90-100th column
let &colorcolumn=join(range(90,101),",")

""""""""""""
"" GENERAL FUNCTION/SYSTEM
set shell=bash
set mouse=a
set autoread
" backup files
set nobackup
set nowritebackup
set noswapfile
autocmd VimEnter * clearjumps
" Menu
set wildmenu
set wildmode=full
set wildignore+=*.o,*.a,*.git
" get rid of netrwhist
" let g:netrw_home = expand('/tmp')
" misc.
set cpoptions=ces$  " make the 'cw' and like commands put a $ at the end

set nopaste

""""""""""""""""""""""""
"" FILETYPE
""""""""""""""""""""""""
au BufRead,BufNewFile *.tpp set filetype=cpp

""""""""""""""""""""""""
"" FUNCTIONS
""""""""""""""""""""""""
function! ClearTags()
  call settagstack(winnr(), {'items': []})
  ":clearjumps
  echo "Tag list emptied"
endfunction

function! ToggleCopy()
  let currpos=winnr()
  let currtab=tabpagenr()
  if (&number == 1)
    tabdo execute 'windo execute "set nonumber"'
    set mouse=
  else
    tabdo execute 'windo execute "set number"'
    set mouse=a
  endif
  execute 'tabn ' . currtab
  execute currpos . 'wincmd w'
  call TogglePaste()
endfunction

function! TogglePaste()
  if (&paste == 1)
    set nopaste
  else
    set paste
  endif
endfunction

function! ToggleWrap()
  if (&wrap == 1)
    set nowrap
  else
    set wrap
  endif
endfunction

function! ToggleLoc()
  let loclist=getloclist(0, {'winid': 0})
  if get(loclist, 'winid', 0)
    execute 'lcl'
  else
    execute 'lopen'
  endif
endfunction

function! SearchSelection()
  let l:press_n = 0
  let l:text = getreg('*')
  let l:text_ori = escape(l:text, '\\/.$^~[]')
  let l:text = substitute(l:text_ori, '^\s\+', '', '')
  if l:text !=# l:text_ori
    let l:press_n = 1
  endif
  let l:text = substitute(l:text, '\n', '\\n', "g")
  let @/ = '\V' . l:text
  normal! n
  if l:press_n == 1
    normal! n
  endif
  redraw
endfunction
