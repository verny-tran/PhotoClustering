//
//  Edge.swift
//  PhotoClustering
//
//  Created by Trần T. Dũng on 7/5/24.
//

import Foundation

struct Edge {
    var source: Int
    var destination: Int
    var weight: Float

    init(from source: Int, to destination: Int, with weight: Float) {
        self.source = source
        self.destination = destination
        self.weight = weight
    }
}
