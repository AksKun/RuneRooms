local JeraEssence = {}

local PICKUP_RESPAWN_CHANCE = 0.1
local PICKUP_VARIANT_CHANCE = 1
local NO_RESPAWN_PICKUPS = {
    [PickupVariant.PICKUP_BROKEN_SHOVEL] = true,
    [PickupVariant.PICKUP_BED] = true,
    [PickupVariant.PICKUP_COLLECTIBLE] = true,
    [PickupVariant.PICKUP_ETERNALCHEST] = true,
    [PickupVariant.PICKUP_MOMSCHEST] = true,
    [PickupVariant.PICKUP_PILL] = true,
    [PickupVariant.PICKUP_SHOPITEM] = true,
    [PickupVariant.PICKUP_TAROTCARD] = true,
    [PickupVariant.PICKUP_THROWABLEBOMB] = true,
    [PickupVariant.PICKUP_TRINKET] = true,
    [PickupVariant.PICKUP_TROPHY] = true
}

local JeraItem = RuneRooms.Enums.Item.JERA_ESSENCE


---Forbids a pickup from respawning with the Essence of Jera effect.
---@param pickupVariant PickupVariant | integer
function RuneRooms.API:ForbidPickupFromRespawning(pickupVariant)
    NO_RESPAWN_PICKUPS[pickupVariant] = true
end

---@param player EntityPlayer
function JeraEssence:OnSpeedCache(player)
    local numItems = player:GetCollectibleNum(JeraItem)
    player.MoveSpeed = player.MoveSpeed + numItems * 0.15
end
RuneRooms:AddCallback(
    ModCallbacks.MC_EVALUATE_CACHE,
    JeraEssence.OnSpeedCache,
    CacheFlag.CACHE_SPEED
)


---@param pickup EntityPickup
function JeraEssence:OnPickupCollect(pickup)
    if not TSIL.Players.DoesAnyPlayerHasItem(JeraItem) then return end
    if NO_RESPAWN_PICKUPS[pickup.Variant] then return end

    local rng = TSIL.RNG.NewRNG(pickup.InitSeed)
    if rng:RandomFloat() >= PICKUP_RESPAWN_CHANCE then return end

    local newSubtype = pickup.SubType
    if rng:RandomFloat() < PICKUP_VARIANT_CHANCE then
        --A subtype of 0 makes it so a random variant spawns
        newSubtype = 0
    end

    local spawnPos = RuneRooms.Helpers:GetRandomPositionInRoom(false, false, rng)
    TSIL.EntitySpecific.SpawnPickup(
        pickup.Variant,
        newSubtype,
        spawnPos
    )
end
RuneRooms:AddCallback(
    TSIL.Enums.CustomCallback.POST_PICKUP_COLLECT,
    JeraEssence.OnPickupCollect
)


---@param chest EntityPickup
function JeraEssence:OnChestOpen(chest)
    if not TSIL.Players.DoesAnyPlayerHasItem(JeraItem) then return end
    if NO_RESPAWN_PICKUPS[chest.Variant] then return end

    local rng = TSIL.RNG.NewRNG(chest.InitSeed)
    if rng:RandomFloat() >= PICKUP_RESPAWN_CHANCE then return end

    if RuneRooms:WillChestClose(chest) then return end

    local spawnPos = RuneRooms.Helpers:GetRandomPositionInRoom(false, false, rng)
    TSIL.EntitySpecific.SpawnPickup(
        chest.Variant,
        ChestSubType.CHEST_CLOSED,
        spawnPos
    )
end
RuneRooms:AddCallback(
    RuneRooms.Enums.CustomCallback.POST_CHEST_OPENED,
    JeraEssence.OnChestOpen
)