{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.environments.gnome;
in {
  imports = [./gnome-shell.nix ./gtk.nix];

  options.features.desktop.environments.gnome = {
    enable = mkEnableOption "Enable GNOME configuration.";
    background = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = ../assets/wallpaper.jpeg;
      description = "Set desktop wallpaper.";
    };
    backgroundDark = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = ../assets/wallpaperDark.jpeg;
      description = "Set desktop dark wallpaper.";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs.gnomeExtensions; [
      just-perfection
      vitals
      pop-shell
      blur-my-shell
    ];

    dconf.settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          "just-perfection-desktop@just-perfection"
          "pop-shell@system76.com"
          "Vitals@CoreCoding.com"
          "blur-my-shell@aunetx"
          "user-theme@gnome-shell-extensions.gcampax.github.com"
        ];
      };

      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "Adwaita-dark";
      };

      "org/gnome/desktop/background" = mkIf (cfg.background != null && cfg.backgroundDark != null) {
        picture-uri = builtins.toString cfg.background;
        picture-uri-dark = builtins.toString cfg.backgroundDark;
      };

      "org/gnome/mutter" = {
        overlay-key = "Super_L";
        workspaces-only-on-primary = false;
      };

      "org/gnome/mutter/keybindings" = {
        toggle-tiled-left = ["@as []"]; # Disable to avoid conflict with focus-left
        toggle-tiled-right = ["@as []"]; # Disable to avoid conflict with focus-right
      };

      "org/gnome/shell/extensions/just-perfection" = {
        dash = false; # Dash/sidebar
        workspace-switcher-should-show = true;
        workspace-popup = true;
        panel = true; # Top bar
        activities-button = true;
        app-menu = false;
      };

      "org/gnome/shell/extensions/pop-shell" = {
        tile-by-default = true;
        active-hint = true;
        active-hint-border-radius = 4;
        smart-gaps = true;
        gap-inner = 4;
        gap-outer = 4;
        show-title = false;
        focus-left = ["<Super>Left"];
        focus-right = ["<Super>Right"];
        focus-up = ["<Super>Up"];
        focus-down = ["<Super>Down"];
        float-window-exceptions = [];
      };

      "org/gnome/shell/extensions/blur-my-shell/panel" = {
        blur = true;
        static-blur = true;
        unblur-in-overview = false;
        customize = true;
        override-background = true;
      };

      "org/gnome/desktop/wm/keybindings" = {
        switch-to-workspace-left = ["<Super><Control>Left"];
        switch-to-workspace-right = ["<Super><Control>Right"];
        switch-to-workspace-up = ["<Super><Control>Up"];
        switch-to-workspace-down = ["<Super><Control>Down"];
        close = ["<Super>q"];
        toggle-maximized = ["<Super>f"];
        maximize = ["@as []"]; # Disable to avoid conflict with focus-up
        unmaximize = ["@as []"]; # Disable to avoid conflict with focus-down
      };

      "org/gnome/shell/keybindings" = {
        focus-active-notification = ["@as []"]; # Disable to avoid conflicts
        toggle-application-view = ["<Super>a"]; # Show app grid
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        ];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        name = "Open Ghostty Terminal";
        command = "ghostty";
        binding = "<Super>t";
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        name = "Open Obsidian";
        command = "obsidian";
        binding = "<Super>n";
      };
    };
  };
}