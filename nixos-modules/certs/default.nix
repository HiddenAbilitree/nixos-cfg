{
  pkgs,
  config,
  ...
}: {
  security.pki.certificateFiles = [
    ./caddy-ca-cert.crt
  ];
  system.activationScripts.chromeCerts = ''
    mkdir -p /home/ezhang/.pki/nssdb
    ${pkgs.nssTools}/bin/certutil -d sql:/home/ezhang/.pki/nssdb -A -t "C,," -n "Caddy Local CA" -i ${config.sops.secrets.caddy-ca-cert.path} 2>/dev/null || true
  '';
}
