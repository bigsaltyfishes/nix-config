{ ... }:
{
  security.sudo-rs = {
    enable = true;
    extraConfig = ''
      Defaults env_keep += "*_proxy *_PROXY"
    '';
  };
}
