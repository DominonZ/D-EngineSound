local vehicle_sounds = {} 

RegisterNetEvent("engine:sound")
AddEventHandler("engine:sound", function(name,plate)
    if vehicle_sounds[plate] == nil then
        vehicle_sounds[plate] = {}
    end
    vehicle_sounds[plate].plate = plate
    vehicle_sounds[plate].name = name
end)

-- Handle showing the sound selection menu
RegisterNetEvent('customsounds:showMenu', function(plate)
    -- Get the sounds list from server
    lib.callback('customsounds:getSoundsList', false, function(sounds)
        if not sounds then
            lib.notify({
                type = 'error',
                description = 'Failed to load engine sounds list'
            })
            return
        end
        
        -- Create input dialog with searchable select dropdown
        local input = lib.inputDialog('Engine Sound Selector', {
            {
                type = 'select',
                label = 'Choose Engine Sound',
                description = 'Select from available engine sounds',
                icon = 'volume-high',
                required = true,
                searchable = true,
                options = sounds
            }
        })
        
        if input and input[1] then
            -- Send the selected sound to server to apply (include plate for verification)
            TriggerServerEvent('customsounds:applySound', input[1], plate)
        end
    end)
end)

Citizen.CreateThread(function()
    while true do
        local mycoords = GetEntityCoords(PlayerPedId())
        for k,v in pairs(GetGamePool('CVehicle')) do
            local plate = string.gsub(GetVehicleNumberPlateText(v), "%s+", "")
            if #(mycoords - GetEntityCoords(v, false)) < 100 then
                if vehicle_sounds[plate] ~= nil and vehicle_sounds[plate].plate ~= nil and plate == vehicle_sounds[plate].plate and vehicle_sounds[plate].current ~= vehicle_sounds[plate].name then
                ForceVehicleEngineAudio(v,vehicle_sounds[plate].name)
                vehicle_sounds[plate].current = vehicle_sounds[plate].name
            end
        elseif #(mycoords - GetEntityCoords(v, false)) > 100 and vehicle_sounds[plate] ~= nil and vehicle_sounds[plate].current ~= nil then
            vehicle_sounds[plate].current = nil
        end
    end
        Wait(2000)
    end
end)

-- Vehicle tracking for automatic sound restoration
local trackedVehicles = {}

-- Function to check and load sound for a vehicle
local function CheckVehicleSound(vehicle)
    if not DoesEntityExist(vehicle) then return end
    
    local plate = string.gsub(GetVehicleNumberPlateText(vehicle), "%s+", "")
    if not plate or plate == "" then return end
    
    if not trackedVehicles[plate] then
        trackedVehicles[plate] = true
        -- Request sound loading from server
        TriggerServerEvent('customsounds:loadVehicleSound', plate)
    end
end

-- Thread to monitor vehicle spawns
CreateThread(function()
    local lastVehicleCount = 0
    
    while true do
        local vehicles = GetGamePool('CVehicle')
        local currentCount = #vehicles
        
        -- If vehicle count increased, check new vehicles
        if currentCount > lastVehicleCount then
            for _, vehicle in pairs(vehicles) do
                CheckVehicleSound(vehicle)
            end
        end
        
        lastVehicleCount = currentCount
        Wait(2000) -- Check every 2 seconds
    end
end)

-- Clean up tracked vehicles when they're deleted
CreateThread(function()
    while true do
        for plate, _ in pairs(trackedVehicles) do
            local found = false
            for _, vehicle in pairs(GetGamePool('CVehicle')) do
                local vehPlate = string.gsub(GetVehicleNumberPlateText(vehicle), "%s+", "")
                if vehPlate == plate then
                    found = true
                    break
                end
            end
            
            if not found then
                trackedVehicles[plate] = nil
            end
        end
        
        Wait(10000) -- Clean up every 10 seconds
    end
end)