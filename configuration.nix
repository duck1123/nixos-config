# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

let
  moz_overlay = import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz);
  nixpkgs = import <nixpkgs> { overlays = [ moz_overlay ]; };
  my_python_packages = python-packages: with python-packages; [
    pynvim
    nvr
  ];
  python_with_my_packages = nixpkgs.python3.withPackages my_python_packages;
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./nvim.nix
    ./zsh.nix
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

  systemd.coredump.enable = true;
  security.pam.loginLimits = [
    { domain = "*"; item = "core"; type = "soft"; value = "unlimited"; }
  ];
  systemd.extraConfig = "DefaultLimitCORE=1000000";

  # Allow unfree packages (e.g. Spotify)
  nixpkgs.config.allowUnfree = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  console = {
    font = "ter-i16b";
    packages = with pkgs; [ terminus_font ];
    #   consoleFont = "Lat2-Terminus16";
    #   consoleKeyMap = "us";
    #   defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  nix.nixPath = [
    "nixos-config=/etc/nixos/configuration.nix"
    "nixpkgs=/etc/nixos/nixpkgs-channels"
    "nixpkgs-overlays=/etc/nixos/overlays"
  ];


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    vim
    myNeovim
    emacs
    less
    xclip
    firefox
    spotify
    zip
    unzip
    binutils
    gcc
    gdb
    nodejs
    python_with_my_packages
    telnet
    dmenu
  ];
  programs.zsh.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.postgresql.enable = true;
  services.postgresql.package = pkgs.postgresql_12;

  # Enable mongodb
  # services.mongodb.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "eurosign:e";
    desktopManager = {
      xfce = {
        enable = true;
        noDesktop = false;
        enableXfwm = true;
      };
    };
    displayManager = {
      defaultSession = "xfce";
    };
    windowManager.xmonad = {
      enable = false;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: with haskellPackages; [
        haskellPackages.xmonad-contrib
        haskellPackages.xmonad-extras
        haskellPackages.xmonad
      ];
    };
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
  users.users.duck = {
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
