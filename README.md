# TKD Forge - Choong Jang

A premium iOS application for mastering the Taekwondo pattern Choong-Jang (2nd Dan Black Belt).

> **🚀 NEW TO THIS PROJECT?** Start with **[START_HERE.md](START_HERE.md)** for a quick overview and next steps!

> **⚡ WANT TO GET RUNNING FAST?** Jump to **[QUICK_START.md](QUICK_START.md)** for a 30-minute setup guide!

## Overview

**TKD Forge - Choong Jang** is a comprehensive study app designed to help Taekwondo practitioners memorize and perfect the 52 movements of the Choong-Jang pattern. The app features an innovative directional clock system, voice control for hands-free practice, and a beautiful dark mode interface.

### Pattern Information
This app is driven entirely by JSON pattern files. The current release focuses on **Choong-Jang**, and the same data model can be reused for additional patterns (for example Dan-Gun and Won-Hyo).

**Choong-Jang (current pattern)**
- **Belt Level**: 2nd Dan Black Belt
- **Number of Moves**: 52
- **Meaning**: Choong-Jang is the pseudonym of General Kim Duk Ryang who lived during the Lee Dynasty, 14th century.

## Features

### 🎯 Core Features
- **52 Detailed Moves**: Complete breakdown of every movement in the pattern
- **Clock Visualizer**: Custom-built directional system showing facing and direction
- **Phase Organization**: Moves grouped into 6 logical phases
- **Progress Tracking**: Visual progress bar and move counter
- **Move List**: Quick navigation to any move in the pattern

### 🎤 Voice Control
- Hands-free navigation using voice commands
- Say "Next" to advance to the next move
- Say "Back" or "Previous" to go to the previous move
- Say "Repeat" or "Again" to hear the current move description again
- Text-to-speech reads move descriptions aloud

### 🎨 Design
- Modern dark mode theme with Dark Slate background
- Smooth animations and transitions
- Card-based layout for optimal readability
- Orange accent color for visual hierarchy
- Professional, martial arts-inspired aesthetic

## Project Structure

```
TKDForgeChoongJang/
├── TKDForgeChoongJangApp.swift      # App entry point
├── Models/
│   ├── Move.swift                    # Move data model
│   └── PatternData.swift             # Pattern data store
├── ViewModels/
│   ├── AppState.swift                # App-wide state management
│   └── StudyViewModel.swift          # Study screen logic
├── Views/
│   ├── ContentView.swift             # Main navigation view
│   ├── SplashView.swift              # Animated splash screen
│   ├── PatternInfoView.swift         # Pattern overview screen
│   ├── StudyView.swift               # Main study interface
│   └── Components/
│       ├── ClockVisualizer.swift     # Custom clock component
│       ├── MoveCard.swift            # Move display card
│       └── MoveListView.swift        # Move selection list
├── Services/
│   └── VoiceControlManager.swift     # Speech recognition & synthesis
├── Resources/
│   ├── Assets.xcassets/              # Images and colors
│   └── pattern-data.json             # Move data
└── Info.plist                        # App configuration
```

## Setup Instructions

### Prerequisites
- Xcode 15.0 or later
- iOS 17.0 or later
- macOS Sonoma or later

### Installation Steps

1. **Open the project in Xcode**
   ```bash
   open TKDForgeChoongJang.xcodeproj
   ```

2. **Add the logo image**
   - Convert `reference/logo_tkd_forge.svg` to PNG format
   - Add to Assets.xcassets as "logo_tkd_forge"
   - Recommended size: 512x512px

3. **Add move images** (Optional but recommended)
   - Create images for each move named `move_1.png` through `move_52.png`
   - Add them to Assets.xcassets
   - If images are not provided, placeholder icons will be shown

4. **Configure signing**
   - Select your development team in Xcode
   - Update the bundle identifier if needed

5. **Build and run**
   - Select your target device or simulator
   - Press Cmd+R to build and run

## Adding Move Images

To add images for each move:

1. Create or obtain images for each of the 52 moves
2. Name them sequentially: `move_1`, `move_2`, ..., `move_52`
3. Add them to `Assets.xcassets` in Xcode
4. The app will automatically display them in the MoveCard

## Voice Control Setup

The app requests the following permissions:
- **Speech Recognition**: To listen for voice commands
- **Microphone**: To capture audio for speech recognition

These permissions are requested when the user enables voice control for the first time.

## Customization for Other Patterns

This app structure is designed to be reusable for other Taekwondo patterns. To create a new pattern app:

1. **Update Pattern Data**
   - Modify `Resources/pattern-data.json` with new moves
   - Update `PatternInfo` in `Models/PatternData.swift`

2. **Update Branding**
   - Change app name in Info.plist
   - Update splash screen text in `SplashView.swift`
   - Replace logo in Assets.xcassets

3. **Update Bundle Identifier**
   - Change to a unique identifier (e.g., `com.tkdforge.dangun`)

## App Store Submission

### Required Assets
- [ ] App Icon (1024x1024px)
- [ ] Screenshots for all required device sizes
- [ ] App Preview video (optional but recommended)

### Privacy Policy
Required for App Store submission. Must include:
- Speech recognition usage
- Microphone access
- Data collection practices (if any)

### App Store Description Template
```
Master patterns with TKD Forge!

Perfect for white belts to Black Belt students, this app provides:
• Move breakdowns
• Innovative directional clock system
• Hands-free voice control
• Beautiful dark mode interface

Practice anywhere, anytime. Your path to mastery starts here.
```

### Pricing
- Recommended: free - in app pattern purchases
- Category: Education or Health & Fitness
- Age Rating: 4+

## Technical Details

### Minimum Requirements
- iOS 17.0+
- iPhone and iPad compatible
- Portrait orientation (primary)

### Frameworks Used
- SwiftUI (UI Framework)
- Speech (Voice Recognition)
- AVFoundation (Text-to-Speech)
- Combine (Reactive Programming)

### Performance
- Lightweight: < 50MB installed size (without move images)
- Smooth 60fps animations
- Instant app launch
- No network required (fully offline)

## License

Copyright © 2024 TKD Forge. All rights reserved.

## Support

For support or questions, contact: [Your support email]

---

**Version**: 1.0
**Last Updated**: 2024

