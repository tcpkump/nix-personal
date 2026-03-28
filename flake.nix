{
  description = "Personal Nix workstation configurations";

  inputs = {
    nix-base.url = "github:tcpkump/nix-base";
    nixpkgs.follows = "nix-base/nixpkgs";
    nixpkgs-darwin.follows = "nix-base/nixpkgs-darwin";
    home-manager.follows = "nix-base/home-manager";
    nixos-wsl.follows = "nix-base/nixos-wsl";
    nix-darwin.follows = "nix-base/nix-darwin";
    nix-homebrew.follows = "nix-base/nix-homebrew";
    homebrew-core.follows = "nix-base/homebrew-core";
    homebrew-cask.follows = "nix-base/homebrew-cask";
    nixos-hardware.follows = "nix-base/nixos-hardware";
    pre-commit-hooks.follows = "nix-base/pre-commit-hooks";
    nixcats-config.follows = "nix-base/nixcats-config";
    llm-agents.follows = "nix-base/llm-agents";
  };

  outputs =
    inputs@{
      self,
      nix-base,
      nixpkgs,
      nixos-hardware,
      ...
    }:
    let
      inherit (nixpkgs) lib;

      builders = nix-base.lib;

      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = lib.genAttrs supportedSystems;
    in
    {
      nixosConfigurations = {
        optio-desktop = builders.mkNixosWorkstation {
          flakeDir = self;
          hostname = "optio-desktop";
          system = "x86_64-linux";
          user = "garrett";
        };

        fennec-laptop = builders.mkNixosWorkstation {
          flakeDir = self;
          hostname = "fennec-laptop";
          system = "x86_64-linux";
          user = "garrett";
          modules = [ nixos-hardware.nixosModules.framework-13-7040-amd ];
        };

        integra-wsl-desktop = builders.mkNixosWorkstation {
          flakeDir = self;
          hostname = "integra-wsl-desktop";
          system = "x86_64-linux";
          user = "garrett";
          wslMachine = true;
        };
      };

      checks = forAllSystems (system: {
        pre-commit = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixfmt.enable = true;
            flake-checker.enable = true;
            deadnix.enable = true;
          };
        };
      });

      devShells = forAllSystems (system: {
        default = nixpkgs.legacyPackages.${system}.mkShell {
          buildInputs = self.checks.${system}.pre-commit.enabledPackages;
          shellHook = self.checks.${system}.pre-commit.shellHook or "";
        };
      });
    };
}
