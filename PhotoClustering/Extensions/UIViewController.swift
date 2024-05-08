//
//  UIViewController.swift
//  PhotoClustering
//
//  Created by Trần T. Dũng on 7/5/24.
//

import UIKit

extension UIViewController {
    public func showDialog(title: String? = nil, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alertController, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            alertController.dismiss(animated: true)
        }
    }
}

extension UIViewController {
    public func showLoading() {
        DispatchQueue.main.async {
            let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            
            let visualEffectView = UIVisualEffectView(effect: blurEffect)
            visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            visualEffectView.frame = self.view.bounds
            visualEffectView.alpha = 0
            self.view.addSubview(visualEffectView)
            
            let activityIndicatorView = UIActivityIndicatorView(style: .large)
            self.view.addSubview(activityIndicatorView)
            
            activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
            activityIndicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            activityIndicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            
            activityIndicatorView.startAnimating()
            
            visualEffectView.fadeIn()
        }
    }
    
    public func hideLoading() {
        DispatchQueue.main.async {
            for case let visualEffectView as UIVisualEffectView in self.view.subviews {
                visualEffectView.fadeOut(completion: { [weak visualEffectView] in
                    visualEffectView?.removeFromSuperview()
                    
                    for case let activityIndicatorView as UIActivityIndicatorView in self.view.subviews {
                        activityIndicatorView.stopAnimating()
                        activityIndicatorView.removeFromSuperview()
                    }
                })
            }
        }
    }
}
