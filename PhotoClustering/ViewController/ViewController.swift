//
//  ViewController.swift
//  PhotoClustering
//
//  Created by Trần T. Dũng on 7/5/24.
//

import UIKit
import PhotosUI

class ViewController: UICollectionViewController {
    var images = [UIImage]()
    
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

    @objc 
    func pick() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1000
        configuration.filter = .images
        
        let pickerViewController = PHPickerViewController(configuration: configuration)
        pickerViewController.delegate = self
        
        self.present(pickerViewController, animated: true)
    }
}

extension ViewController {
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
