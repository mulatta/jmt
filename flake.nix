{
  description = "jmt - jj fix with treefmt formatter";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      imports = [
        ./nix/formatter.nix
        ./nix/checks.nix
        ./nix/shell.nix
      ];

      perSystem =
        { pkgs, self', ... }:
        {
          packages = {
            jmt = pkgs.callPackage ./default.nix { };
            default = self'.packages.jmt;
          };
        };

      flake.overlays.default = final: _: {
        jmt = final.callPackage ./default.nix { };
      };
    };
}
