import UIKit

final class AppRouter: NSObject {

    // MARK: - Properties
    // MARK: Private

    private let window: UIWindow
    private var randomQuoteInteractionController: TransitionInteractor?

    // MARK: - Initializers

    init(window: UIWindow) {
        self.window = window
    }

    // MARK: - API

    func start(with dependencies: AppDependencies) {
        let controller = QuotesListViewController.make(dependencies: dependencies)
        let navigationController = UINavigationController(rootViewController: controller)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func goToRandomQuote(dependencies: AppDependencies) {
        let controller = RandomQuoteViewController.make(dependencies: dependencies)
        controller.modalPresentationStyle = .overFullScreen
        controller.transitioningDelegate = self
        controller.loadViewIfNeeded()
        randomQuoteInteractionController = TransitionInteractor(attachTo: controller)
        window.rootViewController?.present(controller, animated: true, completion: nil)
        
    }

}

extension AppRouter: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissTransitionAnimator()
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentTransitionAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let interactor = randomQuoteInteractionController else { return nil }
        return interactor.transitionInProgress ? interactor : nil
    }
}
