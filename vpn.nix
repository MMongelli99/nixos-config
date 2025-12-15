{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ openconnect ];
  programs.bash.shellAliases."vpn" =
    "sudo openconnect --protocol=anyconnect vpn.csanalytical.com:556";
}
