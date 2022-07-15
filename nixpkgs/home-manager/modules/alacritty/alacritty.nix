{ config, pkgs, lib, ... }: {
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      window = {
        opacity = 0.95;
        dynamic_title = true;
        dynamic_padding = true;
        decorations = "none";
        dimensions = { lines = 0; columns = 0; };
        padding = { x = 15; y = 15; };
        startup_mode = "Windowed";
      };

      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      mouse = { hide_when_typing = true; };

      key_bindings = [
        {
          # clear terminal
          key = "L";
          mods = "Control";
          chars = "\\x0c";
        }
      ];

      font = let fontname = "Liga SFMono Nerd Font"; in
      # font = let fontname = "Hack Nerd Font"; in
        # font = let fontname = "Hack"; in
        {
          #font = let fontname = "Recursive Mono Linear"; in { # TODO fix this font with nerd font
          normal = { family = fontname; style = "Light"; };
          bold = { family = fontname; style = "Normal"; };
          italic = { family = fontname; style = "Light"; };
          size = 16;
          use_thin_strokes = true;
        };
      cursor.style = "Block";

      colors = {
        primary = {
          background = "0x282c34";
          foreground = "0xabb2bf";
        };
        cursor = {
          text = "CellBackground";
          cursor = "0x528bff"; # syntax-cursor-color };
          selection = {
            text = "CellForeground";
            background = "0x3e4451"; # syntax-selection-color };
            normal = {
              black = "0x5c6370"; # mono-3
              red = "0xe06c75"; # red 1
              green = "0x98c379";
              yellow = "0xe5c07b"; # orange 2
              blue = "0x61afef";
              magenta = "0xc678dd";
              cyan = "0x56b6c2";
              white = "0x828997"; # mono-2
            };
          };
        };
      };
      selection = {
        # This string contains all characters that are used as separators for
        # "semantic words" in Alacritty.
        semantic_escape_chars = ",│`| = \"' ()[]{}<>\t";

        # When true, selected text will be copied to the primary clipboard
        save_to_clipboard = true;
      };
    };
  };
}
