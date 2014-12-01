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
endfunction
