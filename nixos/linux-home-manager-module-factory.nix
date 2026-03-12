{ nixvim, nix-index }:
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
        home-config
      ];
    };
  };
}
