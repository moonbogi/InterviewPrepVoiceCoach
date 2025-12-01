# Interview Prep Voice Coach 🎤

A production-ready iOS app built with Swift UIKit (100% programmatic, zero storyboards) that helps you practice and improve your interview skills using speech recognition and AI-powered feedback.

## Features

✨ **Core Features**
- 🎙️ Record mock interview responses with real-time transcription
- 📊 Comprehensive analysis of your performance
- 🗣️ Filler word detection (um, uh, like, etc.)
- ⏱️ Speaking pace analysis (words per minute)
- 😊 Sentiment analysis for confidence scoring
- 📝 10+ built-in behavioral interview questions
- 📱 Clean, modern UI with dark mode support
- 💾 Local data persistence for session history

## Architecture

This app follows industry best practices and App Store-ready design patterns:

### Design Pattern: **MVVM + Coordinator**

```
InterviewPrepVoiceCoach/
├── AppDelegate.swift                 # App lifecycle
├── SceneDelegate.swift               # Scene management
├── Info.plist                        # App configuration & permissions
│
├── Core/
│   ├── Base/
│   │   ├── BaseViewController.swift  # Base VC with common functionality
│   │   └── BaseViewModel.swift       # ViewModel protocols
│   └── Coordinators/
│       └── Coordinators.swift        # Navigation coordination
│
├── Models/
│   └── InterviewModels.swift         # Data models
│
├── Services/
│   ├── AudioRecorderService.swift    # Audio recording
│   ├── SpeechRecognitionService.swift # Speech-to-text
│   ├── AnalysisService.swift         # ML analysis
│   └── PersistenceService.swift      # Data storage
│
├── ViewModels/
│   ├── HomeViewModel.swift
│   ├── RecordingViewModel.swift
│   ├── FeedbackViewModel.swift
│   └── HistoryViewModel.swift
│
└── Views/
    ├── Components/
    │   └── UIComponents.swift         # Reusable UI components
    ├── Home/
    │   └── HomeViewController.swift
    ├── Recording/
    │   └── RecordingViewController.swift
    ├── Feedback/
    │   └── FeedbackViewController.swift
    └── History/
        └── HistoryViewController.swift
```

### Key Design Decisions

1. **Coordinator Pattern**: Clean navigation flow and reduced coupling between view controllers
2. **MVVM**: Clear separation of concerns, testable business logic
3. **Protocol-Oriented**: Flexible, testable architecture
4. **Service Layer**: Reusable, single-responsibility services
5. **Programmatic UI**: 100% code-based UI for better version control and team collaboration
6. **No Third-Party Dependencies**: Uses native iOS frameworks only

## Technologies Used

- **Swift 5+**
- **UIKit** (Programmatic, no Storyboards/XIBs)
- **AVFoundation** - Audio recording and playback
- **Speech Framework** - Real-time speech recognition
- **NaturalLanguage Framework** - Sentiment analysis
- **UserDefaults + Codable** - Local data persistence

## Setup Instructions

### Prerequisites

- Xcode 14.0 or later
- iOS 15.0 or later
- macOS 12.0 or later
- Physical iOS device (recommended for testing microphone and speech features)

### Installation

