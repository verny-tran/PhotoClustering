//
//  Graph.swift
//  PhotoClustering
//
//  Created by Trần T. Dũng on 7/5/24.
//

import Foundation

class Graph {
    var edge: Edge?
    var map = [Int : [Edge]]()
    
    var priorityQueue: PriorityQueue<Edge>

    init() { self.priorityQueue = PriorityQueue<Edge>(order: { $0.weight < $1.weight }) }

    func isEdgeExists(_ vertex1: Int, _ vertex2: Int) -> Bool {
        for element in self.priorityQueue.elements {
            let leftwardDirection = element.destination == vertex1 && element.source == vertex2
            let rightwardDirection = element.destination == vertex2 && element.source == vertex1
            
            if leftwardDirection || rightwardDirection { return true }
        }
        
        return false
    }

    func addEdgeToMap(from source: Int, to destination: Int, with weight: Float, at tolerance: Float) {
        var vertex1: Float = 1
        var vertex2: Float = 1

        if self.map[source] == nil { self.map[source] = [] }
        if self.map[destination] == nil { self.map[destination] = [] }

        var sourceCluster = self.map[source]!
        var destinationCluster = self.map[destination]!

        if !sourceCluster.isEmpty { vertex1 = sourceCluster[0].weight }
        if !destinationCluster.isEmpty { vertex2 = destinationCluster[0].weight }

        if self.isSameCluster(vertex1, vertex2, weight, tolerance) {
            if !sourceCluster.isEmpty && weight > sourceCluster[0].weight { sourceCluster[0].weight = weight }
            if !destinationCluster.isEmpty && weight > destinationCluster[0].weight { destinationCluster[0].weight = weight }

            self.edge = Edge(from: source, to: destination, with: weight)
            sourceCluster.append(self.edge!)
            
            self.edge = Edge(from: destination, to: source, with: weight)
            destinationCluster.append(self.edge!)
        }

        self.map[source] = sourceCluster
        self.map[destination] = destinationCluster
    }

    func newClusters(from map: [Int : [Edge]]) -> Set<Set<Int>>? {
        if !map.isEmpty {
            var checkSet = Set<Int>()
            var clusterSet = Set<Set<Int>>()

            for (source, _) in map {
                if !checkSet.contains(source) {
                    var set = Set<Int>()
                    set = self.newSet(start: source, set: &set)
                    
                    checkSet.formUnion(set)
                    clusterSet.insert(set)
                }
            }
            
            return clusterSet
        }
        
        return nil
    }

    func isLoop(from start: Int, to end: Int, assignTo set: inout Set<Int>) -> Bool {
        set.insert(start)
        
        guard let nodes = self.map[start] else { return true }
        for node in nodes {
            
            if node.destination != end && !set.contains(node.destination) {
                if !self.isLoop(from: node.destination, to: end, assignTo: &set) { return false }
                
            } else if node.destination == end { return false }
        }
        
        set.remove(start)
        
        return true
    }

    private func isSameCluster(_ vertex1: Float, _ vertex2: Float, _ weight: Float, _ tolerance: Float) -> Bool {
        return weight / min(vertex1, vertex2) <= tolerance
    }

    private func newSet(start: Int, set: inout Set<Int>) -> Set<Int> {
        set.insert(start)
        
        guard let list = map[start] else { return set }
        for node in list where !set.contains(node.destination) {
            _ = self.newSet(start: node.destination, set: &set)
        }
        
        return set
    }
}
