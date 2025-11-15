{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.applications.ghostty;
  wrappedGhostty = config.lib.nixGL.wrap pkgs.ghostty;
in {
  options.features.desktop.applications.ghostty = {
    enable = mkEnableOption "Enable ghostty configuration.";
    nixGL = mkEnableOption "Whether or not to wrap ghostty with nixGL.";
    opacity = mkOption {
      type = types.float;
      default = 1.0;
      example = 0.9;
      description = "Set window opacity.";
    };
    shader = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = ../assets/shaders/starfield-colors.glsl;
      description = "Set custom shader from glsl file.";
    };
    windowDecoration = mkEnableOption "Whether or not to enable window decorations";
  };

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      package =
        if cfg.nixGL
        then wrappedGhostty
        else pkgs.ghostty;
      settings =
        {
          window-decoration = cfg.windowDecoration;
          background-opacity = cfg.opacity;
        }
        // lib.optionalAttrs (config.colorScheme or null != null) {
          background = config.colorScheme.palette.base00;
          foreground = config.colorScheme.palette.base05;

          # Palette as a list
          palette = [
            "0=${config.colorScheme.palette.base00}"
            "1=${config.colorScheme.palette.base08}"
            "2=${config.colorScheme.palette.base0B}"
            "3=${config.colorScheme.palette.base0A}"
            "4=${config.colorScheme.palette.base0D}"
            "5=${config.colorScheme.palette.base0E}"
            "6=${config.colorScheme.palette.base0C}"
            "7=${config.colorScheme.palette.base05}"
            "8=${config.colorScheme.palette.base03}"
            "9=${config.colorScheme.palette.base08}"
            "10=${config.colorScheme.palette.base0B}"
            "11=${config.colorScheme.palette.base0A}"
            "12=${config.colorScheme.palette.base0D}"
            "13=${config.colorScheme.palette.base0E}"
            "14=${config.colorScheme.palette.base0C}"
            "15=${config.colorScheme.palette.base07}"
          ];
        }
        // lib.optionalAttrs (cfg.shader != builtins.null) {
          custom-shader = builtins.toString cfg.shader;
          custom-shader-animation = "always";
        };
    };

    xdg.desktopEntries.ghostty = mkIf cfg.nixGL {
      name = "Ghostty";
      genericName = "Terminal";
      exec = "${wrappedGhostty}/bin/ghostty";
      terminal = false;
      categories = ["System" "TerminalEmulator"];
      icon = "com.mitchellh.ghostty";
    };
  };
}
