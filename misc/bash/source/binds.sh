## CUSTOM

## NAV
# - | '"\e[D": backward-char'		## Left (CSI) <-
# - | '"\C-b": backward-char'		## Ctrl b
# - | '"\e[C": forward-char'		## Right (CSI) <-
# - | '"\C-f": forward-char'		## Ctrl f

# - | '"\e[1;5D": backward-word'	## Ctrl Left <-
# - | '"\e[1;3D": backward-word'	## Alt  Left <-
# - | '\ed' ## : backward-word		## Alt  d

# - | "\e[1;5C": forward-word		## Ctrl Right <-
# - | "\e[1;3C": forward-word		## Alt  Right <-
# - | "\ef": forward-word		## Alt  f

# - | "\C-a": beginning-of-line
# - | "\e[H": beginning-of-line		## Home (CSI) <-
# - | "\C-e": end-of-line		## Ctrl e
# - | "\e[F": end-of-line		## Home (CSI) <-

## == DELETE
# - | "\C-d": delete-char
# - | "\e[3~": delete-char		## Del
# - | "\C-h": backward-delete-char	## Backspace
# bind -r '\C-?'	## : backward-delete-char

# ! | "\ed": kill-word			## Alt d
# ! | "\e[3;5~": kill-word		## Ctrl Del
# - | "\e\C-d": shell-kill-word		## Ctrl Alt d

# - | "\e\C-?":	backward-kill-word	## (Ctrl) Alt Backspace
# - | "\e\C-h": backward-kill-word	## Ctrl Alt h
# - | "\C-w": unix-word-rubout		## Ctrl w

# - | "\C-k": kill-line
# bind    '"": backward-kill-line'
# TODO: backward kill line

## ==
# ! | "\C-_": undo
# ? | "\C-g": abort

## == HISTORY
# - | "\C-p": previous-history
# - | "\e[A": previous-history		## Up (CSI)
# - | "\C-n": next-history
# - | "\eOB": next-history		## Down (CSI)
# - | "\C-r": reverse-search-history
# - | "\e[5~": history-search-backward	## Page Up (CSI)
# - | "\e[6~": history-search-forward	## Page Down (CSI)

# == COMPLETION
# - | "\C-i": complete			## Tab || Ctrl i
# - | "\e(": complete-into-braces
# - | "\e$": complete-variable
# ! | "\e=": possible-completions
# - | "\e*": insert-completions

## == INSERT
# - | "\C-y": yank
# - | "\e#": insert-comment

## == SWAP
# - | "\C-t": transpose-chars
# - | "\et": transpose-words
# - | "\e\C-t": shell-transpose-words

## == DISPLAY
# ! | "\e\C-l": clear-display
# - | "\C-l": clear-screen

## == CAP
# - | "\eu": upcase-word
# - | "\el": downcase-word
# - | "\ec": capitalize-word

## == EXEC
# - | "\C-j": accept-line
# - | "\C-m": accept-line
# ! | "\C-x\C-e": edit-and-execute-command
bind '"\C-x\C-a": edit-and-execute-command'
# ! | "\C-o": operate-and-get-next
# - | '"\C-u": unix-line-discard'

## XXX #####

# - | '"\eOD": backward-char'		## Left (SS3)
# - | '"\eOC": forward-char'		## Right (SS3)
# - | "\e[5C": forward-word		## Ctrl Right
# - | "\e\e[C": forward-word		## Alt  Right
# - | '"\e[5D": backward-word'		## Ctrl Left
# - | '"\e\e[D": backward-word'		## Alt  Left

# - | "\eOH": beginning-of-line		## Home (SS3)
# - | "\e[1~": beginning-of-line	## Home (function key format)
# - | "\eOF": end-of-line		## Home (SS3)
# - | "\e[4~": end-of-line		## Home (function key format)

# - | "\eOA": previous-history		## Up (SS3)
# - | "\e[B": next-history		## Down (SS3)

bind -r '\C-]'		## : character-search
bind -r '\e\C-]'	## : character-search-backward
bind -r '\C-x\C-x'	## : exchange-point-and-mark
bind -r '\C-@'		## : set-mark
bind -r '\e '		## : set-mark

bind -r '\e<'		## : beginning-of-history
bind -r '\e>'		## : end-of-history
# X | bind '"": forward-search-history'

bind -r '\e\C-i'	## : dynamic-complete-history
bind -r '\e^'		## : history-expand-line
bind -r '\en'		## : non-incremental-forward-search-history
bind -r '\ep'		## : non-incremental-reverse-search-history

## == COMPLETE
bind -r '\e!'		## : complete-command
bind -r '\e/'		## : complete-filename
bind -r '\e@'		## : complete-hostname
bind -r '\e{'		## : complete-into-braces
bind -r '\e~'		## : complete-username
bind -r '\C-x!'		## : possible-command-completions
bind -r '\e?'		## : possible-completions
bind -r '\C-x/'		## : possible-filename-completions
bind -r '\C-x@'		## : possible-hostname-completions
bind -r '\C-x~'		## : possible-username-completions
bind -r '\C-x$'		## : possible-variable-completions
bind -r '\eg'		## : glob-complete-word
bind -r '\C-xs'		## : spell-correct-word

bind -r '\e.'		## : insert-last-argument
bind -r '\e_'		## : insert-last-argument
bind -r '\C-q'		## : quoted-insert
bind -r '\C-v'		## : quoted-insert
bind -r '\e[2~'		## : quoted-insert
bind -r '\e\C-e'	## : shell-expand-line
bind -r '\e&'		## : tilde-expand

