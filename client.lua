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
    
    -- Check if categories are enabled
    if Config.EngineSounds.showCategories then
        showCategorySelectionDialog(sounds, plate)
    else
        showSoundSelectionDialog(sounds, plate)
    end
end)

function showCategorySelectionDialog(sounds, plate)
    Config:DebugPrint("Showing category selection dialog")
    
    -- Debug: Check if lib is available
    local hasLib = lib ~= nil
    local hasRegisterContext = hasLib and lib.registerContext ~= nil
    local hasShowContext = hasLib and lib.showContext ~= nil
    
    if not hasRegisterContext or not hasShowContext then
        Config:DebugPrint("ox_lib context not available, falling back to sound list")
        showSoundSelectionDialog(sounds, plate)
        return
    end
    
    -- Build category options
    local categoryOptions = {}
    local categories = Config.EngineSounds.categories
    
    for categoryKey, categoryName in pairs(categories) do
        -- Count sounds in this category
        local soundCount = 0
        for _, sound in ipairs(sounds) do
            if sound.category == categoryKey then
                soundCount = soundCount + 1
            end
        end
        
        if soundCount > 0 then
            table.insert(categoryOptions, {
                title = categoryName,
                description = 'Browse ' .. soundCount .. ' engine sounds',
                icon = 'folder',
                onSelect = function()
                    showCategorySounds(sounds, plate, categoryKey, categoryName)
                end
            })
        end
    end
    
    -- Register the category selection menu
    lib.registerContext({
        id = 'engine_sound_categories',
        title = '🔊 Engine Sound Categories',
        options = categoryOptions
    })
    
    -- Show the category menu
    lib.showContext('engine_sound_categories')
end

function showCategorySounds(sounds, plate, categoryKey, categoryName)
    Config:DebugPrint("Showing sounds for category: " .. categoryKey)
    
    -- Filter sounds by category
    local categorySounds = {}
    for _, sound in ipairs(sounds) do
        if sound.category == categoryKey then
            table.insert(categorySounds, sound)
        end
    end
    
    -- Build context menu options for this category
    local contextOptions = {}
    
    -- Add back button
    table.insert(contextOptions, {
        title = '← Back to Categories',
        description = 'Return to category selection',
        icon = 'arrow-left',
        onSelect = function()
            showCategorySelectionDialog(sounds, plate)
        end
    })
    
    -- Add separator
    table.insert(contextOptions, {
        title = '─────────────────',
        disabled = true
    })
    
    -- Add sounds in this category
    for i, sound in ipairs(categorySounds) do
        local soundName = sound.label or sound.value or "Unknown"
        local soundValue = sound.value or soundName
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
    
    -- Register the category sounds menu
    lib.registerContext({
        id = 'engine_sound_category_' .. categoryKey,
        title = categoryName,
        options = contextOptions
    })
    
    -- Show the category sounds menu
    lib.showContext('engine_sound_category_' .. categoryKey)
end

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
    
    -- Check if categories are enabled
    if Config.EngineSounds.showCategories and hasRegisterContext and hasShowContext then
        Config:DebugPrint("Using category-based menu system")
        showCategorySelectionMenu(sounds, plate)
        return
    end
    
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

-- Category selection menu
function showCategorySelectionMenu(sounds, plate)
    Config:DebugPrint("Showing category selection menu")
    
    -- Build categories list
    local categoryOptions = {}
    local categories = Config.EngineSounds.categories
    
    -- Count sounds per category
    local categoryCounts = {}
    for _, sound in ipairs(sounds) do
        local category = sound.category or "other"
        categoryCounts[category] = (categoryCounts[category] or 0) + 1
    end
    
    -- Build category menu options
    for categoryKey, categoryName in pairs(categories) do
        local count = categoryCounts[categoryKey] or 0
        if count > 0 then
            table.insert(categoryOptions, {
                title = categoryName,
                description = count .. " sounds available",
                icon = "list",
                onSelect = function()
                    showSoundsInCategory(sounds, plate, categoryKey, categoryName)
                end
            })
        end
    end
    
    -- Add "All Sounds" option
    table.insert(categoryOptions, 1, {
        title = "🌐 All Sounds",
        description = #sounds .. " sounds available",
        icon = "globe",
        onSelect = function()
            showSoundSelectionContext(sounds, plate)
        end
    })
    
    -- Register and show category menu
    lib.registerContext({
        id = 'engine_sound_categories',
        title = '🔊 Select Sound Category',
        options = categoryOptions
    })
    
    lib.showContext('engine_sound_categories')
end

