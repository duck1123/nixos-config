# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

let
  # See: https://github.com/nix-community/home-manager/issues/3015
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz";
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
    (import "${home-manager}/nixos")
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

  networking.hostName = "nixos-vm"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  console = {
    font = "ter-i16b";
    packages = with pkgs; [ terminus_font ];
    # consoleFont = "Lat2-Terminus16";
    # consoleKeyMap = "us";
    # defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  nix.nixPath = [
    "nixos-config=/etc/nixos/configuration.nix"
    "nixpkgs=/etc/nixos/nixpkgs-channels"
    "nixpkgs-overlays=/etc/nixos/overlays"
  ];

  virtualisation.virtualbox.guest.enable = true;
  # virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.host.enableExtensionPack = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    # vim
    nixfmt
    # myNeovim
    emacs
    less
    xclip
    firefox
    zip
    unzip
    binutils
    # gcc
    # gdb
    nodejs
    # python_with_my_packages
    telnet
    # dmenu
  ];

  # programs.home-manager.enable = true;
  programs.zsh.enable = true;
  # programs.emacs.enable = true;
  # programs.htop.enable = true;
  # programs.npm.enable = true;

  # home.packages = with pkgs; [
  #     gnome3.gnome-tweak-tool
  # ];

  # home-manager.users.duck.programs.jq.enable = true;
  # home-manager.users.duck.programs.zsh.enable = true;

  # home-manager.users.duck = {
  #   programs.jq.enable = true;

  #   programs.zsh = {
  #     enable = true;
  #     enableAutosuggestions = true;
  #     defaultKeymap = "emacs";

  #     history = {
  #       expireDuplicatesFirst = true;
  #       extended = true;
  #       ignoreDups = true;
  #     };

  #     oh-my-zsh = {
  #       enable = true;
  #       theme = "jonathan";
  #       plugins = [
  #         "bgnotify"
  #         "colorize"
  #         "command-not-found"
  #         "compleat"
  #         # "docker-compose"
  #         "docker"
  #         "git"
  #         "git-extras"
  #         "history"
  #         "kubectl"
  #         "nmap"
  #         "node"
  #         "npm"
  #         "pj"
  #         "sudo"
  #         "systemd"
  #       ];
  #     };
  #   };
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # services.postgresql.enable = true;
  # services.postgresql.package = pkgs.postgresql_12;

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
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = false;
    desktopManager.gnome3.enable = true;
  };

  services = {
    dbus.packages = [ pkgs.gnome3.dconf ];
    udev.packages = [ pkgs.gnome3.gnome-settings-daemon ];
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
  system.stateVersion = "21.03"; # Did you read the comment?
}
