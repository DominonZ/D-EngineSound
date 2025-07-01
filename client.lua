local vehicle_sounds = {} 

-- Handle showing the sound selection menu
RegisterNetEvent('customsounds:showMenu', function(plate)
    Config:DebugPrint("Showing menu for plate: " .. plate)
    
    -- Request sounds list from server using traditional event
    TriggerServerEvent('customsounds:requestSoundsList', plate)
end)

-- Handle received sounds list from server
RegisterNetEvent('customsounds:receiveSoundsList', function(sounds, plate)
    if not sounds or #sounds == 0 then
        Config:DebugPrint("No sounds received from server")
        exports.qbx_core:Notify('Failed to load engine sounds list', 'error')
        return
    end
    
    Config:DebugPrint("Successfully received " .. #sounds .. " sounds from server")
    showSoundSelectionDialog(sounds, plate)
end)

function showSoundSelectionDialog(sounds, plate)
    Config:DebugPrint("Attempting to show sound selection dialog")
    Config:DebugPrint("Sounds count: " .. #sounds)
    Config:DebugPrint("Plate: " .. plate)
    
    -- Debug: Check if lib is available
    local hasLib = lib ~= nil
    local hasInputDialog = hasLib and lib.inputDialog ~= nil
    local hasRegisterContext = hasLib and lib.registerContext ~= nil
    local hasShowContext = hasLib and lib.showContext ~= nil
    
    Config:DebugPrint("lib available: " .. tostring(hasLib))
    Config:DebugPrint("inputDialog available: " .. tostring(hasInputDialog))
    Config:DebugPrint("registerContext available: " .. tostring(hasRegisterContext))
    Config:DebugPrint("showContext available: " .. tostring(hasShowContext))
    
    -- Use preferred method from config or fallback
    local preferredMethod = Config.UI.preferredMethod
    
    -- Try context menu first if preferred or input dialog not available
    if (preferredMethod == "context" or not hasInputDialog) and hasRegisterContext and hasShowContext then
        Config:DebugPrint("Using context menu approach")
        showSoundSelectionContext(sounds, plate)
        return
    end
    
    -- Try input dialog if preferred and available
    if (preferredMethod == "input" or preferredMethod ~= "fallback") and hasInputDialog then
        Config:DebugPrint("Using input dialog approach")
        
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
        
        Config:DebugPrint("Formatted options count: " .. #options)
        
        local input = lib.inputDialog(Config.UI.inputDialog.title, {
            {
                type = 'select',
                label = 'Choose Engine Sound',
                description = 'Select from available engine sounds',
                icon = Config.UI.inputDialog.icon,
                required = Config.UI.inputDialog.required,
                searchable = Config.UI.inputDialog.searchable,
                options = options
            }
        })
        
        if input and input[1] then
            Config:DebugPrint("Player selected sound: " .. input[1] .. " for plate: " .. plate)
            TriggerServerEvent('customsounds:applySound', input[1], plate)
        else
            Config:DebugPrint("Player cancelled sound selection or input was nil")
        end
        return
    end
    
    -- Fallback: Use QBCore menu system
    Config:DebugPrint("Using QBCore menu fallback")
    showQBCoreMenu(sounds, plate)
end

function showSoundSelectionContext(sounds, plate)
    -- Build context menu options
    local contextOptions = {}
    
    for i, sound in ipairs(sounds) do
        local soundName = type(sound) == "string" and sound or (sound.label or sound.value or "Unknown")
        local soundValue = type(sound) == "string" and sound or (sound.value or soundName)
        table.insert(contextOptions, {
            title = soundName,
            description = 'Apply this engine sound',
            icon = Config.UI.contextMenu.icon,
            onSelect = function()
                Config:DebugPrint("Player selected sound: " .. soundName .. " (value: " .. soundValue .. ") for plate: " .. plate)
                TriggerServerEvent('customsounds:applySound', soundValue, plate)
                lib.hideContext()
            end
        })
    end
    
    -- Register the context menu using config
    lib.registerContext({
        id = Config.UI.contextMenu.id,
        title = Config.UI.contextMenu.title,
        options = contextOptions
    })
    
    -- Show the context menu
    lib.showContext(Config.UI.contextMenu.id)
end

Citizen.CreateThread(function()
    while true do
        local mycoords = GetEntityCoords(PlayerPedId())
        for k,v in pairs(GetGamePool('CVehicle')) do
            local plate = string.gsub(GetVehicleNumberPlateText(v), "%s+", "")
            if #(mycoords - GetEntityCoords(v, false)) < Config.Sounds.applicationRange then
                if vehicle_sounds[plate] ~= nil and vehicle_sounds[plate].plate ~= nil and plate == vehicle_sounds[plate].plate and vehicle_sounds[plate].current ~= vehicle_sounds[plate].name then
                ForceVehicleEngineAudio(v,vehicle_sounds[plate].name)
                vehicle_sounds[plate].current = vehicle_sounds[plate].name
            end
        elseif #(mycoords - GetEntityCoords(v, false)) > Config.Sounds.applicationRange and vehicle_sounds[plate] ~= nil and vehicle_sounds[plate].current ~= nil then
            vehicle_sounds[plate].current = nil
        end
    end
        Wait(Config.Sounds.updateInterval)
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
        Wait(Config.Sounds.tracking.checkInterval) -- Use config interval
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
        
        Wait(Config.Sounds.tracking.cleanupInterval) -- Use config interval
    end
end)

function showQBCoreMenu(sounds, plate)
    -- Create a menu using QBCore's menu system or simple text selection
    local menuOptions = {}
    
    -- Create a paginated menu using config values
    local soundsPerPage = Config.UI.fallbackMenu.soundsPerPage
    local currentPage = 1
    local totalPages = math.ceil(#sounds / soundsPerPage)
    
    local function showSoundPage(page)
        local startIndex = (page - 1) * soundsPerPage + 1
        local endIndex = math.min(page * soundsPerPage, #sounds)
        
        if Config.UI.fallbackMenu.showPageInfo then
            exports.qbx_core:Notify('Engine Sound Selector - Page ' .. page .. '/' .. totalPages, 'primary')
        end
        exports.qbx_core:Notify('Use chat commands to select sounds:', 'info')
        
        for i = startIndex, endIndex do
            local sound = sounds[i]
            local soundName = type(sound) == "string" and sound or (sound.label or sound.value or "Unknown")
            local soundValue = type(sound) == "string" and sound or (sound.value or soundName)
            
            exports.qbx_core:Notify('[' .. (i - startIndex + 1) .. '] ' .. soundName, 'info')
        end
        
        exports.qbx_core:Notify('Type /soundselect [1-' .. (endIndex - startIndex + 1) .. '] to choose', 'success')
        if page < totalPages then
            exports.qbx_core:Notify('Type /soundnext for next page', 'success')
        end
        if page > 1 then
            exports.qbx_core:Notify('Type /soundprev for previous page', 'success')
        end
        exports.qbx_core:Notify('Type /soundcancel to cancel', 'error')
        
        -- Store current context for commands
        currentSoundSelection = {
            sounds = sounds,
            plate = plate,
            page = page,
            startIndex = startIndex,
            endIndex = endIndex
        }
    end
    
    -- Start with first page
    showSoundPage(1)
end

-- Global variable to store current selection context
local currentSoundSelection = nil

-- Command to select sound by number
RegisterCommand(Config.UI.fallbackMenu.commands.select, function(source, args)
    if not currentSoundSelection then
        exports.qbx_core:Notify('No sound selection active', 'error')
        return
    end
    
    local selection = tonumber(args[1])
    if not selection then
        exports.qbx_core:Notify('Please provide a valid number', 'error')
        return
    end
    
    local soundIndex = currentSoundSelection.startIndex + selection - 1
    if soundIndex < currentSoundSelection.startIndex or soundIndex > currentSoundSelection.endIndex then
        exports.qbx_core:Notify('Invalid selection. Choose between 1 and ' .. (currentSoundSelection.endIndex - currentSoundSelection.startIndex + 1), 'error')
        return
    end
    
    local sound = currentSoundSelection.sounds[soundIndex]
    local soundValue = type(sound) == "string" and sound or (sound.value or sound.label or "Unknown")
    
    Config:DebugPrint("Player selected sound: " .. soundValue .. " for plate: " .. currentSoundSelection.plate)
    TriggerServerEvent('customsounds:applySound', soundValue, currentSoundSelection.plate)
    
    exports.qbx_core:Notify('Applied sound: ' .. (sound.label or soundValue), 'success')
    currentSoundSelection = nil
end, false)

-- Command to go to next page
RegisterCommand(Config.UI.fallbackMenu.commands.next, function(source, args)
    if not currentSoundSelection then
        exports.qbx_core:Notify('No sound selection active', 'error')
        return
    end
    
    local soundsPerPage = Config.UI.fallbackMenu.soundsPerPage
    local totalPages = math.ceil(#currentSoundSelection.sounds / soundsPerPage)
    if currentSoundSelection.page < totalPages then
        local newPage = currentSoundSelection.page + 1
        local startIndex = (newPage - 1) * soundsPerPage + 1
        local endIndex = math.min(newPage * soundsPerPage, #currentSoundSelection.sounds)
        
        if Config.UI.fallbackMenu.showPageInfo then
            exports.qbx_core:Notify('Engine Sound Selector - Page ' .. newPage .. '/' .. totalPages, 'primary')
        end
        exports.qbx_core:Notify('Use chat commands to select sounds:', 'info')
        
        for i = startIndex, endIndex do
            local sound = currentSoundSelection.sounds[i]
            local soundName = type(sound) == "string" and sound or (sound.label or sound.value or "Unknown")
            exports.qbx_core:Notify('[' .. (i - startIndex + 1) .. '] ' .. soundName, 'info')
        end
        
        exports.qbx_core:Notify('Type /' .. Config.UI.fallbackMenu.commands.select .. ' [1-' .. (endIndex - startIndex + 1) .. '] to choose', 'success')
        if newPage < totalPages then
            exports.qbx_core:Notify('Type /' .. Config.UI.fallbackMenu.commands.next .. ' for next page', 'success')
        end
        exports.qbx_core:Notify('Type /' .. Config.UI.fallbackMenu.commands.prev .. ' for previous page', 'success')
        exports.qbx_core:Notify('Type /' .. Config.UI.fallbackMenu.commands.cancel .. ' to cancel', 'error')
        
        currentSoundSelection.page = newPage
        currentSoundSelection.startIndex = startIndex
        currentSoundSelection.endIndex = endIndex
    else
        exports.qbx_core:Notify('Already on last page', 'error')
    end
end, false)

-- Command to go to previous page
RegisterCommand(Config.UI.fallbackMenu.commands.prev, function(source, args)
    if not currentSoundSelection then
        exports.qbx_core:Notify('No sound selection active', 'error')
        return
    end
    
    local soundsPerPage = Config.UI.fallbackMenu.soundsPerPage
    if currentSoundSelection.page > 1 then
        local newPage = currentSoundSelection.page - 1
        local startIndex = (newPage - 1) * soundsPerPage + 1
        local endIndex = math.min(newPage * soundsPerPage, #currentSoundSelection.sounds)
        
        if Config.UI.fallbackMenu.showPageInfo then
            exports.qbx_core:Notify('Engine Sound Selector - Page ' .. newPage .. '/' .. math.ceil(#currentSoundSelection.sounds / soundsPerPage), 'primary')
        end
        exports.qbx_core:Notify('Use chat commands to select sounds:', 'info')
        
        for i = startIndex, endIndex do
            local sound = currentSoundSelection.sounds[i]
            local soundName = type(sound) == "string" and sound or (sound.label or sound.value or "Unknown")
            exports.qbx_core:Notify('[' .. (i - startIndex + 1) .. '] ' .. soundName, 'info')
        end
        
        exports.qbx_core:Notify('Type /' .. Config.UI.fallbackMenu.commands.select .. ' [1-' .. (endIndex - startIndex + 1) .. '] to choose', 'success')
        if newPage < math.ceil(#currentSoundSelection.sounds / soundsPerPage) then
            exports.qbx_core:Notify('Type /' .. Config.UI.fallbackMenu.commands.next .. ' for next page', 'success')
        end
        if newPage > 1 then
            exports.qbx_core:Notify('Type /' .. Config.UI.fallbackMenu.commands.prev .. ' for previous page', 'success')
        end
        exports.qbx_core:Notify('Type /' .. Config.UI.fallbackMenu.commands.cancel .. ' to cancel', 'error')
        
        currentSoundSelection.page = newPage
        currentSoundSelection.startIndex = startIndex
        currentSoundSelection.endIndex = endIndex
    else
        exports.qbx_core:Notify('Already on first page', 'error')
    end
end, false)

-- Command to cancel selection
RegisterCommand(Config.UI.fallbackMenu.commands.cancel, function(source, args)
    if currentSoundSelection then
        exports.qbx_core:Notify('Sound selection cancelled', 'error')
        currentSoundSelection = nil
    else
        exports.qbx_core:Notify('No sound selection active', 'error')
    end
end, false)

-- Handle engine sound assignment from server
RegisterNetEvent("engine:sound")
AddEventHandler("engine:sound", function(soundName, plate)
    if not soundName or not plate then return end
    
    Config:DebugPrint("Received engine sound assignment: " .. soundName .. " for plate: " .. plate)
    
    -- Store the sound for this vehicle plate
    vehicle_sounds[plate] = {
        name = soundName,
        plate = plate,
        current = nil -- Will be applied in the monitoring loop
    }
    
    -- Immediately try to apply to nearby vehicles with this plate
    for k, v in pairs(GetGamePool('CVehicle')) do
        local vehiclePlate = string.gsub(GetVehicleNumberPlateText(v), "%s+", "")
        if vehiclePlate == plate then
            local playerCoords = GetEntityCoords(PlayerPedId())
            local vehicleCoords = GetEntityCoords(v, false)
            
            if #(playerCoords - vehicleCoords) < Config.Sounds.applicationRange then
                Config:DebugPrint("Immediately applying sound " .. soundName .. " to vehicle with plate " .. plate)
                ForceVehicleEngineAudio(v, soundName)
                vehicle_sounds[plate].current = soundName
                break
            end
        end
    end
end)