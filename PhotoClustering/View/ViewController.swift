//
//  ViewController.swift
//  PhotoClustering
//
//  Created by Trần T. Dũng on 7/5/24.
//

import UIKit

class ViewController: UICollectionViewController {
    var images = [UIImage]()
    let tolerance: Float = 0.7
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(Cell.self, forCellWithReuseIdentifier: "cell")
        self.collectionView.collectionViewLayout = FlowLayout()
        
        self.navigationItem.title = "Photo Clustering"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"), style: .plain,
            target: self, action: #selector(pick)
        )
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? Cell
        else { return UICollectionViewCell() }
        
        cell.imageView.image = self.images[indexPath.item]
        
        return cell
    }
}
