//
//  ViewModel.swift
//  PhotoClustering
//
//  Created by Trần T. Dũng on 8/5/24.
//

import OSLog
import UIKit

final class ViewModel {
    let threshold: Float = 10.0
    var images = [UIImage]()
    
    /// `Node clustering`, also known as `Community Detection` is the process of starting with 
    /// each node as its own cluster and merging clusters until a balancing point is reached.
    ///
    /// - Remark: The function's goal is to generate an `undirected graph` with vertices connected by `weighted edges`.
    ///   The *lower the edge value*, the *more similar* the vertices connected by that edge.
    ///   This function creates *clusters* for the *specified graph*, with each cluster including vertices that are similar to one another.
    ///
    ///   The construction of the cluster is determined by the `threshold` value supplied as input.
    ///   If the *weight of an edge* between two clusters divided by the *minimum weight of clusters* is `less than or equal` to the *tolerance threshold*,
    ///   the two clusters are *combined into a single cluster*. By default, each vertex is a cluster with a weight of ``1``.
    ///
    /// - Parameter completion: The completion hander.
    /// - Complexity: O(*n^2*), where *n* is the length of the sequence.
    ///
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
        
        let depthFirstSearch = DepthFirstSearch()
        edges.forEach { edge in depthFirstSearch.add(edge) }

        let clusters = depthFirstSearch.cluster(with: self.threshold)
        clusters.enumerated().forEach { index, cluster in
            Logger().info("Cluster \(index): \(cluster)")
        }
        
        self.images = clusters.map({ self.images[$0.first ?? 0] })
        completion()
    }
    
    /// `Linear Marching` through all of the photographs, grouping 
    /// similar neighbor photos together and `never turning it's head back`.
    ///
    /// - Bug: This approach results in `fragmented but similar clusters`,
    ///   which is a *disadvantage* but offset by it's optimized `time complexity`.
    ///
    /// - Parameter completion: The completion hander.
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    ///
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
