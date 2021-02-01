import Foundation

protocol ApiRequestsFactory {    
    func makeSignInRequest(login: String, password: String) -> HttpRequest
    func makeSignUpRequest(login: String, email: String, password: String) -> HttpRequest
    func makeRandomQuotesRequest() -> HttpRequest
    func makeQuotesRequest(filter: QuotesFilter) -> HttpRequest
    func makeQuoteDetailsRequest(id: Quote.Id) -> HttpRequest
    func makeFavQuoteRequest(id: Quote.Id) -> HttpRequest
    func makeUnfavQuoteRequest(id: Quote.Id) -> HttpRequest
}

class ApiRequestsFactoryImpl: ApiRequestsFactory {

    // MARK: - Properties
    // MARK: Private
    private let baseUrl: URL
    private let tokenStorage: TokenStorage
    
    // MARK: - Initializers

    init(baseUrl: URL, tokenStorage: TokenStorage) {
        self.baseUrl = baseUrl
        self.tokenStorage = tokenStorage
    }
    
    // MARK: - ApiRequestsFactory
    
    func makeSignInRequest(login: String, password: String) -> HttpRequest {
        let params: [String: Any] = [
            "user": [
                "login": login,
                "password": password
            ]
        ]
        
        return HttpRequest(
            url: baseUrl.appendingPathComponent("session"),
            method: .post,
            body: try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        )
    }
    
    func makeSignUpRequest(login: String, email: String, password: String) -> HttpRequest {
        let params: [String: Any] = [
            "user": [
                "login": login,
                "email": email,
                "password": password
            ]
        ]
        
        return HttpRequest(
            url: baseUrl.appendingPathComponent("users"),
            method: .post,
            body: try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        )
    }
    
    func makeRandomQuotesRequest() -> HttpRequest {
        return HttpRequest(
            url: baseUrl.appendingPathComponent("quotes"),
            headers: userSessionHeaders()
        )
    }
    
    func makeQuotesRequest(filter: QuotesFilter) -> HttpRequest {
        var query: [String: String] = [
            "page": "\(filter.page)"
        ]
        
        if let search = filter.search, !search.isEmpty {
            query["filter"] = search
        }
        
        if let tag = filter.tag, !tag.isEmpty {
            query["tag"] = tag
        }
        
        return HttpRequest(
            url: baseUrl.appendingPathComponent("quotes"),
            headers: userSessionHeaders(),
            queryItems: query
        )
    }
    
    func makeQuoteDetailsRequest(id: Quote.Id) -> HttpRequest {
        return HttpRequest(
            url: baseUrl.appendingPathComponent("quotes/\(id)"),
            headers: userSessionHeaders()
        )
    }
    
    func makeFavQuoteRequest(id: Quote.Id) -> HttpRequest {
        return HttpRequest(
            url: baseUrl.appendingPathComponent("quotes/\(id)/fav"),
            method: .put,
            headers: userSessionHeaders()
        )
    }
    
    func makeUnfavQuoteRequest(id: Quote.Id) -> HttpRequest {
        return HttpRequest(
            url: baseUrl.appendingPathComponent("quotes/\(id)/unfav"),
            method: .put,
            headers: userSessionHeaders()
        )
    }
    
    // MARK: - Helpers
    
    private func userSessionHeaders() -> [String: String]? {
        guard let token = tokenStorage.getToken() else {
            return nil
        }
        return ["User-Token": token]
    }
}
