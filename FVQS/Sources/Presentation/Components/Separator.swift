import UIKit

class Separator: UIView {
    @objc dynamic var height: CGFloat = 1.0 / UIScreen.main.scale {
        didSet {
            constraints.filter { $0.identifier == "height" }.forEach { $0.constant = height }
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width, height: height)
    }

    // MARK: Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        if #available(iOS 13, *) {
            backgroundColor = .separator
        } else {
            backgroundColor = .lightGray
        }
        translatesAutoresizingMaskIntoConstraints = false
        setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}
