import Foundation

// MARK: - Interview Session Model

struct InterviewSession: Codable {
    let id: UUID
    let question: String
    let transcription: String
    let audioFileURL: URL?
    let duration: TimeInterval
    let date: Date
    let analysis: InterviewAnalysis
    
    init(id: UUID = UUID(), question: String, transcription: String, audioFileURL: URL?, duration: TimeInterval, date: Date = Date(), analysis: InterviewAnalysis) {
        self.id = id
        self.question = question
        self.transcription = transcription
        self.audioFileURL = audioFileURL
        self.duration = duration
        self.date = date
        self.analysis = analysis
    }
}

// MARK: - Interview Analysis Model

struct InterviewAnalysis: Codable {
    let fillerWords: FillerWordsAnalysis
    let pacing: PacingAnalysis
    let sentiment: SentimentAnalysis
    let overallScore: Double // 0-100
    
    struct FillerWordsAnalysis: Codable {
        let totalCount: Int
        let fillerWordsList: [FillerWord]
        let frequency: Double // filler words per minute
        
        struct FillerWord: Codable {
            let word: String
            let count: Int
        }
    }
    
    struct PacingAnalysis: Codable {
        let wordsPerMinute: Double
        let pauseCount: Int
        let averagePauseDuration: TimeInterval
        let rating: PacingRating
        
        enum PacingRating: String, Codable {
            case tooSlow = "Too Slow"
            case optimal = "Optimal"
            case tooFast = "Too Fast"
        }
    }
    
    struct SentimentAnalysis: Codable {
        let confidenceScore: Double // 0-1
        let positivity: Double // 0-1
        let clarity: Double // 0-1
        let overallSentiment: Sentiment
        
        enum Sentiment: String, Codable {
            case veryNegative = "Very Negative"
            case negative = "Negative"
            case neutral = "Neutral"
            case positive = "Positive"
            case veryPositive = "Very Positive"
        }
    }
}

// MARK: - Interview Question Model

struct InterviewQuestion: Codable {
    let id: UUID
    let text: String
    let category: QuestionCategory
    let difficulty: Difficulty
    
    enum QuestionCategory: String, Codable, CaseIterable {
        case behavioral = "Behavioral"
        case technical = "Technical"
        case situational = "Situational"
        case general = "General"
    }
    
    enum Difficulty: String, Codable, CaseIterable {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
    }
    
    init(id: UUID = UUID(), text: String, category: QuestionCategory, difficulty: Difficulty) {
        self.id = id
        self.text = text
        self.category = category
        self.difficulty = difficulty
    }
}

// MARK: - Default Questions

extension InterviewQuestion {
    static let defaultQuestions: [InterviewQuestion] = [
        InterviewQuestion(text: "Tell me about yourself.", category: .general, difficulty: .easy),
        InterviewQuestion(text: "What are your greatest strengths?", category: .behavioral, difficulty: .easy),
        InterviewQuestion(text: "Describe a time when you faced a challenge at work and how you overcame it.", category: .behavioral, difficulty: .medium),
        InterviewQuestion(text: "Why do you want to work here?", category: .general, difficulty: .easy),
        InterviewQuestion(text: "Tell me about a time you had a conflict with a team member.", category: .behavioral, difficulty: .medium),
        InterviewQuestion(text: "Where do you see yourself in 5 years?", category: .general, difficulty: .easy),
        InterviewQuestion(text: "Describe a situation where you had to meet a tight deadline.", category: .situational, difficulty: .medium),
        InterviewQuestion(text: "How do you handle stress and pressure?", category: .behavioral, difficulty: .medium),
        InterviewQuestion(text: "What is your biggest weakness?", category: .behavioral, difficulty: .medium),
        InterviewQuestion(text: "Describe a time when you showed leadership skills.", category: .behavioral, difficulty: .hard)
    ]
}
