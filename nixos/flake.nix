{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      # nix-darwin,
      home-manager,
      nixpkgs,
      nixpkgs-unstable,
      nixvim,
      ...
    }:
    let
      nix-version = "25.11"; # can't use this variable with `rec` keyword inside inputs object, for other args, unfortunately
      home-manager-module-factory = (import ./linux-home-manager-module-factory.nix) nixvim.homeModules.nixvim;
      home-config-factory = import ./linux-home-config-factory.nix;
      git-config-factory = import ../priv/git-config-factory.nix;
      nixos-configuration = import ./configuration.nix;

      git-metadata-provider = import ../priv/git-metadata-provider.nix;

      git-config = git-config-factory (git-metadata-provider { });

      create-home-config =
        { git-config }:
        home-config-factory {
          inherit git-config;
          state-version = nix-version;
        };

      config-factory =
        {
          home-manager-module,
          system,
        }:
        let
          pkgs-unstable = import nixpkgs-unstable { inherit system; };
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            nixos-configuration
            home-manager.nixosModules.home-manager
            home-manager-module
          ];
          specialArgs = { inherit pkgs-unstable; };
        };
    in
    {
      nixosConfigurations = {
        vm = config-factory rec {
          system = "aarch64-linux";

          home-manager-module = home-manager-module-factory {
            user-name = "kpf";
            home-config = create-home-config {
              inherit git-config;
            };
          };
        };

      };
    };
}
