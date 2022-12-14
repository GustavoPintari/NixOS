{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Define hostname
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Set time zone
  time.timeZone = "America/Sao_Paulo";

  networking.interfaces.enp0s25.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;
  programs.nm-applet.enable = true; 

  # Internationalisation properties
  i18n.defaultLocale = "en_US.UTF-8";

  # Opengl 
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;

  # Flatpak
  services.flatpak.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Bluetooth
  hardware.bluetooth.enable = true;

  # Intel Microcode
  hardware.cpu.intel.updateMicrocode = true;
 
  # VsCode Error
  services.gnome.gnome-keyring.enable = true;
  
  # Nix Optimise 
  nix.autoOptimiseStore = true;

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "-d";
  };

  # Sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # VirtualBox
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "gustavo" ];
  
  # Docker
  virtualisation.docker.enable = true;

  # Users 
  users.users.gustavo = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "networkmanager" ];
  };
  
  # Packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    gparted xclip 
  ];

  # Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    configure = {
      customRC = (
        builtins.readFile /home/gustavo/.config/nvim/init.vim
      );
    };
  };

  # Shell
  programs.zsh = {
    enable = true;
    enableGlobalCompInit = false;
  };

  users.defaultUserShell = pkgs.zsh; 

  # Desktop Manager
  services.xserver.desktopManager.xfce = {
    enable = true;
    thunarPlugins = [
      pkgs.xfce.thunar-volman
    ];
  };
	  
  # Display Manager
  services.xserver.displayManager = {
    defaultSession = "xfce";
    lightdm.enable = true;
  };

  services.acpid.enable = true;

  # Xorg 
  services.xserver = {
    enable = true;
    layout = "br";
    xkbVariant = "thinkpad";
  };

  # Enable touchpad support 
  services.xserver.libinput.enable = true;

  # Remove screen tearing
  services.xserver.videoDrivers = [ "intel" ];
  services.xserver.deviceSection = ''
	  Option "DRI" "3"
	  Option "TearFree" "true"
  '';

  # Firewall
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It???s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

