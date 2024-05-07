//
//  ViewController+Logic.swift
//  PhotoClustering
//
//  Created by Trần T. Dũng on 7/5/24.
//

import OSLog
import UIKit

extension ViewController {
    func calculate(completion: @escaping ([UIImage]) -> Void) {
        var checkings = self.images
        var results = [UIImage]()
        
        while checkings.count >=  0 {
            if checkings.isEmpty { completion(results); break }
            
            guard let anchor = checkings.first else { continue }
            results.append(anchor)
            
            for index in 1 ..< checkings.count {
                guard let distance = checkings[safe: index]?.distance(to: anchor) else { continue }
                
                Logger().info("Distance: \(distance)")
                
                if distance < self.tolerance { checkings.remove(at: index) }
            }
            
            checkings.remove(at: 0)
        }
    }
}
