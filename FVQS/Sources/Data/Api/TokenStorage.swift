import Combine
import Foundation

protocol TokenStorage: AnyObject {
    var token: AnyPublisher<String?, Never> { get }
    func getToken() -> String?
    func storeToken(_ token: String?)
}

// Token stored in memory only for demo reason
class InMemoryTokenStorage: TokenStorage {
    
    // MARK: - Properties
    // MARK: Private

    private var _token: String?
    private let tokenSubject = CurrentValueSubject<String?, Never>(nil)

    // MARK: - TokenStorage
    
    var token: AnyPublisher<String?, Never> {
        return tokenSubject.eraseToAnyPublisher()
    }
    
    func getToken() -> String? {
        return _token
    }
    
    func storeToken(_ token: String?) {
        _token = token
        tokenSubject.send(token)
    }
}
