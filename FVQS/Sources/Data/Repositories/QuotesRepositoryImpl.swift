import Combine
import Foundation

class QuotesRepositoryImpl: QuotesRepository {
    // MARK: - Properties
    // MARK: Private

    private let httpService: HttpService
    private let requestsFactory: ApiRequestsFactory

    // MARK: - Initializers

    init(httpService: HttpService, requestsFactory: ApiRequestsFactory) {
        self.httpService = httpService
        self.requestsFactory = requestsFactory
    }
    
    // MARK: - QuotesRepository
    
    func randomQuotes() -> AnyPublisher<QuotesPage, Error> {
        return httpService
            .send(requestsFactory.makeRandomQuotesRequest())
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func quoutes(filter: QuotesFilter) -> AnyPublisher<QuotesPage, Error> {
        return httpService
            .send(requestsFactory.makeQuotesRequest(filter: filter))
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func quoteDetails(id: Quote.Id) -> AnyPublisher<Quote, Error> {
        return httpService
            .send(requestsFactory.makeQuoteDetailsRequest(id: id))
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func favQuote(id: Quote.Id) -> AnyPublisher<Quote, Error> {
        return httpService
            .send(requestsFactory.makeFavQuoteRequest(id: id))
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func unfavQuote(id: Quote.Id) -> AnyPublisher<Quote, Error> {
        return httpService
            .send(requestsFactory.makeUnfavQuoteRequest(id: id))
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
