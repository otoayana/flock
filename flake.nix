{
  description = "development shell for flock";

  inputs = {
    naersk.url = "github:nix-community/naersk";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = {
    self,
    fenix,
    naersk,
    nixpkgs,
    utils,
  }:
    utils.lib.eachDefaultSystem (system: let
      pkgs = (import nixpkgs) {
        inherit system;
      };

      naersk' = pkgs.callPackage naersk { };
      toolchain = fenix.packages.${system}.minimal.toolchain;
    in {
      #packages.x86_64-linux.default = fenix.packages.x86_64-linux.default.toolchain;
      defaultPackage = naersk'.buildPackage {
          src = ./.;
      };

      devShell = pkgs.mkShell {
        nativeBuildInputs = [
          toolchain
          (with pkgs; [
            gcc
            rustc
            cargo
            cargo-deny
            cargo-outdated
            openssl.dev
            pkg-config
            rlwrap
            rust-analyzer
            sqlite
          ])
        ];
        };
    });
}
