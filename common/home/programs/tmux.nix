{ pkgs }:
{
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
}
