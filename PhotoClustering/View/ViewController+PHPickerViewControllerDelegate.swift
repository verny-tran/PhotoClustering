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
        configuration.selectionLimit = 10_000
        configuration.preferredAssetRepresentationMode = .current
        configuration.filter = .images
        
        let pickerViewController = PHPickerViewController(configuration: configuration)
        pickerViewController.delegate = self
        
        self.present(pickerViewController, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.delegate = nil
        picker.dismiss(animated: true) { [weak self] in
            guard let `self` = self else { return }
            
            self.showLoading()
            self.viewModel.images.removeAll()
            
            let dispatchGroup = DispatchGroup()
            let dispatchQueue = DispatchQueue(label: "com.verny.PhotoClustering")
            
            let itemProviders = results.map { $0.itemProvider }
                .filter { $0.hasItemConformingToTypeIdentifier(UTType.image.identifier) }
            
            itemProviders.forEach { itemProvider in
                dispatchGroup.enter()
                
                itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { url, error in
                    if let error = error { Logger().error("itemProvider.loadFileRepresentation \(error.localizedDescription)") }
                    
                    guard let url = url else { dispatchGroup.leave(); return }
                    let sourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
                    
                    guard let source = CGImageSourceCreateWithURL(url as CFURL, sourceOptions) else { dispatchGroup.leave(); return }
                    let downsampleOptions = [
                        kCGImageSourceCreateThumbnailFromImageAlways: true,
                        kCGImageSourceCreateThumbnailWithTransform: true,
                        kCGImageSourceThumbnailMaxPixelSize: 300,
                    ] as CFDictionary
                    
                    guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, downsampleOptions) else { dispatchGroup.leave(); return }
                    let data = NSMutableData()
                    
                    guard let imageDestination = CGImageDestinationCreateWithData(data, UTType.jpeg.identifier as CFString, 1, nil) else { return }
                    
                    let isPNG: Bool = {
                        guard let utType = cgImage.utType else { return false }
                        return (utType as String) == UTType.png.identifier
                    }()
                    
                    let destinationProperties = [kCGImageDestinationLossyCompressionQuality: isPNG ? 1.0 : 0.75] as CFDictionary
                    
                    CGImageDestinationAddImage(imageDestination, cgImage, destinationProperties)
                    CGImageDestinationFinalize(imageDestination)
                    
                    dispatchQueue.sync {
                        guard let image = UIImage(data: data as Data) else { dispatchGroup.leave(); return }
                        self.viewModel.images.append(image)
                    }
                    
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                DispatchQueue.main.async { self.processing() }
            }
        }
    }
}
