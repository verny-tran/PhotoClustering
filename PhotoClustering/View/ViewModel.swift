//
//  ViewModel.swift
//  PhotoClustering
//
//  Created by Trần T. Dũng on 8/5/24.
//

import OSLog
import UIKit

final class ViewModel {
    let threshold: Float = 0.5
    var images = [UIImage]()
    
    func bubbleLooping(completion: @escaping () -> Void) {
        var checkings = self.images
        var results = [UIImage]()
        
        while checkings.count >=  0 {
            if checkings.isEmpty { self.images = results; break }
            
            guard let anchor = checkings.first else { continue }
            results.append(anchor)
            
            for index in 1 ..< checkings.count {
                guard let distance = checkings[safe: index]?.distance(to: anchor) else { continue }
                
                if distance < self.threshold { checkings.remove(at: index) }
            }
            
            checkings.remove(at: 0)
        }
    }
    
    func nodeClustering(completion: @escaping () -> Void) {
        var edges = Array<(Int, Int, Float)>()
        
        for lhi in 0 ..< self.images.count {
            for rhi in (lhi + 1) ..< self.images.count {
                
                let lhs = self.images[lhi]
                let rhs = self.images[rhi]
                
                guard let distance = lhs.distance(to: rhs) else { return }
                edges.append((lhi, rhi, distance))
            }
        }
        
        let clustering = Clustering()
        for edge in edges { clustering.addEdge(edge) }

        guard let clusters = clustering.clusterVertices(with: self.threshold) else { return }
        for cluster in clusters { print(cluster) }
        
        self.images = clusters.map({ self.images[$0.first ?? 0] })
        completion()
    }
    
    func linearMarching(completion: @escaping () -> Void) {
        var pivot: Int = 0
        var results = [self.images.first ?? UIImage()]
        
        self.images.enumerated().forEach { index, image in
            guard let distance = self.images[pivot].distance(to: image) else { return }
            
            Logger().log("Pivot: \(pivot), distance: \(distance)")
            
            if distance > self.threshold {
                results.append(image)
                pivot = index
            }
        }
        
        self.images = results
        completion()
    }
}
