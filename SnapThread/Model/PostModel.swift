//
//  PostModel.swift
//  SnapThread
//
//  Created by Rahul K on 05/05/24.
//

import Foundation

// MARK: - Post Model
struct Post: Codable {
    let imageUrls: [String]
    let postCreationDate: Date
    let userId: String
    let postDescription: String
    
    enum CodingKeys: String, CodingKey {
        case imageUrls
        case postCreationDate
        case userId
        case postDescription
    }
}
