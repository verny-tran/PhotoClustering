//
//  UIView.swift
//  PhotoClustering
//
//  Created by Trần T. Dũng on 7/5/24.
//

import UIKit

extension UIView {
    func fadeIn(alpha: CGFloat = 1, duration: TimeInterval = 0.2, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: { self.alpha = alpha },
                       completion: { [weak self] _ in
            guard let `self` = self else { return }
            if alpha != 0 { self.isHidden = false }
            
            completion?()
        })
    }
    
    func fadeOut(alpha: CGFloat = 0, duration: TimeInterval = 0.2, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: { self.alpha = alpha },
                       completion: { [weak self] _ in
            guard let `self` = self else { return }
            if alpha == 0 { self.isHidden = true }
            
            completion?()
        })
    }
    
    func fadeTransition(_ duration: CFTimeInterval = 0.2) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.type = .fade
        animation.duration = duration
        
        self.layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}
