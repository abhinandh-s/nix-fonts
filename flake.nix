{
  description = "Nerd Fonts flake";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      fonts = import ./build-fonts.nix { inherit (pkgs) stdenvNoCC; };
    in {
      packages = fonts;

      # Optional: module that does nothing but expose fonts in a way usable by nixosConfigurations
      nixosModules.nix-fonts = {
        config,
        pkgs,
        ...
      }: {
        environment.systemPackages = with pkgs; [
          # empty by default, user can use `fonts.packages` directly
        ];
      };
    };
}
