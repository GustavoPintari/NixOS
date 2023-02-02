{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Networking
  networking.hostName = "nixos"; 
  networking.networkmanager.enable = true;

  # Time zone
  time.timeZone = "America/Sao_Paulo";

  # Internationalisation properties
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Xorg
  services.xserver.enable = true;

  # Remove Screen Tearing 
  services.xserver.videoDrivers = [ "intel" ];
  services.xserver.deviceSection = ''
	  Option "DRI" "3"
	  Option "TearFree" "true"
  '';

  # Display Manager
  services.xserver.displayManager.sddm = {
    enable = true;
    theme = "breeze";
  };

  # Desktop Manager
  services.xserver.desktopManager.plasma5 = {
    enable = true;
    excludePackages = with pkgs.libsForQt5; [
      elisa
      oxygen
      khelpcenter
      konsole
      plasma-browser-integration
      print-manager
      kwallet 
      spectacle
      krunner
    ];
  };

  # Keymap
  services.xserver = {
    layout = "br";
  };

  console.keyMap = "br-abnt2";

  # Sound
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Docker
  virtualisation.docker.enable = true;

  # Users
  users.users.pintari = {
    isNormalUser = true;
    description = "Gustavo Pintari";
    extraGroups = [ "networkmanager" "docker" "wheel" ];
  };

  # Packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    gparted 
    vim 
    xclip
    libsForQt5.sddm-kcm
  ];

  # VsCode Error
  services.gnome.gnome-keyring.enable = true;

  # Flatpak
  services.flatpak.enable = true;
  xdg.portal.enable = true;
  
  # Shell
  programs.zsh = {
    enable = true;
  };

  users.defaultUserShell = pkgs.zsh;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
