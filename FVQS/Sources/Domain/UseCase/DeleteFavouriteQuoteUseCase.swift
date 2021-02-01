import Combine
import Foundation

struct DeleteFavouriteQuoteUseCase {

    // MARK: - Properties
    // MARK: Private

    private let quotesRepository: QuotesRepository

    // MARK: - Initializers

    init(quotesRepository: QuotesRepository) {
        self.quotesRepository = quotesRepository
    }

    // MARK: - API

    func run(id: Quote.Id) -> AnyPublisher<Quote, Error> {
        return quotesRepository.unfavQuote(id: id)
    }

}
