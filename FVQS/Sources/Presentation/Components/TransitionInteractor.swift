import UIKit

class TransitionInteractor : UIPercentDrivenInteractiveTransition {
    
    let viewController: UIViewController & TransitionContext
    
    private(set) var shouldCompleteTransition = false
    private(set) var transitionInProgress = false
    private var transitionHeight: CGFloat = 0
    
    init(attachTo controller: UIViewController & TransitionContext) {
        self.viewController = controller
        super.init()
        setupGesture(view: controller.contentView)
    }
    
    private func setupGesture(view : UIView) {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        view.addGestureRecognizer(gesture)
    }
    
    @objc private func handleGesture(_ gesture : UIScreenEdgePanGestureRecognizer) {
        
        guard let view = gesture.view else { return }
        let viewTranslation = gesture.translation(in: view)
        var progress = viewTranslation.y / transitionHeight
        progress = min(max(progress, 0.0), 1.0)

        switch gesture.state {
        case .began:
            transitionHeight = viewController.view.bounds.height - viewController.contentView.frame.midY
            transitionInProgress = true
            viewController.dismiss(animated: true, completion: nil)
            break
        case .changed:
            let velocity = gesture.velocity(in: view)
            if velocity.y == 0 {
                shouldCompleteTransition = progress >= 0.47
            } else if velocity.y >  0 {
                shouldCompleteTransition = progress > 0.3
            } else {
                shouldCompleteTransition = progress > 0.7
            }
            
            update(progress)
            break
        case .cancelled:
            transitionInProgress = false
            cancel()
            break
        case .ended:
            transitionInProgress = false
            shouldCompleteTransition ? finish() : cancel()
            break
        default:
            return
        }
    }
}

