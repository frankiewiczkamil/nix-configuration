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

  nixvim = {
    enable = true;

    colorschemes.catppuccin.enable = true;
    plugins = {
      lualine.enable = true;
      telescope.enable = true;
      web-devicons.enable = true;
      lsp.enable = true;
      cmp.enable = true;
    };
    globals = {
      mapleader = " ";
      direnv_auto = 1;
      direnv_silent_load = 0;
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>w";
        action = ":w<CR>";
      }
    ];
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
      catppuccin
    ];

    extraConfig = ''
      set -g status-position 'top'
      set -g status-right-length 100
      set -g status-left-length 100
      set -g status-left ""
      set -g status-right "#{E:@catppuccin_status_application}"
      set -ag status-right "#{E:@catppuccin_status_session}"

      set -g @continuum-restore 'on'
      set -g @resurrect-capture-pane-contents 'on'
    '';
  };
  starship = {
    enable = true;
  };
  zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initExtra = builtins.readFile ./zsh/vi-mode.zsh + ''
      bindkey -v
      export KEYTIMEOUT=1
    '';

    initExtraBeforeCompInit = builtins.readFile ./zsh/zshrc;
  };
}
