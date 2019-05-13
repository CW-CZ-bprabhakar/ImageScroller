//
//  ViewController.swift
//  
//
//  Created by Babul Prabhakar on 13/05/19.
//  Copyright © 2019 babulprabhakar. All rights reserved.
//

import UIKit

class ImageScroller: UIViewController {

   
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet var titleView: UIView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    let viewModel: ImageScrollerViewModal = ImageScrollerViewModal()
    override func viewDidLoad() {
        super.viewDidLoad()
       self.title = self.viewModel.searchText
        let rightButtonItem = UIBarButtonItem.init(
            title: "Search",
            style: .plain,
            target: self,
            action: #selector(ImageScroller.searchButtonClicked(_:))
        )
        
        self.navigationItem.rightBarButtonItem = rightButtonItem
        viewModel.viewModalHandler = {[weak self] type in
            DispatchQueue.main.async() {
                switch type {
                case .showLoader:
                    self?.activityIndicator.startAnimating()
                case .hideLoader:
                    self?.activityIndicator.stopAnimating()
                case .resultFetched:
                    self?.imageCollectionView.reloadData()
                }
            }
           
        }
        
        viewModel.fetchImages(needReset: true)
     
    }
    @IBAction func searchButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Enter Search Text", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter TextField"
            textField.text = self.viewModel.searchText
        }
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            if let textField = alert.textFields?.first, let text = textField.text?.trimmingCharacters(in: .whitespaces), text.count > 0 {
                self.viewModel.searchText = text
                self.title = self.viewModel.searchText
            } else {
                self.searchButtonClicked(self)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    

    

}

extension ImageScroller: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell =   collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as? ImageCollectionCell {
            // downloadImage and show it to user
            let item = self.viewModel.item(indexPath: indexPath)
            cell.item = item
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfItems()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.frame.size.height)
        {
            self.viewModel.fetchImages()
        }
        
    }
}
