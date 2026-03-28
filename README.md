# nix-personal

Personal NixOS workstation configurations. Consumes [nix-base](https://github.com/tcpkump/nix-base) for shared modules and builder functions.

## Hosts

| Hostname | Type | Description |
|---|---|---|
| `optio-desktop` | NixOS | Desktop workstation (GNOME) |
| `fennec-laptop` | NixOS | Framework 13 laptop (GNOME) |
| `integra-wsl-desktop` | NixOS (WSL) | WSL workstation |

## Building and switching

Run these commands from inside this repo's directory. `nix develop` (or direnv) makes the dev shell available.

### NixOS workstations

```bash
# Switch to the configuration for the current machine
sudo nixos-rebuild switch --flake .#fennec-laptop
sudo nixos-rebuild switch --flake .#optio-desktop
sudo nixos-rebuild switch --flake .#integra-wsl-desktop
```

To build without switching (e.g. to check for errors on another machine):

```bash
nix build .#nixosConfigurations.fennec-laptop.config.system.build.toplevel
```

### WSL

Same command as above. Rebuild from within the WSL instance:

```bash
sudo nixos-rebuild switch --flake .#integra-wsl-desktop
```

## Structure

```
flake.nix                          # inputs + nixosConfigurations
hosts/
└── workstations/
    ├── optio-desktop/
    │   ├── configuration.nix      # system config, hardware
    │   ├── home.nix               # user config, git identity
    │   ├── hardware-configuration.nix
    │   └── packages.nix
    ├── fennec-laptop/             # same structure
    └── integra-wsl-desktop/       # same structure
```

Host `configuration.nix` files import desktop environments and hardware modules from nix-base via `${inputs.nix-base}/shared/...`.

Host `packages.nix` files compose packages from nix-base's shared lists plus any host-specific additions.

## Adding a new host

1. Create `hosts/workstations/<hostname>/` with `configuration.nix`, `home.nix`, `packages.nix`, and (for NixOS) `hardware-configuration.nix`
2. Add an entry to `flake.nix`:
   ```nix
   new-host = nix-base.lib.mkNixosWorkstation {
     inherit inputs;
     flakeDir = self;
     hostname = "new-host";
     system = "x86_64-linux";
     user = "alice";
   };
   ```

## Development

```bash
nix develop    # enter dev shell with pre-commit hooks
nix flake check
```
