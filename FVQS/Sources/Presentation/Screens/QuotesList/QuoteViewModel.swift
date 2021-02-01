import Combine
import Foundation

struct QuoteViewModel: Hashable {
    // MARK: - Properties
    // MARK: Public
    let favouritePublisher: AnyPublisher<Void, Never>
    
    var id: Quote.Id { return quote.id }
    var body: String { return "\"\(quote.body)\"" }
    var author: String { return quote.author ?? "" }
    var favouritesTitle: String { return String.localizedStringWithFormat(NSLocalizedString("%d favs", comment: ""), quote.favoritesCount) }
    var isFavourite: Bool { return quote.userDetails?.favorite ?? false }
    var tags: [String] { return quote.tags }
    
    // MARK: Private
    private let quote: Quote
    private let favouriteSubject = PassthroughSubject<Void, Never>()
    
    // MARK: - Initializers

    init(quote: Quote) {
        self.quote = quote
        self.favouritePublisher = favouriteSubject.eraseToAnyPublisher()
    }
    
    // MARK: - QuoteViewModel
    
    func favouriteAction() {
        favouriteSubject.send()
    }
    
    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // MARK: - Equatable
    static func == (lhs: QuoteViewModel, rhs: QuoteViewModel) -> Bool {
        lhs.quote == rhs.quote
    }
}
