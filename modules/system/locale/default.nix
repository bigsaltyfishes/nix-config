{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.molyuu.i18n.inputMethod;
in
{
  options.molyuu.i18n.inputMethod = {
    ibus.enable = lib.mkEnableOption "Enable IBus and set as default input method";
    fcitx5.enable = lib.mkEnableOption "Enable Fcitx5 and set as default input method";
  };

  config = {
    i18n = {
      defaultLocale = "zh_CN.UTF-8";
      extraLocaleSettings = {
        LC_TIME = "zh_CN.UTF-8";
      };
      supportedLocales = [
        "en_US.UTF-8/UTF-8"
        "zh_CN.UTF-8/UTF-8"
      ];
      inputMethod =
        {
          enable = cfg.ibus.enable || cfg.fcitx5.enable;
        }
        // (
          if cfg.ibus.enable then
            {
              type = "ibus";
              ibus.engines = with pkgs.ibus-engines; [ libpinyin ];
            }
          else if cfg.fcitx5.enable then
            {
              type = "fcitx5";
              fcitx5.waylandFrontend = true;
              fcitx5.addons = with pkgs; [
                fcitx5-gtk
                fcitx5-chinese-addons
              ];
            }
          else
            { }
        );
    };

    time.timeZone = "Asia/Shanghai";

    fonts = {
      packages = with pkgs; [
        sarasa-gothic
        noto-fonts-emoji
        source-han-sans
        source-han-serif
        jetbrains-mono
        nerd-fonts.meslo-lg
        nur.repos.rewine.ttf-wps-fonts
      ];

      fontconfig = {
        defaultFonts = {
          emoji = [ "Noto Color Emoji" ];
          monospace = [
            "Sarasa Mono SC"
          ];
          sansSerif = [
            "Source Han Sans SC"
          ];
          serif = [
            "Source Han Serif SC"
          ];
        };
        cache32Bit = true;
      };
    };
  };
}
