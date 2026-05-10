## Prerequisites

Project requires `nix` package manager to be installed on the system.

> [!TIP]
> For macos one can use either official, vanilla `nix` installer, or the Determinate installer.
> In case of the latter, use the CLI installer and make sure to deny managing the `nix` by the determinate deamon, like:
>
> ```shell
> Selecting 'no' will install Nix from NixOS instead.
> Proceed? ([Y]es/[n]o/[e]xplain): n
> ```
>
> because otherwise it may lead to some darwin compatibility issues.


## Init

```shell
git clone https://github.com/frankiewiczkamil/nix-config.git
```

```shell
# macos
sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake ./mac#example
```

```shell
# linux
sudo nixos-rebuild switch --flake ./nixos#example
```

## Update packages

Refreshing available dependencies:

```shell
# macos
nix flake update --flake ./mac
```

```shell
# linux
nix flake update --flake ./nixos
```

Applying the newest dependencies

```shell
# macos
sudo darwin-rebuild switch --flake ./mac#spaceship # ./mac#linux-builder | ./mac#chariot | ...
```

```shell
# linux
sudo nixos-rebuild switch --flake ./nixos#vm
```
## Configuration

### Secrets
Copy folders containing secrets (`.ssh`, `.gnupg`, ...) to your home directory.
In case of `gnupg`, you might need to delete (or better: backup) existing configuration files,
as `home-manager` will create symlinks using provided configuration.

```shell
mv gpg.conf gpg.cong.backup
mv gpg-agent.conf gpg-agent.cong.backup
```

### Git
Like many other programs, `git` can be configured using `home-manager`.
Theoretically, such settings are not considered as sensitive data.
However, one might want to avoid storing them as a plain text in some cases,
for example to avoid email scraping by bots.
Therefore, two approaches for configuring git are supported:
- just `home-manager` (eg `example` profile)
- `home-manager` + `sops` (eg `spaceship` profile)


#### Git metadata managed with SOPS
One needs to have `age` or `pgp` key(s), that will be used for encryption.
The key can be provided in three ways:
1. Generating a new one
    ```shell
    # generate age key
    nix-shell -p age --run "age-keygen -o ~/.config/sops/age/keys.txt"
    
    # add entry to .sops.yaml, then
    cp protected/example.yaml protected/new-one.yaml
    
    # edit yaml
    nix-shell-p sops --run "sops --config .sops.yaml -i -e protected/new-one.yaml"
    
    # stage new file before running switch
    git add protected/new-one.yaml
    ```
2. Using existing one. If it's `pgp`, then it requires encrypt flag. It can be verified with command like this:
    ```
    nix shell nixpkgs#gnupg -c gpg --list-keys
    ```
    and it is expected to see `E` in square brackets in order to use it for encryption.

3. Deriving it from existing ssh key. Possible only if the ssh key is:
    - `Ed25519` for `age` 
    - `RSA` for `pgp`

  
All the limitations and other details are described [here](https://github.com/Mic92/sops-nix).



