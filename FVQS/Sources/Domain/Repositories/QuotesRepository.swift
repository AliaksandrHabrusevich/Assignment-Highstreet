import Combine
import Foundation

protocol QuotesRepository {
    func randomQuotes() -> AnyPublisher<QuotesPage, Error>
    func quoutes(filter: QuotesFilter) -> AnyPublisher<QuotesPage, Error>
    func quoteDetails(id: Quote.Id) -> AnyPublisher<Quote, Error>
    func favQuote(id: Quote.Id) -> AnyPublisher<Quote, Error>
    func unfavQuote(id: Quote.Id) -> AnyPublisher<Quote, Error>
}

