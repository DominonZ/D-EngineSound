-- Engine sound list with descriptive names and their corresponding IDs
local EngineSounds = {
    -- Motorcycles & Bikes
    {label = "2 Stroke Dirt Bike", value = "2strkbeng"},
    {label = "BMW S1000RR I4", value = "bmws1krreng"},
    {label = "Yamaha MT-09/FZ-09 I3", value = "mt09eng"},
    {label = "Suzuki GSX-R 1000 I4 Yoshimura", value = "szkgsxryoshimuraeng"},
    {label = "Yamaha Raptor 700cc I1", value = "lgcyc00qbike700"},
    
    -- Toyota
    {label = "Toyota AE86 4AGE I4", value = "4age"},
    {label = "Toyota Supra 2JZ I6 (F&F)", value = "a80ffeng"},
    {label = "Toyota Supra A90 B58 I6 Tuned", value = "lg16a90mk5"},
    {label = "Toyota 1JZ I6", value = "tjz1eng"},
    {label = "Toyota 2JZ-GTE 3.0L I6-T", value = "toysupmk4"},
    
    -- Honda
    {label = "Honda NSX C30A V6", value = "c30a"},
    {label = "Honda K20A 2.0L I4", value = "k20a"},
    {label = "Honda S2000 F20C I4", value = "lg56hons2k"},
    {label = "Honda Civic B16A I4 (F&F)", value = "lgcy02b16ff"},
    
    -- Nissan
    {label = "Nissan Skyline GTR R34 RB26DETT I6 (2F2F)", value = "bnr34ffeng"},
    {label = "Nissan GTR R35 VR38DETT", value = "nisgtr35"},
    {label = "Nissan RB26DETT 2.6L I6-TT", value = "rb26dett"},
    {label = "Nissan SR20DET I4", value = "nsr2teng"},
    {label = "BNR32 ID RB26DETT", value = "lg36r32skyid"},
    {label = "Nissan 350Z VQ35 V6 (NFSU2)", value = "z33u2"},
    {label = "Nissan 350Z 4.1L (F&F)", value = "z33dkffeng"},
    {label = "Nissan 240Z L24 I6", value = "lgcy03nisl24"},
    
    -- Mazda
    {label = "Mazda RX-7 FD3S", value = "fd3sid"},
    {label = "Mazda RX-7 13B-REW (F&F)", value = "fdvsffeng"},
    {label = "Mazda RX-8 Renesis", value = "lg15rx8ren"},
    {label = "Mazda 13B-REW 1.3L Twin-Rotor", value = "rotary7"},
    {label = "Mazda RX-7 13B (Bridgeported)", value = "rx7bpeng"},
    {label = "Mazda Custom 26B 4 Rotor", value = "lg28cst26b"},
    {label = "Mazda Custom 26B 4 Rotor Turbo", value = "lg29cst26btrb"},
    {label = "Mazda 20B 3 Rotor", value = "lg188maz20b"},
    {label = "Mazda Miata MX-5 1.6L I4 (NA)", value = "mx5nasound"},
    
    -- Mitsubishi
    {label = "Mitsubishi Lancer Evolution 4G63T I4", value = "evorllyeng"},
    {label = "Mitsubishi Lancer Evolution 4B11T I4", value = "lg54evoxtun"},
    
    -- Subaru
    {label = "Subaru Impreza WRX STI EJ25 F4", value = "wrxrllyeng"},
    
    -- BMW
    {label = "BMW M4 S55 I6 Akrapovic", value = "lg18bmwm4"},
    {label = "BMW M3 GTR P60B40 V8", value = "lg58mwm3gtrdemo"},
    
    -- Mercedes-Benz
    {label = "Mercedes-AMG One PU106C V6", value = "amg1eng"},
    {label = "Mercedes-AMG GTR 4.0L V8", value = "lg30meramgtr"},
    {label = "Mercedes AMG C63 M156 6.3L V8", value = "mbnzc63eng"},
    {label = "Mercedes SLS AMG 6.3L V8", value = "lg116slsamg"},
    {label = "Mercedes AMG CLK GTR V12", value = "lg187clkgtr"},
    
    -- Audi
    {label = "Audi RS4 Milltek FSI 4.2L V8", value = "audirs4milltekeng"},
    {label = "Twin Turbo Audi/Lamborghini 5.2L V10", value = "audr8tteng"},
    {label = "Audi/Lamborghini 5.2L V10", value = "lambov10"},
    
    -- Porsche
    {label = "Porsche RS 4.0L Flat-6", value = "gt3flat6"},
    {label = "Porsche 911 GT3RS 4.0L F6", value = "lg157por911"},
    {label = "Porsche 911 F6 Tubi Style Exhaust", value = "lg102por992ts"},
    
    -- Ferrari
    {label = "Ferrari F50GT F130B 4.7L V12", value = "f50gteng"},
    {label = "Ferrari Testarossa F113 V12", value = "f113"},
    {label = "Ferrari 458 F136 V8", value = "f136"},
    {label = "Ferrari 348 F119 V8", value = "frf119eng"},
    {label = "Ferrari 488 GTB 3.9L V8 Capristo", value = "lg53fer488capri"},
    {label = "Ferrari 812 Superfast V12", value = "lg86fer812sf"},
    {label = "Ferrari F40 F120A V8", value = "lgcy12ferf40"},
    {label = "Ferrari 246 Dino GT V6", value = "lg288ferdino"},
    
    -- Lamborghini
    {label = "Lamborghini Aventador SVJ V12 Gintani F1", value = "lamavgineng"},
    {label = "Lamborghini Veneno L539 V12", value = "lamveneng"},
    {label = "Lamborghini Huracan 5.2L V10", value = "lg59hurv10"},
    {label = "Lamborghini Urus 4.0L V8 Capristo", value = "lg51uruscapri"},
    {label = "Lamborghini Countach V12", value = "lg97lamctch"},
    {label = "Lamborghini Gallardo 5.0L V10", value = "lg114oldgalv10"},
    {label = "Lamborghini Murcielago Straight Piped V12", value = "lg123murcisp"},
    
    -- McLaren
    {label = "McLaren MP4/4 F1 V6", value = "honf1v6eng"},
    {label = "McLaren P1 M838T V8", value = "mcp1eng"},
    {label = "McLaren 720S M840T V8", value = "ml720v8eng"},
    
    -- Pagani
    {label = "Pagani-AMG M158 6.0L V12TT", value = "m158huayra"},
    {label = "Pagani-AMG M297 7.3L V12", value = "m297zonda"},
    {label = "Pagani Zonda Revolución 6.0L V12", value = "pgzonreng"},
    
    -- Bugatti
    {label = "Bugatti Veyron W16", value = "bgw16"},
    {label = "Bugatti Chiron Pursport W16", value = "lg62chironpursport"},
    
    -- Koenigsegg
    {label = "Koenigsegg Agera RS 5.0 V8", value = "lg67koagerars"},
    {label = "Koenigsegg Regera 5.0L V8", value = "lg91timreg"},
    
    -- American Muscle
    {label = "Chevrolet Camaro SS LS3 V8", value = "camls3v8"},
    {label = "Chevrolet Corvette ZR1 LT5 V8", value = "czr1eng"},
    {label = "Chevrolet Corvette LS6 V8", value = "lg14c6vette"},
    {label = "Chevrolet Corvette LS6 V8 (NA)", value = "lg14c6vettena"},
    {label = "Chevrolet Corvette C6 LS3 V8", value = "lg68ls3vette"},
    {label = "Chevrolet Camaro Z28 LS7 V8", value = "lg101timcamz28"},
    {label = "Chevrolet Duramax Diesel 6.6L V8", value = "chevydmaxeng"},
    
    {label = "Dodge Challenger HEMI 6.4L V8", value = "dghmieng"},
    {label = "Dodge Challenger Hellcat Redeye V8", value = "lg81hcredeye"},
    {label = "Dodge Viper SRT 8.4L V10 (Twin Turbo)", value = "lg41ttviperv10"},
    {label = "Dodge Viper SRT 8.4L V10 (NA)", value = "lg42naviperv10"},
    {label = "Dodge Viper SRT 9.0L V10", value = "srtvipeng"},
    {label = "Dodge Charger R/T 426 Hemi V8 (1969)", value = "lgcy01chargerv8"},
    
    {label = "Ford Mustang Shelby GT500 V8", value = "lg52musgt500v8"},
    {label = "Ford Mustang GT 5.0 V8", value = "lg57mustangtv8"},
    {label = "Ford Focus RS Ecoboost 2.3L I4", value = "lg21focusrs"},
    {label = "Ford-Shelby Predator 5.2L V8SC", value = "predatorv8"},
    {label = "Cammed Mustang 5.0L V8", value = "lg88camstang"},
    
    -- Luxury & Others
    {label = "Brabus 850 6.0L V8-TT", value = "brabus850"},
    {label = "Bentley Bentayga Mansory V8", value = "lg125mnsrybently"},
    {label = "Chrysler 300C SRT-8 V8", value = "lg124srt8thndrc"},
    {label = "Jaguar F-TYPE V8", value = "lg50ftypev8"},
    {label = "Lexus LFA 4.7L V10", value = "lg48lexlfa"},
    {label = "Volkswagen VR6 V6", value = "lgcy00vr6"},
    
    -- Racing & Special
    {label = "Formula 1 V10", value = "lg115classicf1v10"},
    {label = "NASCAR 7.0L V8", value = "lg44nascarv8"},
    {label = "Skoda Fabia R5 WRC I4", value = "lg87skodar5rally"},
    {label = "Dragster Twin-Charged V8SCT", value = "musv8"},
}

