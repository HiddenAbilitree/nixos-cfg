# ❄️ nix configs ❄️
haha yeah

> [!WARNING]  
> Instructions are for me. Things probably won't work out of the box.

### Installation
go read [nixos-anywhere docs](https://github.com/nix-community/nixos-anywhere/blob/main/docs/quickstart.md)

### Switch to it 
```sh
$ nixos-rebuild switch --flake /flake/dir#hostname --use-remote-sudo
```

 Current valid hostnames are: 
>  loser [fw13]
>
>  winner [bpc]

## Adding a Host 🖥️
Add a new directory in `~/hosts` named the desired hostname.
Init the new host's config using `libx.mkHost` in `~/flake.nix`.
<sub>make sure to disable secure boot on the first switch because lanzaboot requires further setup.</sub>

## Secure Boot 🔒
go read [lanzaboote docs](https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md)
## sops-nix 🔑
to add access to a new system,
first, generate a new age key
```sh
$ mkdir -p ~/.config/sops/age
$ age-keygen -o ~/.config/sops/age/keys.txt
```
add the public key into `~/flake/dir/.sops.yaml`, then run the following:
```sh
$ sops --config ~/flake/dir/.sops.yaml updatekeys ~/flake/dir/home/sops/secrets.yaml
```
<sub>obviously ^ this ^ only works when run on a machine that can decrypt the things already.</sub>

To reference secrets:
in home-manager, use
```nix
{ config, ... }:
...
config.sops.secrets.<name>.path
```
in nixos, use
```nix
{ config, ... }:
...
config.home-manager.users.<user>.sops.secrets.<name>.path
```
