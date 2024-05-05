//
//  PostCollectionViewCell.swift
//  SnapThread
//
//  Created by Rahul K on 05/05/24.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "PostCollectionViewCell"
    
    var post: Post? {
        didSet {
            updateUI()
        }
    }
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .systemBlue
        pageControl.pageIndicatorTintColor = .systemGray
        return pageControl
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    private var imageViews: [UIImageView] = []
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(scrollView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(pageControl)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20.0),
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50)
        ])
        
        scrollView.delegate = self
    }
    
    private func updateUI() {
        guard let post = post else {
            return
        }
        descriptionLabel.text = post.postDescription
        pageControl.numberOfPages = post.imageUrls.count
        
        // Remove existing image views
        for imageView in imageViews {
            imageView.removeFromSuperview()
        }
        imageViews.removeAll()
        
        // Add image views for each image URL
        for imageUrlString in post.imageUrls {
            if let imageUrl = URL(string: imageUrlString) {
                let imageView = UIImageView()
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                scrollView.addSubview(imageView)
                imageViews.append(imageView)
                
                // Load image from URL asynchronously
                loadImage(from: imageUrl, into: imageView)
            }
        }
        
        // Layout image views in the scroll view
        layoutImageViews()
    }
    
    private func loadImage(from url: URL, into imageView: UIImageView) {
        // Asynchronously load image from URL
        URLSession.shared.dataTask(with: url) { [weak self, weak imageView] data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                print("Error loading image from URL: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.main.async {
                imageView?.image = image
            }
        }.resume()
    }
    
    private func layoutImageViews() {
        // Set frame for each image view in the scroll view
        var xOffset: CGFloat = 0
        let yOffset: CGFloat = 0
        let scrollViewWidth = scrollView.bounds.width
        let scrollViewHeight = scrollView.bounds.height
        
        for imageView in imageViews {
            imageView.frame = CGRect(x: xOffset, y: yOffset, width: scrollViewWidth, height: scrollViewHeight)
            print("scrollViewWidth",scrollViewWidth, scrollViewHeight)
            xOffset += scrollViewWidth
        }
        
        // Set content size of the scroll view
        scrollView.contentSize = CGSize(width: xOffset, height: scrollViewHeight)
    }
}

// MARK: - UIScrollViewDelegate
extension PostCollectionViewCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(round(scrollView.contentOffset.x / scrollView.bounds.width))
        pageControl.currentPage = pageIndex
    }
}
