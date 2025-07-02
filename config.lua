Config = {}

-- ═══════════════════════════════════════════════════════════════
--                         GENERAL SETTINGS
-- ════════════════════════════════════════════════

-- Categories for better organization by region
Config.Categories = {
    american = "🇺🇸 American",
    japanese = "🇯🇵 Japanese", 
    european = "🇪🇺 European",
    motorcycles = "🏍️ Motorcycles & Bikes",
    racing = "🏁 Racing & Special"
}

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
    -- Categories for better organization by region
    categories = {
        american = "�🇸 American",
        japanese = "🇯🇵 Japanese", 
        european = "�🇺 European",
        motorcycles = "�️ Motorcycles & Bikes",
        racing = "🏁 Racing & Special"
    },
    
    -- Sounds list with regional categories
    sounds = {
        -- Motorcycles & Bikes
        {label = "2 Stroke Dirt Bike", value = "2strkbeng", category = "motorcycles"},
        {label = "BMW S1000RR I4", value = "bmws1krreng", category = "motorcycles"},
        {label = "Yamaha MT-09/FZ-09 I3", value = "mt09eng", category = "motorcycles"},
        {label = "Suzuki GSX-R 1000 I4 Yoshimura", value = "szkgsxryoshimuraeng", category = "motorcycles"},
        {label = "Yamaha Raptor 700cc I1", value = "lgcyc00qbike700", category = "motorcycles"},
        
        -- Japanese Cars
        {label = "Toyota AE86 4AGE I4", value = "4age", category = "japanese"},
        {label = "Toyota Supra 2JZ I6 (F&F)", value = "a80ffeng", category = "japanese"},
        {label = "Toyota Supra A90 B58 I6 Tuned", value = "lg16a90mk5", category = "japanese"},
        {label = "Toyota 1JZ I6", value = "tjz1eng", category = "japanese"},
        {label = "Toyota 2JZ-GTE 3.0L I6-T", value = "toysupmk4", category = "japanese"},
        {label = "Honda NSX C30A V6", value = "c30a", category = "japanese"},
        {label = "Honda K20A 2.0L I4", value = "k20a", category = "japanese"},
        {label = "Honda S2000 F20C I4", value = "lg56hons2k", category = "japanese"},
        {label = "Honda Civic B16A I4 (F&F)", value = "lgcy02b16ff", category = "japanese"},
        {label = "Nissan Skyline GTR R34 RB26DETT I6 (2F2F)", value = "bnr34ffeng", category = "japanese"},
        {label = "Nissan GTR R35 VR38DETT", value = "nisgtr35", category = "japanese"},
        {label = "Nissan RB26DETT 2.6L I6-TT", value = "rb26dett", category = "japanese"},
        {label = "Nissan SR20DET I4", value = "nsr2teng", category = "japanese"},
        {label = "BNR32 ID RB26DETT", value = "lg36r32skyid", category = "japanese"},
        {label = "Nissan 350Z VQ35 V6 (NFSU2)", value = "z33u2", category = "japanese"},
        {label = "Nissan 350Z 4.1L (F&F)", value = "z33dkffeng", category = "japanese"},
        {label = "Nissan 240Z L24 I6", value = "lgcy03nisl24", category = "japanese"},
        {label = "Mazda RX-7 FD3S", value = "fd3sid", category = "japanese"},
        {label = "Mazda RX-7 13B-REW (F&F)", value = "fdvsffeng", category = "japanese"},
        {label = "Mazda RX-8 Renesis", value = "lg15rx8ren", category = "japanese"},
        {label = "Mazda 13B-REW 1.3L Twin-Rotor", value = "rotary7", category = "japanese"},
        {label = "Mazda RX-7 13B (Bridgeported)", value = "rx7bpeng", category = "japanese"},
        {label = "Mazda Custom 26B 4 Rotor", value = "lg28cst26b", category = "japanese"},
        {label = "Mazda Custom 26B 4 Rotor Turbo", value = "lg29cst26btrb", category = "japanese"},
        {label = "Mazda 20B 3 Rotor", value = "lg188maz20b", category = "japanese"},
        {label = "Mazda Miata MX-5 1.6L I4 (NA)", value = "mx5nasound", category = "japanese"},
        {label = "Mitsubishi Lancer Evolution 4G63T I4", value = "evorllyeng", category = "japanese"},
        {label = "Mitsubishi Lancer Evolution 4B11T I4", value = "lg54evoxtun", category = "japanese"},
        {label = "Subaru Impreza WRX STI EJ25 F4", value = "wrxrllyeng", category = "japanese"},
        {label = "Lexus LFA 4.7L V10", value = "lg48lexlfa", category = "japanese"},
        
        -- American Cars
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
        {label = "Chrysler 300C SRT-8 V8", value = "lg124srt8thndrc", category = "american"},
        
        -- European Cars
        {label = "Ferrari F50GT F130B 4.7L V12", value = "f50gteng", category = "european"},
        {label = "Ferrari Testarossa F113 V12", value = "f113", category = "european"},
        {label = "Ferrari 458 F136 V8", value = "f136", category = "european"},
        {label = "Ferrari 348 F119 V8", value = "frf119eng", category = "european"},
        {label = "Ferrari 488 GTB 3.9L V8 Capristo", value = "lg53fer488capri", category = "european"},
        {label = "Ferrari 812 Superfast V12", value = "lg86fer812sf", category = "european"},
        {label = "Ferrari F40 F120A V8", value = "lgcy12ferf40", category = "european"},
        {label = "Ferrari 246 Dino GT V6", value = "lg288ferdino", category = "european"},
        {label = "Mercedes-AMG One PU106C V6", value = "amg1eng", category = "european"},
        {label = "Mercedes-AMG GTR 4.0L V8", value = "lg30meramgtr", category = "european"},
        {label = "Mercedes SLS AMG 6.3L V8", value = "lg116slsamg", category = "european"},
        {label = "Mercedes AMG C63 M156 6.3L V8", value = "mbnzc63eng", category = "european"},
        {label = "Mercedes AMG CLK GTR V12", value = "lg187clkgtr", category = "european"},
        {label = "Audi RS4 Milltek FSI 4.2L V8", value = "audirs4milltekeng", category = "european"},
        {label = "Twin Turbo Audi/Lamborghini 5.2L V10", value = "audr8tteng", category = "european"},
        {label = "Audi/Lamborghini 5.2L V10", value = "lambov10", category = "european"},
        {label = "Lamborghini Aventador SVJ V12 Gintani F1", value = "lamavgineng", category = "european"},
        {label = "Lamborghini Veneno L539 V12", value = "lamveneng", category = "european"},
        {label = "Lamborghini Huracan 5.2L V10", value = "lg59hurv10", category = "european"},
        {label = "Lamborghini Urus 4.0L V8 Capristo", value = "lg51uruscapri", category = "european"},
        {label = "Lamborghini Countach V12", value = "lg97lamctch", category = "european"},
        {label = "Lamborghini Gallardo 5.0L V10", value = "lg114oldgalv10", category = "european"},
        {label = "Lamborghini Murcielago V12 Straight Piped", value = "lg123murcisp", category = "european"},
        {label = "Porsche RS 4.0L Flat-6", value = "gt3flat6", category = "european"},
        {label = "Porsche 911 F6 Tubi Style Exhaust", value = "lg102por992ts", category = "european"},
        {label = "Porsche 911 GT3RS 4.0L F6", value = "lg157por911", category = "european"},
        {label = "McLaren MP4/4 F1 V6", value = "honf1v6eng", category = "european"},
        {label = "McLaren P1 M838T V8", value = "mcp1eng", category = "european"},
        {label = "McLaren 720S M840T V8", value = "ml720v8eng", category = "european"},
        {label = "Bugatti Veyron W16", value = "bgw16", category = "european"},
        {label = "Bugatti Chiron Pursport W16", value = "lg62chironpursport", category = "european"},
        {label = "Koenigsegg Agera RS 5.0 V8", value = "lg67koagerars", category = "european"},
        {label = "Koenigsegg Regera 5.0L V8", value = "lg91timreg", category = "european"},
        {label = "Pagani-AMG M158 6.0L V12TT Huayra", value = "m158huayra", category = "european"},
        {label = "Pagani-AMG M297 7.3L V12 Zonda", value = "m297zonda", category = "european"},
        {label = "Pagani Zonda Revolución 6.0L V12", value = "pgzonreng", category = "european"},
        {label = "BMW M4 S55 I6 Akrapovic", value = "lg18bmwm4", category = "european"},
        {label = "BMW M3 GTR P60B40 V8", value = "lg58mwm3gtrdemo", category = "european"},
        {label = "Jaguar F-TYPE V8", value = "lg50ftypev8", category = "european"},
        {label = "Brabus 850 6.0L V8-TT", value = "brabus850", category = "european"},
        {label = "Bentley Bentayga Mansory V8", value = "lg125mnsrybently", category = "european"},
        {label = "Volkswagen VR6 V6", value = "lgcy00vr6", category = "european"},
        
        -- Racing & Special
        {label = "Formula 1 V10", value = "lg115classicf1v10", category = "racing"},
        {label = "NASCAR 7.0L V8", value = "lg44nascarv8", category = "racing"},
        {label = "Skoda Fabia R5 WRC I4", value = "lg87skodar5rally", category = "racing"},
        {label = "Dragster Twin-Charged V8SCT", value = "musv8", category = "racing"},
    },
    
    -- Categorized display settings
    showCategories = true, -- Set to true to organize sounds by category in the menu
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

function Config:GetCategoriesWithCounts()
    local categoryCounts = {}
    for _, sound in pairs(self.EngineSounds.sounds) do
        local category = sound.category or "other"
        categoryCounts[category] = (categoryCounts[category] or 0) + 1
    end
    return categoryCounts
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
