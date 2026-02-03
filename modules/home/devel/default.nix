{
  config,
  lib,
  pkgs,
  osConfig,
  inputs,
  ...
}:
let
  profile = osConfig.molyuu.home-manager.profile;
  pypkgs = config.molyuu.home-manager.python-packages;
in
{
  options.molyuu.home-manager.python-packages = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    default = [ ];
    description = "Python packages to install";
  };

  config =
    lib.mkIf (lib.elem "baseDevel" profile.extraFeatures || lib.elem "full" profile.extraFeatures)
      {
        home.packages = with pkgs; [
          jq
          nixd
          nil
          nixfmt-rfc-style
          (python3.withPackages (p: pypkgs))
          rust-toolchains
          gnumake
          clang
          clang-tools
          lld
          lldb

          android-tools
        ];

        programs.direnv = {
          enable = true;
          enableZshIntegration = true;
        };

        programs.vscode =
          lib.mkIf (lib.elem "extraDevel" profile.extraFeatures || lib.elem "full" profile.extraFeatures)
            {
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
                ])
                ++ (with vscode-marketplace; [
                  jnoortheen.nix-ide
                ]);
            };
      };
}
