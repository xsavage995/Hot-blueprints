RegisterNetEvent('nm-blueprints:receiveBlueprint', function(citizenId, blueprint)
    local src = source
    
    if alreadyLearned(citizenId, blueprint) then
        return TriggerClientEvent('QBCore:Notify', src, 'You have already learned this blueprint', 'error') 
    end
    if hasBlueprint(citizenId, blueprint) then
        return TriggerClientEvent('QBCore:Notify', src, 'You have already redeemed this blueprint', 'error') 
    end

    local result = MySQL.Sync.fetchAll('SELECT blueprints FROM hot_rewards WHERE citizenId = @citizenId', {
        ['@citizenId'] = citizenId
    })

    local blueprints = {}
    if result[1] and result[1].blueprints then
        blueprints = json.decode(result[1].blueprints)
    end

    table.insert(blueprints, blueprint)

    if result[1] then
        MySQL.Sync.execute('UPDATE hot_rewards SET blueprints = @blueprints WHERE citizenId = @citizenId', {
            ['@blueprints'] = json.encode(blueprints),
            ['@citizenId'] = citizenId
        })
    else
        MySQL.Sync.execute('INSERT INTO hot_rewards (citizenId, blueprints) VALUES (@citizenId, @blueprints)', {
            ['@citizenId'] = citizenId,
            ['@blueprints'] = json.encode(blueprints)
        })
    end

    exports['cw-crafting']:giveBlueprintItem(src, blueprint)
end)

function hasBlueprint(citizenId, blueprint)
    local result = MySQL.Sync.fetchAll('SELECT blueprints FROM hot_rewards WHERE citizenId = @citizenId', {
        ['@citizenId'] = citizenId
    })
    if result[1] and result[1].blueprints then
        local blueprints = json.decode(result[1].blueprints)
        for _, bp in ipairs(blueprints) do
            if bp == blueprint then
                return true
            end
        end
    end

    return false
end

function alreadyLearned(citizenId, blueprint)
    local result = MySQL.Sync.fetchAll('SELECT crafting_blueprints FROM players WHERE citizenid = @citizenId', {
        ['@citizenId'] = citizenId
    })
    if result[1] and result[1].crafting_blueprints then
        local crafting_blueprints = json.decode(result[1].crafting_blueprints)
        for _, bp in ipairs(crafting_blueprints) do
            if bp == blueprint then
                return true
            end
        end
    end

    return false

end
