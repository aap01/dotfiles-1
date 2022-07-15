{ config, pkgs, lib, ... }: {
  homebrew = {
    enable = true;
    autoUpdate = true;
    # "zap" removes manually installed brews and casks
    # cleanup = "zap"; 
    brews = [
      # "helm"
      # generating k8s controller
      # "kubebuilder"
      # docker alternative
      # "lima" 
      # macos bar alternative
      "spacebar"
      # keybinding manager
      "skhd"
      # "openstackclient"
      # broken nix builds
      # tiling window manager
      "yabai"
    ];
    casks = [
      # utilities
      # battery management
      # "aldente"
      # hides mac bar icons
      # "bartender"
      # choose browser on each link
      # "browserosaurus"
      # remap keyboard
      # "karabiner-elements"
      # file system utilities
      # "macfuse"

      # virtualization
      # docker desktop
      # "docker"
      # virtual machines
      # "utm"

      # communication
      # "microsoft-teams"
      # one click mute button
      # "mutify"
      # "zoom"
      # "slack"
      # teamspeak alternative
      # "mumble"
      # micro noise reduction
      # "krisp"
      # messenger
      # "signal"

      # "adobe-creative-cloud"
      # "android-studio"
      # "balenaetcher"
      # "blender"
      # ebook management
      # "calibre" 
      # "chromium"
      # "firefox"
      # "google-chrome"
      # "google-drive"
      # visual k9s
      # "lens"
      # folder differ
      # "meld"
      # dj software
      # "mixxx" 
      # stream / recoding software
      # "obs" 
      # "postman"
      # "bloomrpc"
      # "protonmail-bridge"
      # "raspberry-pi-imager"
      # screenshot tool
      # "shottr"
      # "the-unarchiver"
      # vpn client
      # "tunnelblick"
      "ubersicht"
      # "unity-hub"
      # "visual-studio-code"
      # unbranded vscode
      # "vscodium" 
      # media player
      # "vlc"
      # mac monitoring
      # "eul"
      # flashing keyboard
      # "qmk-toolbox"
      # vim keys for everything
      "kindavim"
    ];
    taps = [
      # spacebar
      "cmacrae/formulae"
      # yabai
      "koekeishiya/formulae"
      # default
      "homebrew/bundle"
      "homebrew/cask"
      "homebrew/cask-drivers"
      "homebrew/core"
      "homebrew/services"
      # spacebar
      "cmacrae/formulae"
      # yabai
      "koekeishiya/formulae"
      # default
      "homebrew/bundle"
      "homebrew/cask"
      "homebrew/cask-drivers"
      "homebrew/core"
      "homebrew/services"
      "homebrew/services"
    ];
  };
}
