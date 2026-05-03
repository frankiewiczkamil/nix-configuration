{
  nixvim,
  nix-index,
  sops-nix,
}:
{ user-name, home-config }:
{
  users.users.${user-name}.home = "/home/${user-name}";
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.${user-name} = {
      imports = [
        nixvim
        nix-index
        sops-nix.homeManagerModules.default
        home-config
      ];
    };
  };
}
