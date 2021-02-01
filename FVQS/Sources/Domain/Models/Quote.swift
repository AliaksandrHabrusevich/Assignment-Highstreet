import Foundation

struct Quote: Codable, Hashable, Identifiable {
    typealias Id = Int
    let id: Id
    let body: String
    let author: String?
    let favoritesCount: Int
    let tags: [String]
    let userDetails: UserDetails?
    
    struct UserDetails: Codable, Hashable {
        let favorite: Bool
        
        enum CodingKeys: String, CodingKey {
            case favorite
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case body
        case author
        case favoritesCount = "favorites_count"
        case tags
        case userDetails = "user_details"
    }
}

extension Quote {
    var isEmpty: Bool {
        return id == 0
    }
}
