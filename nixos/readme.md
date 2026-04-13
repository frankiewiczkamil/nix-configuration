### Prerequisites

#### Git config

> [!NOTE]
> One might not want to store email in repo for privacy reasons,
> so personal git data are taken from `*.env` file.

Simple but impure solution

```shell
cp .env.template .env
```

and adapt your new `.env` file.

Pure(r) solution - using SOPS

One can use either age or pgp. You can:
 - generate a new one
 - use existing one
 - derive it from your existing ssh

For existing one use case, if it's pgp, then ensure that it has encrypt `E` flag in square brackets
```
nix shell nixpkgs#gnupg -c gpg --list-keys
```
For deriving use case: age can be extracted only from Ed25519, and PGP only from RSA.

You will find all the details [here](https://github.com/Mic92/sops-nix).

create file 
```
nix shell nixpkgs#sops -c sops protected/my-metadata.env
```



#### (More) Secrets
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
