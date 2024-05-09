//
//  DepthFirstSearch.swift
//  PhotoClustering
//
//  Created by Trần T. Dũng on 7/5/24.
//

import Foundation

class DepthFirstSearch {
    private var map: [Int : [(Int, Float)]] = [:]
    
    /// Adds given `source, destination and weight` to priority queue.
    ///
    /// - Parameters:
    ///   - vertex1: The first vertex.
    ///   - vertex2: The second vertex.
    ///   - weight: The weight of the connection between the vertexes.
    ///
    func add(_ edge: (vertex1: Int, vertex2: Int, weight: Float)) {
        if self.map[edge.vertex1] == nil { self.map[edge.vertex1] = [] }
        self.map[edge.vertex1]?.append((edge.vertex2, edge.weight))
        
        if self.map[edge.vertex2] == nil { self.map[edge.vertex2] = [] }
        self.map[edge.vertex2]?.append((edge.vertex1, edge.weight))
    }
    
    /// This method `forms the clusters` from the given graph.
    ///
    /// - Parameter threshold: The clustering predefined tolerance.
    /// - Returns: The clusters of grouped nodes.
    ///
    func cluster(with threshold: Float) -> Set<Set<Int>> {
        var visited: Set<Int> = []
        var clusters: Set<Set<Int>> = []
        
        for vertex in self.map.keys where !visited.contains(vertex) {
            var cluster: Set<Int> = []
            self.dfs(vertex, threshold, &visited, &cluster)
            
            clusters.insert(cluster)
        }
        
        return clusters
    }
    
    /// **Depth First Search**, or <DFS>.
    /// This method `visits the vertexes` in the map, `mark the visited to clusters`.
    ///
    /// - Remark: It is a `recursive function`.
    ///
    /// - Parameter threshold: The clustering predefined tolerance.
    /// - Returns: The clusters of grouped nodes.
    ///
    private func dfs(_ vertex: Int, _ threshold: Float, _ visited: inout Set<Int>, _ cluster: inout Set<Int>) {
        guard let neighbors = self.map[vertex] else { return }
        visited.insert(vertex)
        cluster.insert(vertex)
        
        for (neighbor, weight) in neighbors where !visited.contains(neighbor) && weight <= threshold {
            self.dfs(neighbor, threshold, &visited, &cluster)
        }
    }
}
