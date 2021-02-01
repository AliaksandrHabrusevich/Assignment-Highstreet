import Combine
import Foundation

struct SignInUseCase {

    // MARK: - Properties
    // MARK: Private

    private let sessionRepository: SessionRepository

    // MARK: - Initializers

    init(sessionRepository: SessionRepository) {
        self.sessionRepository = sessionRepository
    }

    // MARK: - API

    func run(login: String, password: String) -> AnyPublisher<Void, Error> {
        return sessionRepository
            .signIn(login: login, password: password)
            .eraseToAnyPublisher()
    }

}
