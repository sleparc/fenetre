" ============================================================================
" File:        fenetre.vim
" Description: This pluggin remembers the way you split your windows
"              and can reopen them.
" Maintainer:  Simon Le Parc <lpl.simon at gmail dot com>
" Last Change: 09 November, 2012
" License:     MIT (see LICENCE file)
"
" ============================================================================


" ----- Autocommands -----
augroup Fenetre
  autocmd!
  au VimLeavePre * call FenetreSaveSession()
augroup END


" ----- Commands -----
command! FenetreSaveSession :call FenetreSaveSession()
command! FenetreOpenSession :call FenetreOpenSession()


" ----- Public Functions -----
ruby << EOF
  file = File.join(ENV['HOME'], '.vim', 'bundle', 'fenetre', 'plugin', 'ruby', 'fenetre')
  require file
  file = File.join(ENV['HOME'], '.vim', 'bundle', 'fenetre', 'plugin', 'ruby', 'viml')
  require file
EOF

function! FenetreSaveSession()
ruby << EOF
  Fenetre.save_session
EOF
endfunction

function! FenetreOpenSession()
ruby << EOF
  Fenetre.open_session
EOF
endfunction
