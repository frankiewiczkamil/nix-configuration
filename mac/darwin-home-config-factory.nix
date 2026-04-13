{ state-version, protected-path }:
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
  zed-config = import ../common/home/programs/zed.nix pkgs-unstable;
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
      ".gitconfig".source = config.lib.file.mkOutOfStoreSymlink config.sops.templates."gitconfig".path;

    };
    sessionVariables = {
      EDITOR = "nvim";
    };
    stateVersion = state-version;
  };

  sops = {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = protected-path;
    defaultSopsFormat = "yaml";
    secrets = {
      "gitconfig/git_name" = { };
      "gitconfig/git_email" = { };
      "gitconfig/gpg_signing_key" = { };
    };
    templates."gitconfig".content = ''
      [user]
        name = ${config.sops.placeholder."gitconfig/git_name"}
        email = ${config.sops.placeholder."gitconfig/git_email"}
        signingkey = ${config.sops.placeholder."gitconfig/gpg_signing_key"}
      [commit]
        gpgsign = true
      [init]
        defaultBranch = main
      [url "ssh://git@github.com/"]
        insteadOf = https://github.com/
    '';
  };

  programs = home-programs // {
    git = {
      enable = true;
      ignores = [
        "*.log"
        ".direnv"
        "node_modules"
        ".DS_Store"
      ];
    };
    gpg.enable = true;
    zed-editor = zed-config;
  };
  launchd.agents.keyboard-mapping = import ./keyboard-mapping.nix;
}
