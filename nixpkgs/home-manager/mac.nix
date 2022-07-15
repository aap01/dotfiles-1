{ config, lib, pkgs, ... }:
{
  imports = [
    ./modules/home-manager.nix
    ./modules/alacritty/alacritty.nix
    ./modules/fish.nix
    ./modules/git.nix
    ./modules/neovim.nix
    ./modules/zsh.nix
  ];
  # TODO: update with your own username and homeDirectory
  home.homeDirectory = "/Users/alif";
  home.username = "alif";

  home.stateVersion = "22.05";

  programs.fish.interactiveShellInit = ''
    set -x SSH_AUTH_SOCK "$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";

    set -x PATH $PATH "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

    # nix-darwin binaries
    set -x PATH $PATH "/run/current-system/sw/bin/"

    # `/usr/local/bin` is needed for biometric-support in `op` 1Password CLI
    set -x PATH $PATH /usr/local/bin 
  '';

  # http://czyzykowski.com/posts/gnupg-nix-osx.html
  # adds file to `~/.nix-profile/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac`
  home.packages = with pkgs; [
    pinentry_mac

    nodejs

    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/data/fonts/nerdfonts/default.nix
    nerdfonts
  ];

  # TODO
  # https://aregsar.com/blog/2020/turn-on-key-repeat-for-macos-text-editors/
  # automate `defaults write com.google.chrome ApplePressAndHoldEnabled -bool false`


  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "1password-cli"
  ];
  home.sessionPath = [
    "$HOME/go/bin"
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    "$HOME/.krew/bin"
  ];
  home.sessionVariables = {
    # GO111MODULE = "on";
    EDITOR = "lvim";
    VISUAL = "nvim";
  };
  programs.zsh = {
    initExtraBeforeCompInit = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
      eval "$(starship init zsh)"
      # eval "$(which $SHELL)"
    '';
  };
}
