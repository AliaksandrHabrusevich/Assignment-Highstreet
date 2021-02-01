import UIKit

protocol SignInRouter: Router {
    func close()
    func goToSignUp()
}

class SignInRouterImpl: SignInRouter {

    // MARK: - Properties
    // MARK: Public
    weak var viewController: UIViewController?
    
    // MARK: Private

    private let dependencies: AppDependencies

    // MARK: - Initializers

    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }

    // MARK: - SignInRouter
    
    func close() {
        viewController?.dismiss(animated: true, completion: nil)
    }
    
    func goToSignUp() {
        let controller = SignUpViewController.make(dependencies: dependencies)
        viewController?.navigationController?.pushViewController(controller, animated: true)
    }
}
