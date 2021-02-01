import Combine
import Foundation

struct IsUserLoggedInUseCase {

    // MARK: - Properties
    // MARK: Private

    private let sessionRepository: SessionRepository

    // MARK: - Initializers

    init(sessionRepository: SessionRepository) {
        self.sessionRepository = sessionRepository
    }

    // MARK: - API

    func run() -> AnyPublisher<Bool, Never> {
        return sessionRepository.isUserLoggedIn
    }

}
