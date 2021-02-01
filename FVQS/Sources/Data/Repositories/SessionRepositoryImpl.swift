import Combine
import Foundation

class SessionRepositoryImpl: SessionRepository {
    // MARK: - Properties
    // MARK: Private

    private let httpService: HttpService
    private let requestsFactory: ApiRequestsFactory
    private let tokenStorage: TokenStorage
    
    private lazy var isLoggedIn = CurrentValueSubject<Bool, Never>(tokenStorage.getToken() != nil)
    
    // MARK: - Initializers

    init(httpService: HttpService, requestsFactory: ApiRequestsFactory, tokenStorage: TokenStorage) {
        self.httpService = httpService
        self.requestsFactory = requestsFactory
        self.tokenStorage = tokenStorage
    }
    
    // MARK: - SessionRepository
    
    var isUserLoggedIn: AnyPublisher<Bool, Never> {
        return tokenStorage.token.map { $0 != nil }.eraseToAnyPublisher()
    }
    
    func signIn(login: String, password: String) -> AnyPublisher<Void, Error> {
        let signIn: AnyPublisher<TokenResponse, HttpServiceError> = httpService
            .send(requestsFactory.makeSignInRequest(login: login, password: password))
        
        return signIn
            .mapError { [tokenStorage] error -> Error in
                tokenStorage.storeToken(nil)
                return error as Error
            }
            .flatMap { [tokenStorage] response -> AnyPublisher<Void, Error> in
                tokenStorage.storeToken(response.userToken)
                return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func signUp(login: String, email: String, password: String) -> AnyPublisher<Void, Error> {
        let signUp: AnyPublisher<TokenResponse, HttpServiceError> = httpService
            .send(requestsFactory.makeSignUpRequest(login: login, email: email, password: password))
        
        return signUp
            .mapError { [tokenStorage] error -> Error in
                tokenStorage.storeToken(nil)
                return error as Error
            }
            .flatMap { [tokenStorage] response -> AnyPublisher<Void, Error> in
                tokenStorage.storeToken(response.userToken)
                return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
