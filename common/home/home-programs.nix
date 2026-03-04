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

  nixvim = import ./programs/nixvim.nix;
  zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  tmux = tmux-config;
  starship = {
    enable = true;
  };
  zsh = import ./programs/zsh.nix;
}
