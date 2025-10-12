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
in
{
  home = {
    packages = import ../common/home/home-packages.nix { inherit pkgs pkgs-unstable; } ++ [ ];
    file = {
      ".p10k.zsh".text = builtins.readFile ../common/home/zsh/p10k.zsh;
    };
    sessionVariables = {
      EDITOR = "vim";
    };
    stateVersion = state-version;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableBashIntegration = true;
    pinentry.package = pkgs.pinentry-gnome3;
  };

  programs = home-programs // {
    git = git-config;
    gpg.enable = true;
  };
}
