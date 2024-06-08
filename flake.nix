{
  description = "NixOS installation media";
  inputs = {
    nixos.url = "nixpkgs/nixos-unstable";
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
  };
  outputs =
    {
      self,
      nixos-cosmic,
      nixos,
    }:
    {
      nixosConfigurations = {
        iso = nixos.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares.nix"
            (
              { pkgs, lib, ... }:
              {
                imports = [ nixos-cosmic.nixosModules.default ];
                nix.settings = {
                  substituters = [
                    "https://cache.nixos.org/"
                    "https://cosmic.cachix.org/"
                  ];
                  trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
                };
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
                    bcachefs-tools
                    btrfs-progs
                    helix
                    zed-editor
                  ];
                };
                programs = {
                  xwayland.enable = false;
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
                  desktopManager.cosmic.enable = true;
                  xserver = {
                    displayManager.gdm.enable = true;
                    excludePackages = with pkgs; [ xterm ];
                  };
                  avahi.enable = false;
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
