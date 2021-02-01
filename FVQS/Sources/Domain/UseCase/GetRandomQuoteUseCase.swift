import Combine
import Foundation

struct GetRandomQuoteUseCase {

    // MARK: - Properties
    // MARK: Private

    private let quotesRepository: QuotesRepository

    // MARK: - Initializers

    init(quotesRepository: QuotesRepository) {
        self.quotesRepository = quotesRepository
    }

    // MARK: - API

    func run() -> AnyPublisher<Quote?, Error> {
        quotesRepository
            .randomQuotes()
            .map {
                let item = $0.quotes.filter { !$0.isEmpty }.randomElement()
                return item
            }
            .eraseToAnyPublisher()
    }

}
