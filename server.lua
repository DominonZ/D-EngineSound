-- Load sounds from config
local EngineSounds = Config:GetSoundsList()

Config:DebugPrint("Loaded " .. #EngineSounds .. " engine sounds from config")

-- Initialize database table on resource start
CreateThread(function()
    -- Check if custom_sound column exists in player_vehicles table using config
    local tableName = Config.Database.tableName
    local columnName = Config.Database.columnName
    
    if Config.Database.autoCreateColumn then
        exports.oxmysql:execute('SHOW COLUMNS FROM ' .. tableName .. ' LIKE "' .. columnName .. '"', {}, function(result)
            if #result == 0 then
                -- Add custom_sound column if it doesn't exist
                exports.oxmysql:execute('ALTER TABLE ' .. tableName .. ' ADD COLUMN ' .. columnName .. ' VARCHAR(50) DEFAULT NULL', {}, function(result)
                    if result then
                        Config:DebugPrint('Successfully added ' .. columnName .. ' column to ' .. tableName .. ' table')
                    else
                        Config:DebugPrint('Failed to add ' .. columnName .. ' column to ' .. tableName .. ' table')
                    end
                end)
            else
                Config:DebugPrint('Database table ready - ' .. columnName .. ' column exists')
            end
        end)
    end
end)

RegisterCommand(Config.Commands.changeSound.name, function(source, args, rawCommand)
    local Player = exports.qbx_core:GetPlayer(source)
    
    if not Player then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = 'Player data not found'
        })
        return
    end
    
    -- Check permissions using config function
    local hasPermission, permissionType = Config:IsPlayerAllowed(source, Player)
    
    Config:DebugPrint("Permission check for player " .. source .. " - Type: " .. permissionType .. ", Allowed: " .. tostring(hasPermission))
    
    if not hasPermission then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = 'You do not have permission to change vehicle sounds (Admin or Mechanic required)'
        })
        return
    end
    
    local veh = GetVehiclePedIsIn(GetPlayerPed(source), false)
    if veh == 0 then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = 'You must be in a vehicle to change its sound'
        })
        return
    end
    
    -- Check if vehicle is owned by checking player_vehicles table
    local plate = string.gsub(GetVehicleNumberPlateText(veh), "%s+", "")
    local Player = exports.qbx_core:GetPlayer(source)
    
    if not Player then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = 'Player data not found'
        })
        return
    end
    
    -- Check if vehicle exists in player_vehicles table
    exports.oxmysql:execute('SELECT id FROM ' .. Config.Database.tableName .. ' WHERE plate = ? AND citizenid = ?', {plate, Player.PlayerData.citizenid}, function(result)
        if result and #result > 0 then
            -- Vehicle is owned, proceed with menu
            TriggerClientEvent('customsounds:showMenu', source, plate)
        else
            TriggerClientEvent('ox_lib:notify', source, {
                type = 'error',
                description = 'You can only change sounds on vehicles you own'
            })
        end
    end)
end, false)

RegisterNetEvent('customsounds:applySound')
AddEventHandler('customsounds:applySound', function(soundId, plate)
    if not soundId or not plate then return end
    
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    if not Player then return end
    
    local veh = GetVehiclePedIsIn(GetPlayerPed(src), false)
    
    if veh and veh ~= 0 then
        local vehiclePlate = string.gsub(GetVehicleNumberPlateText(veh), "%s+", "")
        
        -- Verify the plate matches what was sent from client
        if vehiclePlate ~= plate then
            TriggerClientEvent('ox_lib:notify', src, {
                type = 'error',
                description = 'Vehicle verification failed'
            })
            return
        end
        
        -- Update the database with the new sound using config
        exports.oxmysql:execute('UPDATE ' .. Config.Database.tableName .. ' SET ' .. Config.Database.columnName .. ' = ? WHERE plate = ? AND citizenid = ?', {
            soundId, 
            plate, 
            Player.PlayerData.citizenid
        }, function(result)
            if result and result.affectedRows and result.affectedRows > 0 then
                -- Apply the sound to all clients
                TriggerClientEvent("engine:sound", -1, soundId, plate)
                
                -- Find the descriptive name for the sound
                local soundName = soundId
                for _, sound in pairs(EngineSounds) do
                    if sound.value == soundId then
                        soundName = sound.label
                        break
                    end
                end
                
                TriggerClientEvent('ox_lib:notify', src, {
                    type = 'success',
                    description = 'Vehicle sound changed to: ' .. soundName .. ' (Saved)'
                })
                
                print(string.format('[CUSTOMSOUNDS] %s (%s) changed vehicle sound to %s for plate %s', 
                    Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname,
                    Player.PlayerData.citizenid,
                    soundName,
                    plate
                ))
            else
                TriggerClientEvent('ox_lib:notify', src, {
                    type = 'error',
                    description = 'Failed to save vehicle sound changes'
                })
            end
        end)
    end
end)

