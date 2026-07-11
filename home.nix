{ config, pkgs, ... }:

{
  home.username = "david";
  home.homeDirectory = "/home/david";
  home.stateVersion = "26.05";
  programs.git.enable = true;
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos, btw";
    };
    profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        exec Hyprland
      fi
    '';
  };

  home.file.".config/hypr" = {
    source = ./config/hypr;
    force = true;
  };
  home.file.".config/waybar" = {
    source = ./config/waybar;
    force = true;
  };
  home.file.".config/foot" = {
    source = ./config/foot;
    force = true;
  };

  home.packages = with pkgs; [
    (pkgs.writeShellApplication {
      name = "ns";
      runtimeInputs = with pkgs; [
        fzf
        nix-search-tv
      ];
      text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
    })
  ];
}
