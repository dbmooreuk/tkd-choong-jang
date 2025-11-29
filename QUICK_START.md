# 🚀 Quick Start Guide

Get your app running in 30 minutes!

## Prerequisites
- ✅ Mac with Xcode 15+
- ✅ Apple Developer account (for device testing)
- ✅ Basic familiarity with Xcode

## Step-by-Step (30 Minutes)

### 1️⃣ Create Xcode Project (5 min)

```bash
1. Open Xcode
2. File → New → Project
3. Select: iOS → App
4. Fill in:
   - Product Name: TKDForgeChoongJang
   - Team: [Your Team]
   - Organization Identifier: com.tkdforge
   - Interface: SwiftUI
   - Language: Swift
5. Save in: /path/to/tkd-choong-jang
```

### 2️⃣ Add Source Files (5 min)

```bash
1. In Xcode, delete:
   - ContentView.swift
   - TKDForgeChoongJangApp.swift (the default one)

2. Drag these folders into Xcode:
   - TKDForgeChoongJang/Models
   - TKDForgeChoongJang/ViewModels
   - TKDForgeChoongJang/Views
   - TKDForgeChoongJang/Services
   - TKDForgeChoongJang/Resources

3. Drag these files:
   - TKDForgeChoongJang/TKDForgeChoongJangApp.swift
   - TKDForgeChoongJang/Info.plist

4. Check: ✅ Copy items if needed
5. Check: ✅ Create groups
6. Target: ✅ TKDForgeChoongJang
```

### 3️⃣ Add Logo (10 min)

**Convert SVG to PNG:**
```bash
# Option A: Online converter
1. Go to: https://cloudconvert.com/svg-to-png
2. Upload: reference/logo_tkd_forge.svg
3. Set size: 1024x1024
4. Download PNG

# Option B: Using ImageMagick (if installed)
brew install imagemagick
convert -background none -resize 1024x1024 \
  reference/logo_tkd_forge.svg logo_tkd_forge.png
```

**Add to Xcode:**
```bash
1. Open: TKDForgeChoongJang/Resources/Assets.xcassets
2. Right-click → New Image Set
3. Name: logo_tkd_forge
4. Drag PNG into 1x slot
5. Done!
```

### 4️⃣ Configure Project (5 min)

```bash
1. Select project in navigator
2. Select target: TKDForgeChoongJang
3. General tab:
   - Display Name: TKD Forge
   - Bundle Identifier: com.tkdforge.app
   - Version: 1.0
   - Build: 1
   - iOS Deployment Target: 17.0

4. Signing & Capabilities:
   - Team: [Select your team]
   - ✅ Automatically manage signing
```

### 5️⃣ Build & Run (5 min)

```bash
1. Select simulator: iPhone 15 Pro
2. Press: Cmd + R (or click Play ▶️)
3. Wait for build...
4. App launches! 🎉
```

## ✅ Verification Checklist

After launch, verify:
- [ ] Splash screen appears with "TKD FORGE" text
- [ ] Transitions to pattern info screen after 2.5s
- [ ] Shows "Choong-Jang" and "52 Movements"
- [ ] "Begin Study" button works
- [ ] Study view shows move 1
- [ ] Next/Previous buttons work
- [ ] All 52 moves are accessible
- [ ] Move list opens and works
- [ ] Clock visualizer displays

## 🎤 Test Voice Control (Device Only)

```bash
1. Connect iPhone via USB
2. Select your iPhone in Xcode
3. Build & Run (Cmd + R)
4. In app, tap microphone icon
5. Grant permissions when prompted
6. Say "Next" → Should advance to move 2
7. Say "Back" → Should return to move 1
8. Say "Repeat" → Should speak description
```

## 🐛 Quick Fixes

### Logo Not Showing
```bash
Problem: Image "logo_tkd_forge" not found
Fix: 
1. Check Assets.xcassets has "logo_tkd_forge" image set
2. Verify PNG is in the 1x slot
3. Clean build: Cmd + Shift + K
4. Rebuild: Cmd + R
```

### JSON Not Loading
```bash
Problem: "Could not find pattern-data.json"
Fix:
1. Right-click pattern-data.json
2. Show File Inspector (right panel)
3. Target Membership: ✅ TKDForgeChoongJang
4. Clean & rebuild
```

### Build Errors
```bash
Problem: Various Swift errors
Fix:
1. Clean Build Folder: Cmd + Shift + K
2. Close Xcode
3. Delete: ~/Library/Developer/Xcode/DerivedData
4. Reopen Xcode
5. Rebuild
```

## 📱 Next Steps

### For Testing
1. Add move images (optional)
2. Test on multiple devices
3. Test voice control thoroughly
4. Get feedback from users

### For App Store
1. Create app icon (see ASSET_PREPARATION.md)
2. Take screenshots (see APP_STORE_GUIDE.md)
3. Write app description
4. Submit for review

## 📚 Full Documentation

- **README.md** - Complete overview
- **SETUP_GUIDE.md** - Detailed setup
- **ARCHITECTURE.md** - Technical details
- **APP_STORE_GUIDE.md** - Submission guide
- **ASSET_PREPARATION.md** - Asset creation
- **PROJECT_SUMMARY.md** - Everything at a glance

## 🎯 30-Minute Checklist

- [ ] Create Xcode project (5 min)
- [ ] Add source files (5 min)
- [ ] Convert & add logo (10 min)
- [ ] Configure project (5 min)
- [ ] Build & run (5 min)
- [ ] ✅ App running!

## 💡 Pro Tips

1. **Use Simulator First** - Faster iteration
2. **Test on Device** - For voice control
3. **Clean Often** - Cmd+Shift+K fixes many issues
4. **Check Console** - Shows helpful error messages
5. **Read Docs** - All answers are in the guides

## 🆘 Need Help?

1. Check troubleshooting section above
2. Read SETUP_GUIDE.md for details
3. Check Xcode console for errors
4. Verify all files are in target
5. Clean and rebuild

## 🎉 Success!

If you see the splash screen and can navigate through moves, you're done! 

The app is fully functional and ready for:
- ✅ Testing
- ✅ Adding move images
- ✅ Creating screenshots
- ✅ App Store submission

**Time to launch**: 1-2 days from here!

---

**Happy coding! 🥋**

