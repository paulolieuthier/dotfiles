{ config, nixgl, pkgs, ... }:

{
  nixGL = {
    packages = import nixgl { inherit pkgs; };
    defaultWrapper = "mesa";
    installScripts = [ "mesa" ];
  };

  home = {
    username = "paulo.lieuthier";
    homeDirectory = "/home/paulo.lieuthier";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "25.05";

    packages = [
      pkgs.git
      pkgs.fish
      pkgs.tmux
      pkgs.zellij
      pkgs.neovim
      pkgs.helix
      pkgs.zoxide
      pkgs.fzf
      pkgs.skim
      pkgs.ripgrep
      pkgs.fd
      pkgs.parallel
      pkgs.tig
      pkgs.delta
      pkgs.nerd-fonts.fira-code
      pkgs.wl-clipboard
      pkgs.fuzzel
      pkgs.grim
      pkgs.cliphist
      pkgs.imagemagick
      pkgs.awscli
      pkgs.kubectl
      pkgs.rustup

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
    ];

    file = {
      ".config/tig/config".source = extra/tigrc;
      ".config/fuzzel/fuzzel.ini".source = extra/fuzzel.ini;
      ".config/kanshi/config".source = extra/kanshi;
      ".config/mako/config".source = extra/mako;
    };

    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  fonts.fontconfig.enable = true;
  programs.home-manager.enable = true;

  imports = [
    ./modules/fish.nix
    ./modules/tmux.nix
  ];

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.alacritty = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.alacritty;
    settings = {
      window = {
        opacity = 0.9;
        dynamic_padding = true;
      };
      font.normal.family = "FiraCodeNerdFont";
    };
  };
}
