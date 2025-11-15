{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.applications.obsidian;

  # Wrap Obsidian to disable SUID sandbox and use namespace sandbox instead
  obsidianNoSandbox = pkgs.writeShellScriptBin "obsidian" ''
    exec ${pkgs.obsidian}/bin/obsidian --no-sandbox "$@"
  '';

  wrappedObsidian = config.lib.nixGL.wrap obsidianNoSandbox;
in {
  options.features.desktop.applications.obsidian = {
    enable = mkEnableOption "Enable obsidian configuration.";
    nixGL = mkEnableOption "Whether or not to wrap obsidian with nixGL.";
  };

  config = mkIf cfg.enable {
    home.packages = [
      (
        if cfg.nixGL
        then wrappedObsidian
        else pkgs.obsidian
      )
    ];

    xdg.desktopEntries.obsidian = mkIf cfg.nixGL {
      name = "Obsidian";
      genericName = "Note Taking";
      exec = "${wrappedObsidian}/bin/obsidian";
      terminal = false;
      categories = ["Office" "TextEditor"];
      icon = "obsidian";
    };
  };
}
