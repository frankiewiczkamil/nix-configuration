{
  name,
  email,
  signingKey,
}:
{
  enable = true;
  userName = name;
  userEmail = email;
  signing = {
    key = signingKey;
    signByDefault = true;
  };
  extraConfig = {
    init = {
      defaultBranch = "main";
    };
  };
}
