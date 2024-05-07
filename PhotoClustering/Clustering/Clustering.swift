//
//  Clustering.swift
//  PhotoClustering
//
//  Created by Trần T. Dũng on 7/5/24.
//

import Foundation

class Clustering {
    var graph: Graph

    /// Constructor to initialize the Graph
    ///
    init() { self.graph = Graph() }

    /// Adds given source, destination and weight to priority queue.
    ///
    /// - Parameters:
    ///   - vertex1:
    ///   - vertex2:
    ///   - weight:
    ///
    /// - Returns:
    ///
    func addEdge(_ edge: (vertex1: Int, vertex2: Int, weight: Float)) {
        /// Returns false if given vertex is blank or -ve weight
        /// or node edge already exists in the PQueue.
        if edge.vertex1 != edge.vertex2 && edge.weight > 0 &&
            !self.graph.isEdgeExists(edge.vertex1, edge.vertex2) {
            
            let edge = Edge(from: edge.vertex1, to: edge.vertex2, with: edge.weight)
            self.graph.priorityQueue.enqueue(edge)
        }
    }

    /// This method forms the clusters from the given graph.
    ///
    /// - Parameters:
    ///   - tolerance:
    ///
    /// - Returns:
    ///
    func clusterVertices(with tolerance: Float) -> Set<Set<Int>>? {
        /// Proceed only if tolerance is non -ve value.
        guard tolerance >= 0 else { return nil }
        
        var priorityQueue = PriorityQueue<Edge>(order: { $0.weight < $1.weight })
        for edge in self.graph.priorityQueue.elements { priorityQueue.enqueue(edge) }
        
        while !self.graph.priorityQueue.elements.isEmpty {
            let edge = self.graph.priorityQueue.elements.removeFirst()
            
            /// For first edge, directly add the edge to the graph.
            if !self.graph.map.isEmpty {
                
                /// If edge doesn't creates loop, add edge to graph.
                var set = Set<Int>()
                
                if self.graph.isLoop(from: edge.source, to: edge.destination, assignTo: &set) {
                    self.graph.addEdgeToMap(from: edge.source, to: edge.destination, with: edge.weight, at: tolerance)
                }
            } else {
                self.graph.addEdgeToMap(from: edge.source, to: edge.destination, with: edge.weight, at: tolerance)
            }
        }
        
        self.graph.priorityQueue = priorityQueue
        
        return self.graph.newClusters(from: self.graph.map)
    }
}