## == GLOB
bind -r '\C-x*'		## : glob-expand-word
bind -r '\C-xg'		## : glob-list-expansions

bind -r '\e\\'		## : delete-horizontal-space
bind -r '\C-x\C-?'	## : backward-kill-line	## TODO rebind

## == YANK
bind -r '\e.'		## : yank-last-arg
bind -r '\e_'		## : yank-last-arg
bind -r '\e\C-y'	## : yank-nth-arg
bind -r '\ey'		## : yank-pop

## == UNDO
bind -r '\C-x\C-u'	## : undo
bind -r '\e\C-r'	## : revert-line
bind -r '\er'		## : revert-line
bind -r '\C-x\C-g'	## : abort
bind -r '\e\C-g'	## : abort

## == REPEAT ACTIONS
bind -r '\e-'		## : digit-argument
bind -r '\e0'		## : digit-argument
bind -r '\e1'		## : digit-argument
bind -r '\e2'		## : digit-argument
bind -r '\e3'		## : digit-argument
bind -r '\e4'		## : digit-argument
bind -r '\e5'		## : digit-argument
bind -r '\e6'		## : digit-argument
bind -r '\e7'		## : digit-argument
bind -r '\e8'		## : digit-argument
bind -r '\e9'		## : digit-argument

## == MACRO
bind -r '\C-xe'		## : call-last-kbd-macro
bind -r '\C-x)'		## : end-kbd-macro
bind -r '\C-x('		## : start-kbd-macro

## == MISC
bind -r '\C-x\C-v'	## : display-shell-version
bind -r '\C-x\C-r'	## : re-read-init-file
## bind -r '\e[200~'	## : bracketed-paste-begin ## bugs WSL paste

## == BIN/UNREMOVABLE
# X | "\e\e\000": complete

##   | # alias-expand-line (not bound)
##   | # arrow-key-prefix (not bound)
##   | # backward-byte (not bound)
##   | # copy-backward-word (not bound)
##   | # copy-forward-word (not bound)
##   | # copy-region-as-kill (not bound)
##   | # dabbrev-expand (not bound)
##   | # delete-char-or-list (not bound)
##   | # dump-functions (not bound)
##   | # dump-macros (not bound)
##   | # dump-variables (not bound)
##   | # emacs-editing-mode (not bound)
##   | # fetch-history (not bound)
##   | # forward-backward-delete-char (not bound)
##   | # forward-byte (not bound)
##   | # history-and-alias-expand-line (not bound)
##   | # history-substring-search-backward (not bound)
##   | # history-substring-search-forward (not bound)
##   | # kill-region (not bound)
##   | # kill-whole-line (not bound)
##   | # magic-space (not bound)
##   | # menu-complete (not bound)
##   | # menu-complete-backward (not bound)
##   | # next-screen-line (not bound)
##   | # non-incremental-forward-search-history-again (not bound)
##   | # non-incremental-reverse-search-history-again (not bound)
##   | # old-menu-complete (not bound)
##   | # overwrite-mode (not bound)
##   | # previous-screen-line (not bound)
##   | # print-last-kbd-macro (not bound)
##   | # redraw-current-line (not bound)
##   | # shell-backward-kill-word (not bound)
##   | # skip-csi-sequence (not bound)
##   | # tab-insert (not bound)
##   | # tty-status (not bound)
##   | # universal-argument (not bound)
##   | # unix-filename-rubout (not bound)
##   | # vi-append-eol (not bound)
##   | # vi-append-mode (not bound)
##   | # vi-arg-digit (not bound)
##   | # vi-back-to-indent (not bound)
##   | # vi-backward-bigword (not bound)
##   | # vi-backward-word (not bound)
##   | # vi-bword (not bound)
##   | # vi-bWord (not bound)
##   | # vi-change-case (not bound)
##   | # vi-change-char (not bound)
##   | # vi-change-to (not bound)
##   | # vi-char-search (not bound)
##   | # vi-column (not bound)
##   | # vi-complete (not bound)
##   | # vi-delete (not bound)
##   | # vi-delete-to (not bound)
##   | # vi-edit-and-execute-command (not bound)
##   | # vi-editing-mode (not bound)
##   | # vi-end-bigword (not bound)
##   | # vi-end-word (not bound)
##   | # vi-eof-maybe (not bound)
##   | # vi-eword (not bound)
##   | # vi-eWord (not bound)
##   | # vi-fetch-history (not bound)
##   | # vi-first-print (not bound)
##   | # vi-forward-bigword (not bound)
##   | # vi-forward-word (not bound)
##   | # vi-fword (not bound)
##   | # vi-fWord (not bound)
##   | # vi-goto-mark (not bound)
##   | # vi-insert-beg (not bound)
##   | # vi-insertion-mode (not bound)
##   | # vi-match (not bound)
##   | # vi-movement-mode (not bound)
##   | # vi-next-word (not bound)
##   | # vi-overstrike (not bound)
##   | # vi-overstrike-delete (not bound)
##   | # vi-prev-word (not bound)
##   | # vi-put (not bound)
##   | # vi-redo (not bound)
##   | # vi-replace (not bound)
##   | # vi-rubout (not bound)
##   | # vi-search (not bound)
##   | # vi-search-again (not bound)
##   | # vi-set-mark (not bound)
##   | # vi-subst (not bound)
##   | # vi-tilde-expand (not bound)
##   | # vi-undo (not bound)
##   | # vi-unix-word-rubout (not bound)
##   | # vi-yank-arg (not bound)
##   | # vi-yank-pop (not bound)
##   | # vi-yank-to (not bound)
