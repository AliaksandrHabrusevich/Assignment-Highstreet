import Foundation

protocol AppDependencies {
    var isUserLoggedInUseCase: IsUserLoggedInUseCase { get }
    var signInUseCase: SignInUseCase { get }
    var signUpUseCase: SignUpUseCase { get }
    var getRandomQuoteUseCase: GetRandomQuoteUseCase { get }
    var getQuotesUseCase: GetQuotesUseCase { get }
    var getQuoteDetailsUseCase: GetQuoteDetailsUseCase { get }
    var addFavouriteQuoteUseCase: AddFavouriteQuoteUseCase { get }
    var deleteFavouriteQuoteUseCase: DeleteFavouriteQuoteUseCase { get }
    var toggleFavouriteQuoteUseCase: ToggleFavouriteQuoteUseCase { get }
}

final class AppDependenciesImpl: AppDependencies {
    
    // MARK: - Properties
    // MARK: Private
    let quotesRepository: QuotesRepository
    let sessionRepository: SessionRepository
    
    // MARK: - Initializers

    init() {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Token token=\"\(Constants.apiKey)\""
        ]
        
        let httpService = HttpServiceImpl(
            session: URLSession(configuration: config)
        )
        
        let tokenStorage = InMemoryTokenStorage()
        
        let requestsFactory = ApiRequestsFactoryImpl(baseUrl: Constants.baseUrl, tokenStorage: tokenStorage)
        
        quotesRepository = QuotesRepositoryImpl(httpService: httpService, requestsFactory: requestsFactory)
        sessionRepository = SessionRepositoryImpl(httpService: httpService, requestsFactory: requestsFactory, tokenStorage: tokenStorage)
        
    }
    
    // MARK: - AppDependencies
    
    var isUserLoggedInUseCase: IsUserLoggedInUseCase {
        return IsUserLoggedInUseCase(sessionRepository: sessionRepository)
    }
    
    var signInUseCase: SignInUseCase {
        return SignInUseCase(sessionRepository: sessionRepository)
    }
    
    var signUpUseCase: SignUpUseCase {
        return SignUpUseCase(sessionRepository: sessionRepository)
    }
    
    var getRandomQuoteUseCase: GetRandomQuoteUseCase {
        return GetRandomQuoteUseCase(quotesRepository: quotesRepository)
    }
    
    var getQuotesUseCase: GetQuotesUseCase {
        return GetQuotesUseCase(quotesRepository: quotesRepository)
    }
    
    var getQuoteDetailsUseCase: GetQuoteDetailsUseCase {
        return GetQuoteDetailsUseCase(quotesRepository: quotesRepository)
    }
    
    var addFavouriteQuoteUseCase: AddFavouriteQuoteUseCase {
        return AddFavouriteQuoteUseCase(quotesRepository: quotesRepository)
    }
    
    var deleteFavouriteQuoteUseCase: DeleteFavouriteQuoteUseCase {
        return DeleteFavouriteQuoteUseCase(quotesRepository: quotesRepository)
    }
    
    var toggleFavouriteQuoteUseCase: ToggleFavouriteQuoteUseCase {
        return ToggleFavouriteQuoteUseCase(addFavouriteUseCase: addFavouriteQuoteUseCase, deleteFavouriteUseCase: deleteFavouriteQuoteUseCase)
    }
}
