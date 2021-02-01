import UIKit

protocol QuotesListRouter: Router {
    func goToLogin()
    func goToQuoteDetails(id: Quote.Id)
}

class QuotesListRouterImpl: QuotesListRouter {

    // MARK: - Properties
    // MARK: Public
    weak var viewController: UIViewController?
    
    // MARK: Private

    private let dependencies: AppDependencies

    // MARK: - Initializers

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }

    // MARK: - QuotesListRouter
    
    func goToLogin() {
        let controller = SignInViewController.make(dependencies: dependencies)
        let navigation = UINavigationController(rootViewController: controller)
        viewController?.present(navigation, animated: true, completion: nil)
    }
    
    func goToQuoteDetails(id: Quote.Id) {
        let controller = QuoteDetailsViewController.make(quoteId: id, dependencies: dependencies)
        viewController?.navigationController?.pushViewController(controller, animated: true)
    }
}
