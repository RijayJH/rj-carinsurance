local QBCore = exports["qb-core"]:GetCoreObject()
local IsTargetReady = GetResourceState(Config.target) == "started" or GetResourceState("ox_target") == "started" or GetResourceState("qb-target") == "started"
local PlayerData = QBCore.Functions.GetPlayerData()

AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    exports.ox_inventory:displayMetadata({
        carname = "Name",
        carplate = "Plate",
        cardate = "Date"
    })
end)

local function SpawnPed()
    if pedSpawned then return end
    local model = joaat(Config.model)
    lib.requestModel(model)
    local coords = Config.coords4
    local salesdude = CreatePed(0, model, coords.x, coords.y, coords.z-1.0, coords.w, false, false)


    TaskStartScenarioInPlace(salesdude, 'PROP_HUMAN_STAND_IMPATIENT', 0, true)
    FreezeEntityPosition(salesdude, true)
    SetEntityInvincible(salesdude, true)
    SetBlockingOfNonTemporaryEvents(salesdude, true)

    pedSpawned = true
    if true then
        if IsTargetReady then
            if Config.targettype == 'ox' then
                exports.ox_target:addLocalEntity(salesdude, {
                    {
                        name = 'rj-carinsurance',
                        label = 'Get New Insurance',
                        event = 'rj-carinsurance:client:target',
                        icon = 'fa-solid fa-clipboard',
                        canInteract = function(_, distance)
                            return distance < 4.0
                        end
                    }
                })
            elseif Config.targettype == 'qb' then
                exports['qb-target']:AddTargetEntity(salesdude, {
                    {
                        num = 1,
                        type = 'client',
                        event = 'rj-carinsurance:client:target',
                        icon = 'ffa-solid fa-clipboard',
                        label = 'Get New Insurance',
                        canInteract = function(_, distance)
                            return distance < 4.0
                        end
                    }
                })
            else
                print('This target is not supported')
            end
        else
            print('No targets found')
        end
    end
end

CreateThread(function()
    SpawnPed()
end)


RegisterNetEvent('rj-carinsurance:client:target', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped)
    local plate
    if vehicle then
        plate = QBCore.Functions.GetPlate(vehicle)
    end
    if ped then
        lib.registerContext({
            id = 'carinsurancemenu',
            title = 'How would you like to pay today?',
            icon = "fas fa-cars",
            options = {
                {
                    title = 'Bank',
                    description = 'Pay from your bank account',
                    arrow = false,
                    icon = 'fas fa-university',
                    serverEvent = 'rj-carinsurance:server:Addlicense',
                    args = {src = ped, plate = plate, money = 'bank'}
                },
                {
                    title = 'Cash',
                    description = 'Pay using cash',
                    icon = 'fas fa-money-bill-wave',
                    arrow = false,
                    serverEvent = 'rj-carinsurance:server:Addlicense',
                    args = {src = ped, plate = plate, money = 'cash'}
                }
            }
        })
        lib.showContext('carinsurancemenu')
    end
end)

RegisterCommand('lmaotest', function()
    TriggerEvent('rj-carinsurance:client:target')
end)
