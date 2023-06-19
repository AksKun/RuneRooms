local IngwazNegative = {}

local CHESTS_REPLACED_WITH_SPIKES = {
    [PickupVariant.PICKUP_CHEST] = true,
    [PickupVariant.PICKUP_REDCHEST] = true,
}
local CHESTS_REPLACED_WITH_DOUBLE_CLOSED = {
    [PickupVariant.PICKUP_LOCKEDCHEST] = RuneRooms.Enums.PickupVariant.DOUBLE_LOCKED_CHEST,
    [PickupVariant.PICKUP_BOMBCHEST] = RuneRooms.Enums.PickupVariant.DOUBLE_BOMB_CHEST
}


TSIL.SaveManager.AddPersistentVariable(
    RuneRooms,
    RuneRooms.Enums.SaveKey.REPLACED_DOUBLE_CLOSED_CHESTS,
    {},
    TSIL.Enums.VariablePersistenceMode.RESET_LEVEL
)


---@param type EntityType
---@param variant integer
---@param seed integer
function IngwazNegative:PreEntitySpawn(type, variant, _, _, _, _, seed)
    if not RuneRooms:IsNegativeEffectActive(RuneRooms.Enums.RuneEffect.INGWAZ) then return end

    if type ~= EntityType.ENTITY_PICKUP then return end

    if CHESTS_REPLACED_WITH_SPIKES[variant] then
        return {
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_SPIKEDCHEST,
            ChestSubType.CHEST_CLOSED,
            seed
        }
    elseif CHESTS_REPLACED_WITH_DOUBLE_CLOSED[variant] then
        local chestsReplaced = TSIL.SaveManager.GetPersistentVariable(
            RuneRooms,
            RuneRooms.Enums.SaveKey.REPLACED_DOUBLE_CLOSED_CHESTS
        )
        if chestsReplaced[seed] then return end

        chestsReplaced[seed] = true

        local newChestVariant = CHESTS_REPLACED_WITH_DOUBLE_CLOSED[variant]
        return {
            EntityType.ENTITY_PICKUP,
            newChestVariant,
            0,
            seed
        }
    end
end
RuneRooms:AddCallback(
    ModCallbacks.MC_PRE_ENTITY_SPAWN,
    IngwazNegative.PreEntitySpawn
)