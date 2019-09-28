# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./nvim.nix
      ./zsh.nix
      ./hardware-configuration.nix
      # ./base16/default.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
      consoleFont = "ter-i16b";
      consolePackages = with pkgs; [ terminus_font ];
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  nix.nixPath = [
    "nixos-config=/etc/nixos/configuration.nix"
    "nixpkgs=/etc/nixos/nixpkgs-channels"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    vim
    # neovim
    myNeovim
    # git
    less
    xclip
    firefox
    zip
    unzip
  ];
  programs.zsh.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "eurosign:e";
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: with haskellPackages; [
        haskellPackages.xmonad-contrib
        haskellPackages.xmonad-extras
        haskellPackages.xmonad
       ];
    };
    windowManager.default = "xmonad";
    displayManager.lightdm.enable = true;
    displayManager.sessionCommands = ''
       xrdb "${pkgs.writeText  "xrdb.conf" ''
          URxvt.font:                 xft:Dejavu Sans Mono for Powerline:size=14
          XTerm*faceName:             xft:Dejavu Sans Mono for Powerline:size=14
          XTerm*utf8:                 2
          URxvt.letterSpace:          0
          URxvt*saveLines:            32767
          XTerm*saveLines:            32767
          URxvt.url-select.launcher:  /usr/bin/firefox -new-tab
          URxvt.url-select.underline: true
          Xft*dpi:                    96
          Xft*antialias:              true
          Xft*hinting:                full
          URxvt.scrollBar:            false
          URxvt*scrollTtyKeypress:    true
          URxvt*scrollTtyOutput:      false
          URxvt*scrollWithBuffer:     false
          URxvt*scrollstyle:          plain
          URxvt*secondaryScroll:      true
          Xft.autohint: 0
          Xft.lcdfilter:  lcddefault
          Xft.hintstyle:  hintfull
          Xft.hinting: 1
          Xft.antialias: 1
       ''}"
    '';
  };

  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.blake = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?

}
