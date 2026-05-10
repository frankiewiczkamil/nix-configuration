merge: fn: git-config:
args@{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:
let
  base = fn args;
  addition = {
    programs = {
      git = merge git-config {
        settings = {
          init = {
            defaultBranch = "main";
          };
          url = {
            "ssh://git@github.com/" = {
              insteadOf = "https://github.com/";
            };
          };
        };
      };
    };
  };
in
merge base addition
