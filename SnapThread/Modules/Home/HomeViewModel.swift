//
//  HomeViewModel.swift
//  SnapThread
//
//  Created by Rahul K on 05/05/24.
//

import Foundation
import FirebaseFirestore

class HomeViewModel {
    var onDataFetch: (([Post]) -> Void)?
    
    func fetchPosts() {
        let postsRef = Firestore.firestore().collection("posts")
        postsRef.getDocuments { [weak self] snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                print("Error fetching posts: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            var fetchedPosts = [Post]()
            for document in documents {
                if let post = try? document.data(as: Post.self) {
                    fetchedPosts.append(post)
                }
            }
            self?.onDataFetch?(fetchedPosts)
        }
    }
}

