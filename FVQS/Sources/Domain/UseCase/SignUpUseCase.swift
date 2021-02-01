import Combine
import Foundation

struct SignUpUseCase {

    // MARK: - Properties
    // MARK: Private

    private let sessionRepository: SessionRepository

    // MARK: - Initializers

    init(sessionRepository: SessionRepository) {
        self.sessionRepository = sessionRepository
    }

    // MARK: - API

    func run(login: String, email: String, password: String) -> AnyPublisher<Void, Error> {
        return sessionRepository
            .signUp(login: login, email: email, password: password)
            .eraseToAnyPublisher()
    }

}
