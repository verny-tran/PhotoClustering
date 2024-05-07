//
//  SimpleClustering.swift
//  PhotoClustering
//
//  Created by Trần T. Dũng on 7/5/24.
//

import Foundation

class SimpleClustering {
    private var adjacencyList: [String : [(String, Float)]] = [:]
    
    func addEdge(_ vertex1: String, _ vertex2: String, _ weight: Float) {
        if self.adjacencyList[vertex1] == nil {
            self.adjacencyList[vertex1] = []
        }
        
        self.adjacencyList[vertex1]?.append((vertex2, weight))
        
        if self.adjacencyList[vertex2] == nil {
            self.adjacencyList[vertex2] = []
        }
        
        self.adjacencyList[vertex2]?.append((vertex1, weight))
    }
    
    func clusterVertices(_ threshold: Float) -> Set<Set<String>> {
        var visited: Set<String> = []
        var clusters: Set<Set<String>> = []
        
        for vertex in self.adjacencyList.keys where !visited.contains(vertex) {
            var cluster: Set<String> = []
            self.dfs(vertex, threshold, &visited, &cluster)
            
            clusters.insert(cluster)
        }
        
        return clusters
    }
    
    private func dfs(_ vertex: String, _ threshold: Float, _ visited: inout Set<String>, _ cluster: inout Set<String>) {
        guard let neighbors = self.adjacencyList[vertex] else { return }
        visited.insert(vertex)
        cluster.insert(vertex)
        
        for (neighbor, weight) in neighbors where !visited.contains(neighbor) && weight <= threshold {
            self.dfs(neighbor, threshold, &visited, &cluster)
        }
    }
}

