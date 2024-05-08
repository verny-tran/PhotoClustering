//
//  ViewController.swift
//  PhotoClustering
//
//  Created by Trần T. Dũng on 7/5/24.
//

import UIKit

class ViewController: UICollectionViewController {
    let viewModel = ViewModel()
    var mode: Mode = .linearMarching
    
    enum Mode: String, CaseIterable {
        case nodeClustering = "Node Clustering"
        case linearMarching = "Linear Marching"
        
        var index: Int {
            switch self {
            case .nodeClustering: 0
            case .linearMarching: 1
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(Cell.self, forCellWithReuseIdentifier: "cell")
        self.collectionView.collectionViewLayout = FlowLayout()
        
        self.navigationItem.title = "Photo Clustering"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "list.bullet"), style: .plain,
            target: self, action: #selector(choose)
        )
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"), style: .plain,
            target: self, action: #selector(pick)
        )
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? Cell
        else { return UICollectionViewCell() }
        
        cell.imageView.image = self.viewModel.images[indexPath.item]
        
        return cell
    }
    
    func processing() {
        let start = Date()
        let amount = self.viewModel.images.count
        
        switch self.mode {
        case .nodeClustering: self.viewModel.nodeClustering(completion: { [weak self] in
            guard let `self` = self else { return }
            self.reload(from: start, with: amount)
        })
            
        case .linearMarching: self.viewModel.linearMarching(completion: { [weak self] in
            guard let `self` = self else { return }
            self.reload(from: start, with: amount)
        })
        }
    }
    
    private func reload(from start: Date, with amount: Int) {
        self.collectionView.reloadData()
        
        let clusters = self.viewModel.images.count
        let title = "In \(Date().timeIntervalSince(start).rounded(to: 4)) seconds"
        let message = "\(amount) images clustered into \(clusters) groups with \(self.mode.rawValue)."
        
        self.showDialog(title: title, message: message)
        self.hideLoading()
    }
}
