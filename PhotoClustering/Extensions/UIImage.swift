//
//  UIImage.swift
//  PhotoClustering
//
//  Created by Trần T. Dũng on 7/5/24.
//

import OSLog
import UIKit
import Vision

extension UIImage {
    var featurePrintObservation: VNFeaturePrintObservation? {
        guard let cgImage = self.cgImage else { return nil }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNGenerateImageFeaturePrintRequest()
        
        do {
            try requestHandler.perform([request])
            return request.results?.first as? VNFeaturePrintObservation
        } catch {
            print("Vision error: \(error)")
            return nil
        }
    }
    
    func distance(to image: UIImage) -> Float? {
        guard let selfObservation = self.featurePrintObservation,
              let imageObservation = image.featurePrintObservation else { return nil }
        
        var distance = Float(0)
        
        do { try selfObservation.computeDistance(&distance, to: imageObservation) }
        catch { Logger().error("VNFeaturePrintObservation.computeDistance") }
        
        return distance
    }
}
