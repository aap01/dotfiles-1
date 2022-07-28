# Install darwinConfiguration
nix build ".#darwinConfigurations.alif-mac.system"
./result/sw/bin/darwin-rebuild switch --flake ."#alif-mac"

# Install homeConfigurations
home-manager switch --flake ."#homeConfigurations.alif-mac"
