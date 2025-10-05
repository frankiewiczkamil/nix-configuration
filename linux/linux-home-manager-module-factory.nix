{ user-name, home-config }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${user-name} = home-config;
  };
}
