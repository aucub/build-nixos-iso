{
  description = "NixOS installation media";
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
                isoImage.squashfsCompression = "zstd -Xcompression-level 15";
                boot.kernelPackages = pkgs.linuxPackages_latest;
                boot.supportedFilesystems = lib.mkForce [
                  "bcachefs"
                  "btrfs"
                  "reiserfs"
                  "vfat"
                  "f2fs"
                  "xfs"
                  "ntfs"
                  "cifs"
                ];
                environment.gnome.excludePackages =
                  (with pkgs; [
                    orca
                    tecla
                    gnome-tecla
                    gnome-tour
                    gnome-photos
                    gnome-menus
                    baobab
                    epiphany
                    gnome-connections
                    libsForQt5.qt5ct
                    qt6Packages.qt6ct
                    gnome-console
                  ])
                  ++ (with pkgs.gnome; [
                    gnome-contacts
                    gnome-initial-setup
                    yelp
                    cheese
                    gnome-music
                    gnome-terminal
                    epiphany
                    geary
                    gnome-calendar
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
                programs.seahorse.enable = false;
                programs.gnome-terminal.enable = false;
                programs.file-roller.enable = false;
                services.gnome = {
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
                i18n = {
                  defaultLocale = "zh_CN.UTF-8";
                  supportedLocales = [
                    "zh_CN.UTF-8/UTF-8"
                    "en_US.UTF-8/UTF-8"
                  ];
                  inputMethod = {
                    enabled = "fcitx5";
                    fcitx5 = {
                      addons = with pkgs; [
                        fcitx5-gtk
                        fcitx5-with-addons
                        fcitx5-chinese-addons
                      ];
                      waylandFrontend = true;
                    };
                  };
                };
                environment.systemPackages = with pkgs; [
                  bcachefs-tools
                  btrfs-progs
                  zstd
                ];
              }
            )
          ];
        };
      };
    };
}