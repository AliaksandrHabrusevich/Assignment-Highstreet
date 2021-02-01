import Combine
import UIKit

extension QuotesListViewController {
    static func make(tag: String? = nil, dependencies: AppDependencies) -> QuotesListViewController {
        let router = QuotesListRouterImpl.init(dependencies: dependencies)
        let model = QuotesListViewModelImpl(tag: tag, router: router, dependencies: dependencies)
        let contoller = QuotesListViewController(viewModel: model)
        router.viewController = contoller
        return contoller
    }
}

class QuotesListViewController: UIViewController {

    // MARK: - Properties
    // MARK: Public
    
    // MARK: Private
    private let viewModel: QuotesListViewModel
    private var cancellables: [AnyCancellable] = []

    @IBOutlet private var tableView: UITableView!    
    private lazy var dataSource = makeDataSource()

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .black
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    private lazy var accountButton = UIBarButtonItem(title: NSLocalizedString("Account", comment: ""), style: .plain, target: nil, action: nil)
    
    
    // MARK: - Initializers

    init(viewModel: QuotesListViewModel) {
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
        definesPresentationContext = true
        configureNavigationItem()
        configureTableView()
    }
    
    private func configureNavigationItem() {
        navigationItem.title = NSLocalizedString("Quotes", comment: "")
        accountButton.target = self
        accountButton.action = #selector(accountButtonAction)
        navigationItem.rightBarButtonItem = accountButton
        navigationItem.searchController = searchController
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.register(cellType: QuoteTableViewCell.self)
    }

    // MARK: - View Mode Bindings
    
    private func bindViewModel() {
        navigationItem.title = viewModel.tag ?? NSLocalizedString("Quotes", comment: "")
        navigationItem.rightBarButtonItem = viewModel.tag == nil ? accountButton : nil

        viewModel.quoteViewModels
            .sink { [weak self] quotes in
                self?.update(with: quotes, animate: false)
            }
            .store(in: &cancellables)

        viewModel.accountButtonTitle
            .map { Optional($0) }
            .replaceError(with: "")            
            .assign(to: \UIBarButtonItem.title, on: accountButton)
            .store(in: &cancellables)
            
    }
    
    // MARK: - Actions
    
    @objc private func accountButtonAction() {
        viewModel.accountAction()
    }
}

private extension QuotesListViewController {
    enum Section: CaseIterable {
        case quotes
    }

    func makeDataSource() -> UITableViewDiffableDataSource<Section, QuoteViewModel> {
        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, quoteViewModel in
                let cell = tableView.dequeue(cellType: QuoteTableViewCell.self, for: indexPath)
                cell.bind(to: quoteViewModel)
                return cell
            }
        )
    }

    func update(with quotes: [QuoteViewModel], animate: Bool = true) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Section, QuoteViewModel>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(quotes, toSection: .quotes)
            self.dataSource.apply(snapshot, animatingDifferences: animate)
        }
    }
}

extension QuotesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(text: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.search(text: "")
    }
}

extension QuotesListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let snapshot = dataSource.snapshot()
        if indexPath.row == snapshot.itemIdentifiers.count - 1 {
            viewModel.loadNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snapshot = dataSource.snapshot()
        viewModel.selectQuote(id: snapshot.itemIdentifiers[indexPath.row].id)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
