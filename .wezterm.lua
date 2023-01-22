local wezterm = require 'wezterm'
local act = wezterm.action

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
    leader = { key=',', mods='CTRL' },
    keys = {
        {
            key='%', mods='SHIFT|CTRL',
            action=act.SplitHorizontal{domain='CurrentPaneDomain'}
        },
        {
            key='\"', mods='SHIFT|CTRL',
            action=act.SplitVertical{domain='CurrentPaneDomain'}
        },
        {
            key='h', mods='CTRL|SHIFT',
            action=act.ActivatePaneDirection 'Left'
        },
        {
            key='H', mods='LEADER',
            action = act.AdjustPaneSize { 'Left', 5 },
        },
        {
            key='l', mods='CTRL|SHIFT',
            action=act.ActivatePaneDirection 'Right' 
        },
        {
            key='L', mods='LEADER',
            action=act.AdjustPaneSize { 'Right', 5 },
        },
        {
            key='k', mods='CTRL|SHIFT',
            action=act.ActivatePaneDirection 'Up' 
        },
        {
            key='K', mods='LEADER',
            action=act.AdjustPaneSize { 'Up', 5 },
        },
        {
            key='j', mods='CTRL|SHIFT',
            action=act.ActivatePaneDirection 'Down' 
        },
        {
            key='J', mods='LEADER',
            action=act.AdjustPaneSize { 'Down', 5 },
        },
    },
}
