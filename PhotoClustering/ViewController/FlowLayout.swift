//
//  FlowLayout.swift
//  PhotoClustering
//
//  Created by Trần T. Dũng on 7/5/24.
//

import UIKit

final class FlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        
        let size = (UIScreen.main.bounds.width - 4) / 3
        self.itemSize = CGSize(width: size, height: size)
        
        self.scrollDirection = .vertical
        self.sectionInset = .zero
        self.minimumInteritemSpacing = 2
        self.minimumLineSpacing = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
