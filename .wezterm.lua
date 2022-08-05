local wezterm = require 'wezterm'
local act = wezterm.action

local ram = "QAYIND4PWMSSR5XMGVQWKNESS33CWZGL"

return {
    font = wezterm.font_with_fallback({
        "mononoki",
        "FreeMono",
        "PowerlineSymbols",
    }),
    font_size = 14,

    -- color_scheme = "Breeze",
    -- color_scheme = "Darkside",
    color_scheme = "OceanicMaterial",

    hide_tab_bar_if_only_one_tab = true,
    window_padding = {
        left = 0,
        right = 0,
        top = 0,
        bottom = 0,
    },

    -- custom keyboard shortcuts
    keys = {
        {
            key="%", mods="SHIFT|CTRL",
            action=act.SplitHorizontal{domain="CurrentPaneDomain"}
        },
        {
            key="\"", mods="SHIFT|CTRL",
            action=act.SplitVertical{domain="CurrentPaneDomain"}
        },
        {
            key="h", mods="CTRL|SHIFT",
            action=act.ActivatePaneDirection("Left")
        },
        {
            key="l", mods="CTRL|SHIFT",
            action=act.ActivatePaneDirection("Right")
        },
        {
            key="k", mods="CTRL|SHIFT",
            action=act.ActivatePaneDirection("Up")
        },
        {
            key="j", mods="CTRL|SHIFT",
            action=act.ActivatePaneDirection("Down")
        },
    }
}
