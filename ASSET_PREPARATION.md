# Asset Preparation Guide

## Required Assets for App Store Submission

### 1. App Icon

#### Specifications
- **Size**: 1024x1024 pixels
- **Format**: PNG (no transparency)
- **Color Space**: sRGB or P3
- **No rounded corners** (iOS adds them automatically)

#### Design Guidelines
- Use the TKD Forge logo as base
- Ensure it's recognizable at small sizes
- High contrast for visibility
- No text smaller than 6pt
- Test on both light and dark backgrounds

#### Tools
- Figma (recommended)
- Sketch
- Adobe Illustrator
- Online: appicon.co

#### Steps
1. Open `reference/logo_tkd_forge.svg`
2. Create 1024x1024 artboard
3. Center logo with padding
4. Add background color (dark slate)
5. Export as PNG
6. Add to Xcode Assets → AppIcon

### 2. Screenshots

#### Required Sizes

**iPhone 6.7"** (iPhone 15 Pro Max, 14 Pro Max)
- 1290 x 2796 pixels
- Portrait orientation
- Required: 3-10 screenshots

**iPhone 6.5"** (iPhone 14 Plus, 13 Pro Max, 12 Pro Max)
- 1284 x 2778 pixels
- Portrait orientation
- Required: 3-10 screenshots

**iPad Pro 12.9"** (Optional but recommended)
- 2048 x 2732 pixels
- Portrait orientation
- Optional: 3-10 screenshots

#### Screenshot Sequence

**Screenshot 1: Splash Screen**
- Show TKD Forge logo
- Clean, professional first impression
- Add text overlay: "Master Choong-Jang Pattern"

**Screenshot 2: Pattern Info**
- Pattern overview screen
- Highlight: "52 Movements"
- Text overlay: "Complete Pattern Breakdown"

**Screenshot 3: Study View - Clock**
- Show clock visualizer prominently
- Display a move card
- Text overlay: "Innovative Directional System"

**Screenshot 4: Study View - Move**
- Different move than screenshot 3
- Show phase badge
- Text overlay: "Step-by-Step Instructions"

**Screenshot 5: Move List**
- Show the move list view
- Highlight organization
- Text overlay: "Quick Navigation"

**Screenshot 6: Voice Control** (Optional)
- Show microphone icon active
- Add visual indicator of voice control
- Text overlay: "Hands-Free Practice"

#### Creating Screenshots

**Method 1: Simulator (Quick)**
```bash
1. Run app in Xcode simulator
2. Navigate to desired screen
3. Cmd+S to save screenshot
4. Screenshots saved to Desktop
```

**Method 2: Device (Best Quality)**
```bash
1. Run app on physical device
2. Navigate to screen
3. Volume Up + Side button
4. Screenshots in Photos app
5. AirDrop to Mac
```

**Method 3: Xcode Screenshot Tool**
```bash
1. Window → Devices and Simulators
2. Select device
3. Take Screenshot button
4. Automatically sized correctly
```

#### Enhancing Screenshots

Use tools like:
- **Figma** (free, recommended)
- **Sketch**
- **Adobe Photoshop**
- **Screenshot Creator** (online tool)

Add:
- Text overlays explaining features
- Subtle drop shadows
- Consistent branding
- Device frames (optional)

### 3. App Preview Video (Optional)

#### Specifications
- **Length**: 15-30 seconds
- **Format**: .mov, .m4v, or .mp4
- **Resolution**: Match screenshot sizes
- **Orientation**: Portrait
- **File size**: Max 500MB

#### Storyboard

**0:00-0:05** - Splash Screen
- Logo animation
- App name reveal

**0:05-0:10** - Pattern Info
- Scroll through information
- Tap "Begin Study"

**0:10-0:20** - Study Flow
- Navigate through 2-3 moves
- Show clock visualizer
- Demonstrate next/previous

**0:20-0:25** - Voice Control
- Enable microphone
- Show voice command working

**0:25-0:30** - Move List
- Open move list
- Select a move
- End with logo

#### Recording Tools
- **QuickTime Player** (Mac, free)
- **Xcode Simulator** (built-in recording)
- **Screen Studio** (Mac, paid, professional)
- **iMovie** (editing)

