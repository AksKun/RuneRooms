local RuneIconsSprite = Sprite()
RuneIconsSprite:Load("gfx/ui/rune_icons.anm2", true)


---@param runeEffect RuneEffect
---@param name string
local function AddRuneEffectIcons(runeEffect, name)
    local frame = RuneRooms.Constants.RUNE_EFFECT_ICON_FRAME[runeEffect]

    MinimapAPI:AddMapFlag(
        name .. "Positive",
        function ()
            return RuneRooms:IsPositiveEffectActive(runeEffect)
        end,
        RuneIconsSprite,
        "Positive",
        frame
    )

    MinimapAPI:AddMapFlag(
        name .. "Negative",
        function ()
            return RuneRooms:IsNegativeEffectActive(runeEffect)
        end,
        RuneIconsSprite,
        "Negative",
        frame
    )
end


for runeEffect, name in pairs(RuneRooms.Constants.RUNE_NAMES) do
    AddRuneEffectIcons(runeEffect, name)
end