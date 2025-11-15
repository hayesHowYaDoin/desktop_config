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

  # Map base16 colors to semantic names for GTK (only if colorScheme is available)
  colors = lib.optionalAttrs (config.colorScheme or null != null) (with config.colorScheme.palette; {
    bg = mkColor base00; # Default background
    bg1 = mkColor base01; # Lighter background (popups, sidebars)
    bg2 = mkColor base02; # Selection background
    bg3 = mkColor base03; # Comments, invisibles

    fg = mkColor base05; # Default foreground
    fg_dim = mkColor base04; # Dimmed foreground
    fg_bright = mkColor base06; # Bright foreground

    # Accent colors
    red = mkColor base08;
    orange = mkColor base09;
    yellow = mkColor base0A;
    green = mkColor base0B;
    cyan = mkColor base0C;
    blue = mkColor base0D;
    purple = mkColor base0E;
    brown = mkColor base0F;
  });

  # GTK CSS that applies nix-colors palette (only if colorScheme is available)
  gtkCss = lib.optionalString (config.colorScheme or null != null) ''
    /* Base colors */
    @define-color window_bg_color ${colors.bg};
    @define-color window_fg_color ${colors.fg};
    @define-color view_bg_color ${colors.bg};
    @define-color view_fg_color ${colors.fg};

    /* Header bar colors */
    @define-color headerbar_bg_color ${colors.bg1};
    @define-color headerbar_fg_color ${colors.fg};
    @define-color headerbar_backdrop_color ${colors.bg};
    @define-color headerbar_shade_color ${colors.bg};

    /* Card and sidebar colors */
    @define-color card_bg_color ${colors.bg1};
    @define-color card_fg_color ${colors.fg};
    @define-color card_shade_color ${colors.bg};
    @define-color sidebar_bg_color ${colors.bg1};
    @define-color sidebar_fg_color ${colors.fg};
    @define-color sidebar_shade_color ${colors.bg};

    /* Popover colors */
    @define-color popover_bg_color ${colors.bg1};
    @define-color popover_fg_color ${colors.fg};

    /* Dialog colors */
    @define-color dialog_bg_color ${colors.bg1};
    @define-color dialog_fg_color ${colors.fg};

    /* Accent color (used for links, focus, etc) */
    @define-color accent_bg_color ${colors.blue};
    @define-color accent_fg_color ${colors.bg};
    @define-color accent_color ${colors.blue};

    /* Success/Warning/Error colors */
    @define-color success_bg_color ${colors.green};
    @define-color success_fg_color ${colors.bg};
    @define-color success_color ${colors.green};

    @define-color warning_bg_color ${colors.yellow};
    @define-color warning_fg_color ${colors.bg};
    @define-color warning_color ${colors.yellow};

    @define-color error_bg_color ${colors.red};
    @define-color error_fg_color ${colors.bg};
    @define-color error_color ${colors.red};

    /* Destructive action colors */
    @define-color destructive_bg_color ${colors.red};
    @define-color destructive_fg_color ${colors.bg};
    @define-color destructive_color ${colors.red};

    /* Border and shadow colors */
    @define-color borders ${colors.bg2};
    @define-color shade_color ${colors.bg};
    @define-color scrollbar_outline_color ${colors.bg};
  '';
in {
  config = mkIf cfg.enable {
    gtk = {
      enable = true;

      gtk3.extraCss = gtkCss;
      gtk4.extraCss = gtkCss;

      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };

      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
    };
  };
}
