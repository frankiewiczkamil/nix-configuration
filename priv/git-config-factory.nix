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
    signing = {
      key = signingKey;
      signByDefault = true;
    };
  };
}
