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

autocmd BufAdd,BufCreate,BufDelete,BufWipeout,BufNew,BufHidden,BufUnload,VimLeavePre * call FenetreSaveSession()

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

function! s:SavePositionsToFile(WindowPositions)
ruby << EOF
  require 'yaml'
  File.open(File.expand_path("~/.abc"), 'w') {|f| f.write(VIM::evaluate("a:WindowPositions").to_yaml) }
EOF
endfunction

function! s:GoToTopLeftWindow()
  let s:currentWindowPosition = -1

  while s:currentWindowPosition != bufnr( "%" )
    let s:currentWindowPosition = bufnr( "%" )
    wincmd h
  endwhile
endfunction
