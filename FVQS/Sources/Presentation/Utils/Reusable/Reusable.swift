import UIKit

protocol Reusable: class {
    static var reuseIdentifier: String { get }
}

typealias NibReusable = Reusable & NibLoadable

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
