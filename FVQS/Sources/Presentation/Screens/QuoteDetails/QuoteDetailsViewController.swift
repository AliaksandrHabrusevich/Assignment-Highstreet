import Combine
import UIKit

extension QuoteDetailsViewController {
    static func make(quoteId: Quote.Id, dependencies: AppDependencies) -> QuoteDetailsViewController {
        let router = QuoteDetailsRouterImpl.init(dependencies: dependencies)
        let model = QuoteDetailsViewModelImpl(quoteId: quoteId, router: router, dependencies: dependencies)
        let contoller = QuoteDetailsViewController(viewModel: model)
        router.viewController = contoller
        return contoller
    }
}

class QuoteDetailsViewController: UIViewController {
    // MARK: - Properties
    // MARK: Public
    
    // MARK: Private
    private let viewModel: QuoteDetailsViewModel
    private var cancellables: [AnyCancellable] = []

    @IBOutlet private var bodyLabel: UILabel!
    @IBOutlet private var authorLabel: UILabel!
    @IBOutlet private var favouriteButton: UIButton!
    @IBOutlet private var tagsTitleLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
        
    @IBOutlet private var tagsCollectionView: UICollectionView!
    private lazy var dataSource = makeDataSource()
    
    // MARK: - Initializers

    init(viewModel: QuoteDetailsViewModel) {
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
        bodyLabel.font = bodyLabel.font.withSymbolicTraits(.traitItalic)
        configureTagsCollectionView()
    }

    private func configureTagsCollectionView() {
        let layout = TagsCollectionViewLayout()
        layout.tagWidthProvider = { TagCollectionViewCell.width(for: self.dataSource.snapshot().itemIdentifiers[$0]) }
        tagsCollectionView.collectionViewLayout = layout
        tagsCollectionView.dataSource = dataSource
        tagsCollectionView.delegate = self
        tagsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tagsCollectionView.register(TagCollectionViewCell.self)
    }
    
    private func update(with viewModel: QuoteViewModel) {
        activityIndicator.stopAnimating()
        navigationItem.title = viewModel.author
        let favIcon = viewModel.isFavourite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        bodyLabel.text = viewModel.body
        authorLabel.text = viewModel.author
        favouriteButton.setTitle(viewModel.favouritesTitle, for: .normal)
        favouriteButton.setImage(favIcon, for: .normal)
        updateTags(viewModel.tags, animate: false)
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
    
    @IBAction private func favouriteAction() {
        viewModel.favouriteAction()
    }
}

private extension QuoteDetailsViewController {
    enum Section: CaseIterable {
        case tags
    }

    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, String> {
        return UICollectionViewDiffableDataSource(
            collectionView: tagsCollectionView,
            cellProvider: { collecitonView, indexPath, tag in
                let cell = collecitonView.dequeue(TagCollectionViewCell.self, for: indexPath)
                cell.setTag(tag)
                return cell
            }
        )
    }

    func updateTags(_ tags: [String], animate: Bool = true) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(tags, toSection: .tags)
            self.dataSource.apply(snapshot, animatingDifferences: animate)
        }
    }
}

extension QuoteDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let snapshot = dataSource.snapshot()
        viewModel.selectTag(snapshot.itemIdentifiers[indexPath.row])
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
