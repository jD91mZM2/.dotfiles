{ pkgs, config, ... }:
let
  dwm = pkgs.callPackage <dotfiles/forks/dwm> {};
in
{
  # Allow hotswitching dwm by quitting it
  xdg.dataFile."bin/dwm" = {
    source = "${dwm}/bin/dwm";
    executable = true;
  };

  # Finally, start BSPWM
  xsession = {
    enable = true;
    pointerCursor = {
      package = pkgs.xorg.xcursorthemes;
      name    = "whiteglass";
      size    = 16;
    };
    windowManager.command = ''
      while true; do
        "''${XDG_DATA_HOME:-$HOME/.local/share}/bin/dwm" || break
      done
    '';
  };

  # Composite manager
  services.picom = {
    enable = true;
    # Apparently, using (intel + xrandr to configure multiple monitors + glx
    # backend) seems to cause all kinds of weird issues.
    backend = "xrender";

    fade        = true;
    fadeDelta   = 5;
    inactiveDim = "0.1";
    shadow      = true;
  };

  # Xresources is kinda cool I guess :)
  xresources = {
    extraConfig = builtins.readFile (pkgs.fetchFromGitHub {
      owner  = "dracula";
      repo   = "xresources";
      rev    = "ca0d05cf2b7e5c37104c6ad1a3f5378b72c705db";

      sha256 = "0ywkf2bzxkr45a0nmrmb2j3pp7igx6qvq6ar0kk7d5wigmkr9m5n";
    } + "/Xresources");
    properties = {
      # Everything
      "*.font" = "Hack:pixelsize=13:antialias=true:autohint=true";

      # XTerm stuff
      "XTerm.termName"          = "xterm-256color";
      "XTerm.vt100.faceName"    = "Hack:size =10";
      "XTerm*decTerminalID"     = "vt340";
      "XTerm*numColorRegisters" = 256;
    };
  };

  # GTK+ theme
  gtk = {
    enable = true;
    font = {
      name    = "Cantarell 11";
      package = pkgs.cantarell-fonts;
    };
    iconTheme = {
      name    = "Yaru";
      package = pkgs.yaru-dracula-theme;
    };
    theme = {
      name    = "Yaru-dark";
      package = pkgs.yaru-dracula-theme;
    };
  };

  # QT theme
  qt = {
    enable = true;
    platformTheme = "gtk";
  };
}