{ pkgs }: 

pkgs.stdenv.mkDerivation {
  pname = "illogical-impulse-oneui4-icons";
  version = "unstable-2024-01-05"; # Nix 不支持 git 版本号计算，使用日期作为版本
  
  src = pkgs.fetchFromGitHub {
    owner = "end-4";
    repo = "OneUI4-Icons";
    rev = "9ba21908f6e4a8f7c90fbbeb7c85f4975a4d4eb6"; # 你可以更新为最新的 commit
    sha256 = "sha256-f5t7VGPmD+CjZyWmhTtuhQjV87hCkKSCBksJzFa1x1Y="; # 需使用 `nix-prefetch-git` 计算
  };
  
  installPhase = ''
    install -d $out/share/icons
    cp -dr --no-preserve=mode OneUI{,-dark,-light} $out/share/icons/
  '';
  
  meta = {
    description = "A fork of mjkim0727/OneUI4-Icons for illogical-impulse dotfiles.";
    homepage = "https://github.com/end-4/OneUI4-Icons";
    license = pkgs.lib.licenses.gpl3;
    platforms = pkgs.lib.platforms.linux;
  };
}
