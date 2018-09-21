{ pkgs, ... }:
let
  unstable = import <nixos-unstable> {
    config.allowUnfreePredicate = (p: pkgs.lib.hasPrefix "steam" p.name);
  };
in {
  environment.systemPackages = with pkgs; [
    # Graphical - Look & Feel
    adapta-backgrounds
    adapta-gtk-theme
    libsForQt5.qtstyleplugins # uniform QT/GTK look
    numix-icon-theme
    numix-icon-theme-circle
    xorg.xcursorthemes

    # Graphical - System
    compton
    dmenu
    dunst
    j4-dmenu-desktop
    networkmanagerapplet
    ## XFCE Panel
    xfce.exo
    xfce.xfce4-battery-plugin
    xfce.xfce4-pulseaudio-plugin
    xfce.xfce4panel_gtk3
    xfce.xfconf

    # Graphical - Applications
    chromium
    duplicity
    firefox
    gimp
    liferea
    mpv
    multimc
    obs-studio
    pavucontrol
    thunderbird
    unstable.keepassxc
    unstable.steam
    virtmanager
    xfce.thunar
    xfce.xfce4-power-manager
    (unstable.st.override {
      conf = builtins.readFile (substituteAll {
        src = ./st/config.h;
        colorscheme = builtins.readFile (fetchFromGitHub {
          owner = "honza";
          repo = "base16-st";
          rev = "b3d0d4fbdf86d9b3eda06f42a5bdf261b1f7d1d1";

          sha256 = "1z08abn9g01nnr1v4m4p8gp1j8cwlvcadgpjb7ngjy8ghrk8g0sh";
        } + "/build/base16-default-dark-theme.h");
        shell = ./st/tmux.sh;
      });
    })

    # Graphical - Utils
    feh
    gnome3.zenity
    maim
    xorg.xev

    # Applications
    asciinema
    borgbackup
    grml-zsh-config
    ncdu
    rclone
    tmux
    unstable.neovim
    weechat

    # Utils
    androidsdk
    ascii
    autojump
    bind
    binutils
    efibootmgr
    fd
    ffmpeg
    file
    gist
    git
    gitAndTools.hub
    gnupg
    htop
    httpie
    manpages
    neofetch
    nix-index
    patchelf
    ripgrep
    socat
    sshfs
    trash-cli
    tree
    units
    unzip
    wget
    xclip
    xdotool
    youtube-dl
    zip

    # Languages
    cabal-install
    cmake
    gcc
    gdb
    ghc
    gnumake
    python
    ruby
    rustup
    unstable.cargo-edit
    unstable.cargo-release
    unstable.cargo-tree

    # Daemons
    udiskie
  ];
  fonts.fonts = with pkgs; [
    cantarell-fonts
    font-awesome-ttf
    hack-font
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
  ];
}
