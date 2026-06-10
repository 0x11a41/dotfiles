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

  outputs = { self, nixpkgs, nixpkgs-pureref, ... }@inputs: {
    nixosConfigurations = {
      system = "x86_64-linux";
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs nixpkgs-pureref;
        };
        modules = [ ./configuration.nix ];
      };
    };
  };
}
