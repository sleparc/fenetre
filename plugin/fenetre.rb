require 'yaml'

class Fenetre
  SESSION_FILE = File.expand_path("~/.fenetre_sessions")

  class << self
    def save_session
      windows_config = []
      col_num = 0
      row_num = 0

      VIM.command("call s:GoToTopLeftWindow()")

      current_window_position = -1
      # horizontal direction

      while current_window_position != current_buffer
        column_window_positions = []

        # go down
        while current_window_position != current_buffer
          current_window_position = current_buffer
          column_window_positions << bufname(current_window_position)
          go(:down)
        end

        windows_config << column_window_positions

        go(:up)
        while current_window_position != current_buffer
          current_window_position = current_buffer
          go(:up)
        end
        go(:right)
      end

      File.open(SESSION_FILE, 'w') {|f| f.write(windows_config.to_yaml) }
    end

    def open_session
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

      positions = YAML::load(File.read(SESSION_FILE))

      open_windows(positions, @dirs[@level % 2])
    end

    private

    def open_split(window)
      VIM.command("split")
      go(:down)
      VIM.command("e " + window)
    end

    def open_v_split(window)
      VIM.command("botright vnew " + window)
    end

    def first_window(window)
      VIM.command("e " + window)
    end

    def current_buffer
      VIM.evaluate('bufnr( "%" )')
    end

    def bufname(number)
      VIM.evaluate("bufname(#{number})")
    end

    def go(direction)
      mapping = {:down => 'j', :up => 'k', :right => 'l'}
      VIM.command("wincmd " + mapping[direction])
    end

  end
end
