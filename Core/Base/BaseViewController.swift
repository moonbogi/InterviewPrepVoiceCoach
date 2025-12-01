import UIKit

// MARK: - Base View Controller

class BaseViewController: UIViewController {
    
    // MARK: - Properties
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .systemBlue
        return indicator
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Setup Methods (to be overridden)
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        setupActivityIndicator()
    }
    
    func setupConstraints() {
        // Override in subclasses
    }
    
    // MARK: - Activity Indicator
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func showLoading() {
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
    }
    
    // MARK: - Alert Methods
    
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
    
    func showError(_ error: Error, completion: (() -> Void)? = nil) {
        showAlert(title: "Error", message: error.localizedDescription, completion: completion)
    }
    
    func showConfirmation(title: String, message: String, confirmTitle: String = "Confirm", cancelTitle: String = "Cancel", onConfirm: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel))
        alert.addAction(UIAlertAction(title: confirmTitle, style: .default) { _ in
            onConfirm()
        })
        present(alert, animated: true)
    }
}
