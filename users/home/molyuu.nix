{ lib, pkgs, inputs, osConfig, ... }:
let
  profile = osConfig.molyuu.system.profile;
in
{
  imports = [
    ../../overlays/default.nix
  ];
  
  home.username = "molyuu";
  home.homeDirectory = "/home/molyuu";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];

  home.packages = with pkgs; [
    nixd
    nixpkgs-fmt
    vim
    wget
    lshw
    neofetch
    zinit
    python3
    glxinfo
  ] ++ (if (profile.select == "full") then (with pkgs; [
    spotify
    google-chrome
    wpsoffice-cn
    wechat-uos
    clash-verge-rev
  ]) else [ ]);

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

  programs.vscode = lib.mkIf (profile.select == "full") {
    enable = true;
    extensions =
      let
        inherit (inputs.nix-vscode-extensions.extensions.${pkgs.system}) vscode-marketplace;
      in
      with vscode-marketplace; [
        eamodio.gitlens
        ms-vscode.cpptools-extension-pack
        ms-python.python
        rust-lang.rust-analyzer
        jnoortheen.nix-ide
        codeium.codeium
        ms-ceintl.vscode-language-pack-zh-hans
      ];
  };

  home.stateVersion = "23.11";

  programs.home-manager.enable = true;
}
