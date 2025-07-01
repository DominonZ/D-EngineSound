# Contributing to D-EngineSound

Thank you for your interest in contributing to D-EngineSound! This document provides detailed guidelines for contributors.

## 🚀 Getting Started

### Prerequisites
- FiveM Server with QBX Core framework
- MySQL database setup
- Basic knowledge of Lua scripting
- Git and GitHub account

### Development Environment Setup

1. **Fork and Clone**:
   ```bash
   git fork https://github.com/yourusername/D-EngineSound.git
   git clone https://github.com/yourusername/D-EngineSound.git
   cd D-EngineSound
   ```

2. **Install Dependencies**:
   - Ensure QBX Core is installed
   - Install ox_lib resource
   - Install oxmysql resource

3. **Database Setup**:
   - The script will auto-create the required database column
   - Ensure your `player_vehicles` table exists

## 📝 Contribution Types

### 🎵 Engine Sound Contributions

#### What We're Looking For:
- **High-quality audio**: Clear, well-recorded engine sounds
- **Diverse selection**: Sounds from different vehicle types and manufacturers
- **Realistic sounds**: Authentic engine audio from real vehicles

#### File Requirements:
- **Audio Format**: `.awc` files (FiveM audio format)
- **Configuration Files**: Proper `.dat` files for audio configuration
- **Quality**: 44.1kHz or higher sample rate, minimal background noise

#### Submission Process:
1. **Prepare Files**: Create all required files (.awc, .dat151, .dat54, .dat10)
2. **Test Locally**: Verify the sound works in your development environment
3. **Follow Naming**: Use the established naming convention
4. **Submit PR**: Include a description of the engine/vehicle

#### Naming Convention:
```
Sound ID: manufacturer_model_engine
Files: manufacturer_model_engine_amp.dat
Folder: dlc_manufacturer_model_engine
Label: "Manufacturer Model Engine Description"
```

**Example**:
```
Sound ID: ferrari_sf90_v8hybrid
Files: ferrari_sf90_v8hybrid_amp.dat, ferrari_sf90_v8hybrid_game.dat, etc.
Folder: dlc_ferrari_sf90_v8hybrid
Label: "Ferrari SF90 Stradale V8 Hybrid"
```

### 🐛 Bug Reports

#### Before Reporting:
- Check existing issues to avoid duplicates
- Reproduce the bug consistently
- Test with minimal configuration

#### Bug Report Template:
```markdown
**Bug Description**: Brief description of the issue

**Steps to Reproduce**:
1. Step one
2. Step two
3. Step three

**Expected Behavior**: What should happen

**Actual Behavior**: What actually happens

**Environment**:
- FiveM Version: 
- QBX Core Version: 
- D-EngineSound Version: 
- MySQL Version: 

**Additional Information**: 
- Console errors/logs
- Screenshots (if applicable)
- Server configuration details
```

### 💡 Feature Requests

#### Guidelines:
- **Clear Description**: Explain the feature and its benefits
- **Use Cases**: Provide real-world scenarios where it would be useful
- **Implementation Ideas**: Suggest how it might work (optional)
- **Compatibility**: Consider impacts on existing functionality

#### Feature Request Template:
```markdown
**Feature Summary**: Brief description

**Problem Statement**: What problem does this solve?

**Proposed Solution**: How should it work?

**Use Cases**: When would this be used?

**Additional Context**: 
- Screenshots/mockups
- Similar implementations
- Technical considerations
```

### 🔧 Code Contributions

#### Code Style Guidelines:
- **Indentation**: Use 4 spaces (no tabs)
- **Naming**: Use camelCase for variables, PascalCase for functions
- **Comments**: Add comments for complex logic
- **Structure**: Follow existing file organization

#### Best Practices:
- **Performance**: Consider server performance impact
- **Security**: Validate all user inputs
- **Error Handling**: Include proper error handling
- **Database**: Use prepared statements for SQL queries

#### Code Review Process:
1. **Self Review**: Check your code before submitting
2. **Testing**: Verify functionality works as expected
3. **Documentation**: Update relevant documentation
4. **PR Description**: Clearly describe changes and rationale

## 🧪 Testing Guidelines

### Manual Testing Checklist:
- [ ] Script starts without errors
- [ ] Database column creates successfully
- [ ] Permission system works correctly
- [ ] Sound selection menu appears
- [ ] Sounds apply correctly to vehicles
- [ ] Sounds persist after server restart
- [ ] Ownership verification works
- [ ] Admin cleanup commands function

### Testing Different Scenarios:
- **Multiple Players**: Test with several players simultaneously
- **Different Vehicles**: Test with various vehicle types
- **Permission Levels**: Test with admin, mechanic, and regular players
- **Database Operations**: Test all database interactions

## 📋 Pull Request Process

### Before Submitting:
1. **Sync Fork**: Ensure your fork is up-to-date
2. **Create Branch**: Use descriptive branch names
3. **Test Changes**: Thoroughly test your modifications
4. **Update Documentation**: Update README if needed

### PR Guidelines:
- **Title**: Clear, descriptive title
- **Description**: Explain what changes were made and why
- **Breaking Changes**: Highlight any breaking changes
- **Testing**: Describe how you tested the changes

### PR Template:
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Performance improvement
- [ ] Other (specify)

## Testing
- [ ] Tested locally
- [ ] Tested with multiple players
- [ ] Tested database operations
- [ ] Tested permission system

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No breaking changes (or documented)
```

## 🏆 Recognition

### Contributor Recognition:
- **README Credits**: Contributors listed in README
- **Release Notes**: Major contributors mentioned in releases
- **Community Thanks**: Recognition in community announcements

### Hall of Fame:
We maintain a list of top contributors who have significantly impacted the project.

## 📞 Getting Help

### Communication Channels:
- **GitHub Issues**: For bugs and feature requests
- **GitHub Discussions**: For general questions and ideas
- **Discord**: [Server invite link] (if applicable)

### Mentorship:
New contributors can request mentorship from experienced contributors.

## 📄 License

By contributing to D-EngineSound, you agree that your contributions will be licensed under the same license as the project (MIT License).

---

Thank you for contributing to D-EngineSound! Your efforts help make this project better for the entire FiveM community. 🚗🎵
