{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
      # inputs.nixpkgs.follows = "nixpkgs";
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
      nix-darwin,
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
      darwin-module-factory = import ./darwin-module-factory.nix;
      home-manager-module-factory = (import ./darwin-home-manager-module-factory.nix) {
        inherit sops-nix;
        nixvim = nixvim.homeModules.nixvim;
        nix-index = nix-index-database.homeModules.default;
      };
      home-config-factory = import ./darwin-home-config-factory.nix;
      with-linux-builder = import ./linux-builder.nix;
      with-git-sops-factory = (import ../common/home/programs/with-git-sops.nix) merge;
      with-git-plain-factory = (import ../common/home/programs/with-git-plain.nix) merge;
      with-state-ver = (import ../common/home/with-state-version.nix) merge nix-version;

      home-config = with-state-ver home-config-factory;
      create-home-config-with-git-sops =
        secret-file-name: (with-git-sops-factory "${protected.outPath}/${secret-file-name}") home-config;
      create-home-config-with-git-plain = with-git-plain-factory home-config;

      config-factory =
        {
          home-manager-module,
          darwin-module,
          system,
        }:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          pkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        in
        nix-darwin.lib.darwinSystem {
          inherit system;
          modules = [
            darwin-module
            home-manager.darwinModules.home-manager
            home-manager-module
            sops-nix.darwinModules.sops
          ];
          specialArgs = { inherit pkgs-unstable; };
        };
    in
    {
      darwinConfigurations = {
        spaceship = config-factory rec {
          system = "aarch64-darwin";
          darwin-module = darwin-module-factory {
            hostname = "spaceship";
          };
          home-manager-module = home-manager-module-factory {
            user-name = "kamil";
            home-config = create-home-config-with-git-sops "kpf.yaml";
          };
        };
        chariot = config-factory rec {
          system = "x86_64-darwin";
          darwin-module = darwin-module-factory {
            hostname = "chariot";
          };
          home-manager-module = home-manager-module-factory {
            user-name = "kamil";
            home-config = home-config;
          };
        };
        linux-builder = config-factory rec {
          system = "aarch64-darwin";
          darwin-module = with-linux-builder (darwin-module-factory {
            hostname = "linux-builder";
          });
          home-manager-module = home-manager-module-factory {
            user-name = "kamil";
            home-config = create-home-config-with-git-sops "kpf.yaml";
          };
        };
        c7s = config-factory rec {
          system = "aarch64-darwin";
          darwin-module = darwin-module-factory {
            hostname = "c7s";
          };
          home-manager-module = home-manager-module-factory {
            user-name = "kamilfrankiewicz";
            home-config = create-home-config-with-git-sops "c7s.yaml";
          };
        };
        p7t-vm = config-factory rec {
          system = "aarch64-darwin";
          darwin-module = darwin-module-factory {
            hostname = "p7t-vm";
          };
          home-manager-module = home-manager-module-factory {
            user-name = "kamil.frankiewicz";
            home-config = home-config;
          };
        };
        example = config-factory rec {
          system = "aarch64-darwin";
          darwin-module = darwin-module-factory {
            hostname = "spaceship";
          };
          home-manager-module = home-manager-module-factory {
            user-name = "kamil";
            home-config = create-home-config-with-git-plain {
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
