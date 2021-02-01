import UIKit

protocol TransitionContext {
    var dimmingView: UIView { get }
    var contentView: UIView { get }
}

class PresentTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning  {
    
    private var propertyAnimator: UIViewPropertyAnimator?
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = interruptibleAnimator(using: transitionContext)
        animator.startAnimation()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        if let propertyAnimator = propertyAnimator {
            return propertyAnimator
        }

        let container = transitionContext.containerView
        
        guard let toVc = transitionContext.viewController(forKey: .to) else { fatalError() }
        guard let slideContext = toVc as? TransitionContext else { fatalError() }
        guard let toView = transitionContext.view(forKey: .to) else { fatalError() }
        
        toView.frame = container.bounds
        toView.layoutIfNeeded()
        container.addSubview(toView)
        
        let contentOrigin = slideContext.contentView.frame.origin.y
        slideContext.dimmingView.alpha = 0
        slideContext.contentView.frame.origin.y = container.bounds.maxY
        
        let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), timingParameters: UICubicTimingParameters(animationCurve: .linear))
        animator.addAnimations {
            slideContext.dimmingView.alpha = 1
            slideContext.contentView.frame.origin.y = contentOrigin
        }
        animator.addCompletion { (_) in
            if transitionContext.transitionWasCancelled {
                transitionContext.completeTransition(false)
            } else {
                transitionContext.completeTransition(true)
            }
            self.propertyAnimator = nil
        }
        
        self.propertyAnimator = animator
        return animator
    }
}

class DismissTransitionAnimator : NSObject, UIViewControllerAnimatedTransitioning {
    
    private var propertyAnimator: UIViewPropertyAnimator?
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = interruptibleAnimator(using: transitionContext)
        animator.startAnimation()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        if let propertyAnimator = propertyAnimator {
            return propertyAnimator
        }

        guard let fromVC = transitionContext.viewController(forKey: .from) else { fatalError() }
        let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), timingParameters: UICubicTimingParameters(animationCurve: .linear))
        animator.addAnimations {
            fromVC.view.alpha = 0
        }
        animator.addCompletion { (_) in
            if transitionContext.transitionWasCancelled {
                transitionContext.completeTransition(false)
            } else {
                transitionContext.completeTransition(true)
            }
            self.propertyAnimator = nil
        }
        
        self.propertyAnimator = animator
        return animator
    }
}
