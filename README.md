# ❄️ nix configs ❄️
haha yeah


> [!WARNING]  
> Instructions are for myself. Things probably won't work out of the box.
---
## To switch to this config:
### Clone this repo somewhere
```sh
git clone https://github.com/HiddenAbilitree/nixos-cfg.git
```
If hardware changes, run `sudo nixos-generate-config` and copy `hardware-config.nix` from `/etc/nixos` into the newly cloned repo. 
&nbsp;

### Switch to it 
```sh
nix-rebuild switch --flake /dir/to/flake#hostname
```

 Current valid hostnames are: 
>  loser [fw13]
>
>  winner [bpc]

unfinished
