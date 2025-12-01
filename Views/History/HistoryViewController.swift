import UIKit

// MARK: - History View Controller

class HistoryViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let viewModel: HistoryViewModel
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.identifier)
        return tableView
    }()
    
    private let emptyStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No practice sessions yet.\nStart practicing to see your history!"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let emptyStateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "clock.arrow.circlepath")
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Initialization
    
    init(viewModel: HistoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "History"
        setupTableView()
        updateEmptyState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadSessions()
        tableView.reloadData()
        updateEmptyState()
    }
    
    // MARK: - Setup
    
    override func setupUI() {
        super.setupUI()
        view.addSubview(tableView)
        
        view.addSubview(emptyStateView)
        emptyStateView.addSubview(emptyStateImageView)
        emptyStateView.addSubview(emptyStateLabel)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateImageView.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor, constant: -50),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 80),
            
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: 20),
            emptyStateLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor, constant: 40),
            emptyStateLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor, constant: -40)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func updateEmptyState() {
        emptyStateView.isHidden = !viewModel.sessions.isEmpty
        tableView.isHidden = viewModel.sessions.isEmpty
    }
}

// MARK: - UITableViewDataSource

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sessions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier, for: indexPath) as? HistoryTableViewCell else {
            return UITableViewCell()
        }
        
        let session = viewModel.sessions[indexPath.row]
        cell.configure(with: session)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let session = viewModel.sessions[indexPath.row]
        viewModel.showSessionDetail(session)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completionHandler in
            self?.deleteSession(at: indexPath)
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    private func deleteSession(at indexPath: IndexPath) {
        viewModel.deleteSession(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        updateEmptyState()
    }
}

// MARK: - History Table View Cell

class HistoryTableViewCell: UITableViewCell {
    
    static let identifier = "HistoryTableViewCell"
    
    private let cardView = CardView()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let durationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(cardView)
        cardView.addSubview(questionLabel)
        cardView.addSubview(dateLabel)
        cardView.addSubview(scoreLabel)
        cardView.addSubview(durationLabel)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            questionLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            questionLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            questionLabel.trailingAnchor.constraint(equalTo: scoreLabel.leadingAnchor, constant: -12),
            
            dateLabel.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            
            durationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4),
            durationLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            durationLabel.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -16),
            
            scoreLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with session: InterviewSession) {
        questionLabel.text = session.question
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateLabel.text = dateFormatter.string(from: session.date)
        
        let minutes = Int(session.duration) / 60
        let seconds = Int(session.duration) % 60
        durationLabel.text = "Duration: \(minutes):\(String(format: "%02d", seconds))"
        
        let score = Int(session.analysis.overallScore)
        scoreLabel.text = "\(score)"
        
        if score >= 80 {
            scoreLabel.textColor = .systemGreen
        } else if score >= 60 {
            scoreLabel.textColor = .systemOrange
        } else {
            scoreLabel.textColor = .systemRed
        }
    }
}
