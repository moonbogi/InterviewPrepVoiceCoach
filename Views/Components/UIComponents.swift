import UIKit

// MARK: - Reusable UI Components

// MARK: - Primary Button

class PrimaryButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBlue
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        layer.cornerRadius = 12
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    @objc private func buttonPressed() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.alpha = 0.8
        }
    }
    
    @objc private func buttonReleased() {
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
            self.alpha = 1.0
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }
}

// MARK: - Secondary Button

class SecondaryButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemGray6
        setTitleColor(.label, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor
        heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}

// MARK: - Card View

class CardView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 16
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 8
    }
}

// MARK: - Progress Circle View

class ProgressCircleView: UIView {
    
    private let progressLayer = CAShapeLayer()
    private let trackLayer = CAShapeLayer()
    private let scoreLabel = UILabel()
    
    var progress: Double = 0 {
        didSet {
            updateProgress()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayers() {
        translatesAutoresizingMaskIntoConstraints = false
        
        // Track layer
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: 60, y: 60), radius: 50, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi - CGFloat.pi / 2, clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = UIColor.systemGray5.cgColor
        trackLayer.lineWidth = 10
        trackLayer.lineCap = .round
        layer.addSublayer(trackLayer)
        
        // Progress layer
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.systemGreen.cgColor
        progressLayer.lineWidth = 10
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0
        layer.addSublayer(progressLayer)
        
        // Score label
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.font = .systemFont(ofSize: 28, weight: .bold)
        scoreLabel.textAlignment = .center
        scoreLabel.textColor = .label
        addSubview(scoreLabel)
        
        NSLayoutConstraint.activate([
            scoreLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            scoreLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            widthAnchor.constraint(equalToConstant: 120),
            heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func updateProgress() {
        progressLayer.strokeEnd = CGFloat(progress / 100)
        scoreLabel.text = "\(Int(progress))"
        
        // Update color based on score
        if progress >= 80 {
            progressLayer.strokeColor = UIColor.systemGreen.cgColor
        } else if progress >= 60 {
            progressLayer.strokeColor = UIColor.systemOrange.cgColor
        } else {
            progressLayer.strokeColor = UIColor.systemRed.cgColor
        }
    }
}

// MARK: - Stat Card View

class StatCardView: CardView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        return imageView
    }()
    
    init(title: String, value: String, icon: UIImage?) {
        super.init(frame: .zero)
        titleLabel.text = title
        valueLabel.text = value
        iconImageView.image = icon
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    func updateValue(_ value: String) {
        valueLabel.text = value
    }
}
