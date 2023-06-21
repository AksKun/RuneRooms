local EhwazEssence = {}

local STARTING_ROOM_INDEX = 84
local GRID_INDEX_PER_CORNER = {32, 42, 92, 102}
local RED_ROOM_SPAWN_CHANCE = 0.1
local EhwazItem = RuneRooms.Enums.Item.EHWAZ_ESSENCE

---@param player EntityPlayer
function EhwazEssence:OnShotSpeedCache(player)
    local numItems = player:GetCollectibleNum(EhwazItem)
    player.ShotSpeed = player.ShotSpeed + numItems * 0.3
end
RuneRooms:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    EhwazEssence.OnShotSpeedCache,
    CacheFlag.CACHE_SHOTSPEED
)


function EhwazEssence:OnNewRoom()
    if not TSIL.Players.DoesAnyPlayerHasItem(EhwazItem) then return end

    local roomDesc = TSIL.Rooms.GetRoomDescriptor()
    if roomDesc.GridIndex ~= STARTING_ROOM_INDEX then return end

    local rng = TSIL.RNG.NewRNG(roomDesc.SpawnSeed)
    local corner = TSIL.Random.GetRandomInt(1, 4, rng)
    local gridIndex = GRID_INDEX_PER_CORNER[corner]

    local room = Game():GetRoom()
    local gridEntity = room:GetGridEntity(gridIndex)
    if not gridEntity or gridEntity:GetType() ~= GridEntityType.GRID_STAIRS then
        TSIL.GridEntities.SpawnGridEntity(
            GridEntityType.GRID_STAIRS,
            TSIL.Enums.CrawlSpaceVariant.NORMAL,
            gridIndex
        )
    end
end
RuneRooms:AddCallback(
    ModCallbacks.MC_POST_NEW_ROOM,
    EhwazEssence.OnNewRoom
)


function EhwazEssence:OnRoomClear()
    local player = TSIL.Players.GetPlayersByCollectible(EhwazItem)[1]
    if not player then return end

    if not TSIL.Doors.HasUnusedDoorSlot() then return end

    local rng = player:GetCollectibleRNG(EhwazItem)
    if rng:RandomFloat() >= RED_ROOM_SPAWN_CHANCE then return end

    local unusedDoorSlots = TSIL.Doors.GetUnusedDoorSlots()
    local doorSlot = TSIL.Random.GetRandomElementsFromTable(unusedDoorSlots, 1, rng)[1]

    local level = Game():GetLevel()
    local roomIndex = level:GetCurrentRoomIndex()
    level:MakeRedRoomDoor(roomIndex, doorSlot)
end
RuneRooms:AddCallback(
    TSIL.Enums.CustomCallback.POST_ROOM_CLEAR_CHANGED,
    EhwazEssence.OnRoomClear,
    true
)