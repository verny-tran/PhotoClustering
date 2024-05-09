//
//  Clustering.swift
//  PhotoClustering
//
//  Created by Trần T. Dũng on 7/5/24.
//

import Foundation

class Clustering {
    var graph: Graph
    
    /// Constructor to `initialize the graph`.
    ///
    init() { self.graph = Graph() }
    
    /// Adds given `source, destination and weight` to priority queue.
    ///
    /// - Parameters:
    ///   - vertex1: The first vertex.
    ///   - vertex2: The second vertex.
    ///   - weight: The weight of the connection between the vertexes.
    ///
    func add(_ edge: (vertex1: Int, vertex2: Int, weight: Float)) {
        /// Returns ``false`` if given vertex `is blank` or 
        /// *-ve weight of node edge* already exists` in the <PriorityQueue>.
        if edge.vertex1 != edge.vertex2 && edge.weight >= 0 &&
            !self.graph.isEdgeExists(edge.vertex1, edge.vertex2) {
            
            let edge = Edge(from: edge.vertex1, to: edge.vertex2, with: edge.weight)
            self.graph.priorityQueue.enqueue(edge)
        }
    }
    
    /// This method `forms the clusters` from the given graph.
    ///
    /// - Parameter threshold: The clustering predefined tolerance.
    /// - Returns: The clusters of grouped nodes.
    ///
    func cluster(with threshold: Float) -> Set<Set<Int>>? {
        /// Proceed only if `threshold is non -ve` value.
        guard threshold >= 0 else { return nil }
        
        var priorityQueue = PriorityQueue<Edge>(order: { $0.weight < $1.weight })
        for edge in self.graph.priorityQueue.elements { priorityQueue.enqueue(edge) }
        
        while !self.graph.priorityQueue.elements.isEmpty {
            guard let edge = self.graph.priorityQueue.dequeue() else { continue }
            
            /// For `first edge`, directly add the edge to the graph.
            if !self.graph.map.isEmpty {
                
                /// If edge `doesn't creates loop`, add edge to graph.
                var set = Set<Int>()
                
                if self.graph.isLoop(from: edge.source, to: edge.destination, assignTo: &set) {
                    self.graph.addEdgeToMap(from: edge.source, to: edge.destination, with: edge.weight, at: threshold)
                }
            } else {
                self.graph.addEdgeToMap(from: edge.source, to: edge.destination, with: edge.weight, at: threshold)
            }
        }
        
        self.graph.priorityQueue = priorityQueue
        
        return self.graph.newClusters(from: self.graph.map)
    }
}
