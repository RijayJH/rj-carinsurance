local QBCore = exports["qb-core"]:GetCoreObject()

local function AddSQL(cid, plate)
    local id = MySQL.insert.await('INSERT INTO `rj-carinsurance` (vehicle, date) VALUES (?, ?)', {plate, os.date('%Y-%m-%d')})
    print(id)
end

local function Additem(src, name, plate)
    if exports.ox_inventory:CanCarryItem(src, Config.itemname, 1) then
        local date = os.date("%x")
        if exports.ox_inventory:AddItem(src, Config.itemname, 1, { cardate = date, carplate = plate, carname = name }) then
            return true
        else
            return false
        end
    end
end

-- Convert date string as YYYY-MM-DD to Epoch time.
local function parseDate (str)
    local y, m, d = string.match(str, "(%d+)-(%d+)-(%d+)")
    return os.time({year = y, month = m, day = d})
end

local function checklicense(plate)
    local diff
    local row = MySQL.single.await('SELECT * FROM `rj-carinsurance` WHERE vehicle = ?', {plate})
    if row then
        if row.date == nil then return false end
        local today = os.date('%Y-%m-%d')
        local seconds = 60 * 60 * 24
        local d1 = parseDate(row.date)
        local d2 = parseDate(today)
        diff = math.ceil(os.difftime(d2, d1) / seconds)
    end
    if diff ~= nil then
        if diff > Config.days then
            return false
        else
            return true
        end
    else
        return false
    end
end 

RegisterNetEvent('rj-carinsurance:server:Addlicense', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local name = Player.PlayerData.charinfo.firstname .." ".. Player.PlayerData.charinfo.lastname
    local plate = data.plate
    if not checklicense(plate) and exports["vehicles_keys"]:isPlayerOwnerOfVehiclePlate(src, plate, true) then
        if Player.Functions.RemoveMoney(data.money, Config.Money, "Vehicle Insurance") then
            local cid = Player.PlayerData.citizenid
            sql = AddSQL(cid, plate)
            item = Additem(src, name, plate)
            if not item then print('failed adding item') return false end
            TriggerClientEvent('QBCore:Notify', src, "Successfully given license", "success")
        else
            TriggerClientEvent('QBCore:Notify', src, "Not enough money!", "error")
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "You already have an insurance or you dont own this vehicle", "error")
    end
end)




lib.addCommand('qbcore.god', 'givetestlicense', function(source, args)
    local src = source
    Additem(src, 'lmao', 'kekw')
end)


    
