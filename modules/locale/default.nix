{ config, pkgs, ... }:
{
  i18n = {
    defaultLocale = "zh_CN.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "zh_CN.UTF-8";
    };
    supportedLocales = [ "en_US.UTF-8/UTF-8" "zh_CN.UTF-8/UTF-8" ];
    inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ libpinyin ];
    };
  };

  time.timeZone = "Asia/Shanghai";

  fonts = {
    packages = (with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      source-code-pro
      source-han-mono
      source-han-sans
      source-han-serif
      hack-font
      jetbrains-mono
      nerdfonts
      wqy_zenhei
    ]) ++ [ config.nur.repos.rewine.ttf-wps-fonts ];

    fontDir.enable = true;

    fontconfig = {
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [
          "Noto Sans Mono CJK SC"
          "Sarasa Mono SC"
          "DejaVu Sans Mono"
        ];
        sansSerif = [
          "Noto Sans CJK SC"
          "Source Han Sans SC"
          "DejaVu Sans"
        ];
        serif = [
          "Noto Serif CJK SC"
          "Source Han Serif SC"
          "DejaVu Serif"
        ];
      };
    };
  };

  # Extra
  system.fsPackages = [ pkgs.bindfs ];
  fileSystems =
    let
      mkRoSymBind = path: {
        device = path;
        fsType = "fuse.bindfs";
        options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
      };
      aggregatedIcons = pkgs.buildEnv {
        name = "system-icons";
        paths = with pkgs; [
          #libsForQt5.breeze-qt5  # for plasma
          gnome.gnome-themes-extra
        ];
        pathsToLink = [ "/share/icons" ];
      };
      aggregatedFonts = pkgs.buildEnv {
        name = "system-fonts";
        paths = config.fonts.packages;
        pathsToLink = [ "/share/fonts" ];
      };
    in
    {
      "/usr/share/icons" = mkRoSymBind "${aggregatedIcons}/share/icons";
      "/usr/local/share/fonts" = mkRoSymBind "${aggregatedFonts}/share/fonts";
    };

  systemd.user.services.link-fonts = {
    description = "Create symbolic link for fonts";
    wantedBy = [ "default.target" "graphical-session.target" ];
    before = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStartPre = ''
        ${pkgs.bash}/bin/bash -c "${pkgs.coreutils}/bin/test ! -e %h/.local/share && ${pkgs.coreutils}/bin/mkdir -p %h/.local/share || ${pkgs.coreutils}/bin/true"
      '';
      ExecStart = ''
        ${pkgs.bash}/bin/bash -c "${pkgs.coreutils}/bin/test ! -e %h/.local/share/fonts && ${pkgs.coreutils}/bin/ln -s /run/current-system/sw/share/X11/fonts %h/.local/share/fonts || ${pkgs.coreutils}/bin/true"
      '';
    };
  };
}
