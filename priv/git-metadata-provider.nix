{ }:
{
  name =
    let
      val = builtins.getEnv "GIT_NAME";
    in
    if val == "" then throw "❌ GIT_NAME not set" else val;
  email =
    let
      val = builtins.getEnv "GIT_EMAIL";
    in
    if val == "" then throw "❌ GIT_EMAIL not set" else val;
  signingKey = builtins.getEnv "GPG_SIGNING_KEY"; # GPG signing key is optional
}
