{
  inputs,
  nix-base,
  user,
  pkgs,
  ...
}:
{
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
