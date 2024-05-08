//
//  SimpleClustering.swift
//  PhotoClustering
//
//  Created by Trần T. Dũng on 7/5/24.
//

import Foundation

class SimpleClustering {
    private var adjacencyList: [Int : [(Int, Float)]] = [:]
    
    func addEdge(_ edge: (vertex1: Int, vertex2: Int, weight: Float)) {
        if self.adjacencyList[edge.vertex1] == nil {
            self.adjacencyList[edge.vertex1] = []
        }
        
        self.adjacencyList[edge.vertex1]?.append((edge.vertex2, edge.weight))
        
        if self.adjacencyList[edge.vertex2] == nil {
            self.adjacencyList[edge.vertex2] = []
        }
        
        self.adjacencyList[edge.vertex2]?.append((edge.vertex1, edge.weight))
    }
    
    func clusterVertices(with threshold: Float) -> Set<Set<Int>> {
        var visited: Set<Int> = []
        var clusters: Set<Set<Int>> = []
        
        for vertex in self.adjacencyList.keys where !visited.contains(vertex) {
            var cluster: Set<Int> = []
            self.dfs(vertex, threshold, &visited, &cluster)
            
            clusters.insert(cluster)
        }
        
        return clusters
    }
    
    private func dfs(_ vertex: Int, _ threshold: Float, _ visited: inout Set<Int>, _ cluster: inout Set<Int>) {
        guard let neighbors = self.adjacencyList[vertex] else { return }
        visited.insert(vertex)
        cluster.insert(vertex)
        
        for (neighbor, weight) in neighbors where !visited.contains(neighbor) && weight <= threshold {
            self.dfs(neighbor, threshold, &visited, &cluster)
        }
    }
}
