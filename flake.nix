{
  description = "NixOS media";
  inputs.nixos.url = "nixpkgs/nixos-unstable";
  outputs =
    { self, nixos }:
    {
      nixosConfigurations = {
        iso = nixos.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix"
            (
              { pkgs, lib, ... }:
              {
                isoImage.squashfsCompression = "zstd -Xcompression-level 22";
                boot = {
                  plymouth.enable = lib.mkForce false;
                  kernelPackages = pkgs.linuxPackages_latest;
                  supportedFilesystems = lib.mkForce [
                    "bcachefs"
                    "btrfs"
                    "reiserfs"
                    "vfat"
                    "f2fs"
                    "xfs"
                    "ntfs"
                    "cifs"
                  ];
                };
                environment = {
                  gnome.excludePackages =
                    (with pkgs; [
                      snapshot
                      loupe
                      orca
                      gnome-tecla
                      gnome-tour
                      gnome-photos
                      gnome-menus
                      baobab
                      epiphany
                      gnome-connections
                      libsForQt5.qt5ct
                      qt6Packages.qt6ct
                      gnome-text-editor
                    ])
                    ++ (with pkgs.gnome; [
                      gnome-contacts
                      gnome-initial-setup
                      yelp
                      cheese
                      gnome-music
                      gnome-terminal
                      gnome-font-viewer
                      gnome-tweaks
                      dconf-editor
                      epiphany
                      geary
                      gnome-calendar
                      gnome-calculator
                      gnome-color-manager
                      gnome-clocks
                      gnome-characters
                      gnome-maps
                      gnome-weather
                      gnome-software
                      simple-scan
                      totem
                      tali
                      iagno
                      hitori
                      atomix
                      file-roller
                      seahorse
                    ]);
                  variables = {
                    EDITOR = "hx";
                    QT_IM_MODULE = "fcitx";
                    XMODIFIERS = "@im=fcitx";
                    SDL_IM_MODULE = "fcitx";
                    GLFW_IM_MODULE = "ibus";
                  };
                  shells = with pkgs; [
                    bashInteractive
                    fish
                  ];
                  systemPackages = with pkgs; [
                    gnome-console
                    bcachefs-tools
                    btrfs-progs
                    helix
                  ];
                };
                programs = {
                  xwayland.enable = false;
                  command-not-found.enable = false;
                  seahorse.enable = false;
                  gnome-terminal.enable = false;
                  file-roller.enable = false;
                  fish = {
                    enable = true;
                    interactiveShellInit = ''
                      set -U fish_greeting
                    '';
                  };
                  neovim.enable = false;
                };
                services = {
                  gnome = {
                    at-spi2-core.enable = lib.mkForce false;
                    gnome-user-share.enable = false;
                    gnome-online-accounts.enable = false;
                    gnome-browser-connector.enable = false;
                    gnome-initial-setup.enable = false;
                    gnome-online-miners.enable = lib.mkForce false;
                    games.enable = false;
                    tracker.enable = false;
                    tracker-miners.enable = false;
                    rygel.enable = false;
                    gnome-remote-desktop.enable = false;
                    evolution-data-server.enable = lib.mkForce false;
                  };
                  avahi.enable = false;
                  xserver.excludePackages = with pkgs; [ xterm ];
                  kmscon = {
                    enable = true;
                    fonts = [
                      {
                        name = "Noto Sans CJK SC";
                        package = pkgs.noto-fonts-cjk-sans;
                      }
                    ];
                    extraOptions = "--term xterm-256color";
                    extraConfig = "font-size=20";
                    hwRender = true;
                  };
                };
                fonts = {
                  enableDefaultPackages = false;
                  packages = with pkgs; [
                    noto-fonts
                    noto-fonts-cjk-sans
                  ];
                  fontconfig = {
                    enable = true;
                    defaultFonts = {
                      sansSerif = [ "Noto Sans CJK SC" ];
                      monospace = [ "Noto Sans CJK SC" ];
                    };
                  };
                };
                i18n = {
                  defaultLocale = "zh_CN.UTF-8";
                  supportedLocales = [
                    "zh_CN.UTF-8/UTF-8"
                    "en_US.UTF-8/UTF-8"
                  ];
                  inputMethod = {
                    enabled = "fcitx5";
                    fcitx5 = {
                      addons = with pkgs; [ fcitx5-chinese-addons ];
                    };
                  };
                };
                sound.enable = lib.mkForce false;
                networking.firewall.enable = false;
                hardware = {
                  enableAllFirmware = false;
                  pulseaudio.enable = lib.mkForce false;
                };
                documentation.enable = false;
              }
            )
          ];
        };
      };
    };
}
