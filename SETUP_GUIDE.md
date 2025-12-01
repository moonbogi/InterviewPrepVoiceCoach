# Setup Guide for Xcode

## Step-by-Step Setup Instructions

### 1. Create New Xcode Project

1. Open Xcode
2. File → New → Project
3. Select **iOS** → **App**
4. Configure:
   - Product Name: `InterviewPrepVoiceCoach`
   - Team: Your team
   - Organization Identifier: `com.yourcompany`
   - Interface: **Storyboard** (we'll remove it)
   - Language: **Swift**
   - Storage: **None**
   - Uncheck "Use Core Data"
   - Uncheck "Include Tests" (optional)

### 2. Remove Storyboard

#### Delete Files:
- Right-click `Main.storyboard` → Delete → Move to Trash
- Right-click `LaunchScreen.storyboard` → Delete → Move to Trash (optional)

#### Update Project Settings:
1. Select project in Navigator
2. Select your target
3. Go to **Info** tab
4. Find and **DELETE** the row: "Main storyboard file base name" (or "UIMainStoryboardFile")
5. Go to **General** tab → **Deployment Info**
6. Clear the "Main Interface" field (should be empty)

#### Update Info.plist:
- Open `Info.plist` as source code
- Remove these lines if present:
```xml
<key>UIMainStoryboardFile</key>
<string>Main</string>
```

### 3. Project Structure Setup

Create this folder structure in Xcode (Right-click project → New Group):

```
InterviewPrepVoiceCoach
├── Core
│   ├── Base
│   └── Coordinators
├── Models
├── Services
├── ViewModels
└── Views
    ├── Components
    ├── Home
    ├── Recording
    ├── Feedback
    └── History
```

### 4. Add Source Files

**Method 1: Drag & Drop**
1. Open Finder and navigate to your cloned/downloaded source
2. Drag each folder into Xcode matching the structure above
3. When prompted, select:
   - ✅ Copy items if needed
   - ✅ Create groups
   - ✅ Add to targets: InterviewPrepVoiceCoach

**Method 2: New File**
For each file:
1. Right-click the appropriate folder
2. New File → Swift File
3. Copy-paste the content
4. Ensure target membership is checked

### 5. Replace Default Files

Replace the auto-generated files:
- ✅ `AppDelegate.swift` - Replace with provided version
- ✅ `SceneDelegate.swift` - Replace with provided version
- ✅ `Info.plist` - Replace or merge with provided version

### 6. Verify File Structure

Your project navigator should look like:

```
▼ InterviewPrepVoiceCoach
  ▼ InterviewPrepVoiceCoach
    • AppDelegate.swift
    • SceneDelegate.swift
    ▼ Core
      ▼ Base
        • BaseViewController.swift
        • BaseViewModel.swift
      ▼ Coordinators
        • Coordinators.swift
    ▼ Models
      • InterviewModels.swift
    ▼ Services
      • AudioRecorderService.swift
      • SpeechRecognitionService.swift
      • AnalysisService.swift
      • PersistenceService.swift
    ▼ ViewModels
      • HomeViewModel.swift
      • RecordingViewModel.swift
      • FeedbackViewModel.swift
      • HistoryViewModel.swift
    ▼ Views
      ▼ Components
        • UIComponents.swift
      ▼ Home
        • HomeViewController.swift
      ▼ Recording
        • RecordingViewController.swift
      ▼ Feedback
        • FeedbackViewController.swift
      ▼ History
        • HistoryViewController.swift
    ▼ Assets.xcassets
      ▼ AppIcon.appiconset
        • Contents.json
    • Info.plist
    • README.md
    • PROJECT_STRUCTURE.md
```

### 7. Build Settings (Optional but Recommended)

1. Select Project → Build Settings
2. Set minimum iOS version: **iOS 15.0** or later
3. Enable these warnings:
   - Strict Concurrency Checking: Minimal
   - Swift Language Version: Swift 5

### 8. Info.plist Permissions

Ensure these keys exist in Info.plist:

```xml
<key>NSMicrophoneUsageDescription</key>
<string>We need access to your microphone to record your interview practice sessions and provide feedback.</string>

<key>NSSpeechRecognitionUsageDescription</key>
<string>We use speech recognition to analyze your responses and provide feedback on pacing, filler words, and clarity.</string>
```

### 9. Build and Run

1. Select a target:
   - **For full testing**: Physical iPhone/iPad (required for mic & speech)
   - **For UI testing**: Simulator (limited functionality)

2. Press ⌘+B to build
3. Fix any errors (should compile cleanly)
4. Press ⌘+R to run

### 10. First Launch

When the app launches:
1. Grant **Microphone** permission
2. Grant **Speech Recognition** permission
3. App should show the Home screen with empty stats

## Common Issues & Solutions

### Issue: "No such module 'Speech'"
**Solution**: Ensure deployment target is iOS 10.0+

### Issue: Build errors about missing files
**Solution**: Check that all files are added to the target (File Inspector → Target Membership)

### Issue: App crashes on launch
**Solution**: Ensure `SceneDelegate` is properly configured in Info.plist

### Issue: Microphone not working in Simulator
**Solution**: This is expected. Use a physical device for full functionality.

### Issue: "Main storyboard file not found"
**Solution**: 
1. Clean build folder (⌘+Shift+K)
2. Delete derived data
3. Verify Info.plist has no storyboard references
4. Rebuild

## Verification Checklist

Before running:
- [ ] All 20+ source files added
- [ ] No storyboard references in project
- [ ] Info.plist has permission descriptions
- [ ] SceneDelegate properly configured
- [ ] No build errors (⌘+B succeeds)
- [ ] Target set to iOS device or simulator
- [ ] App icon placeholder exists (optional)

## Testing the App

### Basic Flow Test:
1. ✅ Launch app → See Home screen
2. ✅ Tap "Quick Start" → See Recording screen
3. ✅ Grant permissions when prompted
4. ✅ Tap microphone → Start recording
5. ✅ Speak for 10-20 seconds
6. ✅ Tap "Stop & Analyze" → See Feedback screen
7. ✅ View score and metrics
8. ✅ Tap "Done" → Return to Home
9. ✅ Tap "View History" → See saved session
10. ✅ Tap session → View feedback again

## Next Steps

Once running:
1. Add app icon images
2. Customize color scheme
3. Add more questions
4. Test on multiple devices
5. Prepare for App Store submission

## Need Help?

Check:
- README.md for detailed documentation
- PROJECT_STRUCTURE.md for architecture overview
- Inline code comments for specific functionality

---

Happy coding! 🚀 This is an App Store-ready architecture.
