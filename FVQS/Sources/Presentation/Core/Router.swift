import UIKit

protocol Router: AnyObject {
    var viewController: UIViewController? { get }
}

extension Router {
    func showAlert(title: String, message: String, dismissButton: String = NSLocalizedString("OK", comment: "")) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: dismissButton, style: .default, handler: nil))
        viewController?.present(alert, animated: true, completion: nil)
    }
}
