import Combine
import Foundation

protocol RandomQuoteViewModel {
    var quoteViewModel: AnyPublisher<QuoteViewModel, Never> { get }
    
    func viewDidLoad()
    func close()
}

final class RandomQuoteViewModelImpl: RandomQuoteViewModel {

    // MARK: - Properties
    // MARK: Public

    let router: RandomQuoteRouter

    // MARK: Private

    private let getRandomQuoteUseCase: GetRandomQuoteUseCase
    
    @Published private var quote: Quote?
    
    private var cancellables: [AnyCancellable] = []


    // MARK: - Initializers

    init(router: RandomQuoteRouter, dependencies: AppDependencies) {
        self.router = router
        self.getRandomQuoteUseCase = dependencies.getRandomQuoteUseCase
    }

    // MARK: - RandomQuoteViewModel

    var quoteViewModel: AnyPublisher<QuoteViewModel, Never> {
        return $quote
            .compactMap { $0 }
            .map { QuoteViewModel(quote: $0) }
            .eraseToAnyPublisher()
    }
    
    func viewDidLoad() {
        loadData()
    }
    
    func close() {
        router.close()
    }
    
    // MARK: - Helpers

    private func loadData() {
        getRandomQuoteUseCase
            .run()
            .receive(on: DispatchQueue.main)
            .catch { [weak self] error -> AnyPublisher<Quote?, Never> in
                self?.router.showAlert(title: NSLocalizedString("Error", comment: ""), message: error.localizedDescription)
                return Just(nil).eraseToAnyPublisher()
            }
            .assign(to: \.quote, on: self)
            .store(in: &cancellables)
    }

}
