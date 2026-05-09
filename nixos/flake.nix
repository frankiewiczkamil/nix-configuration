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
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    protected = {
      url = "path:../protected";
      flake = false;
    };
  };

  outputs =
    {
      # nix-darwin,
      home-manager,
      nixpkgs,
      nixpkgs-unstable,
      nixvim,
      nix-index-database,
      sops-nix,
      protected,
      ...
    }:
    let
      merge = nixpkgs.lib.recursiveUpdate;
      nix-version = "25.11"; # can't use this variable with `rec` keyword inside inputs object, for other args, unfortunately
      home-manager-module-factory = (import ./linux-home-manager-module-factory.nix) {
        nixvim = nixvim.homeModules.nixvim;
        nix-index = nix-index-database.homeModules.default;
        inherit sops-nix;
      };
      home-config-factory = import ./linux-home-config-factory.nix;
      nixos-configuration = import ./configuration.nix;
      with-git-sops-factory = (import ../common/home/programs/with-git-sops.nix) merge;
      with-state-ver = (import ../common/home/with-state-version.nix) merge nix-version;
      with-git-plain-factory = (import ../common/home/programs/with-git-plain.nix) merge;

      home-config = with-state-ver home-config-factory;
      create-home-config-with-git = with-git-plain-factory home-config;
      create-home-config-with-git-sops =
        secret-file-name: (with-git-sops-factory "${protected.outPath}/${secret-file-name}") home-config;

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
            home-config = create-home-config-with-git-sops "kpf.yaml";
          };
        };

        example = config-factory rec {
          system = "aarch64-linux";

          home-manager-module = home-manager-module-factory {
            user-name = "kpf";
            home-config = create-home-config-with-git {
              settings = {
                user = {
                  name = "John Doe";
                  email = "John [at] Doe [dot] xyz";
                };
              };
            };
          };
        };

      };
    };
}
