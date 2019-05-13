//
//  ImageScrollerViewModal.swift
//  
//
//  Created by Babul Prabhakar on 13/05/19.
//  Copyright © 2019 babulprabhakar. All rights reserved.
//

import Foundation
enum ViewModalActionType  {
    case showLoader
    case hideLoader
    case resultFetched
}
class ImageScrollerViewModal {
    private(set) var currentPage: Int = 0
    private(set) var isPending: Bool = false
    private let manager: APINetworkManager = APINetworkManager()
    var imagesList : [ImageResponse.ImageListResponse]?
    var viewModalHandler: ((_ type: ViewModalActionType) -> Void)?
    var searchText: String = "rose" {
        didSet {
            self.isPending = false
           self.fetchImages(needReset: true)
        }
    }
    
    func fetchImages(needReset: Bool = false) {
        if isPending == false  {
            if needReset  {
                self.currentPage = 0
            }
            self.currentPage += 1
            self.isPending = true
            self.viewModalHandler?(.showLoader)
            self.manager.fetchImageList(searchText: self.searchText, page: self.currentPage, reponseType: ImageResponse.self) {[weak self] (responseObj, error, statusCode) in

                if let weakSelf = self {
                    weakSelf.viewModalHandler?(.hideLoader)
                    weakSelf.isPending = false
                    if let responseObj =  responseObj {
                        if needReset == true  {
                            weakSelf.imagesList = responseObj.photos.photo
                        } else {
                            if weakSelf.imagesList != nil {
                                weakSelf.imagesList!.append(contentsOf: responseObj.photos.photo)
                            }
                        }
                         weakSelf.viewModalHandler?(.resultFetched)
                    }
                   
                }
              
            }
        }
        
    }
    
    func numberOfItems() -> Int {
        return self.imagesList?.count ?? 0
    }
    
    func item(indexPath: IndexPath) -> ImageResponse.ImageListResponse?{
        return self.imagesList?[indexPath.item]
    }
    
    
    
}
