{ config, lib, pkgs, ...}:

with lib; let
  cfg = config.features.desktop.fonts;
in
{
  options.features.desktop.fonts.enable =
    mkEnableOption "install additional fonts for desktop apps";

  config = mkIf cfg.enable {
    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
        sansSerif = [ "Noto Sans" ];
        serif = [ "Noto Serif" ];
      };
    };

    home.packages = with pkgs; [
      fontconfig
      fira-code
      fira-code-symbols
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      font-manager
      font-awesome_5
      font-awesome
      noto-fonts-emoji
      noto-fonts
      jetbrains-mono
    ];
  };
}
