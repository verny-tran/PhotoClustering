//
//  String.swift
//  PhotoClustering
//
//  Created by Trần T. Dũng on 8/5/24.
//

import Foundation

extension String {
    var isBlank: Bool {
        return !self.isEmpty ? (self.components(separatedBy: .whitespaces).count == 0) : true
    }
}
