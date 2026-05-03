merge: state-version: home-config-fn:
args@{ pkgs, config, ... }: # it seems that args need to be enumerated, otherwise it won't work on NixOS ¯\_(ツ)_/¯
let
  base = home-config-fn args;
  addon = {
    home.stateVersion = state-version;
  };
in
merge base addon
