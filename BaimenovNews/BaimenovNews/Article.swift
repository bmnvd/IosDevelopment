//
//  Article.swift
//  BaimenovNews
//
//  Created by Daniyal Baimenov on 18.12.2025.
//

import Foundation

/// Model representing a news article
struct Article: Codable, Equatable {
    let id: String
    let title: String
    let description: String
    let imageURL: String?
    let source: String
    let publishedAt: String?
    
    // Custom initializer for creating dummy articles
    init(id: String = UUID().uuidString, title: String, description: String, imageURL: String? = nil, source: String, publishedAt: String? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.source = source
        self.publishedAt = publishedAt
    }
    
    // CodingKeys for JSON mapping
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case imageURL = "urlToImage"
        case source
        case publishedAt
    }
    
    // Nested Source struct for API response
    struct Source: Codable {
        let name: String
    }
    
    // Alternative decoding for NewsAPI format
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Try to decode id, if not present generate one
        if let idValue = try? container.decode(String.self, forKey: .id) {
            self.id = idValue
        } else {
            self.id = UUID().uuidString
        }
        
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        self.imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL)
        
        // Handle source - can be string or object
        if let sourceName = try? container.decode(String.self, forKey: .source) {
            self.source = sourceName
        } else if let sourceObject = try? container.decode(Source.self, forKey: .source) {
            self.source = sourceObject.name
        } else {
            self.source = "Unknown"
        }
        
        self.publishedAt = try container.decodeIfPresent(String.self, forKey: .publishedAt)
    }
    
    // Encoding implementation
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encodeIfPresent(imageURL, forKey: .imageURL)
        try container.encode(source, forKey: .source)
        try container.encodeIfPresent(publishedAt, forKey: .publishedAt)
    }
}

/// Response wrapper for API calls
struct ArticlesResponse: Codable {
    let articles: [Article]
    let totalResults: Int?
}

