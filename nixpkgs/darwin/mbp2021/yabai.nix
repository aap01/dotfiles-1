{ config, pkgs, lib, ... }: {
  home.file.yabai = {
    executable = true;
    target = ".config/yabai/yabairc";
    text = ''
            #!/usr/bin/env sh

      sudo yabai --load-sa
      yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"

      # global settings
      yabai -m config mouse_follows_focus          off
      yabai -m config focus_follows_mouse          off
      yabai -m config window_origin_display        default
      yabai -m config window_placement             second_child
      yabai -m config window_topmost               on
      yabai -m config window_shadow                on
      yabai -m config window_opacity               on
      yabai -m config window_opacity_duration      0.0
      yabai -m config active_window_opacity        1.0
      yabai -m config normal_window_opacity        0.4
      yabai -m config window_border                off
      yabai -m config window_border_width          6
      yabai -m config active_window_border_color   0xff775759
      yabai -m config normal_window_border_color   0xff555555
      yabai -m config insert_feedback_color        0xffd75f5f
      yabai -m config split_ratio                  0.50
      yabai -m config auto_balance                 off
      yabai -m config mouse_modifier               fn
      yabai -m config mouse_action1                move
      yabai -m config mouse_action2                resize
      yabai -m config mouse_drop_action            swap

      # general space settings
      yabai -m config layout                       bsp
      yabai -m config top_padding                  5
      yabai -m config bottom_padding               5
      yabai -m config left_padding                 5
      yabai -m config right_padding                5
      yabai -m config window_gap                   5

      # apps to not manage (ignore)
      yabai -m rule --add app="^System Preferences$" manage=off
      yabai -m rule --add app="^Archive Utility$" manage=off
      yabai -m rule --add app="^Wally$" manage=off
      yabai -m rule --add app="^Pika$" manage=off
      yabai -m rule --add app="^balenaEtcher$" manage=off
      yabai -m rule --add app="^Creative Cloud$" manage=off
      yabai -m rule --add app="^Logi Options$" manage=off
      yabai -m rule --add app="^Alfred Preferences$" manage=off

      echo "yabai configuration loaded.."
    '';
  };

  home.file.skhd = {
    executable = true;
    target = ".config/skhd/skhdrc";
    text = ''
      # TODO https://github.com/koekeishiya/yabai/issues/725

      # focus window
      alt - h : /opt/homebrew/bin/yabai -m window --focus west
      alt - j : /opt/homebrew/bin/yaba -m window --focus south
      alt - k : /opt/homebrew/bin/yabai -m window --focus north
      alt - l : /opt/homebrew/bin/yabai -m window --focus east

      # swap managed window
      shift + alt - h : /opt/homebrew/bin/yabai -m window --swap west
      shift + alt - j : /opt/homebrew/bin/yabai -m window --swap south
      shift + alt - k : /opt/homebrew/bin/yabai -m window --swap north
      shift + alt - l : /opt/homebrew/bin/yabai -m window --swap east

      # move managed window
      shift + alt + ctrl - h : /opt/homebrew/bin/yabai -m window --warp west
      shift + alt + ctrl - j : /opt/homebrew/bin/yabai -m window --warp south
      shift + alt + ctrl - k : /opt/homebrew/bin/yabai -m window --warp north
      shift + alt + ctrl - l : /opt/homebrew/bin/yabai -m window --warp east

      # rotate tree
      alt - r : /opt/homebrew/bin/yabai -m space --rotate 90

      # toggle window fullscreen zoom
      alt - f : /opt/homebrew/bin/yabai -m window --toggle zoom-fullscreen

      # toggle padding and gap
      alt - g : /opt/homebrew/bin/yabai -m space --toggle padding; /opt/homebrew/bin/yabai -m space --toggle gap

      # float / unfloat window and center on screen
      alt - t : /opt/homebrew/bin/yabai -m window --toggle float;\
                /opt/homebrew/bin/yabai -m window --grid 4:4:1:1:2:2

      # toggle window split type
      alt - e : /opt/homebrew/bin/yabai -m window --toggle split

      # balance size of windows
      shift + alt - 0 : /opt/homebrew/bin/yabai -m space --balance

      # move window and focus desktop
      shift + alt - 1 : /opt/homebrew/bin/yabai -m window --space 1; /opt/homebrew/bin/yabai -m space --focus 1
      shift + alt - 2 : /opt/homebrew/bin/yabai -m window --space 2; /opt/homebrew/bin/yabai -m space --focus 2
      shift + alt - 3 : /opt/homebrew/bin/yabai -m window --space 3; /opt/homebrew/bin/yabai -m space --focus 3
      shift + alt - 4 : /opt/homebrew/bin/yabai -m window --space 4; /opt/homebrew/bin/yabai -m space --focus 4
      shift + alt - 5 : /opt/homebrew/bin/yabai -m window --space 5; /opt/homebrew/bin/yabai -m space --focus 5
      shift + alt - 6 : /opt/homebrew/bin/yabai -m window --space 6; /opt/homebrew/bin/yabai -m space --focus 6
      shift + alt - 7 : /opt/homebrew/bin/yabai -m window --space 7; /opt/homebrew/bin/yabai -m space --focus 7
      shift + alt - 8 : /opt/homebrew/bin/yabai -m window --space 8; /opt/homebrew/bin/yabai -m space --focus 8
      shift + alt - 9 : /opt/homebrew/bin/yabai -m window --space 9; /opt/homebrew/bin/yabai -m space --focus 9


      # fast focus desktop
      alt - 0 : /opt/homebrew/bin/yabai -m space --focus recent

      # send window to monitor and follow focus
      shift + alt - n : /opt/homebrew/bin/yabai -m window --display next; /opt/homebrew/bin/yabai -m display --focus next
      shift + alt - p : /opt/homebrew/bin/yabai -m window --display previous; /opt/homebrew/bin/yabai -m display --focus previous

      # increase window size
      shift + alt - w : /opt/homebrew/bin/yabai -m window --resize top:0:-20
      shift + alt - d : /opt/homebrew/bin/yabai -m window --resize left:-20:0

      # decrease window size
      shift + alt - s : /opt/homebrew/bin/yabai -m window --resize bottom:0:-20
      shift + alt - a : /opt/homebrew/bin/yabai -m window --resize top:0:20
    '';
  };
}
