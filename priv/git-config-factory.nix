{
  name,
  email,
  signingKey,
}:
{
  enable = true;
  settings = {
    user = {
      inherit name;
      inherit email;
    };
    init = {
      defaultBranch = "main";
    };
    url = {
      "ssh://git@github.com/" = {
        insteadOf = "https://github.com/";
      };
    };
  };
  signing = {
    key = signingKey;
    signByDefault = true;
  };
}
