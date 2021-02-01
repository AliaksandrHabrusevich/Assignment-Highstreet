import Foundation

struct QuotesPage: Codable, Hashable {
    let page: Int
    let lastPage: Bool
    let quotes: [Quote]
    
    enum CodingKeys: String, CodingKey {
        case page
        case lastPage = "last_page"
        case quotes
    }
}

extension QuotesPage {
    var isEmpty: Bool {
        return quotes.first?.isEmpty ?? true
    }
}
