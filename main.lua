RuneRooms = RegisterMod("Rune Rooms", 1)

local myFolder = "rune_rooms_loi"
local LOCAL_TSIL = require(myFolder .. ".TSIL")
LOCAL_TSIL.Init(myFolder)

include("rune_rooms_scripts.enums")
include("rune_rooms_scripts.constants")
include("rune_rooms_scripts.helpers")
RuneRooms.API = {}

if StageAPI then
    StageAPI.UnregisterCallbacks(RuneRooms.Constants.MOD_ID)
end

RuneRooms.Libs = {}
include("rune_rooms_scripts.lib.achievement_checker")
include("rune_rooms_scripts.lib.hidden_item_manager")
include("rune_rooms_scripts.lib.dss_menu")
include("rune_rooms_scripts.lib.minimap_api")

include("rune_rooms_scripts.mod_compat.main")

include("rune_rooms_scripts.custom_callbacks.main")
include("rune_rooms_scripts.effects.main")
include("rune_rooms_scripts.grid.main")
include("rune_rooms_scripts.item_pools.main")
include("rune_rooms_scripts.items.main")
include("rune_rooms_scripts.pickups.main")
include("rune_rooms_scripts.player_effects.main")
include("rune_rooms_scripts.room.main")
include("rune_rooms_scripts.rune_effects.main")
include("rune_rooms_scripts.tear_effects.main")

print("Rune Rooms loaded. Use \"rune help\" to get information about commands.")


RuneRooms:AddCallback(ModCallbacks.MC_EXECUTE_CMD, function (_, cmd, params)
    if cmd == "rune" then
        local tokens = TSIL.Utils.String.Split(params, " ")
        tokens = TSIL.Utils.Tables.Map(tokens, function (_, token)
            return string.lower(token)
        end)

        local found = Isaac.RunCallbackWithParam(
            RuneRooms.Enums.CustomCallback.ON_CUSTOM_CMD,
            tokens[1],
            table.unpack(tokens)
        )

        if not found then
            print("Command " .. tokens[1] .. " not found.")
            print("Type \"rune help\" to get information about commands.")
        end
    end
end)


RuneRooms:AddCallback(RuneRooms.Enums.CustomCallback.ON_CUSTOM_CMD, function ()
    print("rune help - Shows this message.")
    print("rune seteffect [rune_effect] - Changes the rune effect for the current floor.")
    print("rune good [rune_effect] - Activates the good effect of a rune for the current level.")
    print("rune bad [rune_effect] - Activates the good effect of a rune for the current level.")
    print("rune ehwazmode [mode] - Changes how the positive effect of ehwaz works")

    return true
end, "help")

return