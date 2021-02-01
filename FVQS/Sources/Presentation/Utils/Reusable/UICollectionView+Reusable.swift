import UIKit

extension UICollectionView {

    final func register<T: UICollectionViewCell>(_ cellType: T.Type) where T: NibReusable {
        register(cellType.nib, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }

    final func register<T: UICollectionViewCell>(_ cellType: T.Type) where T: Reusable {
        register(cellType.self, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }

    final func dequeue<T: UICollectionViewCell>(_ cellType: T.Type = T.self, for indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
                fatalError(
                    "Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self). "
                        + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
                        + "and that you registered the cell beforehand"
                )
            }
            return cell
    }

    final func register<T: UICollectionReusableView>(_ viewType: T.Type, forSupplementaryViewOfKind viewKind: String) where T: NibReusable {
        register(viewType.nib, forSupplementaryViewOfKind: viewKind, withReuseIdentifier: viewType.reuseIdentifier)
    }

    final func register<T: UICollectionReusableView>(_ viewType: T.Type, forSupplementaryViewOfKind: String) where T: Reusable {
        register(viewType.self, forSupplementaryViewOfKind: forSupplementaryViewOfKind, withReuseIdentifier: viewType.reuseIdentifier)
    }

    final func dequeue<T: UICollectionReusableView>(_ viewType: T.Type = T.self, ofKind viewKind: String, for indexPath: IndexPath) -> T where T: Reusable {
            guard let view = self.dequeueReusableSupplementaryView(ofKind: viewKind, withReuseIdentifier: viewType.reuseIdentifier, for: indexPath) as? T else {
                fatalError(
                    "Failed to dequeue a supplementary view of kind \(viewKind) with identifier \(viewType.reuseIdentifier) "
                        + "matching type \(viewType.self). "
                        + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
                        + "and that you registered the supplementary view beforehand"
                )
            }
            return view
    }

}
