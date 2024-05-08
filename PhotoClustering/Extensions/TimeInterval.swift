//
//  TimeInterval.swift
//  PhotoClustering
//
//  Created by Trần T. Dũng on 8/5/24.
//

import Foundation

extension TimeInterval {
    func rounded(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
