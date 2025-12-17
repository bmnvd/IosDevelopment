//
//  ArticleDetailViewController.swift
//  BaimenovNews
//
//  Created by Daniyal Baimenov on 18.12.2025.
//

import UIKit

/// View controller for displaying full article details
class ArticleDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var mainStackView: UIStackView!
    
    // MARK: - Properties
    var article: Article?
    private var imageTask: URLSessionDataTask?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureWithArticle()
        updateFavoriteButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Update favorite button state in case it changed elsewhere
        updateFavoriteButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Cancel image loading if view is disappearing
        imageTask?.cancel()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Article Details"
        
        // Configure image view
        articleImageView.contentMode = .scaleAspectFill
        articleImageView.clipsToBounds = true
        articleImageView.backgroundColor = .systemGray5
        
        // Configure labels
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .label
        
        sourceLabel.font = UIFont.systemFont(ofSize: 14)
        sourceLabel.textColor = .secondaryLabel
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .label
        
        // Configure stack view
        mainStackView.spacing = 16
        mainStackView.axis = .vertical
        mainStackView.alignment = .fill
        mainStackView.distribution = .fill
    }
    
    // MARK: - Configuration
    private func configureWithArticle() {
        guard let article = article else { return }
        
        titleLabel.text = article.title
        sourceLabel.text = article.source
        descriptionLabel.text = article.description
        
        // Load image
        if let imageURLString = article.imageURL, let imageURL = URL(string: imageURLString) {
            loadImage(from: imageURL)
        } else {
            articleImageView.image = UIImage(systemName: "photo")
            articleImageView.tintColor = .systemGray3
        }
    }
    
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
    
    private func updateFavoriteButton() {
        guard let article = article else { return }
        
        let isFavorite = FavoritesManager.shared.isFavorite(article)
        favoriteButton.image = isFavorite ? 
            UIImage(systemName: "heart.fill") : 
            UIImage(systemName: "heart")
        favoriteButton.tintColor = isFavorite ? .systemRed : .systemBlue
    }
    
    // MARK: - Actions
    @IBAction func favoriteButtonTapped(_ sender: UIBarButtonItem) {
        guard let article = article else { return }
        
        let isFavorite = FavoritesManager.shared.isFavorite(article)
        
        if isFavorite {
            FavoritesManager.shared.removeFavorite(article)
        } else {
            FavoritesManager.shared.addFavorite(article)
        }
        
        // Animate button update
        UIView.animate(withDuration: 0.2, animations: {
            self.updateFavoriteButton()
        })
        
        // Show feedback
        let message = isFavorite ? "Removed from favorites" : "Added to favorites"
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            alert.dismiss(animated: true)
        }
    }
}

