import Combine
import UIKit

extension RandomQuoteViewController {
    static func make(dependencies: AppDependencies) -> RandomQuoteViewController {
        let router = RandomQuoteRouterImpl.init(dependencies: dependencies)
        let model = RandomQuoteViewModelImpl(router: router, dependencies: dependencies)
        let contoller = RandomQuoteViewController(viewModel: model)
        router.viewController = contoller
        return contoller
    }
}

class RandomQuoteViewController: UIViewController {
    // MARK: - Properties
    // MARK: Public
    
    // MARK: Private
    private let viewModel: RandomQuoteViewModel
    private var cancellables: [AnyCancellable] = []

    @IBOutlet private var backgroundView: UIView!
    @IBOutlet private var quoteCardView: UIView!
    @IBOutlet private var bodyLabel: UILabel!
    @IBOutlet private var authorLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
        
    
    // MARK: - Initializers

    init(viewModel: RandomQuoteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Not supported!")
    }

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
        viewModel.viewDidLoad()
    }

    // MARK: - UI Configuration
    
    private func configureUI() {
        quoteCardView.layer.cornerRadius = 16
        quoteCardView.layer.masksToBounds = true
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeAction)))
        bodyLabel.font = bodyLabel.font.withSymbolicTraits(.traitItalic)
    }

    private func update(with quote: QuoteViewModel) {
        activityIndicator.stopAnimating()
        bodyLabel.text = quote.body
        authorLabel.text = quote.author
    }
    
    // MARK: - View Mode Bindings
    
    private func bindViewModel() {
        viewModel.quoteViewModel
            .sink { [weak self] quote in
                self?.update(with: quote)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    
    @objc private func closeAction() {
        viewModel.close()
    }
}

extension RandomQuoteViewController: TransitionContext {
    var contentView: UIView { return quoteCardView }
    var dimmingView: UIView { return backgroundView }
}
