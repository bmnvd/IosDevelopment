//
//  ArticleTests.swift
//  BaimenovNewsTests
//
//  Created by Daniyal Baimenov on 18.12.2025.
//

import XCTest
@testable import BaimenovNews

/// Unit tests for Article model and JSON decoding
class ArticleTests: XCTestCase {
    
    func testArticleInitialization() {
        // Given
        let title = "Test Article"
        let description = "Test Description"
        let source = "Test Source"
        
        // When
        let article = Article(title: title, description: description, source: source)
        
        // Then
        XCTAssertEqual(article.title, title)
        XCTAssertEqual(article.description, description)
        XCTAssertEqual(article.source, source)
        XCTAssertNotNil(article.id)
    }
    
    func testArticleEquality() {
        // Given
        let id = UUID().uuidString
        let article1 = Article(id: id, title: "Title", description: "Desc", source: "Source")
        let article2 = Article(id: id, title: "Title", description: "Desc", source: "Source")
        
        // Then
        XCTAssertEqual(article1, article2)
    }
    
    func testArticleJSONDecoding() {
        // Given
        let jsonString = """
        {
            "title": "Test Article",
            "description": "Test Description",
            "urlToImage": "https://example.com/image.jpg",
            "source": {
                "name": "Test Source"
            },
            "publishedAt": "2025-12-18T10:00:00Z"
        }
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        
        // When
        do {
            let article = try JSONDecoder().decode(Article.self, from: jsonData)
            
            // Then
            XCTAssertEqual(article.title, "Test Article")
            XCTAssertEqual(article.description, "Test Description")
            XCTAssertEqual(article.imageURL, "https://example.com/image.jpg")
            XCTAssertEqual(article.source, "Test Source")
            XCTAssertEqual(article.publishedAt, "2025-12-18T10:00:00Z")
        } catch {
            XCTFail("Failed to decode article: \(error)")
        }
    }
    
    func testArticleJSONDecodingWithStringSource() {
        // Given
        let jsonString = """
        {
            "title": "Test Article",
            "description": "Test Description",
            "source": "Test Source"
        }
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        
        // When
        do {
            let article = try JSONDecoder().decode(Article.self, from: jsonData)
            
            // Then
            XCTAssertEqual(article.source, "Test Source")
        } catch {
            XCTFail("Failed to decode article: \(error)")
        }
    }
    
    func testArticlesResponseDecoding() {
        // Given
        let jsonString = """
        {
            "articles": [
                {
                    "title": "Article 1",
                    "description": "Description 1",
                    "source": "Source 1"
                },
                {
                    "title": "Article 2",
                    "description": "Description 2",
                    "source": "Source 2"
                }
            ],
            "totalResults": 2
        }
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        
        // When
        do {
            let response = try JSONDecoder().decode(ArticlesResponse.self, from: jsonData)
            
            // Then
            XCTAssertEqual(response.articles.count, 2)
            XCTAssertEqual(response.articles[0].title, "Article 1")
            XCTAssertEqual(response.articles[1].title, "Article 2")
            XCTAssertEqual(response.totalResults, 2)
        } catch {
            XCTFail("Failed to decode articles response: \(error)")
        }
    }
}


