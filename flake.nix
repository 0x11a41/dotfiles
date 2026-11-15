{
  description = "flakes yay!";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-pureref.url = "github:NixOS/nixpkgs/nixos-25.11";
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ({ ... }: {
          nixpkgs.overlays = [
            (final: prev:
            let
              system = prev.stdenv.hostPlatform.system;
            in
            {
              pureref = (import inputs.nixpkgs-pureref {
                inherit system;
                config.allowUnfree = true;
              }).pureref;

              zen-browser = inputs.zen-browser.packages.${system}.default;
            })
          ];
        })

        ./configuration.nix
      ];
    };
  };
}
