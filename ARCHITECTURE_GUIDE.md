# Architecture Quick Reference

## MVVM + Coordinator Pattern Overview

### Component Responsibilities

#### 1. Models (Data)
**File**: `InterviewModels.swift`
- Pure data structures
- Codable for persistence
- No business logic
- Immutable where possible

```swift
struct InterviewSession {
    let id: UUID
    let question: String
    let transcription: String
    let analysis: InterviewAnalysis
}
```

#### 2. Views (UI)
**Files**: `*ViewController.swift`
- UIKit components
- User interaction handling
- Display data only
- No business logic
- Delegate to ViewModel

```swift
class HomeViewController: BaseViewController {
    private let viewModel: HomeViewModel
    // UI setup and event forwarding
}
```

#### 3. ViewModels (Logic)
**Files**: `*ViewModel.swift`
- Business logic
- Data transformation
- State management
- Service coordination
- No UIKit imports

```swift
class HomeViewModel {
    weak var coordinator: HomeCoordinator?
    func startInterview() { /* logic */ }
}
```

#### 4. Coordinators (Navigation)
**File**: `Coordinators.swift`
- Screen flow control
- ViewController instantiation
- Navigation logic
- Child coordinator management

```swift
class HomeCoordinator {
    func startInterview() {
        let vm = RecordingViewModel()
        let vc = RecordingViewController(vm)
        navigationController.push(vc)
    }
}
```

#### 5. Services (Utilities)
**Files**: `*Service.swift`
- Reusable functionality
- API calls (if any)
- Data persistence
- System frameworks
- Singleton pattern

```swift
class SpeechRecognitionService {
    static let shared = SpeechRecognitionService()
    func startRecognition() { /* ... */ }
}
```

## Data Flow

```
User Action
    ↓
ViewController (View)
    ↓
ViewModel (Logic)
    ↓
Service (Data/System)
    ↓
Model (Data Structure)
    ↓
ViewModel (Processing)
    ↓
ViewController (Update UI)
```

## Navigation Flow

```
AppCoordinator (Root)
    ↓
HomeCoordinator
    ├→ RecordingCoordinator
    │      └→ FeedbackCoordinator
    └→ HistoryCoordinator
           └→ FeedbackCoordinator
```

## Communication Patterns

### View → ViewModel
- Direct method calls
- Action methods
```swift
viewModel.startRecording()
```

### ViewModel → View
- Closures/callbacks
- Delegation (optional)
```swift
viewModel.onUpdate = { data in
    updateUI(data)
}
```

### ViewModel → Coordinator
- Weak reference
- Navigation requests
```swift
coordinator?.showNextScreen()
```

### Service → ViewModel
- Completion handlers
- Result types
```swift
service.fetch { result in
    // handle result
}
```

## Dependency Injection

All dependencies injected through initializers:

```swift
class RecordingViewController {
    init(viewModel: RecordingViewModel) {
        self.viewModel = viewModel
    }
}

class RecordingViewModel {
    init(coordinator: RecordingCoordinator) {
        self.coordinator = coordinator
    }
}
```

## Memory Management Rules

### Strong References
- View owns ViewModel
- Coordinator owns child ViewControllers
- Services are singletons

### Weak References
- ViewModel → Coordinator (weak)
- Closure captures of self (weak/unowned)
- Delegate protocols (weak)

```swift
weak var coordinator: HomeCoordinator?

viewModel.onUpdate = { [weak self] in
    self?.updateUI()
}
```

## Testing Strategy

### Testable Components
✅ ViewModels (pure logic, no UI)
✅ Models (data validation)
✅ Services (mocked dependencies)

### Testing Approach
```swift
func testStartInterview() {
    let coordinator = MockHomeCoordinator()
    let viewModel = HomeViewModel(coordinator: coordinator)
    viewModel.startInterview(with: question)
    XCTAssertTrue(coordinator.startInterviewCalled)
}
```

## Code Organization Principles

### SOLID Principles Applied

**S - Single Responsibility**
- Each class has one reason to change
- Services do one thing well

**O - Open/Closed**
- Protocol-oriented design
- Extensible without modification

**L - Liskov Substitution**
- Base classes can be replaced by subclasses
- BaseViewController used consistently

**I - Interface Segregation**
- Small, focused protocols
- ViewModelType protocol

**D - Dependency Inversion**
- Depend on abstractions (protocols)
- Inject dependencies

## Key Design Decisions

### Why MVVM?
✅ Testable business logic
✅ Clear separation of concerns
✅ Reusable ViewModels
✅ No massive ViewControllers

### Why Coordinator Pattern?
✅ Reusable ViewControllers
✅ Centralized navigation
✅ Deep linking friendly
✅ Easier to modify flows

### Why No Storyboards?
✅ Better for code review
✅ No merge conflicts
✅ Version control friendly
✅ More explicit
✅ Better for large teams

### Why Programmatic UI?
✅ Type-safe constraints
✅ Compile-time checking
✅ Better code reuse
✅ Easier refactoring

## Common Patterns Used

### Singleton
```swift
class AudioRecorderService {
    static let shared = AudioRecorderService()
}
```

### Factory (in Coordinators)
```swift
func makeViewController() -> UIViewController {
    let vm = HomeViewModel(coordinator: self)
    return HomeViewController(viewModel: vm)
}
```

### Observer (Closures)
```swift
var onUpdate: ((String) -> Void)?
onUpdate?("new data")
```

### Delegation
```swift
protocol RecordingDelegate: AnyObject {
    func didFinishRecording()
}
```

## File Naming Conventions

- ViewControllers: `FeatureViewController.swift`
- ViewModels: `FeatureViewModel.swift`
- Models: `FeatureModels.swift` or `Feature.swift`
- Services: `FeatureService.swift`
- Coordinators: `FeatureCoordinator.swift`
- Views: `FeatureView.swift`

## Code Style Guidelines

### Naming
- Classes: PascalCase
- Variables/functions: camelCase
- Constants: camelCase or UPPER_CASE
- Protocols: PascalCase (often with -able, -ing suffix)

### Structure
```swift
class MyViewController {
    // MARK: - Properties (grouped by access level)
    
    // MARK: - Initialization
    
    // MARK: - Lifecycle
    
    // MARK: - Setup
    
    // MARK: - Actions
    
    // MARK: - Private Methods
}
```

## Error Handling

### Result Type
```swift
func loadData(completion: (Result<Data, Error>) -> Void) {
    // ...
}
```

### Try-Catch
```swift
do {
    try audioRecorder.start()
} catch {
    handleError(error)
}
```

### Optional Handling
```swift
guard let url = audioURL else { return }
// preferred over force unwrapping
```

## Performance Considerations

✅ Lazy initialization
✅ Reuse cells in tables
✅ Background processing
✅ Weak references in closures
✅ Efficient data structures

## Security Checklist

✅ No hardcoded secrets
✅ Secure local storage
✅ Proper permission handling
✅ Input validation
✅ Error messages don't leak info

## Scalability

### Easy to Add:
- New screens (new Coordinator + VC + VM)
- New features (new Service)
- New data models (Models file)
- New UI components (Components file)

### Easy to Modify:
- Navigation flows (Coordinators)
- Business logic (ViewModels)
- UI layouts (ViewControllers)
- Data structure (Models)

---

**Quick Tip**: When adding a new feature, follow this order:
1. Model (data structure)
2. Service (if needed)
3. ViewModel (business logic)
4. ViewController (UI)
5. Coordinator (navigation)
