//
//  FavoritesManagerTests.swift
//  BaimenovNewsTests
//
//  Created by Daniyal Baimenov on 18.12.2025.
//

import XCTest
@testable import BaimenovNews

/// Unit tests for FavoritesManager and UserDefaults storage
class FavoritesManagerTests: XCTestCase {
    
    var favoritesManager: FavoritesManager!
    let testUserDefaults = UserDefaults(suiteName: "TestFavorites")!
    
    override func setUp() {
        super.setUp()
        favoritesManager = FavoritesManager.shared
        
        // Clear test data
        testUserDefaults.removeObject(forKey: "FavoriteArticles")
    }
    
    override func tearDown() {
        // Clean up test data
        testUserDefaults.removeObject(forKey: "FavoriteArticles")
        super.tearDown()
    }
    
    func testAddFavorite() {
        // Given
        let article = Article(title: "Test Article", description: "Test Description", source: "Test Source")
        
        // When
        favoritesManager.addFavorite(article)
        
        // Then
        let favorites = favoritesManager.getFavorites()
        XCTAssertTrue(favorites.contains(where: { $0.id == article.id }))
    }
    
    func testRemoveFavorite() {
        // Given
        let article = Article(title: "Test Article", description: "Test Description", source: "Test Source")
        favoritesManager.addFavorite(article)
        
        // When
        favoritesManager.removeFavorite(article)
        
        // Then
        let favorites = favoritesManager.getFavorites()
        XCTAssertFalse(favorites.contains(where: { $0.id == article.id }))
    }
    
    func testIsFavorite() {
        // Given
        let article = Article(title: "Test Article", description: "Test Description", source: "Test Source")
        
        // When/Then - Initially not favorite
        XCTAssertFalse(favoritesManager.isFavorite(article))
        
        // When - Add to favorites
        favoritesManager.addFavorite(article)
        
        // Then - Should be favorite
        XCTAssertTrue(favoritesManager.isFavorite(article))
    }
    
    func testGetFavorites() {
        // Given
        let article1 = Article(title: "Article 1", description: "Desc 1", source: "Source 1")
        let article2 = Article(title: "Article 2", description: "Desc 2", source: "Source 2")
        
        // When
        favoritesManager.addFavorite(article1)
        favoritesManager.addFavorite(article2)
        
        // Then
        let favorites = favoritesManager.getFavorites()
        XCTAssertEqual(favorites.count, 2)
        XCTAssertTrue(favorites.contains(where: { $0.id == article1.id }))
        XCTAssertTrue(favorites.contains(where: { $0.id == article2.id }))
    }
    
    func testPreventDuplicateFavorites() {
        // Given
        let article = Article(title: "Test Article", description: "Test Description", source: "Test Source")
        
        // When - Add same article twice
        favoritesManager.addFavorite(article)
        favoritesManager.addFavorite(article)
        
        // Then - Should only have one instance
        let favorites = favoritesManager.getFavorites()
        let articleCount = favorites.filter { $0.id == article.id }.count
        XCTAssertEqual(articleCount, 1)
    }
    
    func testFavoritesPersistence() {
        // Given
        let article = Article(id: "test-id", title: "Test Article", description: "Test Description", source: "Test Source")
        favoritesManager.addFavorite(article)
        
        // When - Create new manager instance (simulating app restart)
        let newManager = FavoritesManager.shared
        
        // Then - Favorites should persist
        let favorites = newManager.getFavorites()
        XCTAssertTrue(favorites.contains(where: { $0.id == article.id }))
    }
    
    func testEmptyFavorites() {
        // When
        let favorites = favoritesManager.getFavorites()
        
        // Then
        XCTAssertTrue(favorites.isEmpty)
    }
}


