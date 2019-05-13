//
//  APINetworkManager.swift
//  
//
//  Created by Babul Prabhakar on 13/05/19.
//  Copyright © 2019 babulprabhakar. All rights reserved.
//

import Foundation
let BASE_URL: String = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(SECRET_KEY)&format=json&nojsoncallback=1&safe_search=1"
let SECRET_KEY: String = "3e7cc266ae2b0e0d78e279ce8e361736"

class APINetworkManager {
    
    let serviceManager: APIServiceManager = APIServiceManager()
    func fetchImageList<T: Codable>(searchText: String, page: Int, reponseType: T.Type,  callback: @escaping(_ response: T?,_ error: Error?,_ statusCode: Int?) ->Void) {
        var url: String = BASE_URL
        if let escapedString = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
           url.append("&text=\(escapedString)&page=\(page)")
        } else {
             url.append("&text=\(searchText)&page=\(page)")
        }

        
        
        self.serviceManager.getData(url: url) { (data, response, error) in
            if let data = data  {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let json = json {
                    print(json)
                }
                let obj = try? JSONDecoder().decode(reponseType.self,from: data)
                callback(obj, error, (response as? HTTPURLResponse)?.statusCode)
            }
        }
    }
    
}


struct ImageResponse : Codable {
    
    let photos: PhotosResponse
    struct PhotosResponse:Codable {
        let total: String
        let photo: [ImageListResponse]
    }
    struct ImageListResponse: Codable {
        let id: String
        let secret: String
        let server: String
        let farm: Int
        let title: String
    }
    
}
