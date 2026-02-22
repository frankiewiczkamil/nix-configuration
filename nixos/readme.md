### Prerequisites

#### Git config

In order to start run:

```shell
cp .env.template .env
```

and adapt your new `.env` file.

> [!NOTE]
> One might not want to store email in repo for privacy reasons,
> so personal git data are taken from `.env` file.
> For convenience and simplicity sake all user metadata are obtained that way:
> _name_ and signing _key_ as well.
> It's a compromise between pure, reproducible approach and privacy 🤷‍♂️

#### Secrets

Copy folders containing secrets (`.ssh`, `.gnupg`, ...) to your home directory.
In case of _gnupg_, you might need to delete (or better: backup) existing configuration files,
as _home-manager_ will create symlinks using provided configuration.

```shell
mv gpg.conf gpg.cong.backup
mv gpg-agent.conf gpg-agent.cong.backup

```

### Init

```shell
git clone https://github.com/frankiewiczkamil/nix-config.git
```

```shell

set -a && source .env && set +a
sudo -E nixos-rebuild switch --flake ./nixos#vm --impure
```

### Update packages

Refresh available dependencies:

```shell
nix flake update --flake ./nixos
```

Apply newest dependencies

```shell
sudo -E nixos-rebuild switch --flake ./nixos#vm --impure
```
