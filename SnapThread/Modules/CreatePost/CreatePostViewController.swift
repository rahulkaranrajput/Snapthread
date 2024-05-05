//
//  CreatePostViewController.swift
//  SnapThread
//
//  Created by Rahul K on 30/04/24.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth

class CreatePostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let viewModel = PostViewModel()
    
    // MARK: - UI Elements
    private let imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)
        collectionView.allowsMultipleSelection = true
        return collectionView
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .systemGray6
        textView.layer.cornerRadius = 8
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.text = "Enter post description..."
        textView.textColor = .placeholderText
        return textView
    }()
    
    private let addImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Images", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(addImageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Post", for: .normal)
        button.backgroundColor = .systemGreen
        button.tintColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(postButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var selectedImages = [UIImage]()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(imageCollectionView)
        view.addSubview(descriptionTextView)
        view.addSubview(addImageButton)
        view.addSubview(postButton)
        
        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        postButton.translatesAutoresizingMaskIntoConstraints = false
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        descriptionTextView.delegate = self
        
        NSLayoutConstraint.activate([
            imageCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageCollectionView.heightAnchor.constraint(equalToConstant: 100),
            
            descriptionTextView.topAnchor.constraint(equalTo: imageCollectionView.bottomAnchor, constant: 20),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 100),
            
            addImageButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20),
            addImageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addImageButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addImageButton.heightAnchor.constraint(equalToConstant: 44),
            
            postButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            postButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            postButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            postButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - Actions
    @objc private func addImageButtonTapped() {
        presentImagePicker()
    }
    
    @objc private func postButtonTapped() {
        guard !selectedImages.isEmpty else {
            showAlert(title: "Error", message: "Please select at least one image.")
            return
        }
        
        let postDescription = descriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        self.showLoader()
        viewModel.onDataUpload = { [weak self] in
            DispatchQueue.main.async {
                self?.hideLoader()
                self?.dismiss(animated: true, completion: nil)
            }
        }
        
        viewModel.uploadPost(description: postDescription, images: selectedImages)
    }
    
    // MARK: - Image Picker
    private func presentImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImages.append(editedImage)
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImages.append(originalImage)
        }
        
        imageCollectionView.reloadData()
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDataSource
extension CreatePostViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier, for: indexPath) as! ImageCollectionViewCell
        cell.configure(with: selectedImages[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CreatePostViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Handle image selection
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // Handle image deselection
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CreatePostViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}

// MARK: - UITextViewDelegate
extension CreatePostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter post description..." {
            textView.text = ""
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter post description..."
            textView.textColor = .placeholderText
        }
    }
}
