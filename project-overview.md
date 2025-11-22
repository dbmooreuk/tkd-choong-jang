Project Brief: Choong-Jang Master (iOS Edition)

1. App Overview
App Name: Choong-Jang Master
Platform: iOS (iPhone & iPad)
Framework: SwiftUI
Goal: A premium, interactive study companion for the Taekwondo pattern "Choong-Jang" (2nd Dan Black Belt). The app visualizes movements using a unique clock-face orientation system, offers AI-powered tactical analysis, and includes hands-free voice navigation for training.

2. Core Features & Requirements

A. The Pattern Player (Main View)
Card-Based Interface: Display one move at a time.
Move Details: Show Phase, Move Number, Title, and Description.
Navigation: Next/Previous buttons and a progress bar (1/52).
New Feature (Images): Display a static image for each move (e.g., move_01.jpg, move_02.jpg) above the text description. Note: Use placeholder SF Symbols or colored rectangles if assets aren't provided yet.
B. The Clock Visualizer (Crucial UI Component)
A custom vector graphic (using SwiftUI Shapes) that renders dynamically for every move to help the user orient themselves.

Visual Elements:
A compass/clock face background (12, 3, 6, 9 labels).
Blue Dot/Triangle: Represents the user's body facing direction (e.g., Facing 12:00).
Red Arrow/Line: Represents the direction of the movement/attack (e.g., Moving to 3:00).
Logic: The component must accept facing and direction integers (12, 3, 6, 9) and rotate the shapes to the correct degrees.

C. Voice Control (Hands-Free Mode)
Goal: Allow students to practice without touching the screen.
Interaction:
User taps "Start Voice Mode".
App acts as a "Sensei," reading the current move aloud.
App listens for commands: "Next", "Back", "Repeat".
App updates the UI automatically based on the command.
Tech: Use Gemini Live API (WebSocket) OR native SFSpeechRecognizer + AVSpeechSynthesizer for lower latency and offline capability. Recommendation for the AI: Use native iOS Speech/AVFoundation for reliability and cost-saving, utilizing Gemini only for the "Analysis" text.
3. Data Model
The app must use a static dataset (JSON or Structs) containing 52 moves.
Fields required:

id (Int)
phase (String)
title (String)
description (String)
imageName (String) [New Field]
facing (Int) - The clock hour (12, 3, 6, 9)
direction (Int) - The clock hour (12, 3, 6, 9)
4. Design Guidelines (Aesthetics)
Theme: Dark Mode ("Dojo" aesthetic).
Colors:
Background: Slate/Dark Navy (Color(hex: "0f172a")).
Accents: Electric Blue for "Facing", Red for "Target", Gold for "Sensei/AI".
Typography: Clean, sans-serif (System font or similar to Inter).
Animations: Smooth transitions between moves (slide animation) and smooth rotation for the clock visualizer arrows.
5. Technical Stack
Language: Swift 5+
UI Framework: SwiftUI
AI SDK: GoogleGenerativeAI (Swift Package)
Audio: AVFoundation, Speech
Minimum iOS Version: iOS 16.0

As a note this app will be reused for other taekwondo patterns that just use a different json file.

A future developement will be to add a video to each move and to also ad the following feature but these will be once the app is in the app store and has some revenue.


Future developemnt:
1. "Ask Sensei" (AI Analysis)
Action: A button labeled "Ask Sensei Analysis".
Behavior: When clicked, sends the current move's description to the Google Gemini API.
Prompt: "Analyze this Taekwondo move. Explain the practical self-defense application (Bunkai) and why we face this specific direction. Keep it under 50 words."

2. Video
Display: Show the loading state and then the text result in a collapsible box inside the move card.