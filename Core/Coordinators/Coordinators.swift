import UIKit

// MARK: - Coordinator Protocol

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    func start()
}

extension Coordinator {
    func addChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}

// MARK: - App Coordinator

class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showHome()
    }
    
    func showHome() {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        homeCoordinator.parentCoordinator = self
        addChildCoordinator(homeCoordinator)
        homeCoordinator.start()
    }
}

// MARK: - Home Coordinator

class HomeCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: AppCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = HomeViewModel(coordinator: self)
        let homeVC = HomeViewController(viewModel: viewModel)
        navigationController.pushViewController(homeVC, animated: false)
    }
    
    func startInterview(question: String) {
        let coordinator = RecordingCoordinator(navigationController: navigationController, question: question)
        coordinator.parentCoordinator = self
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    func showHistory() {
        let coordinator = HistoryCoordinator(navigationController: navigationController)
        coordinator.parentCoordinator = self
        addChildCoordinator(coordinator)
        coordinator.start()
    }
}

// MARK: - Recording Coordinator

class RecordingCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: HomeCoordinator?
    let question: String
    
    init(navigationController: UINavigationController, question: String) {
        self.navigationController = navigationController
        self.question = question
    }
    
    func start() {
        let viewModel = RecordingViewModel(coordinator: self, question: question)
        let recordingVC = RecordingViewController(viewModel: viewModel)
        navigationController.pushViewController(recordingVC, animated: true)
    }
    
    func showFeedback(session: InterviewSession) {
        let coordinator = FeedbackCoordinator(navigationController: navigationController, session: session)
        coordinator.parentCoordinator = self
        addChildCoordinator(coordinator)
        coordinator.start()
    }
    
    func finish() {
        parentCoordinator?.removeChildCoordinator(self)
        navigationController.popViewController(animated: true)
    }
}

// MARK: - Feedback Coordinator

class FeedbackCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: RecordingCoordinator?
    let session: InterviewSession
    
    init(navigationController: UINavigationController, session: InterviewSession) {
        self.navigationController = navigationController
        self.session = session
    }
    
    func start() {
        let viewModel = FeedbackViewModel(coordinator: self, session: session)
        let feedbackVC = FeedbackViewController(viewModel: viewModel)
        navigationController.pushViewController(feedbackVC, animated: true)
    }
    
    func finish() {
        parentCoordinator?.removeChildCoordinator(self)
        navigationController.popToRootViewController(animated: true)
    }
}

// MARK: - History Coordinator

class HistoryCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    weak var parentCoordinator: HomeCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = HistoryViewModel(coordinator: self)
        let historyVC = HistoryViewController(viewModel: viewModel)
        navigationController.pushViewController(historyVC, animated: true)
    }
    
    func showSessionDetail(session: InterviewSession) {
        let viewModel = FeedbackViewModel(coordinator: self, session: session)
        let feedbackVC = FeedbackViewController(viewModel: viewModel)
        navigationController.pushViewController(feedbackVC, animated: true)
    }
    
    func finish() {
        parentCoordinator?.removeChildCoordinator(self)
        navigationController.popViewController(animated: true)
    }
}
