# D-EngineSound - Advanced FiveM Engine Sound System

**NOTE: Got inspired by SpiritCreations his resource can be found here:**
[SpiritCreations](https://github.com/SpiritsCreations/FiveM-Engine-Sound-Pack)

**NOTE: Credit is due to the original sound creators aswell.**


[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![FiveM](https://img.shields.io/badge/FiveM-Compatible-blue.svg)](https://fivem.net/)
[![QBX Core](https://img.shields.io/badge/Framework-QBX%20Core-green.svg)](https://github.com/Qbox-project/qbx_core)

A comprehensive and advanced FiveM script that allows players to dynamically change their vehicle engine sounds with over 100+ high-quality engine sound options from various real-world vehicles. Features a modern category-based UI, database persistence, regional sound organization, and extensive customization options.

**[YOUTUBE PREVIEW](https://youtu.be/qvfjIJzuBrI?si=_SCiPEvNy2DJHsnG)**

**If you are an Author and don't want the Engine Sound to be here on GitHub, just create an issue and pull request!**

## 🎯 Repository Description

**D-EngineSound** is a feature-rich engine sound replacement system for FiveM servers running QBX Core. It provides players and mechanics with an intuitive regional category-based interface to customize vehicle engine sounds while maintaining proper permissions, ownership verification, and persistent storage across server restarts.

Perfect for roleplay servers looking to enhance the vehicle customization experience with realistic engine sounds organized by geographic regions - from American muscle cars to Japanese sports cars, European supercars, motorcycles, and racing vehicles.

## ✨ Features

### 🔊 **Complete Sound Library**
- **100+ Engine Sounds**: Comprehensive collection of high-quality engine sounds
- **Regional Organization**: Sounds organized by geographic regions for intuitive browsing
- **Real Vehicle Sounds**: Authentic engine sounds from real-world vehicles

### 🗺️ **Regional Category System**
- 🇺🇸 **American**: Ford, Chevrolet, Dodge muscle cars and performance vehicles
- 🇯🇵 **Japanese**: Honda, Toyota, Nissan sports and tuner cars  
- 🇪🇺 **European**: BMW, Mercedes, Ferrari, Lamborghini supercars and luxury vehicles
- 🏍️ **Motorcycles & Bikes**: Various motorcycle and bike engine sounds
- 🏁 **Racing & Special**: Formula 1, NASCAR, and specialized racing engines

### 🎮 **Enhanced User Interface**
- **Category-Based Navigation**: Intuitive menu system organized by vehicle regions
- **Context Menu System**: Modern ox_lib context menus with back navigation
- **Search Functionality**: Searchable sound selection with ox_lib input system
- **"All Sounds" Option**: Complete alphabetical list for power users
- **Fallback System**: Chat-based menu when ox_lib is unavailable
[UI](https://imgur.com/XMBsCiq)

### 🔒 **Advanced Security & Permissions**
- **Permission System**: Only admins and mechanics can change vehicle sounds
- **Ownership Verification**: Only vehicle owners can modify their vehicle's engine sound
- **Database Persistence**: Vehicle sounds saved and restored automatically across server restarts
- **Automatic Sound Loading**: Saved sounds applied when vehicles spawn
[ADMIN PIC](https://imgur.com/tD0X3n5)

### 🛠️ **Technical Excellence**
- **Real-Time Application**: Sounds applied instantly to vehicles
- **Cross-Framework Support**: Built for QBX Core framework  
- **Performance Optimized**: Efficient tracking and sound application
- **Modern Dependencies**: ox_lib UI and oxmysql database integration

## Requirements

- **QBX Core**: Required for job and permission checking
- **ox_lib**: Required for the user interface and notifications
- **oxmysql**: Required for database operations and persistence
- **MySQL Database**: Required for storing vehicle sound preferences

## Installation

1. **Download & Extract**: Place the `D-EngineSound` folder in your `resources/[vehicles]/` directory
2. **Database Setup**: The script will automatically add a `custom_sound` column to your existing `player_vehicles` table
3. **Add to server.cfg**: Add `ensure D-EngineSound` to your server configuration file
4. **Restart Server**: Restart your FiveM server or use `refresh` and `start D-EngineSound`

### Database Structure
The script automatically modifies your `player_vehicles` table by adding:
```sql
ALTER TABLE player_vehicles ADD COLUMN custom_sound VARCHAR(50) DEFAULT NULL;
```

This will add the `custom_sound` column as the 24th column in your `player_vehicles` table, which stores the sound ID for each vehicle, enabling persistence across server restarts.

**Important**: The script checks your existing table structure and only adds the column if it doesn't already exist, so it's safe to restart the resource multiple times.

## Database Persistence System

The script now includes a comprehensive database persistence system that ensures vehicle sounds are saved and restored automatically.

### How It Works

1. **Automatic Database Setup**: On first run, the script adds a `custom_sound` column to your existing `player_vehicles` table
2. **Ownership Verification**: Only the actual owner of a vehicle can change its engine sound
3. **Automatic Saving**: When a player changes a vehicle's engine sound, it's immediately saved to the database
4. **Automatic Loading**: When vehicles spawn, their saved engine sounds are automatically applied
5. **Cleanup System**: Admin command available to clean up orphaned sound entries

### Database Schema

The script modifies the `player_vehicles` table by adding:
```sql
-- Column #24 - Added automatically by the script
custom_sound VARCHAR(50) DEFAULT NULL
```

**Key Database Operations:**
- **Ownership Check**: `SELECT id FROM player_vehicles WHERE plate = ? AND citizenid = ?`
- **Sound Save**: `UPDATE player_vehicles SET custom_sound = ? WHERE plate = ? AND citizenid = ?`
- **Sound Load**: `SELECT custom_sound FROM player_vehicles WHERE plate = ? AND custom_sound IS NOT NULL`
- **Cleanup**: Removes orphaned entries for non-existent vehicles

### Key Features

- **Persistent Across Restarts**: Vehicle sounds survive server restarts and shutdowns
- **Owner-Only Changes**: Only vehicle owners can modify their vehicle's engine sound
- **Automatic Application**: Saved sounds are applied when vehicles spawn without player intervention
- **Database Integrity**: Built-in cleanup tools for maintaining database health
- **Performance Optimized**: Efficient querying and caching to minimize database load

## 🎯 Usage

### For Players
1. **Get in a vehicle that you own** (must be in your `player_vehicles` database table)
2. **Type `/changesound`** in chat to open the sound selection menu
3. **Choose a category** from the regional menu:
   - 🇺🇸 American (Ford, Chevrolet, Dodge, etc.)
   - 🇯🇵 Japanese (Honda, Toyota, Nissan, etc.)  
   - 🇪🇺 European (BMW, Mercedes, Ferrari, etc.)
   - 🏍️ Motorcycles & Bikes
   - 🏁 Racing & Special
   - 📋 All Sounds (complete alphabetical list)
4. **Select your desired engine sound** from the category
5. **Use the back button** to return to the main category menu
6. **Your selection is automatically saved** and will persist through server restarts!

### Alternative Navigation
- **Search Option**: Use the search functionality to quickly find specific sounds
- **Fallback Menu**: If ox_lib is unavailable, a chat-based menu system will activate automatically

### For Administrators
- **Grant Access**: Give players the `mechanic` job or `admin` group permissions
- **Monitor Changes**: All sound changes are logged in the console for tracking
- **Database Cleanup**: Use `/cleanupsounds` to maintain database integrity
- **Debug Tools**: Use `/testsounds` and `/checkperms` for troubleshooting

## Permission System

The script uses a dual permission system:

### Admin Access
- Players with `group.admin` permission can use the script
- Checked via QBX Core's permission system

### Job Access
- Players with the `mechanic` job can use the script
- Perfect for roleplay scenarios where mechanics customize vehicles

## 🎵 Available Engine Sounds

The script includes **100+ engine sounds** organized by geographic regions for intuitive browsing:

### 🇺🇸 American Muscle & Performance (20+ sounds)
- **Chevrolet**: Camaro SS LS3, Corvette variants (LS6, LS3, ZR1 LT5), Duramax Diesel
- **Dodge**: Challenger HEMI & Hellcat Redeye, Viper SRT V10 variants, Charger R/T 426 Hemi
- **Ford**: Mustang GT 5.0 & Shelby GT500, Focus RS Ecoboost, Shelby Predator V8
- **Others**: Chrysler 300C SRT-8, Cammed Mustang 5.0L

### 🇯🇵 Japanese Sports & Tuner Cars (30+ sounds)
- **Toyota**: Supra 2JZ variants (A80 F&F, A90 B58 Tuned), AE86 4AGE, 1JZ-GTE
- **Honda**: NSX C30A, S2000 F20C, Civic B16A (F&F), K20A VTEC
- **Nissan**: GTR R35 VR38DETT, Skyline GTR R34 (2F2F), 350Z variants, SR20DET, RB26DETT
- **Mazda**: RX-7 FD3S, RX-8 Renesis, various rotary engines (13B-REW, 26B, 20B), Miata MX-5
- **Others**: Mitsubishi Evo 4G63T & 4B11T, Subaru WRX STI EJ25, Lexus LFA V10

### 🇪🇺 European Supercars & Luxury (40+ sounds)
- **Ferrari**: F50GT, Testarossa, 458, 488 GTB, 812 Superfast, F40, 246 Dino GT
- **Lamborghini**: Aventador SVJ, Veneno, Huracan, Urus, Countach, Gallardo, Murcielago
- **McLaren**: MP4/4 F1, P1, 720S
- **Porsche**: 911 variants (GT3RS, Tubi Style), RS 4.0L Flat-6
- **Mercedes-AMG**: One PU106C, GTR, SLS AMG, C63 M156, CLK GTR
- **Others**: Audi RS4 & R8, BMW M3 GTR & M4, Pagani Huayra & Zonda, Bugatti Veyron & Chiron, Koenigsegg Agera & Regera

### 🏍️ Motorcycles & Bikes (5 sounds)
- **Sport Bikes**: BMW S1000RR I4, Suzuki GSX-R 1000 Yoshimura
- **Naked Bikes**: Yamaha MT-09/FZ-09 I3
- **Off-Road**: 2 Stroke Dirt Bike, Yamaha Raptor 700cc

### 🏁 Racing & Special Vehicles (4 sounds)
- **Formula Racing**: Classic Formula 1 V10, McLaren MP4/4 F1 V6
- **Stock Car**: NASCAR 7.0L V8
- **Rally**: Skoda Fabia R5 WRC I4
- **Drag Racing**: Twin-Charged V8 Supercharged Dragster

### 🔍 Menu Navigation Features
- **Category Selection**: Browse sounds by region for easier discovery
- **Back Navigation**: Easy return to main menu from any category
- **Complete List**: "All Sounds" option shows every sound alphabetically
- **Search Function**: Quick search through the entire sound library
- **Sound Counts**: Each category shows the number of available sounds

## 📋 Commands

| Command | Permission | Description |
|---------|------------|-------------|
| `/changesound` | Admin or Mechanic | Opens the regional category-based engine sound selection menu (only works on owned vehicles) |
| `/cleanupsounds` | Admin Only | Cleans up orphaned sound entries in the database |
| `/testsounds` | Admin Only | Test the sound selection menu with a test plate (debug command) |
| `/checkperms` | Any Player | Check your current permissions and job status |

### Command Details

#### `/changesound`
- **Requirement**: Must be in a vehicle you own and have admin/mechanic permissions
- **Function**: Opens the modern category-based menu system
- **Menu Flow**: Category Selection → Sound Selection → Application
- **Fallback**: Automatically switches to chat-based menu if ox_lib is unavailable

#### `/cleanupsounds`
- **Requirement**: Admin permissions only
- **Function**: Removes orphaned sound entries for deleted vehicles
- **Safety**: Only affects vehicles no longer in the database
- **Feedback**: Shows count of cleaned entries

#### Debug Commands
- **`/testsounds`**: Opens the sound menu without vehicle ownership checks (admin only)
- **`/checkperms`**: Displays your current permission level and job status

## Configuration

### Adding New Sounds

The script is designed to be easily extensible. Here's how to add new engine sounds:

#### Step 1: Prepare Audio Files
You'll need three types of files for each engine sound:
- **`.awc` file**: The actual audio wave pack containing the engine sounds
- **`.dat151.rel` file**: Audio synthesis data (controls how the sound behaves)
- **`.dat54.rel` file**: Audio game data (defines when sounds play)
- **`.dat10.rel` file**: Audio sound data (maps sound names to audio files)

#### Step 2: File Placement
```
D-EngineSound/
├── audioconfig/
│   ├── your_engine_amp.dat        # Copy and rename existing .dat151.rel
│   ├── your_engine_game.dat       # Copy and rename existing .dat54.rel
│   └── your_engine_sounds.dat     # Copy and rename existing .dat10.rel
└── sfx/
    └── dlc_your_engine/
        └── your_engine.awc         # Your audio file
```

#### Step 3: Update fxmanifest.lua
Add your new sound entries to `fxmanifest.lua`:

```lua
-- Your Custom Engine Sound --
data_file 'AUDIO_SYNTHDATA' 'audioconfig/your_engine_amp.dat'
data_file 'AUDIO_GAMEDATA' 'audioconfig/your_engine_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/your_engine_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_your_engine'
```

#### Step 4: Update server.lua
Add your sound to the `sounds` table in `config.lua` under the appropriate category:

```lua
-- Add this entry to the Config.EngineSounds.sounds table
{label = "Your Custom Engine Description", value = "your_engine_id", category = "american"},
```

**Example Addition:**
```lua
-- In the appropriate category section (e.g., American muscle cars)
{label = "Custom Supercharged V12", value = "customv12sc", category = "american"},
{label = "Turbo Diesel V6", value = "tdieselv6", category = "european"},
```

#### Step 5: Restart Resource
After adding new sounds:
1. Save all files
2. Restart the resource: `restart D-EngineSound`
3. The new sounds will appear in the selection menu

### Practical Example: Adding a Ferrari LaFerrari Sound

Let's walk through adding a Ferrari LaFerrari V12 sound as a complete example:

#### 1. Prepare Your Files
```
D-EngineSound/
├── audioconfig/
│   ├── laferrari_amp.dat
│   ├── laferrari_game.dat
│   └── laferrari_sounds.dat
└── sfx/
    └── dlc_laferrari/
        └── laferrari.awc
```

#### 2. Add to fxmanifest.lua
```lua
-- Ferrari LaFerrari V12 --
data_file 'AUDIO_SYNTHDATA' 'audioconfig/laferrari_amp.dat'
data_file 'AUDIO_GAMEDATA' 'audioconfig/laferrari_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audioconfig/laferrari_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'sfx/dlc_laferrari'
```

#### 3. Add to config.lua EngineSounds table
```lua
-- In the appropriate category section (e.g., European supercars)
{label = "Ferrari LaFerrari V12 Hybrid", value = "laferrari", category = "european"},
```

#### 4. Restart and Test
```
restart D-EngineSound
```

Your new sound will now appear in the menu as "Ferrari LaFerrari V12 Hybrid" and be saved to the database like any other sound.

### Where to Get Sound Files

#### Option 1: Create Your Own
- Record real vehicle sounds
- Use audio editing software (Audacity, Adobe Audition)
- Convert to proper FiveM format using OpenIV or similar tools

#### Option 2: Sound Packs
- Download community-made sound packs
- Check FiveM modding communities (GTAMods, LSPDFR, etc.)
- Ensure you have proper permissions/licenses

#### Option 3: Convert from Other Games
- Extract sounds from other racing games
- Convert using appropriate tools
- Respect copyright and licensing

### File Naming Convention

For consistency, follow this naming pattern:
- **Sound ID**: `brand_model_engine` (e.g., `ford_gt40_v8`)
- **Files**: `brand_model_engine_amp.dat`, `brand_model_engine_game.dat`, etc.
- **Folder**: `dlc_brand_model_engine`

### Testing New Sounds

1. **Add the sound** following steps above
2. **Restart resource**: `restart D-EngineSound`
3. **Test in-game**: Use `/changesound` and select your new sound
4. **Verify persistence**: Restart server and check if sound loads correctly

### Troubleshooting New Sounds

**Sound not appearing in menu?**
- Check `config.lua` - ensure entry is added to `Config.EngineSounds.sounds` table with proper category
- Verify syntax (commas, brackets, quotes, category assignment)
- Restart the resource: `restart D-EngineSound`

**Sound not playing?**
- Check file paths in `fxmanifest.lua`
- Ensure `.awc` file is in correct folder
- Verify `.dat` files are properly configured

**Sound cuts out or glitches?**
- Check audio file quality and format
- Ensure `.dat` files are properly configured for your audio
- Test with different vehicles

### Community Contributions

If you create high-quality engine sounds, consider:
- Sharing with the FiveM community
- Contributing to sound pack repositories
- Documenting your sound sources and creation process

### Advanced Customization

For more advanced users, you can also:
- Modify existing `.dat` files to change sound behavior
- Create custom sound categories in the menu
- Add sound preview functionality
- Implement sound-to-vehicle-class matching

### Modifying Permissions
Edit the permission check in `server.lua`:

```lua
-- Add custom job access
if Player.PlayerData.job.name == 'your_custom_job' then
    hasPermission = true
end

-- Add custom permission group
if exports.qbx_core:HasPermission(source, 'your.custom.permission') then
    hasPermission = true
end
```

## 📋 Version Information

**Current Version**: 2.1.0  
**Release Date**: July 2, 2025  
**Compatibility**: FiveM latest builds  
**Framework**: QBX Core  

### 🆕 Latest Changes (v2.1.0)
- **Regional Category System**: Sounds organized by geographic regions (American, Japanese, European, etc.)
- **Enhanced Navigation**: Category-based menu with back buttons and sub-menus  
- **Complete Sound Library**: All 100+ sounds from fxmanifest.lua now accessible
- **Improved User Experience**: Intuitive browsing with category counts and search functionality
- **Fallback Support**: Chat-based menu system when ox_lib is unavailable

### Version History
- **v2.1.0** - Regional categories, enhanced navigation, complete sound library coverage
- **v2.0.0** - Database persistence, ox_lib integration, ownership verification  
- **v1.0.0** - Basic engine sound replacement functionality

### Upcoming Features
- Custom sound upload system
- Integration with vehicle modification scripts  
- Sound preview functionality
- Enhanced admin management tools

## File Structure

```
D-EngineSound/
├── audioconfig/          # Engine sound configuration files
│   ├── *.dat151.rel
│   ├── *.dat54.rel
│   └── *.dat10.rel
├── sfx/                  # Audio wave pack files
│   └── dlc_*/
│       └── *.awc
├── client.lua            # Client-side script
├── server.lua            # Server-side script
├── versioncheck.lua      # Version checking script
├── fxmanifest.lua        # Resource manifest
└── README.md             # This file
```

## Troubleshooting

### Common Issues

**Sound menu not showing or only showing categories?**
- Ensure all 100+ sounds are loaded: Check that `config.lua` contains all engine sounds
- Verify `showCategories = true` in config for category-based menu
- Restart the resource: `restart D-EngineSound`

**Category menu shows but sounds are missing?**
- Check category assignments in `config.lua` - each sound should have a `category` field
- Verify utility functions are properly loaded in config
- Ensure server.lua is sending category information to client

**Sound not working in-game?**
- Ensure the vehicle supports custom engine sounds
- Check that all required dependencies are installed and running
- Verify the sound files are properly loaded in fxmanifest.lua

**Permission denied when using `/changesound`?**
- Confirm the player has admin permissions or mechanic job
- Check QBX Core is properly configured
- Verify the permission system is working with `/checkperms`

**Menu navigation issues?**
- Ensure ox_lib is installed and running (latest version)
- Check for client-side console errors (F8 menu)
- Verify the resource started correctly without errors

**Can't change vehicle sound?**
- Ensure you own the vehicle (it must be in your `player_vehicles` table)
- Confirm you have admin permissions or mechanic job
- Check that the vehicle has a valid license plate

**Sounds not persisting after server restart?**
- Verify oxmysql is installed and working
- Check database connection and permissions  
- Ensure the `custom_sound` column was added to `player_vehicles` table
- Use `/cleanupsounds` to clean up any orphaned entries

**Fallback menu activating unexpectedly?**
- Check that ox_lib is properly installed and loaded
- Verify no errors in ox_lib startup
- Ensure ox_lib version compatibility with your server

### Console Commands for Debugging
```
# Check if resource is running
resmon

# Restart the resource
restart D-EngineSound

# Check for errors
con_miniconChannels script:*
```

## Credits

- **Original Author**: DOMINONZ
- **Enhanced by DOMINONZ with**: Custom modifications for QBX Core and ox_lib integration
- **Audio Sources**: Various high-quality engine sound recordings from various authors on 5mods.
- **Script Idea**: SpiritCreations & A friend of mine
## License

This script is provided as-is for FiveM server use. Please respect the original audio sources and any applicable licensing terms.

## Support

For support and updates, please contact your server development team or check the resource documentation.

---

**Note**: This script is designed for roleplay servers and should be used responsibly. Always ensure you have proper permissions before modifying vehicle sounds in multiplayer environments.

## 🤝 Contributing

We welcome contributions from the community! Here's how you can help improve D-EngineSound:

### How to Contribute

1. **Fork the Repository**: Create your own fork of the project
2. **Create a Feature Branch**: `git checkout -b feature/your-feature-name`
3. **Make Your Changes**: Implement your feature or bug fix
4. **Test Thoroughly**: Ensure your changes work properly
5. **Submit a Pull Request**: Describe your changes and submit for review

### Contribution Guidelines

#### 🎵 Adding Engine Sounds
- **High Quality**: Only submit high-quality, clear engine sounds
- **Proper Attribution**: Credit the original source if applicable
- **Naming Convention**: Follow the established naming patterns
- **Testing**: Test sounds in-game before submitting

#### 🐛 Bug Reports
- Use the issue tracker to report bugs
- Include detailed reproduction steps
- Specify your FiveM version and server setup
- Attach relevant logs or error messages

#### 💡 Feature Requests
- Check existing issues to avoid duplicates
- Clearly describe the feature and its benefits
- Consider the impact on server performance
- Be open to discussion and feedback

#### 🔧 Code Contributions
- Follow the existing code style and structure
- Add comments for complex logic
- Test your changes thoroughly
- Update documentation as needed

### Development Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/D-EngineSound.git
   ```

2. **Set up development environment**:
   - FiveM server with QBX Core
   - MySQL database
   - ox_lib and oxmysql resources

3. **Testing**:
   - Test with multiple vehicle types
   - Verify database operations
   - Check permission system functionality

### Code of Conduct

- Be respectful to all contributors
- Provide constructive feedback
- Help newcomers learn and contribute
- Focus on the project's goals and quality

### Recognition

Contributors will be recognized in:
- README credits section
- Release notes
- Special thanks in documentation

We appreciate all contributions, whether it's code, sounds, documentation, or bug reports!
