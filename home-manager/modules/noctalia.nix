{ config, pkgs, ... }: {

  nixpkgs.overlays = [
    (final: prev: {
      noctalia = config.lib.pamShim.replacePam prev.noctalia;
    })
  ];

  home.packages = [
    pkgs.noctalia
  ];

  systemd.user.services.noctalia-shell = {
    Unit = {
      Description = "Noctalia";
      After = [ "graphical-session.target" ];
    };
    Service = {
      # evaluates to the patched binary version pointing to Ubuntu's native PAM
      ExecStart = "${pkgs.noctalia}/bin/noctalia";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
