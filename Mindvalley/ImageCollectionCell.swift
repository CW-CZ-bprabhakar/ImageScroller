//
//  ImageCollectionCell.swift
//  
//
//  Created by Babul Prabhakar on 13/05/19.
//  Copyright © 2019 babulprabhakar. All rights reserved.
//

import UIKit
let imageCache = NSCache<NSString, UIImage>()
class ImageCollectionCell: UICollectionViewCell {
     @IBOutlet weak var imageView: UIImageView!
    var dataTask:URLSessionDataTask?
    var item : ImageResponse.ImageListResponse! {
        didSet {
            if let url =  self.getURL(item: item) {
                self.imageFromServerURL(url, placeHolder: nil)
            } else {
                self.imageView.image = nil
            }
            
        }
    }
    
    func getURL(item: ImageResponse.ImageListResponse?) -> String? {
        if let item = item {
            let url = "http://farm\(item.farm).static.flickr.com/\(item.server)/\(item.id)_\(item.secret).jpg"
            return url
        }
        return nil
      
    }
    
    func imageFromServerURL(_ URLString: String, placeHolder: UIImage?) {
        self.dataTask?.cancel()
        self.imageView.image = nil
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
            self.imageView.image = cachedImage
            return
        }
        
        if let url = URL(string: URLString) {
            
            self.dataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                //print("RESPONSE FROM API: \(response)")
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL: \(error!)")
                    DispatchQueue.main.async {
                        self.imageView.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
                            self.imageView.image = downloadedImage
                        }
                    }
                }
            })
            self.dataTask?.resume()
        }
    }
}


