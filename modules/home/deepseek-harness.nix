{ pkgs, ... }:

{
  home.packages = [ (pkgs.callPackage ../../packages/deepseek-harness { }) ];
}
