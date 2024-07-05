{ lib, pkgs, inputs, osConfig, ... }:
let
  profile = osConfig.molyuu.home-manager.profile;
in
{
  imports = [
    ../../../overlays/default.nix
  ];

  config = lib.mkIf (lib.elem "extraDevel" profile.extraFeatures || lib.elem "full" profile.extraFeatures) {
    programs.vscode = {
      enable = true;
      extensions =
        let
          inherit (inputs.nix-vscode-extensions.extensions.${pkgs.system}) vscode-marketplace;
        in
        (with pkgs.vscode-extensions; [
          eamodio.gitlens
          ms-vscode.cpptools-extension-pack
          ms-python.python
          rust-lang.rust-analyzer
          github.copilot
          github.copilot-chat
          ms-ceintl.vscode-language-pack-zh-hans
        ]) ++ (with vscode-marketplace; [
          jnoortheen.nix-ide
        ]);
    };
  };
}
