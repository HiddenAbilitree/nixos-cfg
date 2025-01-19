# ❄️ nix configs ❄️
haha yeah

### Installation
go read [nixos-anywhere docs](https://github.com/nix-community/nixos-anywhere/blob/main/docs/quickstart.md)

## Adding a Host 🖥️
Add a new directory in `~/hosts` named the desired hostname.
Init the new host's config using `libx.mkHost` in `~/flake.nix`.
<sub>make sure to disable secure boot on the first switch because lanzaboot requires further setup.</sub>

## Secure Boot 🔒
go read [lanzaboote docs](https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md)
