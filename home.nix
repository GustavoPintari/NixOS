{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "gustavo";
  home.homeDirectory = "/home/gustavo";

  home.packages = with pkgs; [
    firefox-esr libreoffice neofetch git  
    nicotine-plus ncmpcpp mpd vlc ranger ueberzug krita
    winePackages.staging eclipses.eclipse-jee jdk vscode git
    transmission-gtk flameshot bottom htop wget curl 
    obsidian discord barrier patool unzip
    corefonts 
  ];

  fonts.fontconfig.enable = true;

  # GTK
  gtk = {
    enable = true;
    iconTheme.name = "Qogir-Dark";
    iconTheme.package = pkgs.qogir-icon-theme;
  };

  # Rofi
  programs.rofi = {
    enable = true;
    theme = "paper-float.rasi";
    plugins = [
      pkgs.rofi-calc
    ];
  };
  
  # Shell
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      du      = "du -h | egrep -v ''./.+/'' | sort -h";
      nclear  = "sudo nix-collect-garbage -d";
      nboot   = "sudo nixos-rebuild boot";
      nupdate = "sudo nixos-rebuild switch";
      nconfig = "sudoedit nvim /etc/nixos/configuration.nix";
      hconfig = "nvim ~/.config/nixpkgs/home.nix";
      hupdate = "home-manager switch";
    };
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.5.0";
          sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
        };
      }
    ];
    oh-my-zsh = {
      enable = true;
      theme = "nicoulaj";
    };
  };
  
  # Ncmpcpp
  programs.ncmpcpp = {
    enable = true;
    mpdMusicDir = ~/Music;
    settings = {
      startup_screen = "media_library";
    };
  };
  
  # Git
  programs.git = {
    enable = true;
    userName  = "GustavoPintari";
    userEmail = "gustavopintari@gmail.com";
    extraConfig = {
      credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";
    };
  };

  # Kitty
  programs.kitty = {
    enable = true;
    theme = "Mona Lisa";
    font = {
      package = pkgs.hack-font;
      name = "Hack Regular";
      size = 12;
    };
    extraConfig = "
      background                #000000
      cursor_blink_interval     1.5
      background_opacity        0.95
      enable_audio_bell         no 
      remember_window_size      yes
      window_padding_width      0 
      placement_strategy        center
      confirm_os_window_close   0
    ";
  };

  # Neovim 
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      vim-nix
      nerdtree
      neovim-ayu
      indentLine
      nvim-autopairs
      vim-hexokinase

      (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))

      {
        plugin = nvim-ts-autotag;
        config =
          "lua require 'nvim-ts-autotag'.setup()";
      } 
      {
        plugin = nvim-autopairs;
        config = 
          "lua require 'nvim-autopairs'.setup()";
      }
      {
        plugin = lualine-nvim;
        config = "
          lua require 'lualine'
          .setup({theme = 'auto'})
        ";
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
      set encoding=utf8
      set tabstop=2 softtabstop=2 expandtab shiftwidth=2
      color ayu-dark

      map <C-n> :NERDTreeToggle<cr>
    '';
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
