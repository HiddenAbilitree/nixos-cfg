# ❄️ nix configs ❄️
haha yeah

## Adding a Host 🖥️

[nixos-anywhere](https://nix-community.github.io/nixos-anywhere/quickstart.html),
[disko](https://github.com/nix-community/disko/blob/master/docs/quickstart.md), and
[lanzaboote](https://nix-community.github.io/lanzaboote/).

init the new host files (run on existing host):

```bash
mkdir -p hosts/<host>/home
cp hosts/winner/disk-config.nix hosts/<host>/
echo "{}" > hosts/<host>/hardware-configuration.nix
echo "{}" > hosts/<host>/home/default.nix
```

put this in `hosts/<host>/default.nix`:

```nix
{
  imports = [
    ./hardware-configuration.nix
    ./disk-config.nix
  ];

  bootx.bootloader.enable = true;
  ssh.enable = true;
}
```

pick the install disk (run on target host):

```bash
lsblk -o NAME,SIZE,MODEL,TYPE
```

then set `device` in `hosts/<host>/disk-config.nix` (on existing host):

```nix
device = "/dev/nvme0n1"; # this disk gets wiped
```

update `flake.nix`:

```nix
<host> = mkHost {
 hostName = "<host>";
 system = "x86_64-linux";
 secureboot = false;
 install = false;
 modulesx = [];
};
```

stage the new files so flakes can see them:

```bash
git add flake.nix hosts/<host>
```

init sops (on existing host):

```bash
mkdir -p ~/nixos-bootstrap/<host>/root
age-keygen -o ~/nixos-bootstrap/<host>/root/keys.txt
chmod 600 ~/nixos-bootstrap/<host>/root/keys.txt
```

add the public key to `.sops.yaml`, then:

```bash
cd ~/code/nix/private-nixos-cfg
sops updatekeys -y nixos/sops/secrets.yaml
```

wireguard (run on existing host):

```bash
mkdir -p ~/nixos-bootstrap/<host>/wireguard
(umask 077; wg genkey > ~/nixos-bootstrap/<host>/wireguard/private)
(umask 077; wg genpsk > ~/nixos-bootstrap/<host>/wireguard/psk)
wg pubkey < ~/nixos-bootstrap/<host>/wireguard/private
```

add the public key to `nixos-modules/wireguard/default.nix`, then add `wg-<host>-private-key` and `wg-<host>-psk` to private config secrets

add both to private config `nixos/sops/default.nix` with `owner = "systemd-network";`

then set `wireguard.enable = true`.

then commit and update this flake.

nixos-anywhere:

```bash
cd ~/code/nix/nixos-cfg
git add -A
nix run github:nix-community/nixos-anywhere -- --extra-files ~/nixos-bootstrap/<host> --generate-hardware-config nixos-generate-config ./hosts/<host>/hardware-configuration.nix --flake .#<host> --target-host root@<ip>
```

secure boot:

```bash
sudo sbctl create-keys
```

set `secureboot = true`

then rebuild:

```bash
ns
```

then follow [lanzaboote docs](https://nix-community.github.io/lanzaboote/getting-started/enable-secure-boot.html)
