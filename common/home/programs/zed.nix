pkgs: {
  enable = true;
  package = pkgs.zed-editor;
  extensions = [
    "nix"
    "toml"
  ];
  userSettings = {
    theme = {
      mode = "system";
      dark = "One Dark";
      light = "One Light";
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
}
