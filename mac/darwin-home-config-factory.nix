{
  git-config,
  state-version,
  catppuccinHomeModule,
}:
{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:
let
  home-programs = import ../common/home/home-programs.nix {
    inherit pkgs pkgs-unstable;
  };
in
{
  imports = [ catppuccinHomeModule ];
  home = {
    packages = import ../common/home/home-packages.nix { inherit pkgs pkgs-unstable; } ++ [
      pkgs.pinentry_mac
    ];
    file = {
      ".gnupg/gpg-agent.conf".text = ''
        default-cache-ttl 86400 # 1 day
        default-cache-ttl-ssh 86400
        max-cache-ttl 604800 # 1 week
        max-cache-ttl-ssh 604800
        pinentry-program ${pkgs.pinentry_mac}/bin/pinentry-mac
      '';
      ".p10k.zsh".text = builtins.readFile ../common/home/zsh/p10k.zsh;
    };
    sessionVariables = {
      EDITOR = "vim";
    };
    stateVersion = state-version;
  };

  catppuccin = {
    tmux = {

      enable = true;
      extraConfig = ''
        set -g @catppuccin_status_modules_right "user directory host session"
        set -g @catppuccin_window_number_position 'right'

        set -g @catppuccin_window_default_fill 'number'
        set -g @catppuccin_window_default_text '#W'

        set -g @catppuccin_window_current_fill 'number'
        set -g @catppuccin_window_current_text '#W'
      '';
    };
  };

  programs = home-programs // {
    git = git-config;
    gpg.enable = true;
  };
}
