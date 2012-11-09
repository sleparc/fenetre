" ============================================================================
" File:        fenetre.vim
" Description: This pluggin remember and can re-open your splits/windows
" Maintainer:  Simon Le Parc <lpl.simon at gmail dot com>
" Last Change: 08 November, 2012
" License:     MIT (see LICENCE file)
"
" ============================================================================


function! ListVisibleBuff()
  " figure out which buffers are visible in any tab
  let visible_buffer_number = []
  let visible_filename = []
  for t in range(1, tabpagenr('$'))
    for b in tabpagebuflist(t)
      call add(visible_filename, bufname(b))
      call add(visible_buffer_number, b)
    endfor
  endfor

  echo s:BEGetBufferInfo(visible_buffer_number[0])
endfun


function! FenetrePositions()
  let s:initialWindowPosition = bufnr( "%" )
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

  echo s:WindowPositions

ruby << EOF
  require 'yaml'
  File.open(File.expand_path("~/.abc"), 'w') {|f| f.write(VIM::evaluate("s:WindowPositions").to_yaml) }
EOF
  " call s:WritePositionsIntoFile(s:WindowPositions)
  "
endfunction

function! s:GoToTopLeftWindow()
  let s:currentWindowPosition = -1

  while s:currentWindowPosition != bufnr( "%" )
    let s:currentWindowPosition = bufnr( "%" )
    wincmd h
  endwhile
endfunction

function! s:WritePositionsIntoFile(positions)
  call ':echo positions' > ~/.fenetre_positions'
  " let l = readfile( '~/.fenetre_positions', '', 1 )
endfunction

function! ReadFenetrePos()
ruby << EOF
  require 'yaml'

  def open_split(window)
    VIM.command("split")
    VIM.command("wincmd j")
    VIM.command("e " + window)
  end

  def open_v_split(window)
    VIM.command("botright vnew " + window)
  end

  def first_window(window)
    VIM.command("e " + window)
  end

  @first_window = true
  @level = -1
  @dirs = ["open_split", "open_v_split"]

  def open_windows(windows, direction_action)
    first_one = true
    windows.each do |window|
      if window.is_a?(Array)
        @level += 1
        open_windows(window, @dirs[@level % 2])
      else
        action = @first_window ? "first_window" : (first_one ? @dirs[(@level+1) % 2] : direction_action)
        action = direction_action if (@level == -1)
        first_one = false
        @first_window = false
        send(action, window)
      end
    end

    @level -= 1
  end


  positions = YAML::load(File.read(File.expand_path("~/.abc")))
  # positions = ["bundle/fenetre/test/a.txt", ["bundle/fenetre/test/b.txt", "bundle/fenetre/test/c.txt"]]

  open_windows(positions, @dirs[@level % 2])
EOF

endfunction
