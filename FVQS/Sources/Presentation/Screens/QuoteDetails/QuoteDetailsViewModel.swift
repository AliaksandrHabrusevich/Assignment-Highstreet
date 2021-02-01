import Combine
import Foundation

protocol QuoteDetailsViewModel {

    var quoteViewModel: AnyPublisher<QuoteViewModel, Never> { get }
    
    func viewDidLoad()
    func favouriteAction()
    func selectTag(_ tag: String)
}

final class QuoteDetailsViewModelImpl: QuoteDetailsViewModel {

    // MARK: - Properties
    // MARK: Public

    let router: QuoteDetailsRouter

    // MARK: Private

    private let quoteId: Quote.Id
    private let getQuoteDetailsUseCase: GetQuoteDetailsUseCase
    private let isUserLoggedInUseCase: IsUserLoggedInUseCase
    private let toggleFavouriteQuoteUseCase: ToggleFavouriteQuoteUseCase
    
    @Published private var quote: Quote?
    @Published private var isUserLoggedIn: Bool = false
    
    private var cancellables: [AnyCancellable] = []


    // MARK: - Initializers

    init(quoteId: Quote.Id, router: QuoteDetailsRouter, dependencies: AppDependencies) {
        self.quoteId = quoteId
        self.router = router
        self.getQuoteDetailsUseCase = dependencies.getQuoteDetailsUseCase
        self.isUserLoggedInUseCase = dependencies.isUserLoggedInUseCase
        self.toggleFavouriteQuoteUseCase = dependencies.toggleFavouriteQuoteUseCase
    }

    // MARK: - QuoteDetailsViewModel

    var quoteViewModel: AnyPublisher<QuoteViewModel, Never> {
        return $quote
            .compactMap { $0 }
            .map { QuoteViewModel(quote: $0) }
            .eraseToAnyPublisher()
    }
    
    func viewDidLoad() {
        loadData()
        bindLoginStatus()
    }
    
    func favouriteAction() {
        toggleFavourite()
    }
    func selectTag(_ tag: String) {
        router.goToTagQuotes(tag: tag)
    }
    
    // MARK: - Helpers

    private func loadData() {
        getQuoteDetailsUseCase
            .run(id: quoteId)
            .map { Optional($0) }
            .receive(on: DispatchQueue.main)
            .catch { [weak self] error -> AnyPublisher<Quote?, Never> in
                self?.router.showAlert(title: NSLocalizedString("Error", comment: ""), message: error.localizedDescription)
                return Just(nil).eraseToAnyPublisher()
            }
            .assign(to: \.quote, on: self)
            .store(in: &cancellables)
    }

    private func bindLoginStatus() {
        isUserLoggedInUseCase.run()
            .replaceError(with: false)
            .assign(to: \.isUserLoggedIn, on: self)
            .store(in: &cancellables)
    }
    
    private func toggleFavourite() {
        guard let quote = quote else { return }
        
        guard isUserLoggedIn else {
            router.goToLogin()
            return
        }
        
        toggleFavouriteQuoteUseCase
            .run(quote: quote)
            .map { Optional($0) }
            .receive(on: RunLoop.main)
            .catch { [weak self] error -> AnyPublisher<Quote?, Never> in
                self?.router.showAlert(title: NSLocalizedString("Error", comment: ""), message: error.localizedDescription)
                return Just(nil).eraseToAnyPublisher()
            }
            .assign(to: \.quote, on: self)
            .store(in: &cancellables)
    }
}
