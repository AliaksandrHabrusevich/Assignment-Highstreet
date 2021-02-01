import Foundation

struct HttpRequest {
    let url: URL
    let method: HttpMethod
    let headers: [String: String]?
    let queryItems: [String: String]?
    let body: Data?

    init(url: URL, method: HttpMethod = .get, headers: [String: String]? = nil, queryItems: [String: String]? = nil, body: Data? = nil) {
        self.url = url
        self.method = method
        self.headers = headers
        self.queryItems = queryItems
        self.body = body
    }
}

struct HttpMethod: RawRepresentable, Equatable {
    static let delete = HttpMethod(rawValue: "DELETE")
    static let get = HttpMethod(rawValue: "GET")
    static let post = HttpMethod(rawValue: "POST")
    static let put = HttpMethod(rawValue: "PUT")

    let rawValue: String

    init(rawValue: String) {
        self.rawValue = rawValue
    }
}
