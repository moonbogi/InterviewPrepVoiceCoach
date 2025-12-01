import Foundation
import AVFoundation

// MARK: - Recording ViewModel

class RecordingViewModel: ViewModelType {
    
    weak var coordinator: RecordingCoordinator?
    
    let question: String
    private let audioRecorderService = AudioRecorderService.shared
    private let speechRecognitionService = SpeechRecognitionService.shared
    private let analysisService = AnalysisService.shared
    private let persistenceService = PersistenceService.shared
    
    var isRecording = false
    var transcription = ""
    var recordingStartTime: Date?
    private var audioFileURL: URL?
    
    var onTranscriptionUpdate: ((String) -> Void)?
    var onRecordingTimeUpdate: ((TimeInterval) -> Void)?
    var onError: ((Error) -> Void)?
    
    init(coordinator: RecordingCoordinator, question: String) {
        self.coordinator = coordinator
        self.question = question
    }
    
    // MARK: - Recording Actions
    
    func startRecording(completion: @escaping (Bool) -> Void) {
        // Request permissions
        requestPermissions { [weak self] granted in
            guard granted else {
                completion(false)
                return
            }
            
            self?.beginRecording()
            completion(true)
        }
    }
    
    func stopRecording(completion: @escaping () -> Void) {
        audioRecorderService.stopRecording()
        speechRecognitionService.stopRecognition()
        isRecording = false
        
        guard let startTime = recordingStartTime else {
            completion()
            return
        }
        
        let duration = Date().timeIntervalSince(startTime)
        
        // Perform analysis
        let analysis = analysisService.performCompleteAnalysis(transcription: transcription, duration: duration)
        
        // Create session
        let session = InterviewSession(
            question: question,
            transcription: transcription,
            audioFileURL: audioFileURL,
            duration: duration,
            analysis: analysis
        )
        
        // Save session
        persistenceService.saveSession(session)
        
        // Show feedback
        coordinator?.showFeedback(session: session)
        
        completion()
    }
    
    func cancelRecording() {
        audioRecorderService.stopRecording()
        speechRecognitionService.stopRecognition()
        isRecording = false
        
        // Delete audio file if exists
        if let url = audioFileURL {
            try? FileManager.default.removeItem(at: url)
        }
        
        coordinator?.finish()
    }
    
    // MARK: - Private Methods
    
    private func requestPermissions(completion: @escaping (Bool) -> Void) {
        var microphoneGranted = false
        var speechGranted = false
        
        let group = DispatchGroup()
        
        // Request microphone permission
        group.enter()
        audioRecorderService.requestPermission { granted in
            microphoneGranted = granted
            group.leave()
        }
        
        // Request speech recognition permission
        group.enter()
        speechRecognitionService.requestAuthorization { granted in
            speechGranted = granted
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion(microphoneGranted && speechGranted)
        }
    }
    
    private func beginRecording() {
        do {
            // Start audio recording
            audioFileURL = try audioRecorderService.startRecording()
            
            // Start speech recognition
            try speechRecognitionService.startRecognition(
                onResult: { [weak self] transcription in
                    self?.transcription = transcription
                    self?.onTranscriptionUpdate?(transcription)
                },
                onError: { [weak self] error in
                    self?.onError?(error)
                }
            )
            
            isRecording = true
            recordingStartTime = Date()
            
        } catch {
            onError?(error)
        }
    }
    
    func getCurrentRecordingTime() -> TimeInterval {
        guard let startTime = recordingStartTime else { return 0 }
        return Date().timeIntervalSince(startTime)
    }
}
