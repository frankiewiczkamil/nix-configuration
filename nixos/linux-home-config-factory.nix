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
    packages = import ../common/home/home-packages.nix { inherit pkgs pkgs-unstable; } ++ [
      pkgs.vscode
      pkgs.helix
    ];
    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableBashIntegration = true;
    pinentry.package = pkgs.pinentry-gnome3;
  };

  programs = home-programs // {
    gpg.enable = true;
  };
}
