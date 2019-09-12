//
//  ProductAsset.swift
//  pattern-matching-game
//
//  Created by Joshua Kuan on 9/11/19.
//  Copyright © 2019 Joshua Kuan. All rights reserved.
//

import Foundation

// https://shopicruit.myshopify.com/admin/products.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6

class Items: Decodable{
    struct Products: Decodable {
        struct Image: Decodable {
            let src: String
        }
        let image: Image
        
    }
    
    let products: [Products]
}
