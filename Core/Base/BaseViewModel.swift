import Foundation

// MARK: - Base ViewModel Protocol

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

// MARK: - ViewModelType (for simpler ViewModels without Input/Output)

protocol ViewModelType: AnyObject {
}
