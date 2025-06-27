### Prerequisites

#### Nix

Ensure you have the _Nix_ installed.

> [!TIP]
> For macos one can use either official, vanilla _Nix_ installer, or the Determinate installer.> In case of the latter, use the CLI installer and make sure to deny managing the _Nix_ by the determinate deamon, like:
>
> ```shell
> Selecting 'no' will install Nix from NixOS instead.
> Proceed? ([Y]es/[n]o/[e]xplain): n
> ```
>
> because otherwise it may lead to some darwin compatibility issues.

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

### Init

```shell
git clone https://github.com/frankiewiczkamil/nix-config.git
```

```shell

set -a && source .env && set +a

sudo -E nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake ./mac#spaceship --show-trace --impure

# ./mac#linux-builder | ./mac#chariot | ...
```

### Update packages

Refresh available dependencies:

```shell
nix flake update --flake ./mac
```

Apply newest dependencies

```shell
sudo -E darwin-rebuild switch --flake ./mac#spaceship --show-trace --impure

# ./mac#linux-builder | ./mac#chariot | ...
```
