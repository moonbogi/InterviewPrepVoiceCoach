import Foundation
import AVFoundation

// MARK: - Audio Recorder Service

class AudioRecorderService: NSObject {
    
    static let shared = AudioRecorderService()
    
    private var audioRecorder: AVAudioRecorder?
    private var recordingSession: AVAudioSession?
    private var currentRecordingURL: URL?
    
    private override init() {
        super.init()
        setupAudioSession()
    }
    
    // MARK: - Setup
    
    private func setupAudioSession() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession?.setCategory(.playAndRecord, mode: .default)
            try recordingSession?.setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    // MARK: - Permission
    
    func requestPermission(completion: @escaping (Bool) -> Void) {
        recordingSession?.requestRecordPermission { allowed in
            DispatchQueue.main.async {
                completion(allowed)
            }
        }
    }
    
    // MARK: - Recording
    
    func startRecording() throws -> URL {
        let filename = "interview_\(UUID().uuidString).m4a"
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioURL = documentsPath.appendingPathComponent(filename)
        
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        audioRecorder = try AVAudioRecorder(url: audioURL, settings: settings)
        audioRecorder?.delegate = self
        audioRecorder?.record()
        
        currentRecordingURL = audioURL
        return audioURL
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
    }
    
    func pauseRecording() {
        audioRecorder?.pause()
    }
    
    func resumeRecording() {
        audioRecorder?.record()
    }
    
    var isRecording: Bool {
        return audioRecorder?.isRecording ?? false
    }
    
    var currentTime: TimeInterval {
        return audioRecorder?.currentTime ?? 0
    }
    
    // MARK: - Playback
    
    func getAudioDuration(url: URL) -> TimeInterval {
        let asset = AVURLAsset(url: url)
        return CMTimeGetSeconds(asset.duration)
    }
}

// MARK: - AVAudioRecorderDelegate

extension AudioRecorderService: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            print("Recording failed")
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Recording error: \(error)")
        }
    }
}
