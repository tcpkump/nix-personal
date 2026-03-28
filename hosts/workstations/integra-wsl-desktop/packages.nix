{
  inputs,
  nix-base,
  lib,
  pkgs,
}:

let
  shared-base-packages = import "${nix-base}/shared/workstations/all/packages.nix" {
    inherit inputs pkgs;
  };
in
lib.concatMap (pset: pset) [
  shared-base-packages
]
