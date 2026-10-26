-- Animations configuration
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
-- Inspired by prasanthrangan/hyprdots animations

-- Disable animations for specific layers
hl.layer_rule({
    name  = "no-anim-hyprpicker",
    match = { namespace = "hyprpicker" },
    no_anim = true,
})

hl.layer_rule({
    name  = "no-anim-selection",
    match = { namespace = "selection" },
    no_anim = true,
})

-- Custom curves
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Additional curves from hyprdots
hl.curve("wind", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("winIn", { type = "bezier", points = { { 0.1, 1.1 }, { 0.1, 1.1 } } })
hl.curve("winOut", { type = "bezier", points = { { 0.3, -0.3 }, { 0, 1 } } })
hl.curve("liner", { type = "bezier", points = { { 1, 1 }, { 1, 1 } } })

-- More refined curves from hyprdots (Caelestia-level bezier curves)
hl.curve("easeOutExpo", { type = "bezier", points = { { 0.19, 1 }, { 0.22, 1 } } })
hl.curve("easeOutCirc", { type = "bezier", points = { { 0.075, 0.82 }, { 0.165, 1 } } })
hl.curve("easeOutBack", { type = "bezier", points = { { 0.175, 0.885 }, { 0.32, 1.275 } } })
hl.curve("easeOutElastic", { type = "bezier", points = { { 0.11, 0 }, { 0.12, 1.01 } } })
hl.curve("smooth", { type = "bezier", points = { { 0.25, 0.46 }, { 0.45, 0.94 } } })
hl.curve("snappy", { type = "bezier", points = { { 0.1, 0.9 }, { 0.2, 1.1 } } })
hl.curve("bouncy", { type = "bezier", points = { { 0.34, 1.56 }, { 0.64, 1 } } })

-- Default springs
hl.curve("easy", { type = "spring", mass = 1, stiffness = 238.1191, dampening = 24.21279333 })
hl.curve("smooth_spring", { type = "spring", mass = 1.2, stiffness = 280, dampening = 28 })
hl.curve("snappy_spring", { type = "spring", mass = 0.8, stiffness = 400, dampening = 30 })
hl.curve("bouncy_spring", { type = "spring", mass = 1, stiffness = 300, dampening = 15 })

-- Animations (only valid leaves from hyprctl animations)
hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

-- Additional animations from hyprdots (more snappy)
hl.animation({ leaf = "windowsMove", enabled = true, speed = 5, bezier = "wind", style = "slide" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 1, bezier = "liner" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 5, bezier = "wind", style = "slidevert" })

-- Refined animations using valid leaves with better curves
hl.animation({ leaf = "fadePopups", enabled = true, speed = 2, bezier = "smooth" })
hl.animation({ leaf = "fadePopupsIn", enabled = true, speed = 1.5, bezier = "snappy" })
hl.animation({ leaf = "fadePopupsOut", enabled = true, speed = 2, bezier = "easeOutExpo" })
hl.animation({ leaf = "fadeDim", enabled = true, speed = 1.5, bezier = "quick" })
hl.animation({ leaf = "fadeShadow", enabled = true, speed = 1, bezier = "linear" })
hl.animation({ leaf = "fadeGlow", enabled = true, speed = 1, bezier = "linear" })