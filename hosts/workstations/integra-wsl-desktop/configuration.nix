# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ user, pkgs, ... }:

{
  wsl.enable = true;
  wsl.defaultUser = "garrett";

  networking = {
    hostName = "integra";
  };

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
