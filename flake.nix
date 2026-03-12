{
  description = "flakes yay!";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      system = "x86_64-linux";
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [ ./configuration.nix ];
      };
    };
  };
}
