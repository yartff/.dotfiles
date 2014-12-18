"""
""  File: [rmts.vim]
""  Author: yartFF.
""  Contact: <carbonel.q@gmail.com> (github.com/yartFF)
""  Created on 2014-12-18 19:20
""  
"" 

"" Removes
"autocmd BufWritePre * :call Plg_rmts_RemoveST()
"
function! Plg_rmts_RemoveST()
  let pos = line(".")
  let ext = expand("%:e")
  if (ext != "md")
    execute "0,$s/[ \t]*$//"
  endif
  execute pos
  unlet pos
endfunction
