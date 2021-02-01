import UIKit

protocol QuoteDetailsRouter: Router {
    func goToLogin()
    func goToTagQuotes(tag: String)
}

class QuoteDetailsRouterImpl: QuoteDetailsRouter {

    // MARK: - Properties
    // MARK: Public
    weak var viewController: UIViewController?
    
    // MARK: Private

    private let dependencies: AppDependencies

    // MARK: - Initializers

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }

    // MARK: - QuoteDetailsRouter
    
    func goToLogin() {
        let controller = SignInViewController.make(dependencies: dependencies)
        let navigation = UINavigationController(rootViewController: controller)
        viewController?.present(navigation, animated: true, completion: nil)
    }
    
    func goToTagQuotes(tag: String) {
        let controller = QuotesListViewController.make(tag: tag, dependencies: dependencies)
        viewController?.navigationController?.pushViewController(controller, animated: true)
    }
}
