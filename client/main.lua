local QBCore = exports['qb-core']:GetCoreObject()
local entities = {}
local initalized = false
local bluePrintPed = nil

-- FUNCTIONS
function loadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
end

function loadAnimDict(animDict)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(0)
    end
end

function bluePrintPed()
    if initalized then return end
    -- Ped
    loadModel(Config.Ped.model)
    bluePrintPed = CreatePed(4, Config.Ped.model, Config.Ped.coords.x, Config.Ped.coords.y, Config.Ped.coords.z - 0.90, Config.Ped.coords.w, false, true)
    FreezeEntityPosition(bluePrintPed, true)
    SetEntityInvincible(bluePrintPed, true)
    SetBlockingOfNonTemporaryEvents(bluePrintPed, true)
    if Config.Ped.useEmote then
    loadAnimDict(Config.Ped.animDict)
    TaskPlayAnim(bluePrintPed, Config.Ped.animDict, Config.Ped.animName, 8.0, 8.0, -1, 1, 0, false, false, false)
    end
    if Config.Ped.useScenario then
        TaskStartScenarioInPlace(bluePrintPed, Config.Ped.scenario, 0, true)
    end
    table.insert(entities, bluePrintPed)
    -- Target
    if Config.target == 'qb' then
    exports['qb-target']:AddTargetEntity(bluePrintPed, {
        options = {
            {
                type = "client",
                icon = "fas fa-scroll",
                label = Config.Ped.targetLabel,
                action = function()
                    openBlueprintMenu()
                end,
            }
        },
        distance = 2.0
    })
    else
    exports['ox_target']:addLocalEntity(bluePrintPed, {
        {
            name = 'blueprint_ped',
            icon = 'fas fa-scroll',
            label = Config.Ped.targetLabel,
            onSelect = function()
                openBlueprintMenu()
            end,
        }
    })
end
    initalized = true
end

function openBlueprintMenu()
    if Config.menu == 'qb' then
        local menu = {
            {
                header = "Blueprint Reward Menu",
                isMenuHeader = true
            }
        }
    
        for i, reward in ipairs(Config.Rewards) do
            table.insert(menu, {
                header = reward.label,
                txt = reward.description,
                params = {
                    event = "nm-blueprints:client:giveBlueprint",
                    args = { index = i }
                }
            })
        end
    
        table.insert(menu, {
            header = "Close Menu",
            txt = "",
            params = {
                event = "qb-menu:client:closeMenu"
            }
        })
    
        exports['qb-menu']:openMenu(menu)
    else
    local options = {
        {
            title = "Blueprint Reward Menu",
            description = "",
            disabled = true
        }
    }

    for i, reward in ipairs(Config.Rewards) do
        table.insert(options, {
            title = reward.label,
            description = reward.description,
            event = "nm-blueprints:client:giveBlueprint",
            args = { index = i }
        })
    end

    table.insert(options, {
        title = "Close Menu",
        description = "",
        event = "ox_lib:closeMenu"
    })

    lib.registerContext({
        id = 'blueprint_menu',
        title = 'Blueprint Reward Menu',
        options = options
    })

    lib.showContext('blueprint_menu')
    end
end

RegisterNetEvent('nm-blueprints:client:giveBlueprint', function(data)
    local index = data.index
    local player = QBCore.Functions.GetPlayerData().citizenid
    local reward = Config.Rewards[index]
    local requiredSkill = exports["cw-rep"]:getCurrentSkill(reward.skillName)
    if requiredSkill >= reward.skillRequired then
        TriggerServerEvent('nm-blueprints:receiveBlueprint', player, reward.blueprint)
    else
        QBCore.Functions.Notify('You do not have the required skill to redeem this blueprint', 'error')
    end
end)

-- Event Handlers

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    Wait(2000)
    bluePrintPed()
end)

AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    if Config.target == 'qb' then
    exports['qb-target']:RemoveTargetEntity(bluePrintPed, Config.Ped.targetLabel)
    else
        exports.ox_target:removeLocalEntity(bluePrintPed, 'blueprint_menu')
    end
    for k, v in pairs(entities) do
        DeleteEntity(v)
    end
    initalized = false
end)

AddEventHandler('onResourceStart', function(resName)
    if (GetCurrentResourceName() ~= resName) then return end
    bluePrintPed()
end)

AddEventHandler('onResourceStop', function(resName)
    if (GetCurrentResourceName() ~= resName) then return end
    if Config.target == 'qb' then
    exports['qb-target']:RemoveTargetEntity(bluePrintPed, Config.Ped.targetLabel)
    else
        exports.ox_target:removeLocalEntity(bluePrintPed, 'blueprint_menu')
    end
    for k, v in pairs(entities) do
        DeleteEntity(v)
    end
end)