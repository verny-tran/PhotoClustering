//
//  ViewController+UIPopoverPresentationControllerDelegate.swift
//  PhotoClustering
//
//  Created by Trần T. Dũng on 8/5/24.
//

import UIKit

extension ViewController: UIPopoverPresentationControllerDelegate {
    @objc
    func choose() {
        let optionsListController = OptionsListController(selectedOption: self.mode, options: Mode.allCases)
        optionsListController.preferredContentSize = CGSize(width: 200, height: 48 * Mode.allCases.count)
        optionsListController.modalPresentationStyle = .popover
        
        optionsListController.onSelect = { [weak self] mode in
            guard let `self` = self else { return }
            self.mode = mode
        }
        
        let popoverPresentationController = optionsListController.popoverPresentationController!
        popoverPresentationController.delegate = self
        popoverPresentationController.sourceView = self.view
        popoverPresentationController.barButtonItem = self.navigationItem.leftBarButtonItem
        
        self.present(optionsListController, animated: true, completion:nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
