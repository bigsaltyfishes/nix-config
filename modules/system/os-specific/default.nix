{ lib, system, ... }:
{
  imports = (lib.optionals (system == "x86_64-linux") [
    ./x86_64-linux
  ]) ++ (lib.optionals (system == "x86_64-darwin") [
    ./x86_64-darwin
  ]);
}