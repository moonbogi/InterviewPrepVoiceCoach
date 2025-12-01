import Foundation

// MARK: - Persistence Service

class PersistenceService {
    
    static let shared = PersistenceService()
    
    private let userDefaults = UserDefaults.standard
    private let sessionsKey = "savedInterviewSessions"
    
    private init() {}
    
    // MARK: - Save Session
    
    func saveSession(_ session: InterviewSession) {
        var sessions = loadAllSessions()
        sessions.append(session)
        saveSessions(sessions)
    }
    
    // MARK: - Load Sessions
    
    func loadAllSessions() -> [InterviewSession] {
        guard let data = userDefaults.data(forKey: sessionsKey) else {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            let sessions = try decoder.decode([InterviewSession].self, from: data)
            return sessions.sorted { $0.date > $1.date }
        } catch {
            print("Failed to decode sessions: \(error)")
            return []
        }
    }
    
    // MARK: - Delete Session
    
    func deleteSession(_ session: InterviewSession) {
        var sessions = loadAllSessions()
        sessions.removeAll { $0.id == session.id }
        
        // Delete audio file if exists
        if let audioURL = session.audioFileURL {
            try? FileManager.default.removeItem(at: audioURL)
        }
        
        saveSessions(sessions)
    }
    
    // MARK: - Clear All
    
    func clearAllSessions() {
        let sessions = loadAllSessions()
        
        // Delete all audio files
        for session in sessions {
            if let audioURL = session.audioFileURL {
                try? FileManager.default.removeItem(at: audioURL)
            }
        }
        
        userDefaults.removeObject(forKey: sessionsKey)
    }
    
    // MARK: - Private Methods
    
    private func saveSessions(_ sessions: [InterviewSession]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(sessions)
            userDefaults.set(data, forKey: sessionsKey)
        } catch {
            print("Failed to save sessions: \(error)")
        }
    }
    
    // MARK: - Statistics
    
    func getStatistics() -> SessionStatistics {
        let sessions = loadAllSessions()
        
        guard !sessions.isEmpty else {
            return SessionStatistics(totalSessions: 0, averageScore: 0, totalPracticeTime: 0)
        }
        
        let totalSessions = sessions.count
        let averageScore = sessions.map { $0.analysis.overallScore }.reduce(0, +) / Double(totalSessions)
        let totalPracticeTime = sessions.map { $0.duration }.reduce(0, +)
        
        return SessionStatistics(
            totalSessions: totalSessions,
            averageScore: averageScore,
            totalPracticeTime: totalPracticeTime
        )
    }
}

// MARK: - Session Statistics

struct SessionStatistics {
    let totalSessions: Int
    let averageScore: Double
    let totalPracticeTime: TimeInterval
}
