{ pkgs, lib, ... }:
{
  home-manager.enable = true;
  direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ./zsh;
        file = "p10k.zsh";
      }
    ];
    initContent = lib.mkOrder 550 "export GPG_TTY=$TTY";
  };
}
