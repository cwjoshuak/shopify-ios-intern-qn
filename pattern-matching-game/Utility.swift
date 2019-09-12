//
//  ShopifyAPI.swift
//  pattern-matching-game
//
//  Created by Joshua Kuan on 9/11/19.
//  Copyright © 2019 Joshua Kuan. All rights reserved.
//

import Foundation
import UIKit
class Utility {
    
    private static let baseURL = "https://shopicruit.myshopify.com/admin/products.json?"
    private static let accessToken: String = "c32313df0d0ef512ca64d5b336a0d7c6"
    
    private static func url(with page: Int?) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "shopicruit.myshopify.com"
        urlComponents.path = "/admin/products.json"
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: String(page ?? 1)),
           URLQueryItem(name: "access_token", value: accessToken)
        ]
        
        return urlComponents.url
    }
    static func getItems(page: Int?, progressView: UIProgressView, completion: @escaping (_ success: Bool, _ results: Items?, _ error: Error?) -> Void) {
        
        guard let url = url(with: page) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
        guard let dataResponse = data,
                  error == nil else {
                  print(error?.localizedDescription ?? "Response Error")
                  return }
            
            do{
                let jsonResponse = try JSONSerialization.jsonObject(with:
                                       dataResponse, options: [])
                print(jsonResponse) //Response result
                let decoder = JSONDecoder()
                let items = try decoder.decode(Items.self, from: dataResponse)
                completion(true, items, nil)

             } catch let parsingError {
                completion(false, nil, parsingError)
           }
        }
        task.resume()
        progressView.observedProgress = task.progress
    }
    
    static func getAssets(from url: URL, completion: @escaping (_ success: Bool, _ image: UIImage?, _ error: Error?) -> Void) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data, error == nil else {
                print(error?.localizedDescription ?? "Response Error")
                completion(false, nil, error)
                return }
            completion(true, UIImage(data: dataResponse), nil)
        }
        return task
    }
    
}
