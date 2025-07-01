local vehicle_sounds = {} 

local vehicle_sounds = {} 

-- Enhanced debug: Check if lib is available with multiple checks
CreateThread(function()
    Wait(2000) -- Wait longer for ox_lib to load
    
    -- Check multiple ways
    local libAvailable = lib ~= nil
    local callbackAvailable = lib and lib.callback ~= nil
    local notifyAvailable = lib and lib.notify ~= nil
    local inputDialogAvailable = lib and lib.inputDialog ~= nil
    
    print("^3[D-EngineSound] Debug Info:^7")
    print("  lib available: " .. tostring(libAvailable))
    print("  lib.callback available: " .. tostring(callbackAvailable))
    print("  lib.notify available: " .. tostring(notifyAvailable))
    print("  lib.inputDialog available: " .. tostring(inputDialogAvailable))
    
    if libAvailable and callbackAvailable and notifyAvailable and inputDialogAvailable then
        print("^2[D-EngineSound] ox_lib loaded successfully!^7")
    else
        print("^1[D-EngineSound] ERROR: ox_lib components not fully loaded!^7")
    end
end)

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
    -- Enhanced check for lib availability with retry mechanism
    if not lib or not lib.callback or not lib.notify or not lib.inputDialog then
        print("^1[D-EngineSound] ox_lib not fully available, attempting fallback...^7")
        
        -- Try to wait a bit and check again
        CreateThread(function()
            local attempts = 0
            while (not lib or not lib.callback or not lib.notify or not lib.inputDialog) and attempts < 10 do
                Wait(500)
                attempts = attempts + 1
            end
            
            if lib and lib.callback and lib.notify and lib.inputDialog then
                print("^2[D-EngineSound] ox_lib loaded after retry, proceeding with menu...^7")
                TriggerEvent('customsounds:showMenu', plate) -- Retry the menu
            else
                -- Ultimate fallback to QBX notification
                exports.qbx_core:Notify('ox_lib is not available! Please restart the server.', 'error')
            end
        end)
        return
    end
    
    print("^2[D-EngineSound] Showing menu for plate: " .. plate .. "^7")
    
    -- Get the sounds list from server using ox_lib callback
    local success, sounds = pcall(function()
        return lib.callback.await('customsounds:getSoundsList', false)
    end)
    
    if not success then
        print("^1[D-EngineSound] Error calling callback: " .. tostring(sounds) .. "^7")
        lib.notify({
            type = 'error',
            description = 'Failed to communicate with server'
        })
        return
    end
    
    if not sounds then
        lib.notify({
            type = 'error',
            description = 'Failed to load engine sounds list'
        })
        return
    end
    
    print("^2[D-EngineSound] Loaded " .. #sounds .. " engine sounds^7")
    
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
        print("^2[D-EngineSound] Player selected sound: " .. input[1] .. " for plate: " .. plate .. "^7")
        -- Send the selected sound to server to apply (include plate for verification)
        TriggerServerEvent('customsounds:applySound', input[1], plate)
    else
        print("^3[D-EngineSound] Player cancelled sound selection^7")
    end
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