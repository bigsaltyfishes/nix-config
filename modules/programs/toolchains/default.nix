{ pkgs, ... }:
let
  rust = pkgs.rust-bin.stable.latest.default.override {  extensions = [ "rust-src" ];  };
in
{
  environment.systemPackages = [
    rust
  ] ++ (with pkgs; [
    gcc
    gnumake
  ]);
}
