import Combine
import Foundation

struct ToggleFavouriteQuoteUseCase {

    // MARK: - Properties
    // MARK: Private

    private let addFavouriteUseCase: AddFavouriteQuoteUseCase
    private let deleteFavouriteUseCase: DeleteFavouriteQuoteUseCase

    // MARK: - Initializers

    init(addFavouriteUseCase: AddFavouriteQuoteUseCase, deleteFavouriteUseCase: DeleteFavouriteQuoteUseCase) {
        self.addFavouriteUseCase = addFavouriteUseCase
        self.deleteFavouriteUseCase = deleteFavouriteUseCase
    }

    // MARK: - API

    func run(quote: Quote) -> AnyPublisher<Quote, Error> {
        if quote.userDetails?.favorite == true {
            return deleteFavouriteUseCase.run(id: quote.id)
        } else {
            return addFavouriteUseCase.run(id: quote.id)
        }
    }

}
