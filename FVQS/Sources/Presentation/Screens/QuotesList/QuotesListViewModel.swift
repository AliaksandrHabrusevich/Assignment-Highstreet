import Combine
import Foundation

protocol QuotesListViewModel: AnyObject {
    
    var tag: String? { get }
    var accountButtonTitle: AnyPublisher<String, Never> { get }
    var quoteViewModels: AnyPublisher<[QuoteViewModel], Never> { get }
    
    func viewDidLoad()
    func search(text: String)
    func selectQuote(id: Quote.Id)
    func loadNextPage()
    func accountAction()
}

final class QuotesListViewModelImpl: QuotesListViewModel {

    // MARK: - Properties
    // MARK: Public

    let tag: String?
    let router: QuotesListRouter
    
    // MARK: Private
    private var page: Int = 1
    private var hasMoreItems: Bool = true
    
    private let getQuotesUseCase: GetQuotesUseCase
    private let isUserLoggedInUseCase: IsUserLoggedInUseCase
    private let toggleFavouriteQuoteUseCase: ToggleFavouriteQuoteUseCase
    
    @Published private var search: String = ""
    @Published private var quotes: [Quote] = []
    @Published private var isUserLoggedIn: Bool = false
    private var loadPage = PassthroughSubject<Void, Never>()
    
    private var cancellables: [AnyCancellable] = []

    // MARK: - Initializers

    init(tag: String? = nil, router: QuotesListRouter, dependencies: AppDependencies) {
        self.tag = tag
        self.router = router
        self.getQuotesUseCase = dependencies.getQuotesUseCase
        self.isUserLoggedInUseCase = dependencies.isUserLoggedInUseCase
        self.toggleFavouriteQuoteUseCase = dependencies.toggleFavouriteQuoteUseCase
    }
    
    // MARK: - QuotesListViewModel

    var quoteViewModels: AnyPublisher<[QuoteViewModel], Never> {
        return $quotes
            .map { [unowned self] quotes in
                quotes.map { quote in
                    let viewModel = QuoteViewModel(quote: quote)
                    viewModel.favouritePublisher
                        .sink { [weak self] _ in
                            self?.runFavouriteUseCase(quote: quote)
                        }
                        .store(in: &self.cancellables)
                    
                    return viewModel
                }
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    var accountButtonTitle: AnyPublisher<String, Never> {
        return $isUserLoggedIn
            .map { $0 ? NSLocalizedString("Account", comment: "") : NSLocalizedString("Sign In", comment: "") }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    func viewDidLoad() {
        bindQuotesLoading()
        bindLoginStatus()
        loadPage.send()
    }
    
    func search(text: String) {
        search = text
    }
    
    func selectQuote(id: Quote.Id) {
        router.goToQuoteDetails(id: id)
    }
    
    func loadNextPage() {
        loadPage.send()
    }
    
    func accountAction() {
        if isUserLoggedIn {
            // navigate to account
        } else {
            router.goToLogin()
        }
    }

    // MARK: - Helpers

    private func bindQuotesLoading() {
        let searchFiter = $search
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .map { [unowned self] search in return QuotesFilter(page: 1, search: search, tag: self.tag) }
        
        let loadPageFilter = loadPage
            .map { [unowned self] _ in return QuotesFilter(page: self.page, search: self.search, tag: self.tag) }
        
        let isLoggedInFilter = $isUserLoggedIn
            .removeDuplicates()
            .map { [unowned self] isLoggedIn in return QuotesFilter(page: 1, search: self.search, tag: self.tag) }
            
        Publishers.Merge3(searchFiter, loadPageFilter, isLoggedInFilter)
            .map { [unowned self] filter -> AnyPublisher<Result<QuotesPage, Error>, Never> in
                return self.getQuotesUseCase
                    .run(filter: filter)
                    .map { page -> Result<QuotesPage, Error> in
                        return Result<QuotesPage, Error>.success(page)
                    }
                    .catch { error -> AnyPublisher<Result<QuotesPage, Error>, Never> in
                        return Just(Result<QuotesPage, Error>.failure(error)).eraseToAnyPublisher()
                    }
                    .eraseToAnyPublisher()
                    
            }
            .switchToLatest()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let model):
                    self.hasMoreItems = !model.lastPage
                    self.page = model.page + 1
                    if model.page == 1 {
                        self.quotes = model.quotes
                    } else {
                        self.quotes.append(contentsOf: model.quotes)
                    }
                case .failure(let error):
                    self.router.showAlert(title: NSLocalizedString("Error", comment: ""), message: error.localizedDescription)
                }                
            })
            .store(in: &cancellables)
    }
    
    private func bindLoginStatus() {
        isUserLoggedInUseCase.run()
            .replaceError(with: false)
            .assign(to: \.isUserLoggedIn, on: self)
            .store(in: &cancellables)
    }
    
    private func runFavouriteUseCase(quote: Quote) {
        guard isUserLoggedIn else {
            router.goToLogin()
            return
        }
        
        toggleFavouriteQuoteUseCase
            .run(quote: quote)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.router.showAlert(title: NSLocalizedString("Error", comment: ""), message: error.localizedDescription)
                }
                
            } receiveValue: { [weak self] quote in
                self?.updateQuote(quote)
            }
            .store(in: &cancellables)
    }
    
    private func updateQuote(_ new: Quote) {
        guard let index = quotes.firstIndex(where: { $0.id == new.id }) else { return }
        quotes[index] = new
    }
}
