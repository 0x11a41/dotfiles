{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "i8042.nokbd" ]; # to disable laptop keyboard
  services.logind.settings.Login = {
    HandlePowerKey = "hibernate";
  };

  networking.networkmanager.enable = true;
  networking.hostName = "nixos";
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";
  # i18n.supportedLocales = [ "all" ];

  nixpkgs.config.packageOverrides = pkgs: {
    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  };
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libvdpau-va-gl
    ];
  };
  services.xserver.videoDrivers = ["nvidia"];
  ## f*** nvidia things
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_535;
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:6:0:0";
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };

  services.printing.enable = true;
  services.libinput.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    alsa.support32Bit = true;
    wireplumber.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
        ControllerMode = "bredr";
      };
      Policy = {
        AutoEnable = false;
      };
    };
  };

  programs.fish = {
    enable = true;
    generateCompletions = true;
    shellAbbrs = {
      ta = "tmux a";
    };
  };

  programs.command-not-found.enable = false;

  programs.git = {
    enable = true;
    config = {
      core.editor = "hx";
      merge.tool = "helix";
      mergetool.helix.cmd = "hx \"$MERGED\"";
      init.defaultBranch = "main";
      user.name = "0x11a41";
      user.email = "harikrishnamohan@proton.me";
    };
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    extraConfig = ''
      set -g mode-keys vi
      set-window-option -g mode-keys vi
      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"
      set -g status-style bg=default
      set-option -g status-position top
      set -g mouse on
      set -g base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      set -g escape-time 5

      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind -n M-H previous-window
      bind -n M-L next-window
    '';    
  };

  virtualisation.virtualbox.host.enable = true;

  users.users.hk = {
    isNormalUser = true;
    hashedPassword = "$y$j9T$D.Gc4dBkIlpxoabvNsemz/$JrIQVLeg6ZtXgxAMbVTFPMa8IvQ3UuEIMoWNWMFJ3UD";
    description = "Harikrishna Mohan";
    extraGroups = [ "networkmanager" "wheel" "vboxusers" ];
    shell = pkgs.fish;
    packages = with pkgs; [
      gnome-text-editor
      loupe # image viewer
      baobab # disk usage analyzer
      papers # document viewer
      snapshot # camera app
      gnome-calculator
      gnome-calendar
      telegram-desktop
      gimp
      obsidian
      resources
      pureref
      rnote
      # obs-studio
      localsend
      pixelorama
      audacity
      kdePackages.kdenlive
      libreoffice
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
      vlc
      gparted
      nautilus
      nautilus-open-any-terminal
      pavucontrol
    ];
  };

  documentation.dev.enable = true;
  documentation.man.cache.enable = true;

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    maple-mono.NF
    adwaita-fonts
    nerd-fonts."m+"
    corefonts
    font-awesome
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # garbage collection
  nix.gc = {
    automatic = true;    
    dates = "monthly";
    options = "--delete-older-than 20d";
  };
  nix.settings.auto-optimise-store = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
      userServices = true;
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 6210 ];
    allowedUDPPortRanges = [
      { from = 4000; to = 4007; }
      { from = 8000; to = 8010; }
    ];
  };

  environment.systemPackages = with pkgs; [
    helix
    wl-clipboard
    wlsunset
    playerctl
    brightnessctl
    adwaita-icon-theme
    hyprpolkitagent
    nixd
    nixdoc
    hyprls
    fuzzel
    hyprlock
    swaynotificationcenter
    ashell
    upower
    fastfetch
    power-profiles-daemon
    networkmanagerapplet
    cliphist
    blueman
    hyprpicker
    hyprshot
    rose-pine-hyprcursor
    xdg-desktop-portal
    xdg-desktop-portal-hyprland
    wf-recorder
    libnotify
    slurp
    glib
    zlib
    gzip
    unzip
    awww
    kitty
    zoxide
    fzf
    tree
    btop
    tldr
    pastel
    ffmpeg-full
    man-pages
    man-pages-posix
    direnv
    net-tools
    yazi
    presenterm
    vscode-css-languageserver
    superhtml
    vscode-json-languageserver
    typescript
    typescript-language-server
    python313
    ty
    ruff
    lua
    lua-language-server
    clang
    gdb
    clang-tools
    lldb
    pkg-config
    wget
    jq
    file
    bash-language-server
    libwacom
  ];

  services.displayManager.ly.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
  services.hypridle.enable = true;

  programs.hyprland = {
    enable = true;
  };

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

  services.gvfs.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  environment.sessionVariables = { 
    LIBVA_DRIVER_NAME = "iHD"; # Forces VA-API video decoding on the Intel card
    NIXOS_OZONE_WL = "1";
    GIO_EXTRA_MODULES = [ "${config.services.gvfs.package}/lib/gio/modules" ];
    EDITOR = "hx";
    VISUAL = "hx";
  };

  # don't change this
  system.stateVersion = "25.05";
}

