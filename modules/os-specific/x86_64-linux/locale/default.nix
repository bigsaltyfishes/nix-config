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
      sarasa-gothic
      noto-fonts-emoji
      source-han-sans
      source-han-serif
      jetbrains-mono
      nerdfonts
    ]) ++ [ config.nur.repos.rewine.ttf-wps-fonts ];

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
}
