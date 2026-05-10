{
  nixvim,
  nix-index,
  sops-nix,
}:
{ user-name, home-config }:
{
  users.users.${user-name}.home = /Users/${user-name};
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.${user-name} = {
      imports = [
        nixvim
        nix-index
        home-config
        sops-nix.homeManagerModules.sops
      ];
    };
  };
}
