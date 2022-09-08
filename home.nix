{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "gustavo";
  home.homeDirectory = "/home/gustavo";

  home.packages = with pkgs; [

    firefox-esr libreoffice kitty neofetch git
    nicotine-plus ncmpcpp mpd vlc ranger ueberzug krita
    winePackages.staging eclipses.eclipse-jee jdk vscode git
    transmission-gtk flameshot redshift bottom htop wget curl 
    obsidian discord barrier font-manager corefonts patool unzip
  ];

  fonts.fontconfig.enable = true;

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
      nclear = "sudo nix-collect-garbage -d";
      nboot = "sudo nixos-rebuild boot";
      nupdate = "sudo nixos-rebuild switch";
      nconfig = "sudo nvim ../../etc/nixos/configuration.nix";
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
