{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      vim-nix
      neovim-ayu
      indentLine
      nvim-autopairs
      vim-hexokinase

      (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = ''
          require('nvim-tree').setup{}
        '';
      }
      {
        plugin = nvim-web-devicons;
        type = "lua";
        config = ''
          require('nvim-web-devicons').setup{}
        '';
      }
      {
        plugin = mini-nvim;
        type = "lua";
        config = ''
          local header_art = 
          [[
          ╭╮╭┬─╮╭─╮┬  ┬┬╭┬╮
          │││├┤ │ │╰┐┌╯││││
          ╯╰╯╰─╯╰─╯ ╰╯ ┴┴ ┴
          ]]

          require('mini.starter').setup{
            header = header_art,
            footer = "", 
          } 
        '';
      }
      {
        plugin = nvim-ts-autotag;
        type = "lua";
        config = ''
          require('nvim-ts-autotag').setup{}
        '';
      } 
      {
        plugin = nvim-autopairs;
        type = "lua";
        config = ''
          require('nvim-autopairs').setup{}
        '';
      }
      {
        plugin = lualine-nvim;
        type = "lua";
        config = ''
          require('lualine').setup{
            theme = 'gruvbox',
            options = { 
              section_separators = "",
              component_separators = "",
              disabled_filetypes = {'NvimTree'}
            }
          }
        '';
      }

    ];
    extraConfig = ''
      syntax on
      set termguicolors
      set cursorline
      set hidden
      set mouse=a
      set number 
      set title
      set nowrap
      set clipboard=unnamedplus
      set encoding=UTF-8
      set tabstop=2 softtabstop=2 expandtab shiftwidth=2
      color ayu-dark

      noremap <silent> <C-n> :NvimTreeToggle<CR>
    '';
  };
}
