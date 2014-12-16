let s:user		= $USER
let s:email		= system('git config --get user.email')
let s:date_format	= "%a %b %d %H:%M:%S %Y"

let ft_comment_map = {
      \ "c": [0, 0], "cpp": [0, 0], "css": [0, 0], "java": [0, 0],
      \ "php": [0, system("which php") . "<?php\n"],
      \ "make": [1, 0], "text": [1, 0], "sh": [1, 1],
      \ "ruby": [1, system("which ruby")], "perl": [1, system("which perl")],
      \ "ocaml": [2, system("which ocaml")]
      \ }

let csce_comment_map = [
      \ ["/\*", "\*\*", "\*/"],
      \ ["##", "##", "##"],
      \ ["\(\*", "\*\*", "\*\)"]
      \ ]

"" echo ft_comment_map["php"][1]

