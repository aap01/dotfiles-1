{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-22.05";
    nixpkgsUnstable.url = "github:NixOS/nixpkgs/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, flake-utils, darwin, deploy-rs, nixpkgs, nixpkgsUnstable, home-manager }:


    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {

          devShell = with pkgs; pkgs.mkShell {
            buildInputs = [
              # Just in case :)
            ];
          };

        })
    // # <- concatenates Nix attribute sets
    {
      # TODO re-enable cachix across hosts

      homeConfigurations = {
        # TODO: Change mbp2021 to your hostname
        # Command: home-manager switch --flake ."#homeConfigurations.alif-mac"
        alif-mac = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;
          modules = [
            ./nixpkgs/home-manager/mac.nix
          ];

          extraSpecialArgs = {
            pkgsUnstable = inputs.nixpkgsUnstable.legacyPackages.aarch64-darwin;
          };
        };

        dev2 = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
          modules = [ ./nixpkgs/home-manager/dev2.nix ];
          extraSpecialArgs = {
            pkgsUnstable = inputs.nixpkgsUnstable.legacyPackages.x86_64-linux;
          };
        };

        homepi = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.aarch64-linux;
          modules = [ ./nixpkgs/home-manager/homepi.nix ];
          extraSpecialArgs = {
            pkgsUnstable = inputs.nixpkgsUnstable.legacyPackages.aarch64-linux;
          };
        };

        gitpod = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
          modules = [ ./nixpkgs/home-manager/gitpod.nix ];
          extraSpecialArgs = {
            pkgsUnstable = inputs.nixpkgsUnstable.legacyPackages.x86_64-linux;
          };
        };

      };

      darwinConfigurations = {
        # TODO: replace mbp2021 with your hostname
        # Command: nix build ".#darwinConfigurations.alif-mac.system"
        # Command: ./result/sw/bin/darwin-rebuild switch --flake ."#alif-mac"

        alif-mac = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./nixpkgs/darwin/mbp2021/configuration.nix
          ];
          inputs = { inherit darwin nixpkgs; };
        };
      };

      nixosConfigurations = {

        # sudo nixos-rebuild switch --flake .#dev2
        dev2 = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { common = self.common; inherit inputs; };
          modules = [
            ./nixpkgs/nixos/dev2/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs = { pkgsUnstable = inputs.nixpkgsUnstable.legacyPackages.x86_64-linux; };
              # TODO load home-manager dotfiles also for root user
              home-manager.users.schickling = import ./nixpkgs/home-manager/dev2.nix;
            }
          ];
        };

        build-server = inputs.nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { common = self.common; inherit inputs; };
          modules = [
            ./nixpkgs/nixos/build-server/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs = { pkgsUnstable = inputs.nixpkgsUnstable.legacyPackages.aarch64-linux; };
              home-manager.users.root = import ./nixpkgs/home-manager/nix-builder.nix;
            }
          ];
        };

        # sudo nixos-rebuild switch --flake .#homepi
        homepi = inputs.nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = { common = self.common; inherit inputs; };
          modules = [
            ./nixpkgs/nixos/homepi/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs = { pkgsUnstable = inputs.nixpkgsUnstable.legacyPackages.aarch64-linux; };
              # TODO load home-manager dotfiles also for root user
              home-manager.users.schickling = import ./nixpkgs/home-manager/homepi.nix;
            }
          ];

        };

      };

      images = {
        # nix build .#images.homepi
        homepi = self.nixosConfigurations.homepi.config.system.build.sdImage;
      };

      deploy.nodes = {
        homepi = {
          # hostname = "192.168.1.8"; # local ip
          hostname = "homepi";
          profiles.system = {
            sshUser = "root";
            path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.homepi;
          };
        };

        dev2 = {
          hostname = "dev2";
          profiles.system = {
            sshUser = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.dev2;
          };
        };

        build-server = {
          hostname = "oracle-nix-builder";
          profiles.system = {
            sshUser = "root";
            path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.build-server;
          };
        };
      };

      # checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

      common = {
        sshKeys = [
          "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBLXMVzwr9BKB67NmxYDxedZC64/qWU6IvfTTh4HDdLaJe18NgmXh7mofkWjBtIy+2KJMMlB4uBRH4fwKviLXsSM= MBP2020@secretive.MacBook-Pro-Johannes.local"
          "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBM7UIxnOjfmhXMzEDA1Z6WxjUllTYpxUyZvNFpS83uwKj+eSNuih6IAsN4QAIs9h4qOHuMKeTJqanXEanFmFjG0= MM2021@secretive.Johannes’s-Mac-mini.local"
          "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBPkfRqtIP8Lc7qBlJO1CsBeb+OEZN87X+ZGGTfNFf8V588Dh/lgv7WEZ4O67hfHjHCNV8ZafsgYNxffi8bih+1Q= MBP2021@secretive.Johannes’s-MacBook-Pro.local"
        ];
      };
    };
}
