{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.features.desktop.environments.gnome;

  # Helper to add # prefix to hex colors for CSS
  mkColor = color: "#${color}";
  mkColorRgba = color: alpha: "rgba(${builtins.substring 0 2 color}, ${builtins.substring 2 2 color}, ${builtins.substring 4 2 color}, ${alpha})";

  # Map base16 colors to semantic names (only if colorScheme is available)
  colors = lib.optionalAttrs (config.colorScheme or null != null) (with config.colorScheme.palette; {
    bg = mkColor base00;
    bg1 = mkColor base01;
    bg2 = mkColor base02;
    bg3 = mkColor base03;

    fg = mkColor base05;
    fg_dim = mkColor base04;
    fg_bright = mkColor base06;

    red = mkColor base08;
    orange = mkColor base09;
    yellow = mkColor base0A;
    green = mkColor base0B;
    cyan = mkColor base0C;
    blue = mkColor base0D;
    purple = mkColor base0E;
    brown = mkColor base0F;

    # RGBA variants for transparency
    bg_alpha_50 = "rgba(${builtins.substring 0 2 base00}, ${builtins.substring 2 2 base00}, ${builtins.substring 4 2 base00}, 0.5)";
    bg_alpha_80 = "rgba(${builtins.substring 0 2 base00}, ${builtins.substring 2 2 base00}, ${builtins.substring 4 2 base00}, 0.8)";
    bg_alpha_90 = "rgba(${builtins.substring 0 2 base00}, ${builtins.substring 2 2 base00}, ${builtins.substring 4 2 base00}, 0.9)";
  });

  # GNOME Shell CSS theme (only if colorScheme is available)
  shellCss = lib.optionalString (config.colorScheme or null != null) ''
    /* ===================================================================
     * GNOME Shell Theme - Powered by nix-colors
     * Base16 Color Scheme: ${config.colorScheme.name}
     * =================================================================== */

    /* Stage (root element) */
    stage {
      color: ${colors.fg};
    }

    /* Panel (top bar) */
    #panel {
      background-color: transparent;
      color: ${colors.fg};
      height: 32px;
    }

    .panel-corner {
      -panel-corner-background-color: transparent;
    }

    .panel-button {
      color: ${colors.fg};
      font-weight: bold;
      padding: 0 12px;
    }

    .panel-button:hover {
      background-color: ${colors.bg2};
      color: ${colors.fg_bright};
    }

    .panel-button:active,
    .panel-button:focus,
    .panel-button:checked {
      background-color: ${colors.bg3};
      color: ${colors.fg_bright};
    }

    /* Overview (activities overview) */
    .overview {
      background-color: ${colors.bg_alpha_90};
    }

    /* Dash (application launcher) */
    #dash {
      background-color: ${colors.bg1};
      border-radius: 8px;
      padding: 8px 0;
    }

    .dash-item-container .app-well-app,
    .dash-item-container .show-apps {
      padding: 6px;
    }

    .dash-item-container .app-well-app:hover,
    .dash-item-container .show-apps:hover {
      background-color: ${colors.bg2};
      border-radius: 8px;
    }

    /* App Grid */
    .app-well-app {
      background-color: transparent;
      border-radius: 8px;
    }

    .app-well-app:hover {
      background-color: ${colors.bg2};
    }

    .app-well-app:active,
    .app-well-app:checked {
      background-color: ${colors.bg3};
    }

    /* Search */
    .search-entry {
      background-color: ${colors.bg1};
      color: ${colors.fg};
      border-color: ${colors.bg2};
      border-radius: 8px;
      padding: 8px 12px;
    }

    .search-entry:focus {
      border-color: ${colors.blue};
    }

    /* Workspace Switcher */
    .workspace-thumbnails {
      background-color: ${colors.bg1};
      border-radius: 8px;
      padding: 8px;
    }

    .workspace-thumbnail {
      border: 2px solid transparent;
      border-radius: 4px;
    }

    .workspace-thumbnail:hover {
      border-color: ${colors.bg3};
    }

    .workspace-thumbnail:active {
      border-color: ${colors.blue};
    }

    /* Window Picker */
    .window-clone {
      background-color: ${colors.bg1};
      border: 2px solid ${colors.bg2};
      border-radius: 8px;
    }

    .window-clone:hover {
      border-color: ${colors.blue};
    }

    /* Notifications */
    .notification-banner {
      background-color: ${colors.bg1};
      color: ${colors.fg};
      border: 1px solid ${colors.bg2};
      border-radius: 8px;
      padding: 12px;
    }

    .notification-banner:hover {
      background-color: ${colors.bg2};
    }

    /* Message List (calendar/notifications dropdown) */
    .message-list {
      background-color: ${colors.bg1};
      border-radius: 8px;
    }

    .message {
      background-color: ${colors.bg};
      border: 1px solid ${colors.bg2};
      border-radius: 6px;
      margin: 4px;
    }

    .message:hover {
      background-color: ${colors.bg2};
    }

    /* Quick Settings (system menu) */
    .quick-settings {
      background-color: ${colors.bg1};
      border-radius: 12px;
      padding: 12px;
    }

    .quick-settings-system-item {
      background-color: ${colors.bg};
      border-radius: 8px;
      padding: 8px;
    }

    .quick-settings-system-item:hover {
      background-color: ${colors.bg2};
    }

    .quick-toggle {
      background-color: ${colors.bg};
      border-radius: 8px;
      padding: 8px;
    }

    .quick-toggle:hover {
      background-color: ${colors.bg2};
    }

    .quick-toggle:checked {
      background-color: ${colors.blue};
      color: ${colors.bg};
    }

    /* Buttons */
    .button {
      background-color: ${colors.bg2};
      color: ${colors.fg};
      border: 1px solid ${colors.bg3};
      border-radius: 6px;
      padding: 8px 16px;
    }

    .button:hover {
      background-color: ${colors.bg3};
      color: ${colors.fg_bright};
    }

    .button:active,
    .button:focus {
      background-color: ${colors.blue};
      color: ${colors.bg};
      border-color: ${colors.blue};
    }

    /* Dialog boxes */
    .modal-dialog {
      background-color: ${colors.bg1};
      color: ${colors.fg};
      border: 1px solid ${colors.bg2};
      border-radius: 12px;
      padding: 16px;
    }

    .modal-dialog-content-box {
      padding: 16px;
    }

    /* Popup menus */
    .popup-menu {
      background-color: ${colors.bg1};
      border: 1px solid ${colors.bg2};
      border-radius: 8px;
      padding: 4px;
    }

    .popup-menu-item {
      padding: 8px 12px;
      border-radius: 4px;
    }

    .popup-menu-item:hover {
      background-color: ${colors.bg2};
      color: ${colors.fg_bright};
    }

    .popup-menu-item:active {
      background-color: ${colors.blue};
      color: ${colors.bg};
    }

    /* Switches */
    .toggle-switch {
      background-color: ${colors.bg2};
      border-radius: 12px;
      width: 48px;
      height: 24px;
    }

    .toggle-switch:checked {
      background-color: ${colors.blue};
    }

    /* Sliders */
    .slider {
      -barlevel-active-background-color: ${colors.blue};
      -barlevel-inactive-background-color: ${colors.bg2};
      -barlevel-overdrive-color: ${colors.red};
    }

    /* OSD (On-Screen Display) */
    .osd-window {
      background-color: ${colors.bg1};
      border: 1px solid ${colors.bg2};
      border-radius: 12px;
      padding: 24px;
    }

    .osd-monitor-label {
      color: ${colors.fg};
    }

    /* Screenshots UI */
    .screenshot-ui-panel {
      background-color: ${colors.bg1};
      border-radius: 12px;
      padding: 12px;
    }

    /* Looking Glass (Alt+F2 debugger) */
    .lg-dialog {
      background-color: ${colors.bg};
      color: ${colors.fg};
      border: 2px solid ${colors.bg2};
      border-radius: 8px;
    }

    .lg-completions-text {
      color: ${colors.fg_dim};
    }

    /* Scrollbars */
    StScrollBar {
      padding: 0;
    }

    StScrollView.vfade {
      -st-vfade-offset: 32px;
    }

    StScrollView.hfade {
      -st-hfade-offset: 32px;
    }

    StScrollBar StButton#vhandle,
    StScrollBar StButton#hhandle {
      background-color: ${colors.bg3};
      border-radius: 8px;
    }

    StScrollBar StButton#vhandle:hover,
    StScrollBar StButton#hhandle:hover {
      background-color: ${colors.fg_dim};
    }

    /* Links */
    .shell-link {
      color: ${colors.blue};
    }

    .shell-link:hover {
      color: ${colors.cyan};
    }
  '';
in {
  config = mkIf cfg.enable (lib.mkMerge [
    {
      # Always install user-themes extension
      home.packages = with pkgs.gnomeExtensions; [
        user-themes
      ];
    }
    (lib.mkIf (config.colorScheme or null != null) {
      # Create custom GNOME Shell theme directory (only if colorScheme available)
      home.file.".themes/NixColors/gnome-shell/gnome-shell.css".text = shellCss;

      # Configure user-themes extension to use our custom theme
      dconf.settings = {
        "org/gnome/shell/extensions/user-theme" = {
          name = "NixColors";
        };
      };
    })
  ]);
}
