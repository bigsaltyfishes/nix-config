{ ... }:
{
  security.sudo.extraConfig = ''
    Defaults env_keep += "*_proxy *_PROXY"
  '';
}
