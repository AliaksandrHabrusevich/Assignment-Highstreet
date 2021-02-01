import Combine
import Foundation

struct GetQuotesUseCase {

    // MARK: - Properties
    // MARK: Private

    private let quotesRepository: QuotesRepository

    // MARK: - Initializers

    init(quotesRepository: QuotesRepository) {
        self.quotesRepository = quotesRepository
    }

    // MARK: - API

    func run(filter: QuotesFilter) -> AnyPublisher<QuotesPage, Error> {
        quotesRepository
            .quoutes(filter: filter)
            .map {
                if $0.isEmpty {
                    return QuotesPage(
                        page: $0.page,
                        lastPage: true,
                        quotes: []
                    )
                }
                return $0
            }
            .eraseToAnyPublisher()
    }

}
