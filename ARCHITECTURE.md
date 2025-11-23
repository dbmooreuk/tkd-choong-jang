# TKD Forge - Choong Jang Architecture

## Overview

This document describes the architecture and design patterns used in the TKD Forge - Choong Jang iOS application.

## Architecture Pattern: MVVM (Model-View-ViewModel)

### Why MVVM?
- Clean separation of concerns
- Testable business logic
- SwiftUI's natural fit with MVVM
- Reactive data flow with Combine
- Scalable for future patterns

## Layer Breakdown

### 1. Models (Data Layer)

#### Move.swift
```
Responsibilities:
- Define the structure of a single move
- Conform to Codable for JSON parsing
- Conform to Identifiable for SwiftUI lists
- Compute image name from move ID
```

**Key Properties:**
- `id`: Unique identifier (1-52)
- `title`: Short move name
- `description`: Detailed instructions
- `facing`: Clock hour for body facing
- `direction`: Clock hour for movement direction
- `stanceDetails`: Optional special notes

Optional metadata (may be omitted in JSON):
- `phase`: Grouping/category label for the move
- `pdfPage`: Original reference page number

#### PatternData.swift
```
Responsibilities:
- Load and parse pattern-data.json
- Provide pattern metadata
- Manage move collection
- Handle loading states and errors
```

**Key Components:**
- `PatternInfo`: Static pattern metadata
- `PatternDataStore`: ObservableObject for reactive updates
- JSON loading with error handling

### 2. ViewModels (Business Logic Layer)

#### AppState.swift
```
Responsibilities:
- Manage app-wide navigation state
- Control screen transitions
- Handle splash screen timing
```

**State Machine:**
```
.splash → .patternInfo → .study
```

#### StudyViewModel.swift
```
Responsibilities:
- Manage current move index
- Handle navigation (next/previous/jump)
- Calculate progress
- Control voice control state
```

**Key Methods:**
- `nextMove()`: Advance with animation
- `previousMove()`: Go back with animation
- `goToMove(at:)`: Jump to specific move
- `toggleVoiceControl()`: Enable/disable voice

### 3. Views (Presentation Layer)

#### Screen Views

**SplashView**
- Animated logo entrance
- Brand presentation
- Auto-dismisses after 2.5s

**PatternInfoView**
- Pattern metadata display
- Move count and belt level
- "Begin Study" CTA

**StudyView**
- Main learning interface
- Coordinates all components
- Manages voice control lifecycle

#### Component Views

**ClockVisualizer**
- Custom Shape-based drawing
- Blue arrow: Facing direction
- Red dashed arrow: Movement direction
- Hour markers (1-12)
- Legend

**MoveCard**
- Clock at top
- Optional phase badge (shown only when `phase` is present)
- Move image (or placeholder)
- Title and description
- Optional stance details

**MoveListView**
- Scrollable list of all moves
- Current move highlighting
- Quick navigation

### 4. Services Layer

#### VoiceControlManager.swift
```
Responsibilities:
- Speech recognition (SFSpeechRecognizer)
- Text-to-speech (AVSpeechSynthesizer)
- Audio session management
- Command parsing
```

**Voice Commands:**
- "Next" → Navigate forward
- "Back"/"Previous" → Navigate backward
- "Repeat"/"Again" → Re-read description

**Permissions:**
- Speech recognition authorization
- Microphone access

## Data Flow

### Loading Pattern Data
```
App Launch
    ↓
PatternDataStore.init()
    ↓
loadMoves()
    ↓
Bundle.main.url(forResource: "pattern-data")
    ↓
JSONDecoder.decode([Move].self)
    ↓
@Published moves array updated
    ↓
SwiftUI views automatically refresh
```

### Navigation Flow
```
User Action (Next button)
    ↓
StudyViewModel.nextMove()
    ↓
withAnimation { currentMoveIndex += 1 }
    ↓
@Published property triggers view update
    ↓
SwiftUI re-renders with transition
```

### Voice Control Flow
```
User enables voice control
    ↓
VoiceControlManager.startListening()
    ↓
Audio engine captures speech
    ↓
SFSpeechRecognizer processes audio
    ↓
processCommand() parses text
    ↓
Callback closure executed
    ↓
ViewModel updates state
    ↓
View updates
```

## State Management

### @StateObject vs @ObservedObject vs @EnvironmentObject

**@StateObject** (Owner)
- `PatternDataStore` in ContentView
- `StudyViewModel` in StudyView
- `VoiceControlManager` in StudyView
- `AppState` in App

