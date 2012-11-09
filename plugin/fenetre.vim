" ============================================================================
" File:        fenetre.vim
" Description: This pluggin remember and can re-open your splits/windows
" Maintainer:  Simon Le Parc <lpl.simon at gmail dot com>
" Last Change: 08 November, 2012
" License:     MIT (see LICENCE file)
"
" ============================================================================

ruby << EOF
  file = File.join(ENV['HOME'], '.vim', 'bundle', 'fenetre', 'plugin', 'fenetre')
  require file
EOF

autocmd InsertEnter,VimLeavePre * call FenetreSaveSession()

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


