{ pkgs, ... }:
{
  imports = [
    ../base
    ../../modules/user/extra/syncthing.nix

    # Files
    ./bitwarden.nix
    ./discord.nix
    ./email.nix
    ./hardware.nix
    ./syncthing.nix
    ./web.nix
    ./znc.nix
  ];

  deployment.targetHost = "root@krake.one";

  environment.systemPackages = with pkgs; [
    rclone
  ];

  # Backup
  services.borgbackup.jobs.main =
    let
      repo = "/var/lib/backup";
    in
    {
      paths = [
        "/var/lib"
        "/home/user"
      ];
      exclude = [ repo ];
      inherit repo;
      encryption.mode = "none";
      startAt = "daily";
      prune.keep = {
        daily = 7;
        weekly = 4;
        monthly = 3;
      };
      postHook = ''
        echo "\$archiveName = $archiveName"
        "${pkgs.rclone}/bin/rclone" sync -v "${repo}" "BackBlaze:jD91mZM2-backups/vultr-main"
        "${pkgs.rclone}/bin/rclone" cleanup -v "BackBlaze:jD91mZM2-backups/vultr-main"
      '';
    };
}
