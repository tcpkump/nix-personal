{
  user,
  nix-base,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    "${nix-base}/shared/workstations/nixos/sway/default.nix"
  ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 16;
      };
      efi.canTouchEfiVariables = true;
    };
    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "uinput" ];
  };

  networking = {
    hostName = "fennec";
  };
  services.tailscale.enable = true;

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
        # for embedded development/flashing
        "dialout"
        "uucp"
      ];
      shell = pkgs.zsh;
    };
  };

  system.stateVersion = "23.11"; # Don't change this
}
