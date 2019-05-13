//
//  APINetworkUtil.swift
//  
//
//  Created by Babul Prabhakar on 13/05/19.
//  Copyright © 2019 babulprabhakar. All rights reserved.
//

import Foundation



class APIServiceManager  {
    func getData(url : String, callback:@escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let serviceUrl = URL(string: url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "GET"
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            callback(data,response,error)
            }.resume()
    }
}
