map <F9> <Esc>:GoDecls <CR>
map <F12> <Esc>:GoDeclsDir <CR>
map <C-l> <Esc>:GoDef <CR>
map <C-h> <Esc>:GoDefPop <CR>

map <C-r> <Esc>:GoInfo <CR>
map <C-i> <Esc>:GoImport 
map _ <Esc>:GoSameIds <CR>
map - <Esc>:GoSameIdsClear <CR>
map + <Esc>:GoDescribe <CR>
map <C-w>f <Esc>:exec printf('tabe $GOPATH/src/%s', expand("<cfile>"))<CR>

"" map <C-g>
"" map <C-a>
