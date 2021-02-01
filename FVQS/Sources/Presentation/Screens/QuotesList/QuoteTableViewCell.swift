import UIKit

class QuoteTableViewCell: UITableViewCell, NibReusable {
    // MARK: - Properties
    // MARK: Public
    
    // MARK: Private
    @IBOutlet private var bodyLabel: UILabel!
    @IBOutlet private var authorLabel: UILabel!
    @IBOutlet private var favouritesButton: UIButton!
    
    private var onFavAction: (() -> Void)?

    // MARK: - API
    
    func bind(to viewModel: QuoteViewModel) {
        let favIcon = viewModel.isFavourite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        bodyLabel.text = viewModel.body
        authorLabel.text = viewModel.author
        favouritesButton.setTitle(viewModel.favouritesTitle, for: .normal)
        favouritesButton.setImage(favIcon, for: .normal)
        onFavAction = { viewModel.favouriteAction() }
    }
    
    // MARK: - View
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bodyLabel.font = bodyLabel.font.withSymbolicTraits(.traitItalic)
    }
    
    // MARK: - Acitons
    @IBAction private func favAction(_ sender: Any) {
        onFavAction?()
    }
}
