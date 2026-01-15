{ pkgs, ... }:
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
  zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  tmux = {
    enable = true;

    terminal = "screen-256color";
    baseIndex = 1;
    keyMode = "vi";
    prefix = "C-Space";
    mouse = true;
    historyLimit = 50000;

    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
      resurrect
      continuum
      yank
    ];

    extraConfig = ''
      set -g @continuum-restore 'on'
      set -g @resurrect-capture-pane-contents 'on'
    '';
  };
  zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initExtra = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    '';
    initExtraBeforeCompInit = builtins.readFile ./zsh/zshrc;
  };
}
