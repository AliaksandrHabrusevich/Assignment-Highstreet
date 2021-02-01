import Combine
import Foundation

enum HttpServiceError: Error {
    case invalidRequest(error: Error?)
    case invalidResponse
    case dataLoadingError(statusCode: Int, data: Data)
    case jsonDecodingError(error: Error)
}

protocol HttpService {
    func send<Model: Decodable>(_ request: HttpRequest) -> AnyPublisher<Model, HttpServiceError>
}

class HttpServiceImpl: HttpService {
    
    // MARK: - Properties
    // MARK: Private
    
    private let session: URLSession
    
    // MARK: - Initializers
    
    init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: - HttpService
    
    func send<Model: Decodable>(_ request: HttpRequest) -> AnyPublisher<Model, HttpServiceError> {
        guard let urlRequest = request.makeURLRequest() else {
            return Fail(error: HttpServiceError.invalidRequest(error: nil)).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: urlRequest)
            .mapError { HttpServiceError.invalidRequest(error: $0) }
            .flatMap { data, response -> AnyPublisher<Data, HttpServiceError> in
                guard let response = response as? HTTPURLResponse else {
                    return Fail(error: HttpServiceError.invalidResponse).eraseToAnyPublisher()
                }
                
                guard 200..<300 ~= response.statusCode else {
                    return Fail(error: HttpServiceError.dataLoadingError(statusCode: response.statusCode, data: data)).eraseToAnyPublisher()
                }
                
                return Just(data).setFailureType(to: HttpServiceError.self).eraseToAnyPublisher()
            }
            .decode(type: Model.self, decoder: JSONDecoder())
            .mapError { HttpServiceError.jsonDecodingError(error: $0) }
            .eraseToAnyPublisher()
    }
}

private extension HttpRequest {
    func makeURLRequest() -> URLRequest? {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        
        components.queryItems = queryItems?.map { URLQueryItem(name: $0, value: $1) }
        
        guard let url = components.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        
        return request
    }
}
