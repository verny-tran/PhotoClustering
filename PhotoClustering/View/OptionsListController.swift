//
//  OptionsListController.swift
//  PhotoClustering
//
//  Created by Trần T. Dũng on 8/5/24.
//

import UIKit

final class OptionsListController: UITableViewController {
    var options: [ViewController.Mode]!
    var selectedOption: ViewController.Mode!
    
    var onSelect: ((ViewController.Mode) -> Void)?
    
    convenience init(selectedOption: ViewController.Mode, options: [ViewController.Mode]) {
        self.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .popover
        
        self.selectedOption = selectedOption
        self.options = options
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 48
        self.tableView.estimatedRowHeight = 48
        self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.options.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.options[indexPath.row].rawValue
        
        if indexPath.row == self.selectedOption.index {
            let checkmark = UIImage(systemName: "checkmark")
            let imageView = UIImageView(image: checkmark)
            imageView.contentMode = .center
            cell.addSubview(imageView)
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: cell.bottomAnchor).isActive = true
            imageView.trailingAnchor.constraint(equalTo: cell.trailingAnchor).isActive = true
            imageView.widthAnchor.constraint(equalTo: cell.heightAnchor).isActive = true
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.onSelect?(self.options[indexPath.row])
        self.dismiss(animated: true)
    }
}
