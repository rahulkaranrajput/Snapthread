//
//  HomeViewController.swift
//  SnapThread
//
//  Created by Rahul K on 30/04/24.
//

import UIKit
import FirebaseFirestore

class HomeViewController: UIViewController {
    
    private let viewModel = HomeViewModel()
    
    // MARK: - UI Elements
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.isPagingEnabled = true
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    private let noPostsLabel: UILabel = {
        let label = UILabel()
        label.text = "No posts yet"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    private let createPostPromptLabel: UILabel = {
        let label = UILabel()
        label.text = "Start creating your first post!"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    private var posts = [Post]()
    
    lazy var availableHeight: CGFloat = {
        var availableHeight = UIScreen.main.bounds.height
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let statusBarManager = windowScene.statusBarManager {
            availableHeight -= statusBarManager.statusBarFrame.height
        }
        
        if let navigationBarHeight = navigationController?.navigationBar.frame.height {
            availableHeight -= navigationBarHeight
        }
        
        if let tabBarHeight = tabBarController?.tabBar.frame.height {
            availableHeight -= tabBarHeight
        }
        return availableHeight
    }()
    
    lazy var tabBarHeight = {
       return tabBarController?.tabBar.frame.height ?? 0
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.onDataFetch = { [weak self] (fetchedPosts) in
            self?.posts = fetchedPosts
            self?.collectionView.reloadData()
            if fetchedPosts.isEmpty {
                self?.showEmptyState()
            } else {
                self?.hideEmptyState()
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchPosts()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(noPostsLabel)
        view.addSubview(createPostPromptLabel)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        noPostsLabel.translatesAutoresizingMaskIntoConstraints = false
        createPostPromptLabel.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -tabBarHeight),
            
            noPostsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noPostsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            createPostPromptLabel.topAnchor.constraint(equalTo: noPostsLabel.bottomAnchor, constant: 16),
            createPostPromptLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Data Fetching
    private func fetchPosts() {
        let postsRef = Firestore.firestore().collection("posts")
        postsRef.getDocuments { [weak self] snapshot, error in
            if let error = error {
                print("Error fetching posts: \(error.localizedDescription)")
                return
            }
            guard let documents = snapshot?.documents else {
                self?.showEmptyState()
                return
            }
            
            var fetchedPosts = [Post]()
            for document in documents {
                if let post = try? document.data(as: Post.self) {
                    fetchedPosts.append(post)
                }
            }
        }
    }
    
    // MARK: - Empty State Handling
    private func showEmptyState() {
        noPostsLabel.isHidden = false
        createPostPromptLabel.isHidden = false
    }
    
    private func hideEmptyState() {
        noPostsLabel.isHidden = true
        createPostPromptLabel.isHidden = true
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.reuseIdentifier, for: indexPath) as! PostCollectionViewCell
        cell.post = posts[indexPath.row]
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: availableHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
