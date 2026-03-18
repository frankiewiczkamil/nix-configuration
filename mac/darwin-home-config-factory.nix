{ git-config, state-version }:
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
  zed-config = import ../common/home/programs/zed.nix;
in
{
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
      # ".p10k.zsh".text = builtins.readFile ../common/home/zsh/p10k.zsh;
    };
    sessionVariables = {
      EDITOR = "nvim";
    };
    stateVersion = state-version;
  };

  programs = home-programs // {
    git = git-config;
    gpg.enable = true;
    zed-editor = zed-config;
  };
  launchd.agents.keyboard-mapping = import ./keyboard-mapping.nix;
}
