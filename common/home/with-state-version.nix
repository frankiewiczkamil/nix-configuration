merge: state-version: home-config-fn:
args@{ ... }:
let
  base = home-config-fn args;
  addon = {
    home.stateVersion = state-version;
  };
in
merge base addon
