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
    /// The `object association` of the extended <featurePrintObservation> property of <UIImage>.
    /// A `static property` storing all <featurePrintObservation> object `reference addresses`.
    private static let featurePrintObservationAssociation = ObjectAssociation<VNFeaturePrintObservation>()
    
    /// The `customly extended` <featurePrintObservation> property of <UIImage>.
    var featurePrintObservation: VNFeaturePrintObservation? {
        get { return UIImage.featurePrintObservationAssociation[self] ?? self.vnFeaturePrintObservation() }
        set { UIImage.featurePrintObservationAssociation[self] = newValue }
    }
    
    private func vnFeaturePrintObservation() -> VNFeaturePrintObservation? {
        guard let cgImage = self.cgImage else { return nil }
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        let request = VNGenerateImageFeaturePrintRequest()
        request.revision = VNGenerateImageFeaturePrintRequestRevision1
        
        do {
            try requestHandler.perform([request])
            return request.results?.first as? VNFeaturePrintObservation
        } catch {
            Logger().error("VNFeaturePrintObservation.perform")
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
