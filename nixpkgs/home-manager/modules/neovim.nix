{ config, lib, pkgs, ... }:
{
  programs.neovim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      # UI
      lightline-vim
      tmuxline-vim
      gruvbox
      which-key-nvim
      # Tools
      nerdtree
      nerdcommenter
      telescope-nvim # https://github.com/nvim-telescope/telescope.nvim

      # Languages
      vim-nix
      vim-markdown
      vim-javascript
      typescript-vim
      rust-vim
    ] ++ lib.optionals (pkgs.stdenv.system != "aarch64-linux") [
      vim-go
    ];

    extraConfig = (builtins.concatStringsSep "\n" [
      (builtins.readFile ./vim/config.vim)
      (builtins.readFile ./vim/mappings.vim)
      (builtins.readFile ./vim/plugin.go.vim)
      (builtins.readFile ./vim/plugin.nerdtree.vim)
      (builtins.readFile ./vim/plugin.tmuxline.vim)
      (builtins.readFile ./vim/plugin.telescope.vim)
    ]);
  };
}
