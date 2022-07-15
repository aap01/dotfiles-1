{ config, pkgs, lib, libs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Alif Arfab Pavle";
    userEmail = "aap.pavel@gmail.com";

    signing = {
      signByDefault = true;
      key = "5426B20B4D142339";
    };
    # delta = {
    #   enable = true;
    #   options = {
    #     syntax-theme = "solarized-dark";
    #     side-by-side = true;
    #   };
    # };

    extraConfig = {
      pull.rebase = true;
      init.defaultBranch = "main";
      github.user = "alif";

      push.autoSetupRemote = true;

      core.editor = "nvim";
      core.fileMode = false;
      core.ignorecase = false;
    };
    ignores = [
      ".dir-locals.el"
      ".envrc"
      ".DS_Store"
    ];
  };
}