-- Show sounds within a specific category
function showSoundsInCategory(allSounds, plate, categoryKey, categoryName)
    Config:DebugPrint("Showing sounds in category: " .. categoryKey)
    
    -- Filter sounds by category
    local categorySounds = {}
    for _, sound in ipairs(allSounds) do
        if sound.category == categoryKey then
            table.insert(categorySounds, sound)
        end
    end
    
    Config:DebugPrint("Found " .. #categorySounds .. " sounds in category " .. categoryKey)
    
    -- Build sound options
    local soundOptions = {}
    
    for i, sound in ipairs(categorySounds) do
        local soundName = sound.label or sound.value or "Unknown"
        local soundValue = sound.value or soundName
        table.insert(soundOptions, {
            title = soundName,
            description = 'Apply this engine sound',
            icon = "volume-high",
            onSelect = function()
                Config:DebugPrint("Player selected sound: " .. soundName .. " (value: " .. soundValue .. ") for plate: " .. plate)
                TriggerServerEvent('customsounds:applySound', soundValue, plate)
                lib.hideContext()
            end
        })
    end
    
    -- Add back button
    table.insert(soundOptions, 1, {
        title = "⬅️ Back to Categories",
        description = "Return to category selection",
        icon = "arrow-left",
        onSelect = function()
            -- Re-request sounds list to show categories again
            TriggerServerEvent('customsounds:requestSoundsList', plate)
        end
    })
    
    -- Register and show sounds menu
    lib.registerContext({
        id = 'engine_sounds_' .. categoryKey,
        title = categoryName,
        options = soundOptions
    })
    
    lib.showContext('engine_sounds_' .. categoryKey)
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

-- Fallback QBCore menu system
function showQBCoreMenu(sounds, plate)
    Config:DebugPrint("Using QBCore fallback menu")
    
    -- Simple chat-based selection as last resort
    local soundsPerPage = Config.UI.fallbackMenu.soundsPerPage
    local totalPages = math.ceil(#sounds / soundsPerPage)
    
    -- Show first page
    showSoundsPage(sounds, plate, 1, totalPages)
end

function showSoundsPage(sounds, plate, currentPage, totalPages)
    local soundsPerPage = Config.UI.fallbackMenu.soundsPerPage
    local startIndex = (currentPage - 1) * soundsPerPage + 1
    local endIndex = math.min(startIndex + soundsPerPage - 1, #sounds)
    
    -- Send page info to chat
    TriggerEvent('chat:addMessage', {
        color = {255, 255, 0},
        multiline = true,
        args = {"🔊 Engine Sounds", "Page " .. currentPage .. " of " .. totalPages .. " | Use /" .. Config.UI.fallbackMenu.commands.select .. " [number] to select"}
    })
    
    -- List sounds on this page
    for i = startIndex, endIndex do
        local sound = sounds[i]
        local soundName = sound.label or sound.value or "Unknown"
        local displayIndex = i - startIndex + 1
        
        TriggerEvent('chat:addMessage', {
            color = {255, 255, 255},
            args = {"[" .. displayIndex .. "]", soundName}
        })
    end
    
    -- Store page data for selection
    fallbackMenuData = {
        sounds = sounds,
        plate = plate,
        currentPage = currentPage,
        totalPages = totalPages,
        startIndex = startIndex,
        endIndex = endIndex
    }
end

-- Register fallback commands
RegisterCommand(Config.UI.fallbackMenu.commands.select, function(source, args)
    if not fallbackMenuData then return end
    
    local selection = tonumber(args[1])
    if not selection or selection < 1 or selection > (fallbackMenuData.endIndex - fallbackMenuData.startIndex + 1) then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            args = {"Error", "Invalid selection. Use a number between 1 and " .. (fallbackMenuData.endIndex - fallbackMenuData.startIndex + 1)}
        })
        return
    end
    
    local soundIndex = fallbackMenuData.startIndex + selection - 1
    local selectedSound = fallbackMenuData.sounds[soundIndex]
    
    if selectedSound then
        TriggerServerEvent('customsounds:applySound', selectedSound.value, fallbackMenuData.plate)
        fallbackMenuData = nil
    end
end, false)

RegisterCommand(Config.UI.fallbackMenu.commands.next, function(source, args)
    if not fallbackMenuData then return end
    if fallbackMenuData.currentPage < fallbackMenuData.totalPages then
        showSoundsPage(fallbackMenuData.sounds, fallbackMenuData.plate, fallbackMenuData.currentPage + 1, fallbackMenuData.totalPages)
    end
end, false)

RegisterCommand(Config.UI.fallbackMenu.commands.prev, function(source, args)
    if not fallbackMenuData then return end
    if fallbackMenuData.currentPage > 1 then
        showSoundsPage(fallbackMenuData.sounds, fallbackMenuData.plate, fallbackMenuData.currentPage - 1, fallbackMenuData.totalPages)
    end
end, false)

RegisterCommand(Config.UI.fallbackMenu.commands.cancel, function(source, args)
    fallbackMenuData = nil
    TriggerEvent('chat:addMessage', {
        color = {255, 255, 0},
        args = {"🔊 Engine Sounds", "Selection cancelled"}
    })
end, false)

-- Variable to store fallback menu data
local fallbackMenuData = nil

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