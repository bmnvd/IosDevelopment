//
//  FavoritesManager.swift
//  BaimenovNews
//
//  Created by Daniyal Baimenov on 18.12.2025.
//

import Foundation

/// Manager class for handling favorite articles persistence using UserDefaults
class FavoritesManager {
    
    // Singleton instance
    static let shared = FavoritesManager()
    
    private let favoritesKey = "FavoriteArticles"
    
    private init() {}
    
    /// Save an article to favorites
    /// - Parameter article: The article to save
    func addFavorite(_ article: Article) {
        var favorites = getFavorites()
        
        // Check if article already exists
        if !favorites.contains(where: { $0.id == article.id }) {
            favorites.append(article)
            saveFavorites(favorites)
        }
    }
    
    /// Remove an article from favorites
    /// - Parameter article: The article to remove
    func removeFavorite(_ article: Article) {
        var favorites = getFavorites()
        favorites.removeAll { $0.id == article.id }
        saveFavorites(favorites)
    }
    
    /// Check if an article is favorited
    /// - Parameter article: The article to check
    /// - Returns: True if article is in favorites
    func isFavorite(_ article: Article) -> Bool {
        let favorites = getFavorites()
        return favorites.contains(where: { $0.id == article.id })
    }
    
    /// Get all favorite articles
    /// - Returns: Array of favorite articles
    func getFavorites() -> [Article] {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey),
              let favorites = try? JSONDecoder().decode([Article].self, from: data) else {
            return []
        }
        return favorites
    }
    
    /// Save favorites array to UserDefaults
    /// - Parameter favorites: Array of articles to save
    private func saveFavorites(_ favorites: [Article]) {
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        }
    }
}


