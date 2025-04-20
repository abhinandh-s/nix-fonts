{
  description = "A Simple Fonts flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};

    fonts = import ./default.nix {inherit pkgs;};
  in {
    packages = fonts;
  };
}
