require 'yaml'

class Fenetre
  SESSION_FILE = File.expand_path("~/.fenetre_sessions")

  class << self

    # save_session
    #
    # This method starts from the window at the top most left of the screen
    # and then, while going to the right, scans the position of each window
    # going down. When at the bottom (can't move down anymore), it goes back
    # up and move to the right and repeat until it gets to the far most right
    # (can't move right anymore).
    # At every step, the filename opened in the window is saved in an array
    # which is eventually saved into a file at the end.
    #

    def save_session
      Viml.go_to_top_left

      windows_config = []
      col_num = 0
      row_num = 0

      current_window_position = -1

      # move to the right until the end
      while current_window_position != Viml.current_buffer
        column_window_positions = []

        # move all the way down and add windows to array as we go
        while current_window_position != Viml.current_buffer
          current_window_position = Viml.current_buffer
          column_window_positions << Viml.bufname(current_window_position)
          Viml.go(:down)
        end

        windows_config << column_window_positions

        # move cursor all the way up
        Viml.go(:up)
        while current_window_position != Viml.current_buffer
          current_window_position = Viml.current_buffer
          Viml.go(:up)
        end

        # move on to the next column to the right
        Viml.go(:right)
      end

      File.open(SESSION_FILE, 'w') do |f|
        f.write(windows_config.to_yaml)
      end
    end


    # open_session
    #
    # This method gets the window positions save in the file and reopens them
    # based on the array structure.
    #
    # The algorithm uses recursion to reopen each window based on the saved array.
    #
    # See example:
    # 
    #                              -------------------------
    #                              |       |       |       |
    #                              |       |   3   |       |
    #                              |   1   |       |   6   |
    #                              |       |-------|       |
    #                              |       |       |       |
    # [[1,2],[3,4,5],[6,7]] to =>  |-------|   4   |-------|
    #                              |       |       |       |
    #                              |   2   |-------|       |
    #                              |       |       |   7   |
    #                              |       |   5   |       |
    #                              |       |       |       |
    #                              -------------------------
    #

    def open_session
      positions = YAML::load(File.read(SESSION_FILE))

      @first_window = true
      @level = -1
      @dirs = ["open_split", "open_v_split"]

      open_windows(positions, @dirs[@level % 2])
    end


    private

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
          Viml.send(action, window)
        end
      end

      @level -= 1
    end

  end
end
