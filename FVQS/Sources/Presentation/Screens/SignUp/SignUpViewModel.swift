import Combine
import Foundation

protocol SignUpViewModel: AnyObject {
    
    var isFormValid: AnyPublisher<Bool, Never> { get }
    
    func loginChanged(to value: String)
    func emailChanged(to value: String)
    func passwordChanged(to value: String)
    func signUpAction()
}

final class SignUpViewModelImpl: SignUpViewModel {

    // MARK: - Properties
    // MARK: Public

    let router: SignUpRouter
 
    // MARK: Private
    private let signUpUseCase: SignUpUseCase
    
    @Published private var login: String = ""
    @Published private var email: String = ""
    @Published private var password: String = ""
    private var signUpPublisher = PassthroughSubject<Void, Never>()
    
    private var cancellables: [AnyCancellable] = []

    // MARK: - Initializers

    init(router: SignUpRouter, dependencies: AppDependencies) {
        self.router = router
        self.signUpUseCase = dependencies.signUpUseCase
        self.bindSignUpAction()
    }
    
    // MARK: - SignUpViewModel

    lazy var isFormValid: AnyPublisher<Bool, Never> = {
        Publishers.CombineLatest3($login, $email, $password)
            .map { login, email, password in
                return !login.isEmpty && !email.isEmpty && !password.isEmpty
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }()
    
    func loginChanged(to value: String) {
        login = value
    }
    
    func emailChanged(to value: String) {
        email = value
    }
    
    func passwordChanged(to value: String) {
        password = value
    }
    
    func signUpAction() {
        signUpPublisher.send()
    }
    
    // MARK: - Helpers

    private func bindSignUpAction() {
        signUpPublisher
            .map { [unowned self] _ -> AnyPublisher<Result<Void, Error>, Never> in
                return self.signUpUseCase
                    .run(login: self.login, email: self.email, password: self.password)
                    .map { _ -> Result<Void, Error> in
                        return Result<Void, Error>.success(())
                    }
                    .catch { error -> AnyPublisher<Result<Void, Error>, Never> in
                        return Just(Result<Void, Error>.failure(error)).eraseToAnyPublisher()
                    }
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    self.router.close()
                case .failure(let error):
                    if case HttpServiceError.jsonDecodingError = error { // HOTFIX: API return status code 200 when login, email or password is invalid
                        self.router.showAlert(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Invalid login, email, or password.", comment: ""))
                    } else {
                        self.router.showAlert(title: NSLocalizedString("Error", comment: ""), message: error.localizedDescription)
                    }
                }
            })
            .store(in: &cancellables)
    }

}
