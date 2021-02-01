import Combine
import Foundation

protocol SessionRepository {
    var isUserLoggedIn: AnyPublisher<Bool, Never> { get }
    func signIn(login: String, password: String) -> AnyPublisher<Void, Error>
    func signUp(login: String, email: String, password: String) -> AnyPublisher<Void, Error>
}
