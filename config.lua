Config = {}

-- ═══════════════════════════════════════════════════════════════
--                         GENERAL SETTINGS
-- ═══════════════════════════════════════════════════════════════

-- Enable debug mode (shows detailed console output)
Config.Debug = true

-- Resource information
Config.ResourceInfo = {
    name = "D-EngineSound",
    version = "2.0.0",
    author = "D-EngineSound Contributors",
    description = "Advanced FiveM Engine Sound System with Database Persistence and Modern UI"
}

-- ═══════════════════════════════════════════════════════════════
--                        PERMISSION SETTINGS
-- ═══════════════════════════════════════════════════════════════

-- Permission settings
Config.Permissions = {
    -- Admin permissions (ACE system)
    adminGroup = "group.admin",
    adminCommand = "command.changesound",
    cleanupCommand = "command.cleanupsounds",
    
    -- Job-based permissions
    allowedJobs = {
        "mechanic",
        "tunershop",
        "bennys"
    },
    
    -- Allow players to change sounds on any vehicle (if false, only owned vehicles)
    requireVehicleOwnership = true,
    
    -- Alternative permission system (if ACE doesn't work)
    useAlternativePerms = false,
    alternativeAdminIdentifiers = {
        -- Add steam IDs or license IDs here if ACE system doesn't work
        -- "steam:110000100000000",
        -- "license:abcd1234567890"
    }
}

-- ═══════════════════════════════════════════════════════════════
--                           UI SETTINGS
-- ═══════════════════════════════════════════════════════════════

-- UI preferences and fallback options
Config.UI = {
    -- Preferred UI method (priority order)
    preferredMethod = "context", -- "input", "context", "fallback"
    
    -- ox_lib input dialog settings
    inputDialog = {
        title = "Engine Sound Selector",
        searchable = true,
        required = true,
        icon = "volume-high"
    },
    
    -- ox_lib context menu settings
    contextMenu = {
        id = "engine_sound_selector",
        title = "🔊 Engine Sound Selector",
        icon = "volume-high"
    },
    
    -- Fallback menu settings (chat-based)
    fallbackMenu = {
        soundsPerPage = 10,
        showPageInfo = true,
        commands = {
            select = "soundselect",
            next = "soundnext",
            prev = "soundprev",
            cancel = "soundcancel"
        }
    },
    
    -- Notification settings
    notifications = {
        type = "ox_lib", -- "qbx_core", "ox_lib", "custom"
        duration = 5000,
        position = "top-left"
    }
}

-- ═══════════════════════════════════════════════════════════════
--                        DATABASE SETTINGS
-- ═══════════════════════════════════════════════════════════════

-- Database configuration
Config.Database = {
    -- Table and column names
    tableName = "player_vehicles",
    columnName = "custom_sound",
    
    -- Auto-create column if it doesn't exist
    autoCreateColumn = true,
    
    -- Database cleanup settings
    autoCleanup = {
        enabled = true,
        interval = 24, -- hours
        removeOrphaned = true
    }
}

-- ═══════════════════════════════════════════════════════════════
--                         SOUND SETTINGS
-- ═══════════════════════════════════════════════════════════════

-- Sound application settings
Config.Sounds = {
    -- Range for sound application (in units)
    applicationRange = 100.0,
    
    -- Update interval (milliseconds)
    updateInterval = 2000,
    
    -- Vehicle tracking settings
    tracking = {
        enabled = true,
        checkInterval = 2000, -- Check for new vehicles every 2 seconds
        cleanupInterval = 10000 -- Clean up tracked vehicles every 10 seconds
    },
    
    -- Sound persistence
    persistence = {
        saveToDatabase = true,
        restoreOnSpawn = true
    }
}

-- ═══════════════════════════════════════════════════════════════
--                        COMMAND SETTINGS
-- ═══════════════════════════════════════════════════════════════

-- Command configuration
Config.Commands = {
    -- Main commands
    changeSound = {
        name = "changesound",
        description = "Change the engine sound of your vehicle",
        requireVehicle = true
    },
    
    cleanupSounds = {
        name = "cleanupsounds",
        description = "Clean up orphaned sound entries from database",
        adminOnly = true
    },
    
    -- Debug commands
    debug = {
        enabled = Config.Debug,
        testSounds = {
            name = "testsounds",
            description = "Test the sound selection menu",
            adminOnly = true
        },
        checkPerms = {
            name = "checkperms",
            description = "Check your current permissions",
            adminOnly = false
        }
    }
}

-- ═══════════════════════════════════════════════════════════════
--                         ENGINE SOUNDS LIST
-- ═══════════════════════════════════════════════════════════════

-- Engine sounds configuration
Config.EngineSounds = {
    -- Categories for better organization
    categories = {
        motorcycles = "🏍️ Motorcycles & Bikes",
        toyota = "🚗 Toyota",
        honda = "🚙 Honda", 
        nissan = "🚘 Nissan",
        mazda = "🚗 Mazda",
        mitsubishi = "🚙 Mitsubishi",
        subaru = "🚘 Subaru",
        ferrari = "🏎️ Ferrari",
        lamborghini = "🏎️ Lamborghini",
        porsche = "🏎️ Porsche",
        mclaren = "🏎️ McLaren",
        bugatti = "🏎️ Bugatti",
        koenigsegg = "🏎️ Koenigsegg",
        american = "🇺🇸 American Muscle",
        luxury = "💎 Luxury & Others",
        racing = "🏁 Racing & Special"
    },
    
    -- Sounds list with categories
    sounds = {
        -- Motorcycles & Bikes
        {label = "2 Stroke Dirt Bike", value = "2strkbeng", category = "motorcycles"},
        {label = "BMW S1000RR I4", value = "bmws1krreng", category = "motorcycles"},
        {label = "Yamaha MT-09/FZ-09 I3", value = "mt09eng", category = "motorcycles"},
        {label = "Suzuki GSX-R 1000 I4 Yoshimura", value = "szkgsxryoshimuraeng", category = "motorcycles"},
        {label = "Yamaha Raptor 700cc I1", value = "lgcyc00qbike700", category = "motorcycles"},
        
        -- Toyota
        {label = "Toyota AE86 4AGE I4", value = "4age", category = "toyota"},
        {label = "Toyota Supra 2JZ I6 (F&F)", value = "a80ffeng", category = "toyota"},
        {label = "Toyota Supra A90 B58 I6 Tuned", value = "lg16a90mk5", category = "toyota"},
        {label = "Toyota 1JZ I6", value = "tjz1eng", category = "toyota"},
        {label = "Toyota 2JZ-GTE 3.0L I6-T", value = "toysupmk4", category = "toyota"},
        
        -- Honda
        {label = "Honda NSX C30A V6", value = "c30a", category = "honda"},
        {label = "Honda K20A 2.0L I4", value = "k20a", category = "honda"},
        {label = "Honda S2000 F20C I4", value = "lg56hons2k", category = "honda"},
        {label = "Honda Civic B16A I4 (F&F)", value = "lgcy02b16ff", category = "honda"},
        
        -- Nissan
        {label = "Nissan Skyline GTR R34 RB26DETT I6 (2F2F)", value = "bnr34ffeng", category = "nissan"},
        {label = "Nissan GTR R35 VR38DETT", value = "nisgtr35", category = "nissan"},
        {label = "Nissan RB26DETT 2.6L I6-TT", value = "rb26dett", category = "nissan"},
        {label = "Nissan SR20DET I4", value = "nsr2teng", category = "nissan"},
        {label = "BNR32 ID RB26DETT", value = "lg36r32skyid", category = "nissan"},
        {label = "Nissan 350Z VQ35 V6 (NFSU2)", value = "z33u2", category = "nissan"},
        {label = "Nissan 350Z 4.1L (F&F)", value = "z33dkffeng", category = "nissan"},
        {label = "Nissan 240Z L24 I6", value = "lgcy03nisl24", category = "nissan"},
        
        -- Mazda
        {label = "Mazda RX-7 FD3S", value = "fd3sid", category = "mazda"},
        {label = "Mazda RX-7 13B-REW (F&F)", value = "fdvsffeng", category = "mazda"},
        {label = "Mazda RX-8 Renesis", value = "lg15rx8ren", category = "mazda"},
        {label = "Mazda 13B-REW 1.3L Twin-Rotor", value = "rotary7", category = "mazda"},
        {label = "Mazda RX-7 13B (Bridgeported)", value = "rx7bpeng", category = "mazda"},
        {label = "Mazda Custom 26B 4 Rotor", value = "lg28cst26b", category = "mazda"},
        {label = "Mazda Custom 26B 4 Rotor Turbo", value = "lg29cst26btrb", category = "mazda"},
        {label = "Mazda 20B 3 Rotor", value = "lg188maz20b", category = "mazda"},
        {label = "Mazda Miata MX-5 1.6L I4 (NA)", value = "mx5nasound", category = "mazda"},
        
        -- Mitsubishi
        {label = "Mitsubishi Lancer Evolution 4G63T I4", value = "evorllyeng", category = "mitsubishi"},
        {label = "Mitsubishi Lancer Evolution 4B11T I4", value = "lg54evoxtun", category = "mitsubishi"},
        
        -- Subaru
        {label = "Subaru Impreza WRX STI EJ25 F4", value = "wrxrllyeng", category = "subaru"},
        
        -- Ferrari
        {label = "Ferrari F50GT F130B 4.7L V12", value = "f50gteng", category = "ferrari"},
        {label = "Ferrari Testarossa F113 V12", value = "f113", category = "ferrari"},
        {label = "Ferrari 458 F136 V8", value = "f136", category = "ferrari"},
        {label = "Ferrari 348 F119 V8", value = "frf119eng", category = "ferrari"},
        {label = "Ferrari 488 GTB 3.9L V8 Capristo", value = "lg53fer488capri", category = "ferrari"},
        {label = "Ferrari 812 Superfast V12", value = "lg86fer812sf", category = "ferrari"},
        {label = "Ferrari F40 F120A V8", value = "lgcy12ferf40", category = "ferrari"},
        {label = "Ferrari 246 Dino GT V6", value = "lg288ferdino", category = "ferrari"},
        
        -- American Muscle
        {label = "Chevrolet Camaro SS LS3 V8", value = "camls3v8", category = "american"},
        {label = "Chevrolet Corvette ZR1 LT5 V8", value = "czr1eng", category = "american"},
        {label = "Chevrolet Corvette LS6 V8", value = "lg14c6vette", category = "american"},
        {label = "Chevrolet Corvette LS6 V8 (NA)", value = "lg14c6vettena", category = "american"},
        {label = "Chevrolet Corvette C6 LS3 V8", value = "lg68ls3vette", category = "american"},
        {label = "Chevrolet Camaro Z28 LS7 V8", value = "lg101timcamz28", category = "american"},
        {label = "Chevrolet Duramax Diesel 6.6L V8", value = "chevydmaxeng", category = "american"},
        {label = "Dodge Challenger HEMI 6.4L V8", value = "dghmieng", category = "american"},
        {label = "Dodge Challenger Hellcat Redeye V8", value = "lg81hcredeye", category = "american"},
        {label = "Dodge Viper SRT 8.4L V10 (Twin Turbo)", value = "lg41ttviperv10", category = "american"},
        {label = "Dodge Viper SRT 8.4L V10 (NA)", value = "lg42naviperv10", category = "american"},
        {label = "Dodge Viper SRT 9.0L V10", value = "srtvipeng", category = "american"},
        {label = "Dodge Charger R/T 426 Hemi V8 (1969)", value = "lgcy01chargerv8", category = "american"},
        {label = "Ford Mustang Shelby GT500 V8", value = "lg52musgt500v8", category = "american"},
        {label = "Ford Mustang GT 5.0 V8", value = "lg57mustangtv8", category = "american"},
        {label = "Ford Focus RS Ecoboost 2.3L I4", value = "lg21focusrs", category = "american"},
        {label = "Ford-Shelby Predator 5.2L V8SC", value = "predatorv8", category = "american"},
        {label = "Cammed Mustang 5.0L V8", value = "lg88camstang", category = "american"},
        
        -- Racing & Special
        {label = "Formula 1 V10", value = "lg115classicf1v10", category = "racing"},
        {label = "NASCAR 7.0L V8", value = "lg44nascarv8", category = "racing"},
        {label = "Skoda Fabia R5 WRC I4", value = "lg87skodar5rally", category = "racing"},
        {label = "Dragster Twin-Charged V8SCT", value = "musv8", category = "racing"},
    },
    
    -- Categorized display settings
    showCategories = false, -- Set to true to organize sounds by category in the menu
    categoryIcons = true   -- Show category icons in the menu
}

-- ═══════════════════════════════════════════════════════════════
--                        FRAMEWORK SETTINGS
-- ═══════════════════════════════════════════════════════════════

-- Framework compatibility
Config.Framework = {
    name = "qbx", -- "qb", "qbx", "esx", "custom"
    
    -- Player data paths (adjust based on your framework)
    playerDataPaths = {
        citizenid = "PlayerData.citizenid",
        job = "PlayerData.job.name",
        source = "source"
    },
    
    -- Event names (adjust based on your framework)
    events = {
        playerLoaded = "QBCore:Client:OnPlayerLoaded",
        jobUpdate = "QBCore:Client:OnJobUpdate"
    }
}

-- ═══════════════════════════════════════════════════════════════
--                          UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════

-- Utility functions for config
function Config:GetSoundsList()
    return self.EngineSounds.sounds
end

function Config:GetSoundByValue(value)
    for _, sound in pairs(self.EngineSounds.sounds) do
        if sound.value == value then
            return sound
        end
    end
    return nil
end

function Config:GetSoundsByCategory(category)
    local categorySounds = {}
    for _, sound in pairs(self.EngineSounds.sounds) do
        if sound.category == category then
            table.insert(categorySounds, sound)
        end
    end
    return categorySounds
end

function Config:IsPlayerAllowed(source, Player)
    -- Check ACE permissions
    if IsPlayerAceAllowed and IsPlayerAceAllowed(source, self.Permissions.adminGroup) then
        return true, "admin"
    end
    
    -- Check job permissions
    if Player and Player.PlayerData and Player.PlayerData.job then
        for _, job in pairs(self.Permissions.allowedJobs) do
            if Player.PlayerData.job.name == job then
                return true, "job"
            end
        end
    end
    
    -- Check alternative permissions
    if self.Permissions.useAlternativePerms then
        local identifiers = GetPlayerIdentifiers(source)
        for _, id in pairs(identifiers) do
            for _, allowedId in pairs(self.Permissions.alternativeAdminIdentifiers) do
                if id == allowedId then
                    return true, "alternative"
                end
            end
        end
    end
    
    return false, "none"
end

function Config:DebugPrint(message)
    if self.Debug then
        print("^3[" .. self.ResourceInfo.name .. "]^7 " .. message)
    end
end

return Config
