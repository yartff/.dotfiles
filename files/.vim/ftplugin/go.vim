setlocal omnifunc=go#complete#Complete

set tabstop=2

let g:go_highlight_space_tab_error = 0
let g:go_highlight_array_whitespace_error = 0
let g:go_highlight_trailing_whitespace_error = 0

map <silent> <F9> <Esc>:GoDecls <CR>
map <silent> <F12> <Esc>:GoDeclsDir <CR>
map <silent> <C-l> <Esc>:GoDef <CR>
map <silent> <C-h> <Esc>:GoDefPop <CR>

map <silent> <C-r> <Esc>:GoInfo <CR>
map <C-w><C-i> <Esc>:GoImport 
map <silent> _ <Esc>:GoSameIds <CR>
map <silent> - <Esc>:GoSameIdsClear <CR>
map <silent> + <Esc>:GoDescribe <CR>
map <C-w>f <Esc>:exec printf('tabe $GOPATH/src/%s', expand("<cfile>"))<CR>

function! GoCompletionKey()
	return "\<C-x>\<C-o>"
endfunction
function! GoCompletionNext()
	return "\<C-n>"
endfunction
inoremap <expr> <C-n> pumvisible() ? GoCompletionNext() : GoCompletionKey()

function! GoCompletionStd()
	return "\<C-p>\<C-n>"
endfunction
function! GoCompletionPrev()
	return "\<C-p>"
endfunction
inoremap <expr> <C-p> pumvisible() ? GoCompletionPrev() : GoCompletionStd()

"" map <C-g>
"" map <C-a>
