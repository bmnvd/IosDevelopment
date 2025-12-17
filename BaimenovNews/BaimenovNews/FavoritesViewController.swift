//
//  FavoritesViewController.swift
//  BaimenovNews
//
//  Created by Daniyal Baimenov on 18.12.2025.
//

import UIKit

/// View controller for displaying and managing favorite articles
class FavoritesViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyStateLabel: UILabel!
    
    // MARK: - Properties
    private var favoriteArticles: [Article] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Configure empty state
        emptyStateLabel.text = "No favorite articles yet.\nAdd articles from the News tab!"
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.numberOfLines = 0
        emptyStateLabel.font = UIFont.systemFont(ofSize: 16)
        emptyStateLabel.textColor = .secondaryLabel
        emptyStateLabel.isHidden = true
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        
        // Enable editing
        tableView.allowsMultipleSelectionDuringEditing = false
    }
    
    // MARK: - Data Loading
    private func loadFavorites() {
        favoriteArticles = FavoritesManager.shared.getFavorites()
        updateUI()
    }
    
    private func updateUI() {
        let hasFavorites = !favoriteArticles.isEmpty
        tableView.isHidden = !hasFavorites
        emptyStateLabel.isHidden = hasFavorites
        
        UIView.transition(with: tableView,
                        duration: 0.3,
                        options: .transitionCrossDissolve,
                        animations: {
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Actions
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        let isEditing = tableView.isEditing
        tableView.setEditing(!isEditing, animated: true)
        sender.title = isEditing ? "Edit" : "Done"
    }
}

// MARK: - UITableViewDataSource
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsTableViewCell.identifier,
            for: indexPath
        ) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        
        let article = favoriteArticles[indexPath.row]
        cell.configure(with: article)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let article = favoriteArticles[indexPath.row]
            FavoritesManager.shared.removeFavorite(article)
            
            // Animate removal
            favoriteArticles.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // Update UI after animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.updateUI()
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let article = favoriteArticles[indexPath.row]
        
        // Navigate to detail view
        guard let detailVC = storyboard?.instantiateViewController(
            withIdentifier: "ArticleDetailViewController"
        ) as? ArticleDetailViewController else {
            return
        }
        
        detailVC.article = article
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }
}


