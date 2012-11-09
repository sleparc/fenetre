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


function! FenetrePositions()
  let s:WindowPositions = []
  let s:colNum = 0
  let s:rowNum = 0

  call s:GoToTopLeftWindow()
  let s:currentWindowPosition = -1


  " horizontal direction
  while s:currentWindowPosition != bufnr( "%" )
    let s:ColumnWindowPositions = []

    " go down
    while s:currentWindowPosition != bufnr( "%" )
      let s:currentWindowPosition = bufnr( "%" )
      call add(s:ColumnWindowPositions, bufname(s:currentWindowPosition))
      wincmd j
    endwhile

    call add(s:WindowPositions, s:ColumnWindowPositions)

    "go back up
    wincmd k
    while s:currentWindowPosition != bufnr( "%" )
      let s:currentWindowPosition = bufnr( "%" )
      wincmd k
    endwhile
    " go right
    wincmd l
  endwhile

  call s:SavePositionsToFile(WindowPositions)
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

function! ReadFenetrePos()
ruby << EOF
  Fenetre.reopen_windows
EOF
endfunction


