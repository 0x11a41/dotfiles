local TERMINAL = "kitty"
local WEB_BROWSER = "zen"
local FILE_MANAGER = "nautilus"

-------------------
---- AUTOSTART ----
-------------------
hl.on("hyprland.start", function()
    hl.exec_cmd("uwsm app -- noctalia")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------
hl.env("HYPRCURSOR_THEME", "rose-pine-hyprcursor")
hl.env("HYPRCURSOR_SIZE", 24)

hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
-----------------------
---- LOOK AND FEEL ----
-----------------------
hl.config({
    general = {
        border_size = 1,
        gaps_in     = 0,
        gaps_out    = 0,
        col = {
            active_border   = "rgb(808080)",
            inactive_border = "rgba(00000000)",
        },
        resize_on_border = true,
        layout = "dwindle",
    },

    decoration = {
        rounding         = 0,
        active_opacity   = 1.0,
        inactive_opacity = 0.92,
        -- screen_shader = "crt.frag",
        shadow = { enabled = false },
        blur = { enabled = true },
    },

    animations = { enabled = true },

    input = {
        kb_layout     = "us",
        follow_mouse  = 1,
        repeat_delay  = 222,
        repeat_rate   = 35,
        sensitivity   = -0.45,
        accel_profile = "flat",
        scroll_factor = 0.85,
        touchpad = {
            natural_scroll       = true,
            disable_while_typing = true,
        },
        tablet = {
            output = "current", -- can be eDP-1 (specific monitor)
        },
    },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
        animate_manual_resizes  = true,
        font_family = "Adwaita Sans",
    },

    dwindle = { preserve_split = true, },

    master = { new_status = "master", },

    scrolling = {
        fullscreen_on_one_column = true,
        column_width = 0.56,
        wrap_focus = false,
    },

    ecosystem = {
        enforce_permissions = true,
        no_donation_nag     = true,
    },
})


---------------
---- INPUT ----
---------------
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 4, direction = "horizontal", action = "resize" })
hl.gesture({ fingers = 4, direction = "vertical",   action = "resize" })

hl.device({
    name = "elan2304:00-04f3:3122-touchpad",
    sensitivity = 0.6,
})


---------------------
---- KEYBINDINGS ----
---------------------
-- SPAWNERS
hl.bind("SUPER + T", hl.dsp.exec_cmd(TERMINAL))
hl.bind("SUPER + B", hl.dsp.exec_cmd(WEB_BROWSER))
hl.bind("F2", hl.dsp.exec_cmd("noctalia msg bar-toggle"), { long_press = true })
hl.bind("SUPER + C", hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"))
hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"), { release = true })
hl.bind("SUPER + PERIOD", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher /emo"))
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("hyprpicker | wl-copy"))
-- screenshot
hl.bind("PRINT", hl.dsp.exec_cmd("noctalia msg screenshot-region"))
hl.bind("SUPER + PRINT", hl.dsp.exec_cmd("noctalia msg screenshot-window"))
hl.bind("SUPER + A", hl.dsp.exec_cmd("noctalia msg screenshot-annotate"))
-- screen recording
hl.bind("SUPER + F10", hl.dsp.exec_raw("~/.config/hypr/cast stop"))
hl.bind("XF86Search", hl.dsp.exec_raw("~/.config/hypr/search-word.sh"))
hl.bind("XF86HomePage", hl.dsp.exec_cmd(FILE_MANAGER))
hl.bind("XF86Tools", hl.dsp.exec_cmd("xdg-open https://music.youtube.com"))
hl.bind("XF86Mail", hl.dsp.exec_cmd("xdg-open https://mail.google.com"))

-- WINDOW CONTROLS
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + SHIFT + V", function()
    hl.dispatch(hl.dsp.window.float())
    hl.dispatch(hl.dsp.window.pin())
end)
hl.bind("SUPER + F", hl.dsp.window.fullscreen())
hl.bind("SUPER + P", hl.dsp.window.pseudo())
hl.bind("SUPER + H", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + SHIFT + L",   hl.dsp.window.move({ direction = "right" }))
hl.bind("SUPER + SHIFT + H",   hl.dsp.window.move({ direction = "left" }))
hl.bind("SUPER + SHIFT + K",   hl.dsp.window.move({ direction = "up" }))
hl.bind("SUPER + SHIFT + J",   hl.dsp.window.move({ direction = "down" }))
hl.bind("SUPER + mouse_down",    hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + mouse_up",  hl.dsp.focus({ direction = "left", }))
hl.bind("SUPER + TAB",         hl.dsp.focus({ direction = "right" }), { repeating = true })
hl.bind("SUPER + SHIFT + TAB", hl.dsp.focus({ direction = "left" }),  { repeating = true })

-- MONITOR
hl.bind("SUPER + right", hl.dsp.focus({monitor = "r"}))
hl.bind("SUPER + left", hl.dsp.focus({monitor = "l"}))
hl.bind("SUPER + RETURN", function()
    hl.notification.create({text = "Current resolution: "..edp1.res.."::"..edp1.scale, timeout = 3000})
    hl.dispatch(toggle_edp1_resolution)
end)

-- WORKSPACES
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i}))
    hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end
