import UIKit

// MARK: - Feedback View Controller

class FeedbackViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let viewModel: FeedbackViewModel
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let scoreCircleView = ProgressCircleView()
    
    private let scoreDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let metricsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private let transcriptionCard: CardView = {
        let card = CardView()
        return card
    }()
    
    private let transcriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Your Response"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let transcriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.textColor = .label
        textView.backgroundColor = .clear
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()
    
    private let doneButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setTitle("Done", for: .normal)
        return button
    }()
    
    // MARK: - Initialization
    
    init(viewModel: FeedbackViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Feedback"
        setupBindings()
        populateData()
    }
    
    // MARK: - Setup
    
    override func setupUI() {
        super.setupUI()
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(scoreCircleView)
        contentView.addSubview(scoreDescriptionLabel)
        contentView.addSubview(metricsStackView)
        contentView.addSubview(transcriptionCard)
        transcriptionCard.addSubview(transcriptionTitleLabel)
        transcriptionCard.addSubview(transcriptionTextView)
        contentView.addSubview(doneButton)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            scoreCircleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            scoreCircleView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            scoreDescriptionLabel.topAnchor.constraint(equalTo: scoreCircleView.bottomAnchor, constant: 16),
            scoreDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            scoreDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            
            metricsStackView.topAnchor.constraint(equalTo: scoreDescriptionLabel.bottomAnchor, constant: 32),
            metricsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            metricsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            transcriptionCard.topAnchor.constraint(equalTo: metricsStackView.bottomAnchor, constant: 24),
            transcriptionCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            transcriptionCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            transcriptionTitleLabel.topAnchor.constraint(equalTo: transcriptionCard.topAnchor, constant: 20),
            transcriptionTitleLabel.leadingAnchor.constraint(equalTo: transcriptionCard.leadingAnchor, constant: 20),
            transcriptionTitleLabel.trailingAnchor.constraint(equalTo: transcriptionCard.trailingAnchor, constant: -20),
            
            transcriptionTextView.topAnchor.constraint(equalTo: transcriptionTitleLabel.bottomAnchor, constant: 12),
            transcriptionTextView.leadingAnchor.constraint(equalTo: transcriptionCard.leadingAnchor, constant: 20),
            transcriptionTextView.trailingAnchor.constraint(equalTo: transcriptionCard.trailingAnchor, constant: -20),
            transcriptionTextView.bottomAnchor.constraint(equalTo: transcriptionCard.bottomAnchor, constant: -20),
            
            doneButton.topAnchor.constraint(equalTo: transcriptionCard.bottomAnchor, constant: 24),
            doneButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Private Methods
    
    private func setupBindings() {
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }
    
    private func populateData() {
        let session = viewModel.session
        
        // Score
        scoreCircleView.progress = session.analysis.overallScore
        scoreDescriptionLabel.text = viewModel.getScoreDescription()
        
        // Metrics
        addMetricCard(
            title: "Speaking Pace",
            icon: UIImage(systemName: "speedometer"),
            description: viewModel.getPacingFeedback()
        )
        
        addMetricCard(
            title: "Filler Words",
            icon: UIImage(systemName: "text.badge.xmark"),
            description: viewModel.getFillerWordsFeedback()
        )
        
        addMetricCard(
            title: "Confidence & Tone",
            icon: UIImage(systemName: "chart.line.uptrend.xyaxis"),
            description: viewModel.getSentimentFeedback()
        )
        
        // Add filler words breakdown if present
        if !session.analysis.fillerWords.fillerWordsList.isEmpty {
            addFillerWordsBreakdown(session.analysis.fillerWords.fillerWordsList)
        }
        
        // Transcription
        transcriptionTextView.text = session.transcription
    }
    
    private func addMetricCard(title: String, icon: UIImage?, description: String) {
        let card = CardView()
        
        let iconImageView = UIImageView()
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.image = icon
        iconImageView.tintColor = .systemBlue
        iconImageView.contentMode = .scaleAspectFit
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .label
        
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = description
        descriptionLabel.font = .systemFont(ofSize: 15, weight: .regular)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0
        
        card.addSubview(iconImageView)
        card.addSubview(titleLabel)
        card.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            iconImageView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            iconImageView.widthAnchor.constraint(equalToConstant: 28),
            iconImageView.heightAnchor.constraint(equalToConstant: 28),
            
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 18),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16)
        ])
        
        metricsStackView.addArrangedSubview(card)
    }
    
    private func addFillerWordsBreakdown(_ fillerWords: [InterviewAnalysis.FillerWordsAnalysis.FillerWord]) {
        let card = CardView()
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Filler Words Breakdown"
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .label
        
        card.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16)
        ])
        
        var previousView: UIView = titleLabel
        
        for fillerWord in fillerWords.prefix(5) {
            let wordLabel = UILabel()
            wordLabel.translatesAutoresizingMaskIntoConstraints = false
            wordLabel.text = "• \"\(fillerWord.word)\" - \(fillerWord.count) times"
            wordLabel.font = .systemFont(ofSize: 15, weight: .regular)
            wordLabel.textColor = .secondaryLabel
            
            card.addSubview(wordLabel)
            
            NSLayoutConstraint.activate([
                wordLabel.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: 8),
                wordLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
                wordLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16)
            ])
            
            previousView = wordLabel
        }
        
        previousView.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16).isActive = true
        
        metricsStackView.addArrangedSubview(card)
    }
    
    // MARK: - Actions
    
    @objc private func doneButtonTapped() {
        viewModel.finish()
    }
}
