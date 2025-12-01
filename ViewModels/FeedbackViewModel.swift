import Foundation

// MARK: - Feedback ViewModel

class FeedbackViewModel: ViewModelType {
    
    weak var coordinator: FeedbackCoordinator?
    let session: InterviewSession
    
    init(coordinator: FeedbackCoordinator, session: InterviewSession) {
        self.coordinator = coordinator
        self.session = session
    }
    
    init(coordinator: HistoryCoordinator, session: InterviewSession) {
        self.coordinator = FeedbackCoordinator(navigationController: coordinator.navigationController, session: session)
        self.session = session
    }
    
    func finish() {
        coordinator?.finish()
    }
    
    func getScoreColor() -> String {
        let score = session.analysis.overallScore
        if score >= 80 {
            return "systemGreen"
        } else if score >= 60 {
            return "systemOrange"
        } else {
            return "systemRed"
        }
    }
    
    func getScoreDescription() -> String {
        let score = session.analysis.overallScore
        if score >= 80 {
            return "Excellent! Your response was well-structured and confident."
        } else if score >= 60 {
            return "Good effort! There's room for improvement in delivery."
        } else {
            return "Keep practicing! Focus on reducing filler words and improving pacing."
        }
    }
    
    func getPacingFeedback() -> String {
        let pacing = session.analysis.pacing
        let wpm = Int(pacing.wordsPerMinute)
        
        switch pacing.rating {
        case .tooSlow:
            return "Your speaking pace is a bit slow at \(wpm) words per minute. Try to increase your speed slightly to maintain engagement."
        case .optimal:
            return "Perfect pacing at \(wpm) words per minute! This is an ideal speaking rate for interviews."
        case .tooFast:
            return "You're speaking a bit fast at \(wpm) words per minute. Slow down to ensure clarity."
        }
    }
    
    func getFillerWordsFeedback() -> String {
        let fillerWords = session.analysis.fillerWords
        
        if fillerWords.totalCount == 0 {
            return "Excellent! No filler words detected."
        } else {
            let frequency = String(format: "%.1f", fillerWords.frequency)
            return "You used \(fillerWords.totalCount) filler words (\(frequency) per minute). Try to be more conscious of these words."
        }
    }
    
    func getSentimentFeedback() -> String {
        let sentiment = session.analysis.sentiment
        let confidencePercent = Int(sentiment.confidenceScore * 100)
        
        return "Your confidence level is at \(confidencePercent)%. \(sentiment.overallSentiment.rawValue) tone detected."
    }
}
