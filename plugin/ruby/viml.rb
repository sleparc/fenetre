module Viml

  def self.open_split(window)
    VIM.command("split")
    go(:down)
    VIM.command("e " + window)
  end

  def self.open_v_split(window)
    VIM.command("botright vnew " + window)
  end

  def self.first_window(window)
    VIM.command("e " + window)
  end

  def self.current_buffer
    VIM.evaluate('bufnr( "%" )')
  end

  def self.bufname(number)
    VIM.evaluate("bufname(#{number})")
  end

  def self.go(direction)
    mapping = {:down => 'j', :up => 'k', :left => 'h', :right => 'l'}
    VIM.command("wincmd " + mapping[direction])
  end

  def self.go_to_top_left
    current_window_position = -1
    while current_window_position != current_buffer
      current_window_position = current_buffer
      go(:left)
    end
  end
end
