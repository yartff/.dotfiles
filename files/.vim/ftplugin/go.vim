map <silent> <F9> <Esc>:GoDecls <CR>
map <silent> <F12> <Esc>:GoDeclsDir <CR>
map <silent> <C-l> <Esc>:GoDef <CR>
map <silent> <C-h> <Esc>:GoDefPop <CR>

map <silent> <C-r> <Esc>:GoInfo <CR>
map <C-i> <Esc>:GoImport 
map <silent> _ <Esc>:GoSameIds <CR>
map <silent> - <Esc>:GoSameIdsClear <CR>
map <silent> + <Esc>:GoDescribe <CR>
map <C-w>f <Esc>:exec printf('tabe $GOPATH/src/%s', expand("<cfile>"))<CR>

setlocal omnifunc=go#complete#Complete

""inoremap <expr> <C-n> pumvisible() ? \<C-x>\<C-o> : \<C-n>
inoremap <C-n> <C-x><C-o>

"" map <C-g>
"" map <C-a>
