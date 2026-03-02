{
  enable = true;

  colorschemes.catppuccin.enable = true;
  plugins = {
    lualine.enable = true;
    telescope.enable = true;
    web-devicons.enable = true;
    lsp.enable = true;
    cmp.enable = true;
  };
  globals = {
    mapleader = " ";
    direnv_auto = 1;
    direnv_silent_load = 0;
  };
  keymaps = [
    {
      mode = "n";
      key = "<leader>w";
      action = ":w<CR>";
    }
  ];
}
