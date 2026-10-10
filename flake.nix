{
  description = "Root messaging platform from the official AppImage";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };
  outputs =
    { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (pkgs: rec {
        rootapp = pkgs.callPackage ./package.nix { };
        default = rootapp;
      });
      overlays.default = final: _prev: {
        rootapp = final.callPackage ./package.nix { };
      };
    };
}
