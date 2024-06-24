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
            "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-graphical-base.nix"
            (
              { pkgs, lib, ... }:
              {
                isoImage = {
                  edition = "xfce";
                  squashfsCompression = "zstd -Xcompression-level 22";
                };
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
                  xfce.excludePackages = with pkgs.xfce; [
                    parole
                    xfce4-taskmanager
                    xfce4-terminal
                  ];
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
                  systemPackages =
                    with pkgs;
                    [
                      gnome-console
                      bcachefs-tools
                      btrfs-progs
                      helix
                      zed-editor
                    ]
                    ++ (with pkgs.gnome; [
                      gnome-system-monitor
                      nautilus
                    ]);
                };
                programs = {
                  thunar.enable = lib.mkForce false;
                  command-not-found.enable = false;
                  fish = {
                    enable = true;
                    interactiveShellInit = ''
                      set -U fish_greeting
                    '';
                  };
                  neovim.enable = false;
                };
                services = {
                  avahi.enable = false;
                  xserver = {
                    desktopManager.xfce.enable = true;
                    displayManager = {
                      autoLogin = {
                        enable = true;
                        user = "nixos";
                      };
                      gdm.enable = true;
                    };
                    excludePackages = with pkgs; [ xterm ];
                  };
                  kmscon = {
                    enable = true;
                    fonts = [
                      {
                        name = "Noto Sans CJK SC";
                        package = pkgs.noto-fonts-cjk-sans;
                      }
                    ];
                    extraOptions = "--term xterm-256color";
                    extraConfig = "font-size=14";
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
                xdg.mime.addedAssociations = {
                  "text/plain" = "dev.zed.Zed.desktop";
                  "inode/directory" = "dev.zed.Zed.desktop";
                };
              }
            )
          ];
        };
      };
    };
}
