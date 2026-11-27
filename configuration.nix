{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Options below focus on disabling laptop keyboard and touchpad since mine is damaged
# XIAOMI ==>
  # Prevent the Linux kernel from loading drivers for internal input hardware and hotkeys
  boot.blacklistedKernelModules = [ 
    "atkbd" # for laptop keyboard
    "i2c_hid_acpi" # touchpads
    "i2c_hid" # HID devices over the I2C bus
    "hid_multitouch" # multi touch gesture and finger tracking driver
    "redmi-wmi" # Redmi WMI driver for laptop-specific function keys
  ];

  # Pass low-level power and PS/2 controller flags to the kernel at boot
  boot.kernelParams = [ 
    "mem_sleep_default=deep" # Force S3 deep sleep
    "i8042.reset=1" # reset i8042 PS/2 controller during boot/resume
    "i8042.nosmart=1" # # Disable PS/2 active multiplexing to prevent phantom inputs
  ];

  # Tell libinput to ignore these devices in userspace (fallback)
  services.udev.extraRules = ''
    # Ignore the broken ELAN Touchpad/Mouse interface
    SUBSYSTEM=="input", ATTRS{id}=="i2c:04f3:3122", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    
    # Optional fail-safe: Ensure the internal keyboard matrix can't circumvent sleep
    SUBSYSTEM=="input", ATTRS{name}=="AT Translated Set 2 keyboard", ENV{LIBINPUT_IGNORE_DEVICE}="1"
  '';
# XIAOMI <==

  services.logind.settings.Login = {
    HandlePowerKey = "hibernate";
    HandleLidSwitchExternalPower = "suspend";
    HandleLidSwitch = "suspend";
  };
  # systemd.sleep.settings.Sleep = { HibernateDelaySec = "1h"; };

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
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

  ## NVIDIA things for MX350 🤑
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_535;
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:6:0:0";
      offload.enable = true;
      offload.enableOffloadCmd = true;
    };
  };

  services.printing.enable = true;
  services.libinput.enable = true;

  # Enable the RealtimeKit (rtkit) system service so user-space apps
  # can safely request real-time CPU scheduling priority without needing root privileges
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

  programs.fish.enable = true;

  # programs.command-not-found.enable = false;

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

  users.users.hk = {
    isNormalUser = true;
    initialPassword = "nixos";
    description = "Harikrishna Mohan";
    extraGroups = [ "networkmanager" "wheel" "dialout" ];
    shell = pkgs.fish;
    packages = with pkgs; [
      gnome-text-editor
      loupe # image viewer
      baobab # disk usage analyzer
      papers # document viewer
      telegram-desktop
      gimp
      obsidian
      resources
      rnote
      pixelorama
      libreoffice
      pureref
      zen-browser
      obs-studio
      drawio
      vscodium
      google-chrome
      vlc
      mpv
      cosmic-files
    ];
  };

  programs.localsend = {
    enable = true;
    openFirewall = true;
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

  # garbage collection
  nix.gc = {
    automatic = true;    
    dates = "monthly";
    options = "--delete-older-than 20d";
  };
  nix.settings.auto-optimise-store = true;

  # ZeroConf
  services.avahi = {
    enable = false;
    nssmdns4 = true;
    settings = {
      publish = {
        disable-publishing = false;
        publish-addresses = true;
        publish-workstation = true;
        disable-user-service-publishing = false;
      };
    };
  };

  services.tailscale = {
    enable = true;
    extraSetFlags = [ "--operator=hk" ];
  };

  services.openssh = {
    enable = false;
    settings = {
      PasswordAuthentication = false; 
      PermitRootLogin = "no";
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
    allowedUDPPortRanges = [
      { from = 4000; to = 4007; }
      { from = 8000; to = 8010; }
    ];
  };

  services.immich = {
    enable = true;
    host = "0.0.0.0";
    port = 2283;
    mediaLocation = "/immich";
  };

  environment.systemPackages = with pkgs; [
    (makeDesktopItem {
      name = "immich";
      desktopName = "Immich";
      genericName = "Memories";
      comment = "Self-hosted photo and video backup solution";
      exec = "${pkgs.xdg-utils}/bin/xdg-open http://nixos:2283";
      icon = "folder-pictures";
      categories = [ "Photography" "Graphics" ];
    })
    helix
    wl-clipboard
    playerctl
    brightnessctl
    adwaita-icon-theme
    pastel
    nixd
    nixdoc
    ashell
    noctalia
    upower
    fastfetch
    power-profiles-daemon
    libnotify
    libinput
    glib
    zlib
    gzip
    unzip
    nmap
    nwg-displays
    tcpdump
    impala
    kitty
    zoxide
    tree
    btop
    tldr
    ffmpeg-full
    man-pages
    man-pages-posix
    direnv
    net-tools
    yazi
    vscode-css-languageserver
    superhtml
    vscode-json-languageserver
    typescript
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
    fish-lsp
    libwacom
    hyprls
    hyprpicker
    pavucontrol
    gsettings-desktop-schemas
    xdg-desktop-portal-hyprland
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  # display manager
  services.displayManager.ly = {
    enable = true;
    settings = {
      save = true;
      load = true;
    };
  };
  services.displayManager.defaultSession = "hyprland-uwsm";
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.ly.enableGnomeKeyring = true;

  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  programs.dconf.enable = true;

  services.gvfs.enable = true;
  security.polkit.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
    config = {
      common.default = [ "gtk" ];
      hyprland.default = [ "gtk" ];
    };
  };

  environment.sessionVariables = { 
    LIBVA_DRIVER_NAME = "iHD"; # Forces VA-API video decoding on the Intel card
    NIXOS_OZONE_WL = "1";
    GIO_EXTRA_MODULES = [ "${config.services.gvfs.package}/lib/gio/modules" ];
    EDITOR = "hx";
    VISUAL = "hx";
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # don't change this
  system.stateVersion = "25.05";
}

