{
  name,
  email,
  signingKey,
}:
{
  enable = true;
  ignores = [
    "*.log"
    ".direnv"
    "node_modules"
    ".DS_Store"
  ];

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
