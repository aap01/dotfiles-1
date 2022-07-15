{ config, pkgs, lib, libs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Alif Arfab Pavle";
    userEmail = "aap.pavel@gmail.com";

    # programs.git.signing.signByDefault = true;
    # signing.key = "8E9046ABA7CA018432E4A4897D614C236B9A75E6";

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
