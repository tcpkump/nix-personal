{
  user,
  nix-base,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    "${nix-base}/shared/workstations/nixos/gnome/default.nix"
  ];

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        configurationLimit = 16;
      };
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking = {
    hostName = "optio";
  };

  time.hardwareClockInLocalTime = true; # For dual booting with Windows

  nix = {
    nixPath = [ "nixos-config=/home/${user}/.local/share/src/nixos-config:/etc/nixos" ];
    settings = {
      allowed-users = [ "${user}" ];
      trusted-users = [ "${user}" ];
    };
    gc.automatic = true;
  };

  users.users = {
    ${user} = {
      isNormalUser = true;
      extraGroups = [
        "wheel" # Enable 'sudo'
        "docker"
        "networkmanager"
        "libvirtd"
      ];
      shell = pkgs.zsh;
    };
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  # Mouse wakeup is super sensitive, causing my screen to wake often. This disables mouse wakeup.
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1d57", ATTRS{idProduct}=="fa65", ATTR{power/wakeup}="disabled"
  '';

  system.stateVersion = "23.11"; # Don't change this
}
