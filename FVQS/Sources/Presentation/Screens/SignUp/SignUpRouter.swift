import UIKit

protocol SignUpRouter: Router {
    func close()
}

class SignUpRouterImpl: SignUpRouter {

    // MARK: - Properties
    // MARK: Public
    weak var viewController: UIViewController?
    
    // MARK: Private

    private let dependencies: AppDependencies

    // MARK: - Initializers

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }

    // MARK: - SignUpRouter
    
    func close() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
