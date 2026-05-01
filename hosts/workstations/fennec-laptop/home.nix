{
  inputs,
  nix-base,
  user,
  pkgs,
  ...
}:
{
  wayland.windowManager.sway.extraConfig = ''
    output eDP-1 resolution 2256x1504 scale 1.5
  '';

  services.kanshi.settings = [
    {
      profile.name = "undocked";
      profile.outputs = [
        {
          criteria = "eDP-1";
          scale = 1.5;
          status = "enable";
        }
      ];
    }
    {
      profile.name = "docked";
      profile.outputs = [
        {
          criteria = "eDP-1";
          scale = 1.5;
          status = "enable";
        }
        {
          # Run `swaymsg -t get_outputs` after first boot to get the exact criteria string
          criteria = "Unknown";
          scale = 1.0;
          status = "enable";
        }
      ];
    }
  ];

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    packages = pkgs.callPackage ./packages.nix { inherit inputs nix-base; };

    file = {
      ".ssh/allowed_signers".source = ./config/ssh/allowed_signers;
    };
  };
  programs = {
    git = {
      settings = {
        # Sign all commits using SSH key
        commit.gpgsign = true;
        gpg.format = "ssh";
        gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
        user = {
          name = "Garrett Leber";
          email = "garrett@leberra.com";
          signingkey = "~/.ssh/id_rsa.pub";
        };
      };
    };
    ssh = {
      matchBlocks = {
        "*.imkumpy.in" = {
          user = "lab";
          forwardAgent = true;
        };
      };
    };
  };
}
