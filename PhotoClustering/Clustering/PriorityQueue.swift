//
//  PriorityQueue.swift
//  PhotoClustering
//
//  Created by Trần T. Dũng on 7/5/24.
//

import Foundation

struct PriorityQueue<Element> {
    var elements: [Element]
    let order: (Element, Element) -> Bool
    
    var peek: Element? { self.elements.first }

    init(order: @escaping (Element, Element) -> Bool, elements: [Element] = []) {
        self.order = order
        self.elements = elements
        self.elements.sort(by: order)
    }

    mutating func enqueue(_ element: Element) {
        self.elements.append(element)
        self.elements.sort(by: self.order)
    }

    mutating func dequeue() -> Element? {
        return self.elements.isEmpty ? nil : self.elements.removeFirst()
    }
}
