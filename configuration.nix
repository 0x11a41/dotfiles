{ config, pkgs, ... }:

{
  imports = [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  networking.hostName = "nixos";
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";
  hardware.graphics.enable = true;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };


  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.libinput.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };


  programs.fish.enable = true;
  programs.git = {
    enable = true;
    config = {
      init.defaultBranch = "main";
      user.name = "Harikrishna Mohan";
      user.email = "harikrishnamohan@proton.me";
    };
  };

  users.users.hk = {
    isNormalUser = true;
    description = "Harikrishna Mohan";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
    packages = with pkgs; [
      tree
      git
      fastfetch
      firefox
      tldr
      helix
      bat
    ];
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    maple-mono.NF
    adwaita-fonts
    nerd-fonts."m+"
  ];


  nixpkgs.config.allowUnfree = true;
  services.xserver.enable = false;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;


  
  ##################
  ## ENVIRONMENTS ##
  ##################

  # @HYPRLAND
  services.displayManager.ly.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    fuzzel
    wl-clipboard
    wlsunset
    playerctl
    brightnessctl
    adwaita-icon-theme
    hyprpolkitagent
    hyprpaper
    nixd
    nixdoc
    alacritty
    nautilus
    nautilus-python
    hyprls
  ];

  programs.dconf.profiles.user.databases = [
    {
      settings."org/gnome/desktop/interface" = {
        gtk-theme = "Adwaita";
        icon-theme = "Adwaita";
        font-name = "Adwaita Sans Medium 12";
        document-font-name = "Adwaita Sans Medium 12";
        monospace-font-name = "Maple Mono NL Medium 12";
      };
    }
  ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  
  # don't change this
  system.stateVersion = "25.05";
}