**@EnvironmentObject** (Shared)
- `AppState` passed to all screens
- `PatternDataStore` shared with child views

**@State** (Local)
- Animation states
- UI-only state (showingMoveList)

## Design Patterns

### 1. Observer Pattern
- SwiftUI's `@Published` and `ObservableObject`
- Automatic view updates on data changes

### 2. Delegation Pattern
- Voice control callbacks
- `onNextCommand`, `onBackCommand`, `onRepeatCommand`

### 3. Factory Pattern
- Move image name computation
- `imageName` computed property

### 4. Repository Pattern
- `PatternDataStore` abstracts data loading
- Could easily swap JSON for Core Data or API

## Scalability

### Adding New Patterns

To create "TKD Forge - Dan Gun":

1. **Create new pattern-data.json**
   ```json
   [
     { "id": 1, "title": "...", ... }
   ]
   ```

2. **Update PatternInfo**
   ```swift
   static let danGun = PatternInfo(
       name: "Dan-Gun",
       meaning: "...",
       numberOfMoves: 21,
       belt: "1st Dan Black Belt"
   )
   ```

3. **Update branding**
   - App name
   - Bundle identifier
   - Logo/colors

4. **Reuse all code**
   - No changes to ViewModels
   - No changes to Views
   - No changes to Services

### Future Enhancements

**Potential Features:**
- [ ] Slow-motion video demonstrations
- [ ] AR overlay for stance correction
- [ ] Practice timer and session tracking
- [ ] Multiple pattern support in one app
- [ ] Social sharing of progress
- [ ] Instructor mode with student tracking
- [ ] Offline video downloads
- [ ] Apple Watch companion app

**Technical Improvements:**
- [ ] Unit tests for ViewModels
- [ ] UI tests for critical flows
- [ ] Core Data for user progress
- [ ] CloudKit sync across devices
- [ ] Localization support
- [ ] Accessibility improvements (VoiceOver)

## Performance Considerations

### Image Loading
- Images loaded on-demand
- SwiftUI caches automatically
- Consider lazy loading for large image sets

### Animation Performance
- Use `.spring()` for natural motion
- Limit simultaneous animations
- Profile with Instruments if needed

### Memory Management
- `@StateObject` ensures single instance
- Weak references in closures where needed
- No retain cycles detected

### Voice Recognition
- Audio engine stopped when not in use
- Recognition task cancelled properly
- Audio session deactivated correctly

## Testing Strategy

### Unit Tests
```swift
// ViewModels
- Test navigation logic
- Test progress calculation
- Test move index bounds

// Models
- Test JSON parsing
- Test computed properties
- Test data validation
```

### UI Tests
```swift
// Critical Flows
- Splash → Info → Study
- Next/Previous navigation
- Move list selection
- Voice control toggle
```

### Manual Testing
- Voice control on device
- Different screen sizes
- Dark mode appearance
- Accessibility features

## Code Style Guidelines

### Naming Conventions
- Views: `PascalCase` + "View" suffix
- ViewModels: `PascalCase` + "ViewModel" suffix
- Properties: `camelCase`
- Constants: `camelCase` (or `SCREAMING_SNAKE_CASE` for globals)

### File Organization
- One type per file
- Group related files in folders
- Keep files under 200 lines when possible

### SwiftUI Best Practices
- Extract complex views into components
- Use `@ViewBuilder` for conditional content
- Prefer composition over inheritance
- Keep view bodies simple and readable

## Dependencies

### System Frameworks
- **SwiftUI**: UI framework
- **Speech**: Voice recognition
- **AVFoundation**: Text-to-speech
- **Combine**: Reactive programming

### Third-Party
- None (intentionally dependency-free)

## Security & Privacy

### Data Protection
- All data stored locally
- No network requests
- No analytics or tracking

### Permissions
- Speech recognition: Requested on first use
- Microphone: Requested on first use
- Both can be denied without breaking app

### Privacy Policy Compliance
- GDPR compliant (no data collection)
- COPPA compliant (safe for children)
- App Store privacy nutrition label: None required

---

## Conclusion

This architecture provides:
✅ Clean separation of concerns
✅ Testable components
✅ Scalable for multiple patterns
✅ Maintainable codebase
✅ SwiftUI best practices
✅ Privacy-first design

The app is production-ready and follows Apple's Human Interface Guidelines and App Store Review Guidelines.

