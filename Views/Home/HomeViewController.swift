import UIKit

// MARK: - Home View Controller

class HomeViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let viewModel: HomeViewModel
    
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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Interview Prep"
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Practice makes perfect"
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let statsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }()
    
    private let quickStartButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setTitle("Quick Start", for: .normal)
        return button
    }()
    
    private let selectQuestionButton: SecondaryButton = {
        let button = SecondaryButton()
        button.setTitle("Select Question", for: .normal)
        return button
    }()
    
    private let historyButton: SecondaryButton = {
        let button = SecondaryButton()
        button.setTitle("View History", for: .normal)
        return button
    }()
    
    private let questionCategoriesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Practice Categories"
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let categoriesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    // MARK: - Initialization
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadStatistics()
        updateStatistics()
    }
    
    // MARK: - Setup
    
    override func setupUI() {
        super.setupUI()
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(statsStackView)
        contentView.addSubview(quickStartButton)
        contentView.addSubview(selectQuestionButton)
        contentView.addSubview(historyButton)
        contentView.addSubview(questionCategoriesLabel)
        contentView.addSubview(categoriesStackView)
        
        setupStatsCards()
        setupCategoryCards()
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
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            statsStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            statsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            statsStackView.heightAnchor.constraint(equalToConstant: 100),
            
            quickStartButton.topAnchor.constraint(equalTo: statsStackView.bottomAnchor, constant: 24),
            quickStartButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            quickStartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            selectQuestionButton.topAnchor.constraint(equalTo: quickStartButton.bottomAnchor, constant: 12),
            selectQuestionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            selectQuestionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            historyButton.topAnchor.constraint(equalTo: selectQuestionButton.bottomAnchor, constant: 12),
            historyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            historyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            questionCategoriesLabel.topAnchor.constraint(equalTo: historyButton.bottomAnchor, constant: 32),
            questionCategoriesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            questionCategoriesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            categoriesStackView.topAnchor.constraint(equalTo: questionCategoriesLabel.bottomAnchor, constant: 16),
            categoriesStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            categoriesStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            categoriesStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Private Methods
    
    private func setupStatsCards() {
        let sessionsCard = StatCardView(title: "Total Sessions", value: "0", icon: UIImage(systemName: "mic.fill"))
        let scoreCard = StatCardView(title: "Avg Score", value: "0", icon: UIImage(systemName: "star.fill"))
        
        statsStackView.addArrangedSubview(sessionsCard)
        statsStackView.addArrangedSubview(scoreCard)
    }
    
    private func setupCategoryCards() {
        let categories = InterviewQuestion.QuestionCategory.allCases
        
        for category in categories {
            let card = createCategoryCard(for: category)
            categoriesStackView.addArrangedSubview(card)
        }
    }
    
    private func createCategoryCard(for category: InterviewQuestion.QuestionCategory) -> UIView {
        let cardView = CardView()
        cardView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = category.rawValue
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        
        let countLabel = UILabel()
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        let count = viewModel.questions.filter { $0.category == category }.count
        countLabel.text = "\(count) questions"
        countLabel.font = .systemFont(ofSize: 14, weight: .regular)
        countLabel.textColor = .secondaryLabel
        
        cardView.addSubview(label)
        cardView.addSubview(countLabel)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: cardView.centerYAnchor, constant: -10),
            label.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20),
            
            countLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 4),
            countLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 20)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(categoryCardTapped(_:)))
        cardView.addGestureRecognizer(tapGesture)
        cardView.tag = categories.firstIndex(of: category) ?? 0
        
        return cardView
    }
    
    private func setupBindings() {
        quickStartButton.addTarget(self, action: #selector(quickStartTapped), for: .touchUpInside)
        selectQuestionButton.addTarget(self, action: #selector(selectQuestionTapped), for: .touchUpInside)
        historyButton.addTarget(self, action: #selector(historyTapped), for: .touchUpInside)
    }
    
    private func updateStatistics() {
        guard let stats = viewModel.statistics else { return }
        
        if let sessionsCard = statsStackView.arrangedSubviews[0] as? StatCardView {
            sessionsCard.updateValue("\(stats.totalSessions)")
        }
        
        if let scoreCard = statsStackView.arrangedSubviews[1] as? StatCardView {
            scoreCard.updateValue(String(format: "%.0f", stats.averageScore))
        }
    }
    
    // MARK: - Actions
    
    @objc private func quickStartTapped() {
        let question = viewModel.getRandomQuestion()
        viewModel.startInterview(with: question)
    }
    
    @objc private func selectQuestionTapped() {
        showQuestionPicker()
    }
    
    @objc private func historyTapped() {
        viewModel.showHistory()
    }
    
    @objc private func categoryCardTapped(_ gesture: UITapGestureRecognizer) {
        guard let tag = gesture.view?.tag else { return }
        let category = InterviewQuestion.QuestionCategory.allCases[tag]
        showQuestionsForCategory(category)
    }
    
    private func showQuestionPicker() {
        let alert = UIAlertController(title: "Select a Question", message: nil, preferredStyle: .actionSheet)
        
        for question in viewModel.questions.prefix(10) {
            alert.addAction(UIAlertAction(title: question.text, style: .default) { [weak self] _ in
                self?.viewModel.startInterview(with: question)
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func showQuestionsForCategory(_ category: InterviewQuestion.QuestionCategory) {
        let questions = viewModel.questions.filter { $0.category == category }
        
        let alert = UIAlertController(title: category.rawValue, message: "Select a question to practice", preferredStyle: .actionSheet)
        
        for question in questions {
            alert.addAction(UIAlertAction(title: question.text, style: .default) { [weak self] _ in
                self?.viewModel.startInterview(with: question)
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}
