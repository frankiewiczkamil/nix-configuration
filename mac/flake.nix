{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nix-darwin,
      home-manager,
      nixpkgs,
      nixpkgs-unstable,
      ...
    }:
    let
      nix-version = "25.05"; # can't use this variable with `rec` keyword inside inputs object, for other args, unfortunately
      darwin-module-factory = import ./darwin-module-factory.nix;
      home-manager-module-factory = import ./darwin-home-manager-module-factory.nix;
      home-config-factory = import ./darwin-home-config-factory.nix;
      with-linux-builder = import ./linux-builder.nix;
      git-config-factory = import ../priv/git-config-factory.nix;

      name =
        let
          val = builtins.getEnv "GIT_NAME";
        in
        if val == "" then throw "❌ GIT_NAME not set" else val;
      email =
        let
          val = builtins.getEnv "GIT_EMAIL";
        in
        if val == "" then throw "❌ GIT_EMAIL not set" else val;
      signingKey = builtins.getEnv "GPG_SIGNING_KEY"; # GPG signing key is optional

      git-config = git-config-factory {
        inherit name email signingKey;
      };

      create-home-config =
        { git-config }:
        home-config-factory {
          inherit git-config;
          state-version = nix-version;
        };

      config-factory =
        {
          home-manager-module,
          darwin-module,
          system,
        }:
        let
          pkgs-unstable = import nixpkgs-unstable { inherit system; };
        in
        nix-darwin.lib.darwinSystem {
          inherit system;
          modules = [
            darwin-module
            home-manager.darwinModules.home-manager
            home-manager-module
          ];
          specialArgs = { inherit pkgs-unstable; };
        };
    in
    {
      darwinConfigurations = {
        spaceship = config-factory rec {
          system = "aarch64-darwin";
          darwin-module = darwin-module-factory {
            platform = system;
            hostname = "spaceship";
          };
          home-manager-module = home-manager-module-factory {
            user-name = "kamil";
            home-config = create-home-config {
              inherit git-config;
            };
          };
        };
        chariot = config-factory rec {
          system = "x86_64-darwin";
          darwin-module = darwin-module-factory {
            platform = system;
            hostname = "chariot";
          };
          home-manager-module = home-manager-module-factory {
            user-name = "kamil";
            home-config = create-home-config {
              inherit git-config;
            };
          };
        };
        linux-builder = config-factory rec {
          system = "aarch64-darwin";
          darwin-module = with-linux-builder (darwin-module-factory {
            platform = system;
            hostname = "linux-builder";
          });
          home-manager-module = home-manager-module-factory {
            user-name = "kamil";
            home-config = create-home-config {
              inherit git-config;
            };
          };
        };
        c7s = config-factory rec {
          system = "aarch64-darwin";
          darwin-module = darwin-module-factory {
            platform = system;
            hostname = "c7s";
          };
          home-manager-module = home-manager-module-factory {
            user-name = "kamilfrankiewicz";
            home-config = create-home-config {
              inherit git-config;
            };
          };
        };
        p7t-vm = config-factory rec {
          system = "aarch64-darwin";
          darwin-module = darwin-module-factory {
            platform = system;
            hostname = "p7t-vm";
          };
          home-manager-module = home-manager-module-factory {
            user-name = "kamil.frankiewicz";
            home-config = create-home-config {
              inherit git-config;
            };
          };
        };
      };
    };
}
