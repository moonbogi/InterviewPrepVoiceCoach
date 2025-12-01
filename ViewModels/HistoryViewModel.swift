import Foundation

// MARK: - History ViewModel

class HistoryViewModel: ViewModelType {
    
    weak var coordinator: HistoryCoordinator?
    private let persistenceService = PersistenceService.shared
    
    var sessions: [InterviewSession] = []
    
    init(coordinator: HistoryCoordinator) {
        self.coordinator = coordinator
        loadSessions()
    }
    
    func loadSessions() {
        sessions = persistenceService.loadAllSessions()
    }
    
    func deleteSession(at index: Int) {
        let session = sessions[index]
        persistenceService.deleteSession(session)
        sessions.remove(at: index)
    }
    
    func showSessionDetail(_ session: InterviewSession) {
        coordinator?.showSessionDetail(session: session)
    }
}
