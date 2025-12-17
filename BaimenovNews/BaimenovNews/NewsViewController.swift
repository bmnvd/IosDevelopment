//
//  NewsViewController.swift
//  BaimenovNews
//
//  Created by Daniyal Baimenov on 18.12.2025.
//

import UIKit

/// View controller for displaying news articles in a table view
class NewsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Properties
    private var articles: [Article] = []
    private var filteredArticles: [Article] = []
    private var currentPage = 1
    private var isLoading = false
    private var hasMorePages = true
    private let pageSize = 20
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupSearchBar()
        loadNews()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "News"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Add refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        
        // Register cell if not using Storyboard
        // tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search articles..."
    }
    
    // MARK: - Data Loading
    /// Load news articles from API
    private func loadNews(page: Int = 1, append: Bool = false) {
        guard !isLoading else { return }
        
        isLoading = true
        
        // Show loading indicator
        if !append {
            showLoadingIndicator()
        }
        
        NetworkManager.shared.fetchNews(page: page, pageSize: pageSize) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                self.hideLoadingIndicator()
                self.tableView.refreshControl?.endRefreshing()
                
                switch result {
                case .success(let newArticles):
                    if append {
                        self.articles.append(contentsOf: newArticles)
                    } else {
                        self.articles = newArticles
                    }
                    
                    // Check if we have more pages (simplified - in real app, check total results)
                    self.hasMorePages = newArticles.count == self.pageSize
                    
                    // Update filtered articles
                    self.filterArticles()
                    
                    // Animate table view update
                    UIView.transition(with: self.tableView,
                                    duration: 0.3,
                                    options: .transitionCrossDissolve,
                                    animations: {
                        self.tableView.reloadData()
                    })
                    
                case .failure(let error):
                    self.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    /// Refresh news articles
    @objc private func refreshNews() {
        currentPage = 1
        hasMorePages = true
        loadNews(page: currentPage, append: false)
    }
    
    /// Filter articles based on search text
    private func filterArticles() {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            filteredArticles = articles
            return
        }
        
        let lowercasedSearch = searchText.lowercased()
        filteredArticles = articles.filter { article in
            article.title.lowercased().contains(lowercasedSearch) ||
            article.description.lowercased().contains(lowercasedSearch) ||
            article.source.lowercased().contains(lowercasedSearch)
        }
    }
    
    // MARK: - Helper Methods
    private func showLoadingIndicator() {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.startAnimating()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)
        tableView.tableFooterView = activityIndicator
    }
    
    private func hideLoadingIndicator() {
        tableView.tableFooterView = nil
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsTableViewCell.identifier,
            for: indexPath
        ) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        
        let article = filteredArticles[indexPath.row]
        cell.configure(with: article)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let article = filteredArticles[indexPath.row]
        
        // Navigate to detail view
        guard let detailVC = storyboard?.instantiateViewController(
            withIdentifier: "ArticleDetailViewController"
        ) as? ArticleDetailViewController else {
            return
        }
        
        detailVC.article = article
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Load more articles when scrolling near the end
        if indexPath.row == filteredArticles.count - 3 && hasMorePages && !isLoading {
            currentPage += 1
            loadNews(page: currentPage, append: true)
        }
    }
}

// MARK: - UISearchBarDelegate
extension NewsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterArticles()
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        filterArticles()
        tableView.reloadData()
    }
}


