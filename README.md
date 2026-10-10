# rootapp-flake

Root messaging platform packaged from the official upstream AppImage.

- Upstream: https://www.rootapp.com
- Download page: https://www.rootapp.com/download
- AppImage: `https://installer.rootapp.com/installer/Linux/X64/Root.AppImage`
- Binary: `rootapp`
- Platform: `x86_64-linux`

## Try it

```bash
NIXPKGS_ALLOW_UNFREE=1 nix run --impure github:Matko802/rootapp-flake
```

> Note: Root is proprietary, so the package is marked `unfree`.
> You need `allowUnfree`, e.g. `NIXPKGS_ALLOW_UNFREE=1 ... --impure`
> for one-off runs, or `nixpkgs.config.allowUnfree = true;` in your
> NixOS config.

## Use in your NixOS flake

```nix
rootapp = {
  url = "github:Matko802/rootapp-flake";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

```nix
nixpkgs.overlays = [ inputs.rootapp.overlays.default ];
```

```nix
users.users.you.packages = with pkgs; [
  rootapp
];
```

## Update to a newer AppImage

```bash
./update.sh
```

The script fetches the latest AppImage from the official download URL,
prefetches the new hash, reads the version from the embedded
`Root.desktop`, and rewrites `version` and `hash` in `package.nix`.