hl.bind("SUPER + GRAVE", hl.dsp.workspace.toggle_special("Ref"))
hl.bind("SUPER + SHIFT + GRAVE", hl.dsp.window.move({ workspace = "special:Ref" }))
hl.bind("SUPER + TAB", function()
    local current_layout = hl.get_active_workspace().tiled_layout
    local id = hl.get_active_workspace().id
    local new_layout = current_layout == "dwindle" and "scrolling" or "dwindle"

    hl.workspace_rule({workspace = tostring(id), layout = new_layout})
    hl.notification.create({ text = "Current layout: " .. new_layout, timeout = 2000})
end)
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- MULTIMEDIA & BRIGHTNESS KEYS
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("noctalia msg volume-up"),          { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("noctalia msg volume-down"),        { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("noctalia msg volume-mute"),        { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("noctalia msg mic-mute"),           { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("noctalia msg brightness-up"),      { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("noctalia msg brightness-down"),    { locked = true, repeating = true })
hl.bind("SUPER + BRACKETRIGHT",  hl.dsp.exec_cmd("noctalia msg brightness-up"),      { locked = true, repeating = true })
hl.bind("SUPER + BRACKETLEFT",   hl.dsp.exec_cmd("noctalia msg brightness-down"),    { locked = true, repeating = true })
hl.bind("XF86AudioNext",         hl.dsp.exec_cmd("noctalia msg media next"),         { locked = true })
hl.bind("XF86AudioPause",        hl.dsp.exec_cmd("noctalia msg media play-pause"),   { locked = true })
hl.bind("XF86AudioPlay",         hl.dsp.exec_cmd("noctalia msg media play-pause"),   { locked = true })
hl.bind("XF86AudioPrev",         hl.dsp.exec_cmd("noctalia msg media previous"),     { locked = true })

-- RESIZE MODE --
hl.bind("SUPER + R", function()
    hl.notification.create({text = 'Entered Resize Mode. Use H-J-K-L to resize, ESC to leave', timeout = 2500})
    hl.dispatch(hl.dsp.submap("resize"))
end)

hl.define_submap("resize", function()
    hl.bind("L", hl.dsp.window.resize({ x = 25 , y = 0  , relative = true}), { repeating = true })
    hl.bind("H", hl.dsp.window.resize({ x = -25, y = 0  , relative = true}), { repeating = true })
    hl.bind("K", hl.dsp.window.resize({ x = 0  , y = 25 , relative = true}), { repeating = true })
    hl.bind("J", hl.dsp.window.resize({ x = 0  , y = -25, relative = true}), { repeating = true })

    hl.bind("ESCAPE", function()
        hl.notification.create({text = 'Left resize mode.', timeout = 2500})
        hl.dispatch(hl.dsp.submap("reset"))
    end)
end)

-- NUMB HYPRLAND KEYBINDS --
hl.bind("ALT + SPACE", function()
    hl.notification.create({text = "Entered NUMB mode. press SUPER + ALT + SPACE to release", timeout = 2000})
    hl.dispatch(hl.dsp.submap("numb"))
end)

hl.define_submap("numb", function()
    hl.bind("SUPER + ALT + SPACE", function()
        hl.notification.create({text = "NUMB mode disabled.", timeout = 2000})
        hl.dispatch(hl.dsp.submap("reset"))
    end)
end)

-- GENERAL --
hl.bind("ALT + L", hl.dsp.exec_cmd("noctalia msg session lock"))
hl.bind("SUPER + SHIFT + Q", hl.dsp.exec_cmd("noctalia msg panel-toggle session"))

---handles zooming in and out
---@param fac number multiplicative factor to zoom
local function zoom(fac)
    local MAX_ZOOM = 3
    local MIN_ZOOM = 1
    local ZOOM_TOGGLE_FACTOR = 1.5
    local current = hl.get_config("cursor.zoom_factor")
    if fac ~= nil then
        current = current + fac
    elseif current ~= MIN_ZOOM then
        current = MIN_ZOOM
    else
        current = ZOOM_TOGGLE_FACTOR
    end
    current = math.max(MIN_ZOOM, math.min(MAX_ZOOM, current))
    hl.config({ cursor = { zoom_factor = current } })
end

hl.bind("SUPER + Z", function() zoom(0.5) end,  { repeating = true })
hl.bind("SUPER + X", function() zoom(-0.5) end, { repeating = true })

-- GLOBAL BINDINGS --
hl.bind("SUPER + F10", hl.dsp.pass({ window = "class:^(com\\.obsproject\\.Studio)$" }))


--------------------------------------
---- WINDOWS AND WORKSPACES RULES ----
--------------------------------------
hl.window_rule({ name = "suppress-maximize-events", match = { class = ".*" }, suppress_event = "maximize", })

hl.window_rule({ -- Fix dragging issues with empty XWayland windows
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

hl.layer_rule({ match = { namespace = "launcher" },       dim_around = true, no_anim = true })
hl.layer_rule({ match = { namespace = "^noctalia-.*" },   no_anim = true })

hl.workspace_rule({ workspace = "1", layout = "scrolling" })

-- Smart gaps & borders (combined single-window rule)
hl.workspace_rule({ workspace = "w[tv1]s[false]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]s[false]",   gaps_out = 0, gaps_in = 0 })

hl.window_rule({
    name        = "no-border-fullscreen-workspace",
    match       = { float = false, workspace = "f[1]s[false]" },
    border_size = 0,
    rounding    = 0,
})

-----------------------
----- PERMISSIONS -----
-----------------------
local nix_prefix = "^/nix/store/[a-z0-9]{32}-"

-- Portals
hl.permission({ binary = nix_prefix .. "xdg-desktop-portal-hyprland[^/]*/libexec/(\\.xdg-desktop-portal-hyprland-wrapped|xdg-desktop-portal-hyprland)$", type = "screencopy", mode = "allow" })

-- Noctalia & Quickshell (screencopy + cursorpos for screenshots, lockscreen, and shell previews)
hl.permission({ binary = nix_prefix .. "noctalia[^/]*/bin/\\.?noctalia(-shell)?(-wrapped)?$",     type = "screencopy", mode = "allow" })
hl.permission({ binary = nix_prefix .. "noctalia[^/]*/bin/\\.?noctalia(-shell)?(-wrapped)?$",     type = "cursorpos",  mode = "allow" })
hl.permission({ binary = nix_prefix .. "quickshell[^/]*/bin/\\.?quickshell(-wrapped)?$",          type = "screencopy", mode = "allow" })
hl.permission({ binary = nix_prefix .. "quickshell[^/]*/bin/\\.?quickshell(-wrapped)?$",          type = "cursorpos",  mode = "allow" })

-- Screenshot, color picker, and recording utilities
hl.permission({ binary = nix_prefix .. "grim[^/]*/bin/grim$",                                     type = "screencopy", mode = "allow" })
hl.permission({ binary = nix_prefix .. "grim[^/]*/bin/grim$",                                     type = "cursorpos",  mode = "allow" })
hl.permission({ binary = nix_prefix .. "hyprpicker[^/]*/bin/hyprpicker$",                         type = "screencopy", mode = "allow" })
hl.permission({ binary = nix_prefix .. "hyprpicker[^/]*/bin/hyprpicker$",                         type = "cursorpos",  mode = "allow" })
hl.permission({ binary = nix_prefix .. "obs-studio[^/]*/bin/\\.?obs(-wrapped)?$",                 type = "screencopy", mode = "allow" })
hl.permission({ binary = nix_prefix .. "(wf-recorder|wl-screenrec|gpu-screen-recorder)[^/]*/bin/.*", type = "screencopy", mode = "allow" })

----------------
-- ANIMATIONS --
----------------
local SPEED_FAC = 0.8
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })
hl.curve("snappySpring",   { type = "spring", mass = 1, stiffness = 1100, dampening = 48 })

hl.animation({ leaf = "global",        enabled = true,  speed = 3.0 * SPEED_FAC,    bezier = "quick" })

hl.animation({ leaf = "windows",       enabled = true,  speed = 3.5 * SPEED_FAC,  spring = "snappySpring" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 3.0 * SPEED_FAC,  spring = "snappySpring",  style = "popin 93%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 2.0 * SPEED_FAC,  bezier = "quick",         style = "popin 93%" })

hl.animation({ leaf = "fade",          enabled = true,  speed = 2.0 * SPEED_FAC,  bezier = "quick" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.5 * SPEED_FAC,  bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.5 * SPEED_FAC,  bezier = "almostLinear" })

hl.animation({ leaf = "layers",        enabled = true,  speed = 3.0 * SPEED_FAC,  bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 2.5 * SPEED_FAC,  bezier = "easeOutQuint",  style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5 * SPEED_FAC,  bezier = "quick",         style = "fade" })

hl.animation({ leaf = "workspaces",    enabled = true,  speed = 3.0 * SPEED_FAC,  bezier = "easeOutQuint",  style = "slidevert" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 2.5 * SPEED_FAC,  bezier = "easeOutQuint",  style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 2.5 * SPEED_FAC,  bezier = "easeOutQuint",  style = "slide" })

hl.animation({ leaf = "border",        enabled = true,  speed = 3.0 * SPEED_FAC,  bezier = "quick" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 4.0 * SPEED_FAC,  bezier = "quick" })

require("monitors")

-- For Noctalia Color templates
require("noctalia").apply_theme()
