{ config, pkgs, ... }:

{
  imports = [
    ./nvim/nvim.nix
  ];

  home.username = "pintari";
  home.homeDirectory = "/home/pintari";

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.packages = with pkgs; [
    thunderbird firefox-esr libreoffice-qt neofetch git  
    nicotine-plus ncmpcpp mpd vlc krita
    winePackages.staging vscode git transmission-qt
    bottom htop wget curl flameshot 
    obsidian discord corefonts nerdfonts
    beekeeper-studio insomnia xcolor
    eclipses.eclipse-jee jdk18 
  ];

  fonts.fontconfig.enable = true;

  programs.rofi = {
    enable = true;
    theme = "paper-float.rasi";
    font = "Hack Regular 14";
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

  # MPD
  services.mpd = {
    enable = true;
    dataDir = ~/.config/mpd;
    musicDirectory = ~/Music;
    extraConfig = ''
      auto_update "yes"

      audio_output {
        type  "pipewire"
        name  "pipewire"
      }
      audio_output {
        type  "fifo"
        name  "FIFO"
        path  "/tmp/mpd.fifo"
        format  "44100:16:2"
      }
    '';
  };

  # Ncmpcpp
  programs.ncmpcpp = {
    enable = true;
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
      pull.rebase = false;
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
      size = 15;
    };
    extraConfig = ''
      hide_window_decorations   yes
      background                #000000
      cursor_blink_interval     1.5
      background_opacity        0.95
      enable_audio_bell         no 
      remember_window_size      yes
      window_padding_width      0 
      placement_strategy        center
      confirm_os_window_close   0
      bold_font                 auto
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
