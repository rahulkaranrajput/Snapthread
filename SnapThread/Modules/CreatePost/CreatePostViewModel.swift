//
//  CreatePostViewModel.swift
//  SnapThread
//
//  Created by Rahul K on 05/05/24.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class PostViewModel {
    var onDataUpload: (() -> Void)?
    
    func uploadPost(description: String, images: [UIImage]) {
        
        var imageUrls = [String]()
        let dispatchGroup = DispatchGroup()
        
        for image in images {
            dispatchGroup.enter()
            
            let imageData = image.jpegData(compressionQuality: 0.8)
            let imageName = UUID().uuidString
            let storageRef = Storage.storage().reference().child("posts/\(imageName).jpg")
            
            storageRef.putData(imageData!, metadata: nil) { metadata, error in
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                    dispatchGroup.leave()
                    return
                }
                
                storageRef.downloadURL { url, error in
                    if let error = error {
                        print("Error getting image URL: \(error.localizedDescription)")
                    } else if let url = url?.absoluteString {
                        imageUrls.append(url)
                    }
                    
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            
            let postData = Post(imageUrls: imageUrls,
                                postCreationDate: Date(),
                                userId: Auth.auth().currentUser?.uid ?? "Unknown",
                                postDescription: description)
            
            self.savePostToFirestore(postData)
        }
    }
    
    private func savePostToFirestore(_ postData: Post) {
        let postsRef = Firestore.firestore().collection("posts").document()
        
        do {
            try postsRef.setData(from: postData) { error in
                if let error = error {
                    print("Error saving post to Firestore: \(error.localizedDescription)")
                } else {
                    print("Post saved successfully")
                    self.onDataUpload?()
                }
            }
        } catch {
            print("Error encoding post data: \(error.localizedDescription)")
        }
    }
}
