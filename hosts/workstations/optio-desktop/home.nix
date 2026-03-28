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
  };
  programs = {
    git = {
      settings = {
        user.name = "Garrett Leber";
        user.email = "garrett@leberra.com";
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
