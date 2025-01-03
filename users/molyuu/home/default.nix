{ pkgs, lib, system, ... }:
{
  imports = [
    ./baseDevel.nix
    ./extraDevel.nix
  ] ++ (lib.optionals (system == "x86_64-linux") [
    ./extraApps.nix
    ./gaming.nix
  ]);

  home.username = "molyuu";
  home.homeDirectory = if (system == "x86_64-darwin") then "/Users/molyuu" else "/home/molyuu";

  home.packages = with pkgs; [
    gh
    vim
    wget
    fastfetch
    zinit
    nixos-generators
  ];

  programs.git = {
    enable = true;
    userName = "bigsaltyfishes";
    userEmail = "bigsaltyfishes@gmail.com";
  };

  programs.zsh = {
    enable = true;
    initExtra = ''
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

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
