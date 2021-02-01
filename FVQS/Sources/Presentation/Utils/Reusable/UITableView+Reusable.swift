import UIKit

extension UITableView {

    final func register<T: UITableViewCell>(cellType: T.Type) where T: NibReusable {
        register(cellType.nib, forCellReuseIdentifier: cellType.reuseIdentifier)
    }

    final func register<T: UITableViewCell>(cellType: T.Type) where T: Reusable {
        register(cellType.self, forCellReuseIdentifier: cellType.reuseIdentifier)
    }

    final func dequeue<T: UITableViewCell>(cellType: T.Type = T.self) -> T
        where T: Reusable {
            guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseIdentifier) as? T else {
                fatalError(
                    "Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self). "
                        + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
                        + "and that you registered the cell beforehand"
                )
            }
            return cell
    }

    final func dequeue<T: UITableViewCell>(cellType: T.Type = T.self, for indexPath: IndexPath) -> T
        where T: Reusable {
            guard let cell = self.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
                fatalError(
                    "Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self). "
                        + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
                        + "and that you registered the cell beforehand"
                )
            }
            return cell
    }

    final func register<T: UITableViewHeaderFooterView>(headerFooterViewType: T.Type)
        where T: NibReusable {
            register(headerFooterViewType.nib, forHeaderFooterViewReuseIdentifier: headerFooterViewType.reuseIdentifier)
    }

    final func register<T: UITableViewHeaderFooterView>(headerFooterViewType: T.Type)
        where T: Reusable {
            register(headerFooterViewType.self, forHeaderFooterViewReuseIdentifier: headerFooterViewType.reuseIdentifier)
    }

    final func dequeue<T: UITableViewHeaderFooterView>(headerFooterViewType: T.Type = T.self) -> T
        where T: Reusable {
            guard let view = self.dequeueReusableHeaderFooterView(withIdentifier: headerFooterViewType.reuseIdentifier) as? T else {
                fatalError(
                    "Failed to dequeue a header/footer with identifier \(headerFooterViewType.reuseIdentifier) "
                        + "matching type \(headerFooterViewType.self). "
                        + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
                        + "and that you registered the header/footer beforehand"
                )
            }
            return view
    }

}
