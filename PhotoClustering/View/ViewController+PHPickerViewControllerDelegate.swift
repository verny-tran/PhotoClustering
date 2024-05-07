//
//  ViewController+PHPickerViewControllerDelegate.swift
//  PhotoClustering
//
//  Created by Trần T. Dũng on 7/5/24.
//

import OSLog
import PhotosUI

extension ViewController: PHPickerViewControllerDelegate {
    @objc
    func pick() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1000
        configuration.filter = .images
        
        let pickerViewController = PHPickerViewController(configuration: configuration)
        pickerViewController.delegate = self
        
        self.present(pickerViewController, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        self.showLoading()
        self.images.removeAll()
        
        let itemProviders = results.map { $0.itemProvider }
            .filter { $0.canLoadObject(ofClass: UIImage.self) }
        
        let dispatchGroup = DispatchGroup()
        
        itemProviders.forEach { itemProvider in
            dispatchGroup.enter()
            
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                if let error = error { Logger().error("itemProvider.loadObject \(error.localizedDescription)") }
                
                guard let image = image as? UIImage else { return }
                self.images.append(image)
                
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.calculate(completion: { images in
                self.images = images
                self.hideLoading()
                
                self.collectionView.reloadData()
            })
        }
    }
}
