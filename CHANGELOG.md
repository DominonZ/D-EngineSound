# Changelog

All notable changes to D-EngineSound will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- Custom sound upload interface
- Integration with vehicle modification scripts
- Sound preview functionality before selection
- Bulk sound management for admins

## [2.1.0] - 2025-07-02

### Added
- **Regional Category System**: Organized sounds by geographic regions instead of brands
  - 🇺🇸 American (Ford, Chevrolet, Dodge, etc.)
  - 🇯🇵 Japanese (Honda, Toyota, Nissan, etc.)
  - 🇪🇺 European (BMW, Mercedes, Audi, Ferrari, etc.)
  - 🏍️ Motorcycles & Bikes (Harley, Yamaha, etc.)
  - 🏁 Racing & Special (Formula 1, NASCAR, etc.)
- **Category-Based Navigation**: Modern context menu system with category selection
- **Complete Sound Library**: Added all missing engine sounds from fxmanifest.lua (34 additional sounds)
- **Enhanced Menu System**: 
  - Main category selection menu
  - Sub-menus for each region with back navigation
  - "All Sounds" option for complete list view
  - Search functionality through ox_lib input system
- **Fallback Menu System**: Chat-based menu when ox_lib is unavailable
- **Utility Functions**: Added helper functions for category management in config

### Changed
- **Sound Organization**: Reorganized all 100+ sounds into logical regional categories
- **Menu Interface**: Replaced flat sound list with intuitive category-based navigation
- **User Experience**: Improved navigation with back buttons and category counts
- **Code Structure**: Enhanced config.lua with utility functions for better maintainability

### Technical Details
- **Total Sounds**: 100+ engine sounds now properly categorized and accessible
- **Menu System**: Dual-layer context menu (categories → sounds) with fallback support
- **Category Distribution**: 
  - American: 20+ sounds
  - Japanese: 30+ sounds  
  - European: 40+ sounds
  - Motorcycles: 5 sounds
  - Racing: 4 sounds
- **Backwards Compatibility**: All existing functionality preserved while adding new features

### Fixed
- **Missing Sounds**: Added 34 previously unavailable engine sounds to the menu
- **Category Coverage**: Ensured all sounds from fxmanifest.lua are accessible via the menu
- **Menu Navigation**: Improved user flow with logical categorization and back navigation

## [2.0.0] - 2025-07-01

### Added
- **Database Persistence System**: Vehicle sounds now persist across server restarts
- **Ownership Verification**: Only vehicle owners can change their vehicle's engine sound
- **ox_lib Integration**: Modern, searchable dropdown menu for sound selection
- **Permission System**: Dual permission system (admin/mechanic access)
- **Automatic Sound Loading**: Saved sounds automatically applied when vehicles spawn
- **Vehicle Tracking**: Client-side system to monitor vehicle spawns and apply sounds
- **Database Auto-Setup**: Automatic creation of `custom_sound` column in `player_vehicles` table
- **Admin Tools**: `/cleanupsounds` command for database maintenance
- **Comprehensive Logging**: Server-side logging of all sound changes
- **User Feedback**: Real-time notifications using ox_lib

### Changed
- **Command System**: Enhanced `/changesound` command with proper validation
- **Error Handling**: Improved error messages and user feedback
- **Performance**: Optimized vehicle tracking and sound application
- **Code Structure**: Modular design for better maintainability

### Technical Details
- **Framework**: Built for QBX Core framework
- **Database**: oxmysql integration for reliable database operations
- **UI**: ox_lib for modern user interface components
- **Architecture**: Event-driven system with proper client-server communication

### Database Schema
```sql
ALTER TABLE player_vehicles ADD COLUMN custom_sound VARCHAR(50) DEFAULT NULL;
```

## [1.0.0] - 2025-06-15

### Added
- **Basic Engine Sound Replacement**: Core functionality to change vehicle engine sounds
- **100+ Engine Sounds**: Comprehensive library of real-world vehicle engine sounds
  - Motorcycles & Bikes (5 sounds)
  - Japanese Sports Cars (15+ sounds)
  - European Supercars (25+ sounds)
  - American Muscle Cars (20+ sounds)
  - Luxury & Premium vehicles (15+ sounds)
  - Racing & Special vehicles (10+ sounds)
- **Sound Categories**: Organized sound library by vehicle type and manufacturer
- **Basic Command System**: `/changesound [soundid]` command functionality
- **Real-time Application**: Instant sound changes without restart required
- **Proximity-based System**: Sounds applied within 100m range for performance
- **Sound Management**: Client-side tracking of vehicle sounds by license plate

### Technical Implementation
- **Audio Files**: Complete `.awc` audio wave packs
- **Configuration**: Proper `.dat` files for audio synthesis, game data, and sound data
- **FiveM Integration**: Native `ForceVehicleEngineAudio` API usage
- **Resource Management**: Efficient memory and performance handling

### Initial Sound Library
- **2 Stroke Dirt Bike** - Off-road motorcycle sounds
- **BMW S1000RR I4** - High-performance motorcycle
- **Toyota Supra variants** - Legendary JDM engine sounds
- **Honda NSX, S2000** - VTEC and naturally aspirated engines
- **Nissan GTR, Skyline** - Iconic Japanese performance cars
- **Mazda Rotary engines** - RX-7, RX-8 rotary engine sounds
- **Ferrari collection** - V8 and V12 supercar engines
- **Lamborghini sounds** - V10 and V12 exotic engines
- **American Muscle** - Corvette, Mustang, Challenger engines
- **And many more...**

---

## Version Numbering

We follow [Semantic Versioning](https://semver.org/):
- **MAJOR** version for incompatible API changes
- **MINOR** version for new functionality in a backwards compatible manner
- **PATCH** version for backwards compatible bug fixes

## Migration Notes

### Upgrading from 1.x to 2.x
- **Database**: The script will automatically add the required database column
- **Commands**: `/changesound` now opens a menu instead of requiring sound ID parameter
- **Permissions**: New permission system requires admin or mechanic job
- **Dependencies**: Add `ox_lib` and `oxmysql` to your server resources

### Breaking Changes in 2.0.0
- **Command Arguments**: `/changesound [soundid]` is no longer supported, replaced with menu system
- **Permissions**: Script now requires proper permissions (admin or mechanic job)
- **Dependencies**: New dependencies on ox_lib and oxmysql
- **Database**: Requires MySQL database for persistence functionality

## Support and Compatibility

### Supported Versions
- **FiveM**: Latest stable builds
- **QBX Core**: All current versions
- **MySQL**: 5.7+ or MariaDB 10.2+
- **ox_lib**: Latest version
- **oxmysql**: Latest version

### Legacy Support
- **v1.x**: Security updates only
- **v2.x**: Active development and feature updates
