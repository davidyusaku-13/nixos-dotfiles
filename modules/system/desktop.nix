{ config, lib, pkgs, ... }:

{
  hardware.graphics.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  fonts.packages = with pkgs; [
    font-awesome
    nerd-fonts.iosevka
    nerd-fonts.jetbrains-mono
  ];
}