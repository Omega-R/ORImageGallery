//
//  ORZoomPresentAnimationController.swift
//  Pods
//
//
//

import UIKit

class ORZoomPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var initFrame: CGRect?
    var originFrame: CGRect!
    
    // MARK: - UIViewControllerAnimatedTransitioning
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to), let toView = toVC.view, let fromVC = transitionContext.viewController(forKey: .from) else {
            return
        }
        
        if let initFrame = initFrame {
            let snapshotView = UIView(frame: toView.frame)
            snapshotView.addSubview(toView)
            snapshotView.backgroundColor = .clear
            snapshotView.clipsToBounds = true
            snapshotView.autoresizesSubviews = false
            
            transitionContext.containerView.addSubview(snapshotView)
            
            let scale = initFrame.width / originFrame.width
            snapshotView.transform = CGAffineTransform(scaleX: scale, y: scale)
            
            let yPostionToView = ((initFrame.height - snapshotView.frame.height) / 2) / scale
            
            snapshotView.frame = initFrame
            
            toView.frame = CGRect(x: 0, y: yPostionToView, width: toView.bounds.width, height: toView.bounds.height)
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                snapshotView.transform = CGAffineTransform.identity
                snapshotView.frame = self.originFrame
                toView.frame = self.originFrame
            }, completion: { (finished) in
                transitionContext.completeTransition(finished)
            })
            
            return
        }
        
        transitionContext.containerView.addSubview(toView)
        toView.transform = CGAffineTransform(translationX: 0, y: originFrame.height)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toView.transform = CGAffineTransform.identity
        }, completion: { (finished) in
            transitionContext.completeTransition(finished)
        })
    }
    
    
}
