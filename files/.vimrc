filetype on
filetype plugin on
filetype indent on

set runtimepath^=~/.vim/bundle/ctrlp.vim

" Syntax
set shiftwidth=2
" _
" Search
set hlsearch
set incsearch
set wrapscan
set ignorecase
set smartcase
" _
" GUI
set scrolloff=8
set nowrap
set laststatus=2
set showcmd
set showmode
set mouse=a

syntax on
set t_Co=256
if filereadable($HOME . "/.vim/colors/railscasts.vim")
  colorscheme railscasts
endif
" _
" Misc
set autoread
set shell=tcsh
set showmatch "nts
set matchtime=3 "nts
set wildmenu
set wildmode=full
set wildignore+=*.o,*.a,*.git
set cpoptions=ces$  " make the 'cw' and like commands put a $ at the end
set number
set wrap

" Get rid of netrwhist
let g:netrw_home = expand('/tmp')

" Personal keybinds

function! ToggleCopy()
  if (&number == 1)
    tabdo execute 'windo execute "set nonumber"'
    set mouse=
  else
    tabdo execute 'windo execute "set number"'
    set mouse=a
  endif
endfunction

function! ToggleWrap()
  if (&wrap == 1)
    set nowrap
  else
    set wrap
  endif
endfunction

nmap U		<Esc>:redo <CR>
nmap Q		<ESC>:call ToggleCopy()<CR>
nmap Z		<ESC>:call ToggleWrap()<CR>
nmap h		<Backspace>
nmap l		<Space>

nmap <C-left>	<Esc>:bp <CR>
nmap <C-right>	<Esc>:bn <CR>
nmap <C-j>	<Esc>:tabn <CR>
nmap <C-k>	<Esc>:tabp <CR>

nmap <C-w><C-t>	<ESC><C-w>T
nmap <C-w><C-v>	<ESC>:vs <CR>:bp <CR> <C-w>l
nmap <C-w>s	<ESC>:sp <CR>:bp <CR> <C-w>j
nmap <C-w><C-w>	<ESC><C-w>c

"" nmap <C-w><C-s>	<ESC>:sp <CR>
"" nmap <C-w><C-v>	<ESC>:vs <CR>

map <M-down> <Esc>:resize +1 <CR>
map <M-up> <Esc>:resize -1 <CR>
map <M-left> <Esc>:vertical resize -1 <CR>
map <M-right> <Esc>:vertical resize +1 <CR>

inoremap <C-k> <C-o>C
inoremap <C-z> <C-o>:w <CR>
inoremap <C-d> <Del>
inoremap <C-a> <Esc>I
inoremap <C-e> <End>

"" map <C-p> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Highlight 100th column
let &colorcolumn=join(range(101,101),",")

" No swap or backup files
set nobackup
set nowritebackup
set noswapfile

""  TODO search visual
""  vmap
