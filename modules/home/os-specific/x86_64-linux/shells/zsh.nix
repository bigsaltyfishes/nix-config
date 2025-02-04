{ osConfig, pkgs, lib, ... }:
let
  cfg = osConfig.molyuu.home-manager.profile.shell;
in
{
  programs.zsh = lib.mkIf (cfg == "zsh") {
    enable = true;
    initExtra = ''
      export PATH=$HOME/.cargo/bin:$PATH
      source ${pkgs.zinit}/share/zinit/zinit.zsh
      zinit ice depth=1; zinit light romkatv/powerlevel10k

      zinit light zsh-users/zsh-completions
      zinit light zsh-users/zsh-autosuggestions
      zinit light zsh-users/zsh-history-substring-search
      zinit light zdharma-continuum/fast-syntax-highlighting

      zinit snippet OMZ::lib/completion.zsh
      zinit snippet OMZ::lib/history.zsh
      zinit snippet OMZ::lib/key-bindings.zsh
      zinit snippet OMZ::lib/theme-and-appearance.zsh

      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down

      zinit load djui/alias-tips

      if [[ -f ~/.p10k.zsh ]]; then
          source ~/.p10k.zsh
      fi
    '';
  };
}