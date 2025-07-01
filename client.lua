local vehicle_sounds = {} 

-- Handle showing the sound selection menu
RegisterNetEvent('customsounds:showMenu', function(plate)
    print("^2[D-EngineSound] Showing menu for plate: " .. plate .. "^7")
    
    -- Request sounds list from server using traditional event
    TriggerServerEvent('customsounds:requestSoundsList', plate)
end)

-- Handle received sounds list from server
RegisterNetEvent('customsounds:receiveSoundsList', function(sounds, plate)
    if not sounds or #sounds == 0 then
        print("^1[D-EngineSound] No sounds received from server^7")
        exports.qbx_core:Notify('Failed to load engine sounds list', 'error')
        return
    end
    
    print("^2[D-EngineSound] Successfully received " .. #sounds .. " sounds from server^7")
    showSoundSelectionDialog(sounds, plate)
end)

function showSoundSelectionDialog(sounds, plate)
    print("^2[D-EngineSound] Attempting to show sound selection dialog^7")
    print("^2[D-EngineSound] Sounds count: " .. #sounds .. "^7")
    print("^2[D-EngineSound] Plate: " .. plate .. "^7")
    
    -- Debug: Check if lib is available
    local hasLib = lib ~= nil
    local hasInputDialog = hasLib and lib.inputDialog ~= nil
    local hasRegisterContext = hasLib and lib.registerContext ~= nil
    local hasShowContext = hasLib and lib.showContext ~= nil
    
    print("^2[D-EngineSound] lib available: " .. tostring(hasLib) .. "^7")
    print("^2[D-EngineSound] inputDialog available: " .. tostring(hasInputDialog) .. "^7")
    print("^2[D-EngineSound] registerContext available: " .. tostring(hasRegisterContext) .. "^7")
    print("^2[D-EngineSound] showContext available: " .. tostring(hasShowContext) .. "^7")
    
    -- Try context menu first (more reliable)
    if hasRegisterContext and hasShowContext then
        print("^2[D-EngineSound] Using context menu approach^7")
        showSoundSelectionContext(sounds, plate)
        return
    end
    
    -- Try input dialog with proper format
    if hasInputDialog then
        print("^2[D-EngineSound] Using input dialog approach^7")
        
        -- Convert sounds to proper format for ox_lib inputDialog
        local options = {}
        for i, sound in ipairs(sounds) do
            if type(sound) == "string" then
                table.insert(options, {value = sound, label = sound})
            elseif type(sound) == "table" and sound.value then
                table.insert(options, sound)
            else
                print("^1[D-EngineSound] Invalid sound format: " .. tostring(sound) .. "^7")
            end
        end
        
        print("^2[D-EngineSound] Formatted options count: " .. #options .. "^7")
        
        local input = lib.inputDialog('Engine Sound Selector', {
            {
                type = 'select',
                label = 'Choose Engine Sound',
                description = 'Select from available engine sounds',
                icon = 'volume-high',
                required = true,
                searchable = true,
                options = options
            }
        })
        
        if input and input[1] then
            print("^2[D-EngineSound] Player selected sound: " .. input[1] .. " for plate: " .. plate .. "^7")
            TriggerServerEvent('customsounds:applySound', input[1], plate)
        else
            print("^3[D-EngineSound] Player cancelled sound selection or input was nil^7")
        end
        return
    end
    
    -- Fallback notification
    print("^1[D-EngineSound] No suitable UI method available^7")
    exports.qbx_core:Notify('Sound selector requires ox_lib. Please contact an administrator.', 'error')
end

function showSoundSelectionContext(sounds, plate)
    -- Build context menu options
    local contextOptions = {}
    
    for i, sound in ipairs(sounds) do
        local soundName = type(sound) == "string" and sound or (sound.value or sound.label or "Unknown")
        table.insert(contextOptions, {
            title = soundName,
            description = 'Apply this engine sound',
            icon = 'volume-high',
            onSelect = function()
                print("^2[D-EngineSound] Player selected sound: " .. soundName .. " for plate: " .. plate .. "^7")
                TriggerServerEvent('customsounds:applySound', soundName, plate)
                lib.hideContext()
            end
        })
    end
    
    -- Register the context menu
    lib.registerContext({
        id = 'engine_sound_selector',
        title = 'Engine Sound Selector',
        options = contextOptions
    })
    
    -- Show the context menu
    lib.showContext('engine_sound_selector')
end

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