-- Event to restore vehicle sounds when they spawn
RegisterNetEvent('customsounds:loadVehicleSound')
AddEventHandler('customsounds:loadVehicleSound', function(plate)
    if not plate then return end
    
    exports.oxmysql:execute('SELECT ' .. Config.Database.columnName .. ' FROM ' .. Config.Database.tableName .. ' WHERE plate = ? AND ' .. Config.Database.columnName .. ' IS NOT NULL', {plate}, function(result)
        if result and #result > 0 and result[1][Config.Database.columnName] then
            -- Apply the saved sound to all clients
            TriggerClientEvent("engine:sound", -1, result[1][Config.Database.columnName], plate)
        end
    end)
end)

-- Clean up sounds for deleted vehicles (optional cleanup command for admins)
RegisterCommand(Config.Commands.cleanupSounds.name, function(source, args, rawCommand)
    -- Check admin permission using config
    local Player = exports.qbx_core:GetPlayer(source)
    local hasPermission, permissionType = Config:IsPlayerAllowed(source, Player)
    
    if not hasPermission or permissionType ~= "admin" then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = 'You do not have permission to use this command (Admin required)'
        })
        return
    end
    
    -- Clean up orphaned sound entries using config
    local query = 'UPDATE ' .. Config.Database.tableName .. ' SET ' .. Config.Database.columnName .. ' = NULL WHERE ' .. Config.Database.columnName .. ' IS NOT NULL AND (SELECT COUNT(*) FROM ' .. Config.Database.tableName .. ' pv2 WHERE pv2.plate = ' .. Config.Database.tableName .. '.plate) = 0'
    exports.oxmysql:execute(query, {}, function(result)
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'success',
            description = 'Cleaned up ' .. (result and result.affectedRows or 0) .. ' orphaned sound entries'
        })
    end)
end, false)

-- Export the sounds list for use in client using ox_lib callback system
lib.callback.register('customsounds:getSoundsList', function(source)
    print("[D-EngineSound] Client " .. source .. " requested sounds list via callback")
    
    local soundsList = {}
    for _, soundData in pairs(EngineSounds) do
        if soundData.label and soundData.value then
            table.insert(soundsList, {
                label = soundData.label,
                value = soundData.value,
                category = soundData.category or "other"
            })
        end
    end
    
    print("[D-EngineSound] Sending " .. #soundsList .. " sounds to client " .. source)
    return soundsList
end)

-- Handle sounds list request using traditional events (fallback for ox_lib issues)
RegisterNetEvent('customsounds:requestSoundsList')
AddEventHandler('customsounds:requestSoundsList', function(plate)
    local src = source
    print("[D-EngineSound] Client " .. src .. " requested sounds list via event for plate: " .. plate)
    
    local soundsList = {}
    for _, soundData in pairs(EngineSounds) do
        if soundData.label and soundData.value then
            table.insert(soundsList, {
                label = soundData.label,
                value = soundData.value,
                category = soundData.category or "other"
            })
        end
    end
    
    print("[D-EngineSound] Sending " .. #soundsList .. " sounds to client " .. src .. " via event")
    TriggerClientEvent('customsounds:receiveSoundsList', src, soundsList, plate)
end)

-- Debug command to test the sounds menu
RegisterCommand(Config.Commands.debug.testSounds.name, function(source, args)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    
    if not Player then
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'error',
            description = 'Player data not found'
        })
        return
    end
    
    -- Check admin permission using config
    local hasPermission, permissionType = Config:IsPlayerAllowed(src, Player)
    if not hasPermission or permissionType ~= "admin" then
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'error',
            description = 'You do not have permission to use this command (Admin required)'
        })
        return
    end
    
    -- Show the menu directly with a test plate
    TriggerClientEvent('customsounds:showMenu', src, 'TESTPLAT')
end, false)

-- Debug command to check permissions
RegisterCommand(Config.Commands.debug.checkPerms.name, function(source, args)
    local src = source
    local Player = exports.qbx_core:GetPlayer(src)
    
    if not Player then
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'error',
            description = 'Player data not found'
        })
        return
    end
    
    local hasPermission, permissionType = Config:IsPlayerAllowed(src, Player)
    
    Config:DebugPrint("Permission check for player " .. src .. " - Type: " .. permissionType .. ", Allowed: " .. tostring(hasPermission))
    
    TriggerClientEvent('ox_lib:notify', src, {
        type = 'info',
        description = 'Permission: ' .. tostring(hasPermission) .. ' | Type: ' .. permissionType .. ' | Job: ' .. tostring(Player.PlayerData.job and Player.PlayerData.job.name or "none")
    })
end, false)