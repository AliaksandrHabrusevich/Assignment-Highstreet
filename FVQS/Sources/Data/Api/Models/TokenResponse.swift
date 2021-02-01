import Foundation

struct TokenResponse: Codable {
    let userToken: String
    
    enum CodingKeys: String, CodingKey {
        case userToken = "User-Token"
    }
}
