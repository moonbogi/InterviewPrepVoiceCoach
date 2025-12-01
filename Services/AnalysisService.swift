import Foundation
import NaturalLanguage

// MARK: - Analysis Service

class AnalysisService {
    
    static let shared = AnalysisService()
    
    private init() {}
    
    // MARK: - Filler Words Detection
    
    private let commonFillerWords = [
        "um", "uh", "like", "you know", "so", "actually", "basically",
        "literally", "right", "okay", "well", "kind of", "sort of",
        "i mean", "you see", "honestly", "seriously"
    ]
    
    func analyzeFillerWords(transcription: String, duration: TimeInterval) -> InterviewAnalysis.FillerWordsAnalysis {
        let lowercasedText = transcription.lowercased()
        var fillerWordCounts: [String: Int] = [:]
        
        for fillerWord in commonFillerWords {
            let count = lowercasedText.components(separatedBy: fillerWord).count - 1
            if count > 0 {
                fillerWordCounts[fillerWord] = count
            }
        }
        
        let totalCount = fillerWordCounts.values.reduce(0, +)
        let frequency = duration > 0 ? Double(totalCount) / (duration / 60.0) : 0
        
        let fillerWordsList = fillerWordCounts.map { word, count in
            InterviewAnalysis.FillerWordsAnalysis.FillerWord(word: word, count: count)
        }.sorted { $0.count > $1.count }
        
        return InterviewAnalysis.FillerWordsAnalysis(
            totalCount: totalCount,
            fillerWordsList: fillerWordsList,
            frequency: frequency
        )
    }
    
    // MARK: - Pacing Analysis
    
    func analyzePacing(transcription: String, duration: TimeInterval) -> InterviewAnalysis.PacingAnalysis {
        let words = transcription.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        let wordCount = words.count
        
        let wordsPerMinute = duration > 0 ? Double(wordCount) / (duration / 60.0) : 0
        
        // Detect pauses (sequences of punctuation or repeated spaces in transcription)
        let pauseCount = transcription.components(separatedBy: ".").count - 1 +
                        transcription.components(separatedBy: ",").count - 1
        
        let averagePauseDuration = pauseCount > 0 ? duration / Double(pauseCount) : 0
        
        // Optimal speaking rate is 120-150 words per minute
        let rating: InterviewAnalysis.PacingAnalysis.PacingRating
        if wordsPerMinute < 100 {
            rating = .tooSlow
        } else if wordsPerMinute > 160 {
            rating = .tooFast
        } else {
            rating = .optimal
        }
        
        return InterviewAnalysis.PacingAnalysis(
            wordsPerMinute: wordsPerMinute,
            pauseCount: pauseCount,
            averagePauseDuration: averagePauseDuration,
            rating: rating
        )
    }
    
    // MARK: - Sentiment Analysis
    
    func analyzeSentiment(transcription: String) -> InterviewAnalysis.SentimentAnalysis {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = transcription
        
        var sentimentScores: [Double] = []
        
        tagger.enumerateTags(in: transcription.startIndex..<transcription.endIndex, unit: .paragraph, scheme: .sentimentScore) { tag, _ in
            if let tag = tag, let score = Double(tag.rawValue) {
                sentimentScores.append(score)
            }
            return true
        }
        
        let averageSentiment = sentimentScores.isEmpty ? 0 : sentimentScores.reduce(0, +) / Double(sentimentScores.count)
        
        // Calculate confidence based on word choice and sentiment
        let confidenceScore = calculateConfidence(transcription: transcription, sentiment: averageSentiment)
        
        // Positivity is normalized sentiment score (0-1)
        let positivity = (averageSentiment + 1) / 2
        
        // Clarity based on sentence structure and word complexity
        let clarity = calculateClarity(transcription: transcription)
        
        // Determine overall sentiment
        let overallSentiment: InterviewAnalysis.SentimentAnalysis.Sentiment
        if averageSentiment < -0.5 {
            overallSentiment = .veryNegative
        } else if averageSentiment < -0.1 {
            overallSentiment = .negative
        } else if averageSentiment < 0.1 {
            overallSentiment = .neutral
        } else if averageSentiment < 0.5 {
            overallSentiment = .positive
        } else {
            overallSentiment = .veryPositive
        }
        
        return InterviewAnalysis.SentimentAnalysis(
            confidenceScore: confidenceScore,
            positivity: positivity,
            clarity: clarity,
            overallSentiment: overallSentiment
        )
    }
    
    // MARK: - Helper Methods
    
    private func calculateConfidence(transcription: String, sentiment: Double) -> Double {
        let lowercasedText = transcription.lowercased()
        
        // Negative indicators
        let uncertainWords = ["maybe", "perhaps", "possibly", "might", "could be", "not sure", "i think"]
        var uncertainCount = 0
        for word in uncertainWords {
            uncertainCount += lowercasedText.components(separatedBy: word).count - 1
        }
        
        // Positive indicators
        let confidentWords = ["definitely", "certainly", "absolutely", "confident", "sure", "clearly"]
        var confidentCount = 0
        for word in confidentWords {
            confidentCount += lowercasedText.components(separatedBy: word).count - 1
        }
        
        let wordCount = transcription.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }.count
        let baseConfidence = max(0.4, min(0.8, (sentiment + 1) / 2))
        
        // Adjust based on word usage
        let confidenceAdjustment = Double(confidentCount - uncertainCount) * 0.05
        let finalConfidence = max(0, min(1, baseConfidence + confidenceAdjustment))
        
        return finalConfidence
    }
    
    private func calculateClarity(transcription: String) -> Double {
        let sentences = transcription.components(separatedBy: CharacterSet(charactersIn: ".!?")).filter { !$0.isEmpty }
        let words = transcription.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        
        guard !sentences.isEmpty else { return 0.5 }
        
        let averageWordsPerSentence = Double(words.count) / Double(sentences.count)
        
        // Optimal sentence length is 15-20 words
        let sentenceLengthScore: Double
        if averageWordsPerSentence < 10 {
            sentenceLengthScore = 0.6
        } else if averageWordsPerSentence > 25 {
            sentenceLengthScore = 0.5
        } else {
            sentenceLengthScore = 0.9
        }
        
        return sentenceLengthScore
    }
    
    // MARK: - Complete Analysis
    
    func performCompleteAnalysis(transcription: String, duration: TimeInterval) -> InterviewAnalysis {
        let fillerWords = analyzeFillerWords(transcription: transcription, duration: duration)
        let pacing = analyzePacing(transcription: transcription, duration: duration)
        let sentiment = analyzeSentiment(transcription: transcription)
        
        // Calculate overall score (0-100)
        var score: Double = 70 // Base score
        
        // Filler words penalty (up to -20 points)
        let fillerPenalty = min(20, fillerWords.frequency * 4)
        score -= fillerPenalty
        
        // Pacing bonus/penalty (up to ±10 points)
        if pacing.rating == .optimal {
            score += 10
        } else {
            score -= 5
        }
        
        // Sentiment bonus (up to +20 points)
        score += sentiment.confidenceScore * 10
        score += sentiment.clarity * 10
        
        let overallScore = max(0, min(100, score))
        
        return InterviewAnalysis(
            fillerWords: fillerWords,
            pacing: pacing,
            sentiment: sentiment,
            overallScore: overallScore
        )
    }
}
