# TKD Forge - Choong Jang Setup Guide

## Quick Start

Follow these steps to get your app running in Xcode.

## Step 1: Prepare Assets

### Logo Conversion
The logo needs to be converted from SVG to PNG format:

1. Open `reference/logo_tkd_forge.svg` in a graphics editor (Sketch, Figma, or online converter)
2. Export as PNG at these sizes:
   - 1x: 512x512px
   - 2x: 1024x1024px
   - 3x: 1536x1536px

### Add Logo to Xcode

1. Open Xcode
2. Navigate to `TKDForgeChoongJang/Resources/Assets.xcassets`
3. Right-click → New Image Set
4. Name it `logo_tkd_forge`
5. Drag your PNG files into the appropriate slots (1x, 2x, 3x)

### App Icon

1. Create an app icon from the logo (1024x1024px, no transparency)
2. In Assets.xcassets, select `AppIcon`
3. Drag your 1024x1024 icon into the "App Store iOS" slot
4. Xcode will generate all required sizes automatically

## Step 2: Add Move Images (Optional)

If you have images for each move:

1. Name them: `move_1.png`, `move_2.png`, ..., `move_52.png`
2. Add each to Assets.xcassets as individual image sets
3. The app will automatically display them

If you don't have images yet:
- The app will show placeholder icons
- You can add images later without code changes

## Step 3: Create Xcode Project

Since we've created the source files, you need to create the Xcode project:

### Option A: Create New Project in Xcode

1. Open Xcode
2. File → New → Project
3. Choose "iOS" → "App"
4. Fill in:
   - Product Name: `TKDForgeChoongJang`
   - Team: Your development team
   - Organization Identifier: `com.tkdforge` (or your own)
   - Interface: SwiftUI
   - Language: Swift
   - Storage: None
5. Save in the project directory

### Option B: Use Existing Structure

If you prefer to organize manually:

1. Create a new Xcode project as above
2. Delete the default ContentView.swift and App file
3. Add all the files we created:
   - Drag the `Models` folder into Xcode
   - Drag the `ViewModels` folder into Xcode
   - Drag the `Views` folder into Xcode
   - Drag the `Services` folder into Xcode
   - Drag the `Resources` folder into Xcode
4. Make sure "Copy items if needed" is checked
5. Make sure "Create groups" is selected
6. Add to target: TKDForgeChoongJang

## Step 4: Configure Project Settings

### General Tab
1. Select the project in the navigator
2. Select the target "TKDForgeChoongJang"
3. General tab:
   - Display Name: `TKD Forge - Choong Jang`
   - Bundle Identifier: `com.tkdforge.choongjang`
   - Version: `1.0`
   - Build: `1`
   - Deployment Target: `iOS 17.0`
   - Supported Destinations: iPhone, iPad

### Signing & Capabilities
1. Select your Team
2. Enable "Automatically manage signing"

### Info Tab
1. Verify the privacy descriptions are present:
   - Privacy - Speech Recognition Usage Description
   - Privacy - Microphone Usage Description

## Step 5: Add pattern-data.json to Project

1. In Xcode, right-click on the `Resources` folder
2. Add Files to "TKDForgeChoongJang"
3. Select `TKDForgeChoongJang/Resources/pattern-data.json`
4. Make sure "Copy items if needed" is checked
5. Make sure it's added to the target

## Step 6: Build and Run

1. Select a simulator or device (iPhone 15 Pro recommended)
2. Press Cmd+R or click the Play button
3. The app should build and launch

## Troubleshooting

### "Cannot find 'logo_tkd_forge' in scope"
- Make sure you've added the logo image to Assets.xcassets
- The image set must be named exactly `logo_tkd_forge`

### "Cannot find 'pattern-data.json'"
- Verify the JSON file is in the Resources folder
- Check that it's included in the target membership
- Right-click the file → Show File Inspector → Target Membership

### Voice Control Not Working
- Test on a real device (simulator has limited speech support)
- Grant microphone and speech recognition permissions
- Check that Info.plist has the required privacy descriptions

### Build Errors
- Clean build folder: Cmd+Shift+K
- Restart Xcode
- Check that all files are added to the target

## File Structure Checklist

Ensure your Xcode project has this structure:

```
TKDForgeChoongJang/
├── 📱 TKDForgeChoongJangApp.swift
├── 📁 Models/
│   ├── Move.swift
│   └── PatternData.swift
├── 📁 ViewModels/
│   ├── AppState.swift
│   └── StudyViewModel.swift
├── 📁 Views/
│   ├── ContentView.swift
│   ├── SplashView.swift
│   ├── PatternInfoView.swift
│   ├── StudyView.swift
│   └── 📁 Components/
│       ├── ClockVisualizer.swift
│       ├── MoveCard.swift
│       └── MoveListView.swift
├── 📁 Services/
│   └── VoiceControlManager.swift
├── 📁 Resources/
│   ├── 📁 Assets.xcassets/
│   │   ├── AppIcon.appiconset/
│   │   ├── logo_tkd_forge.imageset/
│   │   └── LaunchScreenBackground.colorset/
│   └── pattern-data.json
└── Info.plist
```

## Testing Checklist

- [ ] App launches with splash screen
- [ ] Splash transitions to pattern info screen
- [ ] "Begin Study" button navigates to study view
- [ ] Clock visualizer displays correctly
- [ ] Next/Previous buttons work
- [ ] Move list opens and allows selection
- [ ] Voice control button toggles on/off
- [ ] Progress bar updates correctly
- [ ] All 52 moves load properly

## Next Steps

1. Add move images for better visual learning
2. Test on physical device for voice control
3. Customize colors/branding if desired
4. Prepare App Store assets
5. Submit for review

## Support

If you encounter issues:
1. Check the troubleshooting section above
2. Verify all files are properly added to the target
3. Clean and rebuild the project
4. Check Xcode console for specific error messages

---

Good luck with your app! 🥋

