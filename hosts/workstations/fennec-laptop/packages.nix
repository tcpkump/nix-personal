{
  inputs,
  nix-base,
  lib,
  pkgs,
}:

with pkgs;
let
  shared-base-packages = import "${nix-base}/shared/workstations/all/packages.nix" {
    inherit inputs pkgs;
  };
  shared-nixos-packages = import "${nix-base}/shared/workstations/nixos/packages.nix" {
    inherit pkgs;
  };
in
lib.concatMap (pset: pset) [
  shared-base-packages
  shared-nixos-packages
]
++ [
  # gaming
  prismlauncher
  godot_4
  # AI
  lmstudio
]
