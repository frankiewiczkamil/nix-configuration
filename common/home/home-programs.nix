{ pkgs, ... }:
let
  tmux-config = import ./programs/tmux.nix { inherit pkgs; };
in
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
  tmux = tmux-config;
  starship = {
    enable = true;
  };
  zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = builtins.readFile ./zsh/zshrc;
  };
}
