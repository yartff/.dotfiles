"""
""  File: [header.vim]
""  Author: yartFF.
""  Contact: <carbonel.q@gmail.com> (github.com/yartFF)
""  Created on 2014-12-18 19:19
""  
"" 

function Plg_header_create()
  if &ft == ""
    return
  endif

  let s:pos = line(".")
  " Content Lines
  let s:l_file = "File: [" . expand("%:t") . "]"
  let s:l_user = "Author: " . $USER . "."
  let s:l_email = "Contact: <" .
	\ substitute(system("git config --get user.email"), "\n", "", "") .
	\ ">"
  let s:l_github_link = "(github.com/" .
	\ substitute(system("git config --get user.name"), "\n", "", "") .
	\ ")"
  let s:l_date = "Created on " . strftime("%Y-%m-%d %H:%M")

  " Associative maps
  let ft_comment_map = {
	\ "c": [0, 0],
	\ "cpp": [0, 0],
	\ "css": [0, 0],
	\ "java": [0, 0],
	\ "php": [0, system("which php") . "<?php\n"],
	\ "make": [1, 0],
	\ "text": [1, 0],
	\ "sh": [1, "/bin/bash\n"],
	\ "ruby": [1, system("which ruby")],
 	\ "perl": [1, system("which perl")],
	\ "ocaml": [2, system("which ocaml")],
	\ "python": [1, system("which python")],
  	\ "vim": [3, 0],
	\ }
  let csce_comment_map = [
	\ ["/\*", "\*\*", "\*/"],
	\ ["##", "\##", "\##"],
	\ ["\(\*", "\*\*", "\*\)"],
	\ ["\"\"\"", "\"\" ", "\"\" "],
	\ ]

  " Saving settings
  let s_fmt = &fo
  let s_autoin = &autoindent
  let s_smartin = &smartindent
  let s_cin = &cindent

  setl noautoindent nosmartindent nocindent
  setl fo-=c fo-=r fo-=o

  execute "normal! gg"
  if ft_comment_map[&ft][1] != "0"
    execute "normal! O#!" . ft_comment_map[&ft][1]
  endif
  execute "normal! i" . csce_comment_map[ft_comment_map[&ft][0]][0] . "\n" .
	\ csce_comment_map[ft_comment_map[&ft][0]][1] . " " .
	\ s:l_file . "\n" .
	\ csce_comment_map[ft_comment_map[&ft][0]][1] . " " .
	\ s:l_user . "\n" .
	\ csce_comment_map[ft_comment_map[&ft][0]][1] . " " .
	\ s:l_email . " " . s:l_github_link . "\n" .
	\ csce_comment_map[ft_comment_map[&ft][0]][1] . " " .
	\ s:l_date . "\n" .
	\ csce_comment_map[ft_comment_map[&ft][0]][1] . " " . "\n" .
	\ csce_comment_map[ft_comment_map[&ft][0]][2] . "\n"

  execute s:pos + 9
  unlet s:pos
  " Restituting settings
  let &fo=s_fmt
  unlet s_fmt
  let &autoindent=s_autoin
  unlet s_autoin
  let &smartindent=s_smartin
  unlet s_smartin
  let &cindent=s_cin
  unlet s_cin

  " Cleaning Content Lines
  unlet s:l_file
  unlet s:l_user
  unlet s:l_email
  unlet s:l_github_link
  unlet s:l_date
  unlet ft_comment_map
  unlet csce_comment_map
endfunction
command Head call Plg_header_create()
