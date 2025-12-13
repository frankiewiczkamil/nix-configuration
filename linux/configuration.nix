{
  config,
  pkgs,
  pkgs-unstable,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  console.keyMap = "pl2";

  environment.systemPackages = with pkgs; [
    htop
    spice
    spice-vdagent
  ];

  home-manager.extraSpecialArgs = { inherit pkgs-unstable; };

  networking = {
    hostName = "nixos-vm";
    networkmanager.enable = true;
  };
  nixpkgs.config.allowUnfree = true;

  i18n = {
    defaultLocale = "pl_PL.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "pl_PL.UTF-8";
      LC_IDENTIFICATION = "pl_PL.UTF-8";
      LC_MEASUREMENT = "pl_PL.UTF-8";
      LC_MONETARY = "pl_PL.UTF-8";
      LC_NAME = "pl_PL.UTF-8";
      LC_NUMERIC = "pl_PL.UTF-8";
      LC_PAPER = "pl_PL.UTF-8";
      LC_TELEPHONE = "pl_PL.UTF-8";
      LC_TIME = "pl_PL.UTF-8";
    };
  };

  services = {
    displayManager.autoLogin = {
      enable = true;
      user = "kpf";
    };
    openssh.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

    };
    printing.enable = true;
    pulseaudio.enable = false;

    xserver = {
      enable = true;

      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;

      xkb = {
        layout = "pl";
        variant = "";
      };
    };
    spice-vdagentd.enable = true;
  };
  programs.zsh.enable = true;
  security.rtkit.enable = true;

  users.users.kpf = {
    isNormalUser = true;
    description = "Kamil";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      #  thunderbird
    ];
    shell = pkgs.zsh;
  };

  system.stateVersion = "25.05";

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
  time.timeZone = "Europe/Warsaw";
}
