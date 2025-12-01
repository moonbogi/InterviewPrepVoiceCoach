import Foundation
import Speech

// MARK: - Speech Recognition Service

class SpeechRecognitionService {
    
    static let shared = SpeechRecognitionService()
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    private init() {}
    
    // MARK: - Permission
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                completion(status == .authorized)
            }
        }
    }
    
    // MARK: - Real-time Recognition
    
    func startRecognition(onResult: @escaping (String) -> Void, onError: @escaping (Error) -> Void) throws {
        // Cancel any ongoing task
        stopRecognition()
        
        guard let speechRecognizer = speechRecognizer, speechRecognizer.isAvailable else {
            throw SpeechRecognitionError.recognizerNotAvailable
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = recognitionRequest else {
            throw SpeechRecognitionError.unableToCreateRequest
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        let inputNode = audioEngine.inputNode
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                let transcription = result.bestTranscription.formattedString
                onResult(transcription)
            }
            
            if let error = error {
                onError(error)
                self.stopRecognition()
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
    }
    
    func stopRecognition() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionRequest = nil
        recognitionTask = nil
    }
    
    // MARK: - Audio File Recognition
    
    func recognizeAudioFile(url: URL, completion: @escaping (Result<String, Error>) -> Void) {
        guard let speechRecognizer = speechRecognizer, speechRecognizer.isAvailable else {
            completion(.failure(SpeechRecognitionError.recognizerNotAvailable))
            return
        }
        
        let request = SFSpeechURLRecognitionRequest(url: url)
        request.shouldReportPartialResults = false
        
        speechRecognizer.recognitionTask(with: request) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let result = result, result.isFinal {
                completion(.success(result.bestTranscription.formattedString))
            }
        }
    }
}

// MARK: - Speech Recognition Error

enum SpeechRecognitionError: LocalizedError {
    case recognizerNotAvailable
    case unableToCreateRequest
    
    var errorDescription: String? {
        switch self {
        case .recognizerNotAvailable:
            return "Speech recognizer is not available"
        case .unableToCreateRequest:
            return "Unable to create speech recognition request"
        }
    }
}