1. **Create a new Xcode project**:
   - Open Xcode
   - File → New → Project
   - Choose "App" template
   - Product Name: `InterviewPrepVoiceCoach`
   - Interface: **Storyboard** (we'll remove it)
   - Language: **Swift**
   - Click "Next" and create

2. **Remove Storyboard**:
   - Delete `Main.storyboard` from project
   - Delete `LaunchScreen.storyboard` (optional)
   - Select project → Target → Info tab
   - Delete "Main storyboard file base name" entry
   - Select "Deployment Info" section
   - Remove "Main Interface" storyboard reference

3. **Add all source files**:
   - Copy all `.swift` files from this repository into your project
   - Maintain the folder structure as shown above
   - Replace the auto-generated `AppDelegate.swift` and `SceneDelegate.swift`

4. **Update Info.plist**:
   - Replace your Info.plist with the provided one, or add these keys:
   ```xml
   <key>NSMicrophoneUsageDescription</key>
   <string>We need access to your microphone to record your interview practice sessions and provide feedback.</string>
   
   <key>NSSpeechRecognitionUsageDescription</key>
   <string>We use speech recognition to analyze your responses and provide feedback on pacing, filler words, and clarity.</string>
   
   <key>UIApplicationSceneManifest</key>
   <dict>
       <key>UISceneConfigurations</key>
       <dict>
           <key>UIWindowSceneSessionRoleApplication</key>
           <array>
               <dict>
                   <key>UISceneConfigurationName</key>
                   <string>Default Configuration</string>
                   <key>UISceneDelegateClassName</key>
                   <string>$(PRODUCT_MODULE_NAME).SceneDelegate</string>
               </dict>
           </array>
       </dict>
   </dict>
   ```

5. **Build and Run**:
   - Select your target device or simulator
   - Press ⌘+R to build and run
   - Grant microphone and speech recognition permissions when prompted

## Usage

1. **Home Screen**:
   - View your practice statistics
   - Quick start with a random question
   - Select a specific question by category
   - Browse your practice history

2. **Recording Screen**:
   - Read the interview question
   - Tap the microphone button to start recording
   - Speak your response naturally
   - Watch real-time transcription
   - Tap "Stop & Analyze" when done

3. **Feedback Screen**:
   - View your overall score (0-100)
   - Review detailed metrics:
     - Speaking pace analysis
     - Filler words count and breakdown
     - Confidence and sentiment scores
   - Read your full transcription
   - Identify areas for improvement

4. **History Screen**:
   - View all past practice sessions
   - Tap any session to review feedback
   - Swipe left to delete sessions

## Key Features Implementation

### Speech Recognition
- Real-time transcription using Apple's Speech framework
- Support for partial results during recording
- Automatic error handling and recovery

### Analysis Engine
- **Filler Word Detection**: Identifies 15+ common filler words
- **Pacing Analysis**: Calculates WPM and provides rating (optimal: 120-150 WPM)
- **Sentiment Analysis**: Uses NaturalLanguage framework for confidence scoring
- **Overall Score**: Composite score based on all metrics

### Data Persistence
- Sessions saved locally using UserDefaults + Codable
- Audio files stored in Documents directory
- Automatic cleanup on session deletion

## Testing on Device

**Important**: Speech recognition requires a physical device. Simulator limitations:
- Microphone access not available
- Speech recognition will fail

To test on a real device:
1. Connect your iPhone/iPad
2. Select it in Xcode's device list
3. Build and run
4. Trust the developer certificate on device (Settings → General → VPN & Device Management)

## App Store Readiness Checklist

- ✅ No storyboards (better for large teams)
- ✅ MVVM + Coordinator architecture
- ✅ Protocol-oriented design
- ✅ Memory management (weak references, no retain cycles)
- ✅ Error handling throughout
- ✅ User permissions properly requested
- ✅ Dark mode support
- ✅ iPad and iPhone support
- ✅ No force-unwrapping (safe optionals handling)
- ✅ Accessibility support ready for implementation
- ✅ No third-party dependencies (reduces security risks)

### Next Steps for App Store

1. **Add App Icon**: Create and add app icons in Assets.xcassets
2. **Launch Screen**: Create a proper launch screen
3. **Localization**: Add support for multiple languages
4. **Accessibility**: Add VoiceOver labels and hints
5. **Analytics**: Integrate analytics (optional)
6. **Testing**: Write unit tests and UI tests
7. **Privacy Policy**: Create privacy policy for App Store
8. **Screenshots**: Create App Store screenshots
9. **App Description**: Write compelling App Store description

## Customization

### Adding New Questions

Edit `InterviewModels.swift`:

```swift
extension InterviewQuestion {
    static let defaultQuestions: [InterviewQuestion] = [
        // Add your questions here
        InterviewQuestion(
            text: "Your custom question?",
            category: .behavioral,
            difficulty: .medium
        ),
    ]
}
```

### Modifying Analysis Thresholds

Edit `AnalysisService.swift`:

```swift
// Adjust WPM thresholds
if wordsPerMinute < 100 {  // Change this value
    rating = .tooSlow
}

// Adjust scoring algorithm
var score: Double = 70  // Base score
```

### Customizing UI Theme

Edit `AppDelegate.swift` → `configureAppearance()`:

```swift
appearance.backgroundColor = .yourCustomColor
UINavigationBar.appearance().tintColor = .yourBrandColor
```

## Performance Considerations

- **Memory**: Audio recordings are streamed, not held in memory
- **Battery**: Recording automatically stops on background
- **Storage**: Each session ~500KB-2MB depending on duration
- **CPU**: Analysis runs on background thread, UI stays responsive

## Troubleshooting

### "Speech recognition not available"
- Ensure device has internet connection (required for first use)
- Check Settings → Privacy → Speech Recognition
- Restart the app

### "Microphone permission denied"
- Go to Settings → Privacy → Microphone
- Enable permission for the app
- Restart the app

### Build errors
- Clean build folder (⌘+Shift+K)
- Ensure all files are added to target
- Check for typos in Info.plist keys

## Future Enhancements

- [ ] Video recording for body language analysis
- [ ] AI-powered answer suggestions
- [ ] Social features (share progress)
- [ ] Custom question categories
- [ ] Export sessions as PDF reports
- [ ] iCloud sync
- [ ] Apple Watch companion app
- [ ] Practice reminders/notifications

## Contributing

This is a template project. Feel free to:
- Fork and customize
- Add features
- Report issues
- Submit pull requests

## License

This project is open source and available under the MIT License.

## Author

Built with ❤️ for interview preparation and iOS development best practices.

---

**Note**: This app is designed as a learning tool and follows professional iOS development standards suitable for portfolio projects and App Store submission.
