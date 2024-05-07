//
//  ViewController.swift
//  PhotoClustering
//
//  Created by Trần T. Dũng on 7/5/24.
//

import UIKit

class ViewController: UICollectionViewController {
    let viewModel = ViewModel()
    let mode: Mode = .linearMarching
    
    enum Mode {
        case bubbleLooping
        case nodeClustering
        case linearMarching
    }
    
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
        self.viewModel.images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? Cell
        else { return UICollectionViewCell() }
        
        cell.imageView.image = self.viewModel.images[indexPath.item]
        
        return cell
    }
    
    func processing() {
        switch self.mode {
        case .bubbleLooping: self.viewModel.bubbleLooping(completion: { [weak self] in
            guard let `self` = self else { return }
            self.collectionView.reloadData()
            
            self.hideLoading()
        })
            
        case .nodeClustering: self.viewModel.nodeClustering(completion: { [weak self] in
            guard let `self` = self else { return }
            self.collectionView.reloadData()
            
            self.hideLoading()
        })
            
        case .linearMarching: self.viewModel.linearMarching(completion: { [weak self] in
            guard let `self` = self else { return }
            self.collectionView.reloadData()
            
            self.hideLoading()
        })
        }
    }
}
