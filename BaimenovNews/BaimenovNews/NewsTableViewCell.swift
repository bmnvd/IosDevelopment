//
//  NewsTableViewCell.swift
//  BaimenovNews
//
//  Created by Daniyal Baimenov on 18.12.2025.
//

import UIKit

/// Custom table view cell for displaying news articles
class NewsTableViewCell: UITableViewCell {
    
    // MARK: - UI Elements
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var imageContainerView: UIView!
    
    // MARK: - Properties
    static let identifier = "NewsCell"
    private var imageTask: URLSessionDataTask?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Cancel any ongoing image download
        imageTask?.cancel()
        imageTask = nil
        articleImageView.image = nil
        titleLabel.text = nil
        sourceLabel.text = nil
        descriptionLabel.text = nil
    }
    
    // MARK: - Setup
    private func setupUI() {
        // Configure image view
        articleImageView.contentMode = .scaleAspectFill
        articleImageView.clipsToBounds = true
        articleImageView.layer.cornerRadius = 8
        articleImageView.backgroundColor = .systemGray5
        
        // Configure labels
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .label
        
        sourceLabel.font = UIFont.systemFont(ofSize: 12)
        sourceLabel.textColor = .secondaryLabel
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 3
        descriptionLabel.textColor = .secondaryLabel
        
        // Set selection style
        selectionStyle = .default
    }
    
    // MARK: - Configuration
    /// Configure cell with article data
    /// - Parameter article: The article to display
    func configure(with article: Article) {
        titleLabel.text = article.title
        sourceLabel.text = article.source
        descriptionLabel.text = article.description
        
        // Load image asynchronously
        if let imageURLString = article.imageURL, let imageURL = URL(string: imageURLString) {
            loadImage(from: imageURL)
        } else {
            articleImageView.image = UIImage(systemName: "photo")
            articleImageView.tintColor = .systemGray3
        }
    }
    
    /// Load image from URL asynchronously
    /// - Parameter url: The image URL
    private func loadImage(from url: URL) {
        // Cancel previous task
        imageTask?.cancel()
        
        // Set placeholder
        articleImageView.image = UIImage(systemName: "photo")
        articleImageView.tintColor = .systemGray3
        
        // Load image
        imageTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data),
                  error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                UIView.transition(with: self.articleImageView,
                                duration: 0.3,
                                options: .transitionCrossDissolve,
                                animations: {
                    self.articleImageView.image = image
                })
            }
        }
        
        imageTask?.resume()
    }
}


