import UIKit

// MARK: - Recording View Controller

class RecordingViewController: BaseViewController {
    
    // MARK: - Properties
    
    private let viewModel: RecordingViewModel
    private var timer: Timer?
    
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
    
    private let questionCard: CardView = {
        let card = CardView()
        return card
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.font = .monospacedSystemFont(ofSize: 48, weight: .medium)
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    private let recordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 40
        button.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        return button
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tap to start recording"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let transcriptionCard: CardView = {
        let card = CardView()
        return card
    }()
    
    private let transcriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Your Response"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
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
    
    private let stopButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setTitle("Stop & Analyze", for: .normal)
        button.backgroundColor = .systemGreen
        button.isHidden = true
        return button
    }()
    
    private let cancelButton: SecondaryButton = {
        let button = SecondaryButton()
        button.setTitle("Cancel", for: .normal)
        return button
    }()
    
    // MARK: - Initialization
    
    init(viewModel: RecordingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Record Response"
        setupBindings()
        questionLabel.text = viewModel.question
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    
    // MARK: - Setup
    
    override func setupUI() {
        super.setupUI()
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(questionCard)
        questionCard.addSubview(questionLabel)
        
        contentView.addSubview(timerLabel)
        contentView.addSubview(recordButton)
        contentView.addSubview(statusLabel)
        
        contentView.addSubview(transcriptionCard)
        transcriptionCard.addSubview(transcriptionTitleLabel)
        transcriptionCard.addSubview(transcriptionTextView)
        
        contentView.addSubview(stopButton)
        contentView.addSubview(cancelButton)
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
            
            questionCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            questionCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            questionCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            questionLabel.topAnchor.constraint(equalTo: questionCard.topAnchor, constant: 20),
            questionLabel.leadingAnchor.constraint(equalTo: questionCard.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: questionCard.trailingAnchor, constant: -20),
            questionLabel.bottomAnchor.constraint(equalTo: questionCard.bottomAnchor, constant: -20),
            
            timerLabel.topAnchor.constraint(equalTo: questionCard.bottomAnchor, constant: 40),
            timerLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            recordButton.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 32),
            recordButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            recordButton.widthAnchor.constraint(equalToConstant: 80),
            recordButton.heightAnchor.constraint(equalToConstant: 80),
            
            statusLabel.topAnchor.constraint(equalTo: recordButton.bottomAnchor, constant: 16),
            statusLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            transcriptionCard.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 32),
            transcriptionCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            transcriptionCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            transcriptionTitleLabel.topAnchor.constraint(equalTo: transcriptionCard.topAnchor, constant: 20),
            transcriptionTitleLabel.leadingAnchor.constraint(equalTo: transcriptionCard.leadingAnchor, constant: 20),
            transcriptionTitleLabel.trailingAnchor.constraint(equalTo: transcriptionCard.trailingAnchor, constant: -20),
            
            transcriptionTextView.topAnchor.constraint(equalTo: transcriptionTitleLabel.bottomAnchor, constant: 12),
            transcriptionTextView.leadingAnchor.constraint(equalTo: transcriptionCard.leadingAnchor, constant: 20),
            transcriptionTextView.trailingAnchor.constraint(equalTo: transcriptionCard.trailingAnchor, constant: -20),
            transcriptionTextView.bottomAnchor.constraint(equalTo: transcriptionCard.bottomAnchor, constant: -20),
            transcriptionTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            stopButton.topAnchor.constraint(equalTo: transcriptionCard.bottomAnchor, constant: 24),
            stopButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stopButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            cancelButton.topAnchor.constraint(equalTo: stopButton.bottomAnchor, constant: 12),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Bindings
    
    private func setupBindings() {
        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        stopButton.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        viewModel.onTranscriptionUpdate = { [weak self] transcription in
            self?.updateTranscription(transcription)
        }
        
        viewModel.onError = { [weak self] error in
            self?.showError(error)
            self?.resetRecordingUI()
        }
    }
    
    // MARK: - Actions
    
    @objc private func recordButtonTapped() {
        if viewModel.isRecording {
            // Already recording, do nothing (use stop button instead)
            return
        }
        
        showLoading()
        viewModel.startRecording { [weak self] success in
            self?.hideLoading()
            
            if success {
                self?.startRecordingUI()
            } else {
                self?.showAlert(title: "Permission Required", message: "Please allow microphone and speech recognition access in Settings.")
            }
        }
    }
    
    @objc private func stopButtonTapped() {
        showLoading()
        viewModel.stopRecording { [weak self] in
            self?.hideLoading()
        }
    }
    
    @objc private func cancelButtonTapped() {
        if viewModel.isRecording {
            showConfirmation(
                title: "Cancel Recording",
                message: "Are you sure you want to cancel? Your recording will be lost.",
                confirmTitle: "Yes, Cancel"
            ) { [weak self] in
                self?.viewModel.cancelRecording()
            }
        } else {
            viewModel.cancelRecording()
        }
    }
    
    // MARK: - UI Updates
    
    private func startRecordingUI() {
        recordButton.backgroundColor = .systemGray
        recordButton.isEnabled = false
        statusLabel.text = "Recording..."
        statusLabel.textColor = .systemRed
        stopButton.isHidden = false
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }
    }
    
    private func resetRecordingUI() {
        recordButton.backgroundColor = .systemRed
        recordButton.isEnabled = true
        statusLabel.text = "Tap to start recording"
        statusLabel.textColor = .secondaryLabel
        stopButton.isHidden = true
        timer?.invalidate()
    }
    
    private func updateTimer() {
        let time = viewModel.getCurrentRecordingTime()
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func updateTranscription(_ text: String) {
        transcriptionTextView.text = text.isEmpty ? "Start speaking..." : text
    }
}
