filetype on
filetype plugin on
filetype indent on

" Syntax
set shiftwidth=2
set tabstop=2
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
if filereadable($HOME . "/.vim/colors/wombat256.vim")
  colorscheme wombat256
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

" Personal keybinds
map <C-j> <Esc>:tabn <CR>
map <C-k> <Esc>:tabp <CR>
map <M-down> <Esc>:resize +1 <CR>
map <M-up> <Esc>:resize -1 <CR>
map <M-left> <Esc>:vertical resize -1 <CR>
map <M-right> <Esc>:vertical resize +1 <CR>
"" map <C-p> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
execute "set <M-j>=\ej"
execute "set <M-k>=\ek"
nnoremap <M-j> <Esc>:bn <CR>
nnoremap <M-k> <Esc>:bp <CR>

" Highlight 80th column
let &colorcolumn=join(range(81,81),",")

" No swap or backup files
set nobackup
set nowritebackup
set noswapfile

" Get rid of netrwhist
let g:netrw_home = expand('/tmp')

set runtimepath^=~/.vim/bundle/ctrlp.vim