#### Recording Steps
```bash
1. Open QuickTime Player
2. File → New Screen Recording
3. Select iPhone simulator
4. Click record
5. Perform actions slowly and deliberately
6. Stop recording
7. Edit in iMovie if needed
```

### 4. Logo Assets

#### For App
- **logo_tkd_forge**: 512x512, 1024x1024, 1536x1536
- Format: PNG with transparency
- Add to Assets.xcassets

#### For Marketing
- **High-res logo**: 2048x2048 or vector
- **Logo variations**: Light/dark backgrounds
- **Social media**: 1200x1200 (square)

### 5. Move Images

#### Specifications
- **Naming**: `move_1.png` through `move_52.png`
- **Size**: 800x800 pixels (or larger)
- **Format**: PNG or JPEG
- **Quality**: High (for zooming)

#### Options

**Option A: Photography**
1. Photograph each move
2. Use consistent background
3. Good lighting
4. Same angle/distance
5. Edit for consistency

**Option B: Illustrations**
1. Commission artist
2. Stick figure style works well
3. Consistent style across all
4. Clear, easy to understand

**Option C: Placeholder**
1. Use system icons initially
2. Add real images in updates
3. App works without images

#### Adding to Xcode
```bash
1. Assets.xcassets → Right-click → New Image Set
2. Name: move_1, move_2, etc.
3. Drag images into 1x, 2x, 3x slots
4. Or just use 1x for simplicity
```

### 6. Marketing Assets

#### App Store Promotional Text
- 170 characters max
- Highlight key feature
- Can be updated without app review

Example:
```
🥋 Master Choong-Jang with voice control! 52 moves, innovative clock system, beautiful dark mode. Perfect for 2nd Dan students.
```

#### Social Media Graphics
- **Twitter/X**: 1200x675
- **Facebook**: 1200x630
- **Instagram**: 1080x1080

Include:
- App icon
- Key feature highlights
- Download link
- Price

### 7. Asset Checklist

Before submission, verify:

- [ ] App Icon (1024x1024, no transparency)
- [ ] iPhone 6.7" screenshots (3-10)
- [ ] iPhone 6.5" screenshots (3-10)
- [ ] iPad screenshots (optional, 3-10)
- [ ] App Preview video (optional)
- [ ] Logo in Assets.xcassets
- [ ] Move images (optional but recommended)
- [ ] All images optimized (compressed)
- [ ] All images in correct format
- [ ] No copyrighted content

## Asset Optimization

### Image Compression
Use tools to reduce file size without quality loss:
- **ImageOptim** (Mac, free)
- **TinyPNG** (online)
- **Squoosh** (online, Google)

### Best Practices
- Compress all images before adding to Xcode
- Use @2x and @3x appropriately
- Remove unused assets
- Use Asset Catalog for organization

## Quick Start Commands

### Convert SVG to PNG (using ImageMagick)
```bash
# Install ImageMagick
brew install imagemagick

# Convert logo
convert -background none -resize 1024x1024 reference/logo_tkd_forge.svg logo_1024.png
```

### Batch Resize Images
```bash
# Resize all move images to 800x800
for img in move_*.png; do
  convert "$img" -resize 800x800 "resized_$img"
done
```

### Create App Icon from Logo
```bash
# Create 1024x1024 app icon
convert -background "#262A30" -gravity center -extent 1024x1024 reference/logo_tkd_forge.svg AppIcon.png
```

## Resources

### Design Tools
- **Figma**: figma.com (free)
- **Canva**: canva.com (templates)
- **Sketch**: sketch.com (Mac only)

### Screenshot Tools
- **Screenshot Creator**: screenshots.pro
- **App Mockup**: app-mockup.com
- **Previewed**: previewed.app

### Icon Generators
- **App Icon Generator**: appicon.co
- **MakeAppIcon**: makeappicon.com

### Stock Photos (if needed)
- **Unsplash**: unsplash.com
- **Pexels**: pexels.com
- **Pixabay**: pixabay.com

---

## Timeline

**Week 1**: Create app icon and logo assets
**Week 2**: Take/create move images
**Week 3**: Create screenshots and video
**Week 4**: Final review and submission

Good luck! 🎨

