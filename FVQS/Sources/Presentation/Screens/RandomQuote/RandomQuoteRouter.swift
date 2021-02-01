import UIKit

protocol RandomQuoteRouter: Router {
    func close()
}

class RandomQuoteRouterImpl: RandomQuoteRouter {

    // MARK: - Properties
    // MARK: Public
    weak var viewController: UIViewController?
    
    // MARK: Private

    private let dependencies: AppDependencies

    // MARK: - Initializers

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }

    // MARK: - RandomQuoteRouter
    
    func close() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
