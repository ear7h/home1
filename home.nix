{ pkgs, lib, ... }:

let
  home = "/home/julio";
in {
  home.sessionPath = [
    "${home}/julio/bin"
    "${home}/julio/.go/bin"
    "${home}/julio/.cargo/bin"
  ];

  home.sessionVariables = {
    GOPATH = "${home}/.go";
    SHELL = "${pkgs.zsh}/bin/zsh";
    MOZ_ENABLE_WAYLAND="1";
  };

  home.packages = with pkgs; [
    git
    binutils
    gcc
    gnumake

    swaylock
    swayidle
    wl-clipboard
    mako
    alacritty
    wofi
    pavucontrol

    wev

    dig

    rbw
    pinentry-curses

    xdg-utils

    zoom-us
    firefox-wayland
  ];

  nixpkgs.config.allowUnfree = true;

  home.file.".xkb".source = ./xkb;

  wayland.windowManager.sway = {
    enable = true;
    # wraperFeatures.gtk = true;
    config = {
        input."type:keyboard".xkb_layout = "us_lv3_arrows";
        input."type:keyboard".xkb_options = "lv3:caps_switch";
        keybindings = let
          mod = "Mod1";
        in lib.mkOptionDefault {
          "${mod}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
          "${mod}+q" = "kill";

          # screen
          "XF86MonBrightnessDown" = "exec 'brightnessctl set 10%-";
          "XF86MonBrightnessUp" = "exec 'brightnessctl set +10%";

          # audio
          "XF86AudioRaiseVolume" = "exec 'pactl set-sink-volume @DEFAULT_SINK@ +10%";
          "XF86AudioLowerVolume" = "exec 'pactl set-sink-volume @DEFAULT_SINK@ -10%";
          "XF86AudioMute" = "exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioMicMute" = "exec 'pactl set-source-mute @DEFAULT_SOURCE@ toggle";
        };
    };
  };

  programs.zsh = {
    enable = true;
    initExtra = ''
      ${builtins.readFile ./profile}
      ${builtins.readFile ./zshrc}
      ${builtins.readFile ./zsh-completion}
    '';
  };

  programs.git = {
    enable = true;
    userName = "julio";
    userEmail = "julio.grillo98@gmail.com";
    extraConfig = {
      core.editor = "vim";
      credential.helper = "store";
      init.defaultBranch = "main";
    };
  };

  home.file = {
    ".alacritty.yml".source = ./alacritty.yml;
    ".vim/".source = ./vim;
    ".vimrc".source = ./vimrc;
  };

  home.activation = {
    vimRuntime = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD mkdir $VERBOSE_ARG -p $HOME/.cache/vim/{backup,undo}
    '';
  };
}
