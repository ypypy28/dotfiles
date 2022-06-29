local wezterm = require 'wezterm';
return {
    -- font = wezterm.font("mononoki"),
    -- font = wezterm.font("Hack"),
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
    }
}