-- Initialize database table on resource start
CreateThread(function()
    -- Check if custom_sound column exists in player_vehicles table
    MySQL.query('SHOW COLUMNS FROM player_vehicles LIKE "custom_sound"', {}, function(result)
        if #result == 0 then
            -- Add custom_sound column if it doesn't exist
            MySQL.execute('ALTER TABLE player_vehicles ADD COLUMN custom_sound VARCHAR(50) DEFAULT NULL', {}, function(success)
                if success then
                    print('^2[CUSTOMSOUNDS]^7 Successfully added custom_sound column to player_vehicles table')
                else
                    print('^1[CUSTOMSOUNDS]^7 Failed to add custom_sound column to player_vehicles table')
                end
            end)
        else
            print('^2[CUSTOMSOUNDS]^7 Database table ready - custom_sound column exists')
        end
    end)
end)

RegisterCommand("changesound", function(source, args, rawCommand)
    -- Check if player has admin permissions or mechanic job
    local hasPermission = false
    
    -- Check for admin group
    if exports.qbx_core:HasPermission(source, 'group.admin') then
        hasPermission = true
    else
        -- Check for mechanic job
        local Player = exports.qbx_core:GetPlayer(source)
        if Player and Player.PlayerData.job.name == 'mechanic' then
            hasPermission = true
        end
    end
    
    if not hasPermission then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = 'You do not have permission to change vehicle sounds'
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
    MySQL.query('SELECT id FROM player_vehicles WHERE plate = ? AND citizenid = ?', {plate, Player.PlayerData.citizenid}, function(result)
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
        
        -- Update the database with the new sound
        MySQL.execute('UPDATE player_vehicles SET custom_sound = ? WHERE plate = ? AND citizenid = ?', {
            soundId, 
            plate, 
            Player.PlayerData.citizenid
        }, function(affectedRows)
            if affectedRows > 0 then
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
    
    MySQL.query('SELECT custom_sound FROM player_vehicles WHERE plate = ? AND custom_sound IS NOT NULL', {plate}, function(result)
        if result and #result > 0 and result[1].custom_sound then
            -- Apply the saved sound to all clients
            TriggerClientEvent("engine:sound", -1, result[1].custom_sound, plate)
        end
    end)
end)

-- Clean up sounds for deleted vehicles (optional cleanup command for admins)
RegisterCommand("cleanupsounds", function(source, args, rawCommand)
    if not exports.qbx_core:HasPermission(source, 'group.admin') then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = 'You do not have permission to use this command'
        })
        return
    end
    
    -- Clean up orphaned sound entries
    MySQL.execute('UPDATE player_vehicles SET custom_sound = NULL WHERE custom_sound IS NOT NULL AND (SELECT COUNT(*) FROM player_vehicles pv2 WHERE pv2.plate = player_vehicles.plate) = 0', {}, function(affectedRows)
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'success',
            description = 'Cleaned up ' .. affectedRows .. ' orphaned sound entries'
        })
    end)
end, false)

-- Export the sounds list for use in client
lib.callback.register('customsounds:getSoundsList', function(source)
    return EngineSounds
end)