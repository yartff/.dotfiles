setlocal omnifunc=go#complete#Complete

set tabstop=2
set completeopt-=preview

let g:go_highlight_space_tab_error = 0
let g:go_highlight_array_whitespace_error = 0
let g:go_highlight_trailing_whitespace_error = 0
let g:go_doc_max_height = 20

"" Useful cmds:
" :GoAddTags
" :GoFillStruct

" <C-_>
" <C-s>
"
" gj gk
" gl
" gh gH g<C-h>
" gv gV

""""""""""""""""""""""""""""""""""""""""

nnoremap <buffer> <silent> <C-n>	:GoDef <CR>
nnoremap <buffer> <silent> <C-w><C-n>	:call Go_DefinitionWindow("vsplit") <CR>
nnoremap <buffer> <silent> <C-w>n	:call Go_DefinitionWindow("split") <CR>
nnoremap <buffer> <silent> <C-w>N	:call go#def#Jump("tab", 0)<CR>
" gD :GoDefType = gD
nnoremap <buffer> <silent> g<C-d>	:call go#def#Jump("split", 1) <CR>
nnoremap <buffer> <silent> gd		:GoInfo <CR>

nnoremap <buffer> <silent> <C-m>	:GoCallers <CR>
nnoremap <buffer> <silent> g<C-m>	:GoReferrers <CR>
nnoremap <buffer> <silent> <C-g>	:GoImplements <CR>

" K :GoDoc = K

nnoremap <buffer> <silent> -		:GoDecls <CR>
nnoremap <buffer> <silent> _		:GoDeclsDir <CR>

nnoremap <buffer> <silent> &		:GoSameIds <CR>
nnoremap <buffer> <silent> g&		:GoSameIdsClear <CR>

"" Jump
function! SwitchWindow()
  execute "normal! \<C-w>x"
endfunction

function! Go_DefinitionWindow(mode)
  if a:mode == "split"
    split
  elseif a:mode == "vsplit"
    vsplit
  endif
  execute "normal! \<C-w>w"
  :GoDef
endfunction

"" Autocomplete
function! GoCompletionKey()
  return "\<C-x>\<C-o>"
endfunction
function! GoCompletionNext()
  return "\<C-n>"
endfunction
inoremap <buffer> <expr> <C-n> pumvisible() ? GoCompletionNext() : GoCompletionKey()

"""""" left to sort
"" map <buffer> <C-w>f <Esc>:exec printf('tabe $GOPATH/src/%s', expand("<cfile>"))<CR>

""""""
"" rebind breaking binds
"" nnoremap <buffer> <silent> U <Esc>:redo <CR>
