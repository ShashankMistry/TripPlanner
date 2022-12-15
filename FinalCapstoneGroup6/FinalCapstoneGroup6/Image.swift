//
//  Image.swift
//  FinalCapstoneGroup6
//
//  Created by user213797 on 12/6/22.
//

import UIKit

class Image  : Equatable{
    let author: String
    let download_url: String
    let id: Int
    let description: String
    
    init(id: Int, download_url: String, author: String, description: String) {
        self.author = author
        self.download_url = download_url
        self.id = id
        self.description = description
    }
    
    static func == (lhs: Image, rhs: Image)->Bool {
        return lhs.id == rhs.id
    }
    
}
