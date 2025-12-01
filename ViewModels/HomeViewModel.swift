import Foundation

// MARK: - Home ViewModel

class HomeViewModel: ViewModelType {
    
    weak var coordinator: HomeCoordinator?
    private let persistenceService = PersistenceService.shared
    
    var questions: [InterviewQuestion] = InterviewQuestion.defaultQuestions
    var statistics: SessionStatistics?
    
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
        loadStatistics()
    }
    
    // MARK: - Actions
    
    func startInterview(with question: InterviewQuestion) {
        coordinator?.startInterview(question: question.text)
    }
    
    func showHistory() {
        coordinator?.showHistory()
    }
    
    func loadStatistics() {
        statistics = persistenceService.getStatistics()
    }
    
    func getRandomQuestion() -> InterviewQuestion {
        return questions.randomElement() ?? questions[0]
    }
}
