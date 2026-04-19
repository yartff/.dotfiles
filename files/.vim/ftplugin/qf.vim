nnoremap <buffer> <C-w><CR>	<C-w><CR> <C-w>w :lclose <CR>:lw <CR><CR>
nnoremap <buffer> h		<CR> :call HighlightLine(2000) <CR>:lopen <CR>
nmap	 <buffer> J		jh
nmap	 <buffer> K		kh
nnoremap <buffer> <C-w><C-w>	<C-w>c

highlight FlashLine cterm=reverse ctermfg=136 gui=reverse guifg=#b58900
"" guibg=LightSkyBlue3
:sign define wholeline linehl=Visual
function! HighlightLine(duration) abort
  let l:line = line('.')
  let l:winid = win_getid()
  let l:match_id = matchaddpos('FlashLine', [[l:line]], 100)
  "" let l:match_id = matchadd('Visual', '\%' . l:line . 'l')

  " Use a timer to remove the match from the correct window
  call timer_start(a:duration, { ->
        \ execute('call win_execute(' . l:winid . ', "call matchdelete(' . l:match_id . ')")')
        \ })
endfunction

