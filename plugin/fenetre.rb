require 'yaml'

class Fenetre
  class << self
    def reopen_windows
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
    end

    private

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

  end
end
