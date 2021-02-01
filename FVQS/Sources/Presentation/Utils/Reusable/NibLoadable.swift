import UIKit

protocol NibLoadable: class {
    static var nib: UINib { get }
}

extension NibLoadable {
    static var nib: UINib {
        let bundle = Bundle(for: self)
        let nibName = String(describing: self)

        if bundle.path(forResource: nibName, ofType: "nib") != nil {
            return UINib(nibName: nibName, bundle: bundle)
        }

        fatalError(
            "\(nibName).nib is not exist "
                + "in bundle \(bundle.debugDescription)."
        )
    }
}

extension NibLoadable where Self: UIView {

    static func loadFromNib() -> Self {
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("The nib \(nib) expected its root view to be of type \(self)")
        }
        return view
    }
}

extension UINib {
    static func nib(for viewType: AnyClass) -> UINib? {
        let bundle = Bundle(for: viewType)
        let nibName = String(describing: viewType)

        if bundle.path(forResource: nibName, ofType: "nib") != nil {
            return UINib(nibName: nibName, bundle: bundle)
        } else {
            return nil
        }
    }
}
