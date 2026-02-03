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

  programs = home-programs // {
    git = git-config;
    gpg.enable = true;
    zed-editor = {
      enable = true;
      extensions = [
        "nix"
        "toml"
        "catppuccin"
      ];
      userSettings = {
        theme = {
          mode = "system";
          dark = "Catppuccin Mocha";
          light = "Catppuccin Latte";
        };
        "languages" = {
          "JavaScript" = {
            "formatter" = {
              "external" = {
                "command" = "prettier";
                "arguments" = [
                  "--stdin-filepath"
                  "{buffer_path}"
                ];
              };
            };
            "format_on_save" = "on";
          };
          "Nix" = {
            "language_servers" = [
              "nil"
              "!nixd"
            ];
            "format_on_save" = "on";
          };
        };
        "lsp" = {
          "nil" = {
            "initialization_options" = {
              "formatting" = {
                "command" = [ "nixfmt" ];
              };
            };
            "settings" = {
              "diagnostics" = {
                "ignored" = [ "unused_binding" ];
              };
            };
          };
        };
        vim_mode = true;
        buffer_font_fallbacks = [ "FiraCode Nerd Font Mono" ];
        ui_font_size = 15;
        buffer_font_size = 15;
        base_keymap = "JetBrains";
        load_direnv = "shell_hook";
      };
    };
  };
}
