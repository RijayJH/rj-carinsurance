local QBCore = exports["qb-core"]:GetCoreObject()
local PlayerData = QBCore.Functions.GetPlayerData()

AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    exports.ox_inventory:displayMetadata({
        carname = "Name",
        carplate = "Plate",
        cardate = "Date"
    })
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
