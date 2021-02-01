import Combine
import Foundation

protocol SignInViewModel: AnyObject {
    
    var isFormValid: AnyPublisher<Bool, Never> { get }
    
    func loginChanged(to value: String)
    func passwordChanged(to value: String)
    func signInAction()
    func signUpAction()
}

final class SignInViewModelImpl: SignInViewModel {

    // MARK: - Properties
    // MARK: Public

    let router: SignInRouter
 
    // MARK: Private
    private let signInUseCase: SignInUseCase
    
    @Published private var login: String = ""
    @Published private var password: String = ""
    private var signInPublisher = PassthroughSubject<Void, Never>()
    
    private var cancellables: [AnyCancellable] = []

    // MARK: - Initializers

    init(router: SignInRouter, dependencies: AppDependencies) {
        self.router = router
        self.signInUseCase = dependencies.signInUseCase
        self.bindSignInAction()
    }
    
    // MARK: - SignIn

    lazy var isFormValid: AnyPublisher<Bool, Never> = {
        Publishers.CombineLatest($login, $password)
            .map { login, password in
                return !login.isEmpty && !password.isEmpty
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }()
    
    func loginChanged(to value: String) {
        login = value
    }
    
    func passwordChanged(to value: String) {
        password = value
    }
    
    func signInAction() {
        signInPublisher.send()
    }
    
    func signUpAction() {
        router.goToSignUp()
    }
    
    // MARK: - Helpers

    private func bindSignInAction() {
        signInPublisher
            .map { [unowned self] _ -> AnyPublisher<Result<Void, Error>, Never> in
                return self.signInUseCase
                    .run(login: self.login, password: self.password)
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
                    if case HttpServiceError.jsonDecodingError = error { // HOTFIX: API return status code 200 when login or password is invalid
                        self.router.showAlert(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Invalid login or password.", comment: ""))
                    } else {
                        self.router.showAlert(title: NSLocalizedString("Error", comment: ""), message: error.localizedDescription)
                    }
                }
            })
            .store(in: &cancellables)
    }
}
