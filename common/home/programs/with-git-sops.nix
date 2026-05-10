merge: secret-file-path: fn:
args@{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:
let
  base = fn args;
  addition = {
    home.file.".gitconfig".source =
      config.lib.file.mkOutOfStoreSymlink
        config.sops.templates."gitconfig".path;

    sops = {
      age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
      defaultSopsFile = secret-file-path;
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
  };
in
merge base addition
