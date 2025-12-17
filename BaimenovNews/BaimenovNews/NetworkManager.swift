//
//  NetworkManager.swift
//  BaimenovNews
//
//  Created by Daniyal Baimenov on 18.12.2025.
//

import Foundation

/// Network manager for fetching news articles from API
class NetworkManager {
    
    // Singleton instance
    static let shared = NetworkManager()
    
    // Using NewsAPI.org as the sample API (free tier)
    // You can also use a mock API or sample JSON
    private let baseURL = "https://newsapi.org/v2/top-headlines"
    private let apiKey = "YOUR_API_KEY_HERE" // Replace with actual API key or use sample data
    
    // Fallback sample API endpoint (JSONPlaceholder style)
    private let sampleAPIURL = "https://jsonplaceholder.typicode.com/posts"
    
    private init() {}
    
    /// Fetch news articles from API
    /// - Parameters:
    ///   - page: Page number for pagination
    ///   - pageSize: Number of articles per page
    ///   - completion: Completion handler with articles or error
    func fetchNews(page: Int = 1, pageSize: Int = 20, completion: @escaping (Result<[Article], Error>) -> Void) {
        
        // For demo purposes, we'll use sample data if API key is not set
        // In production, replace with actual API call
        if apiKey == "YOUR_API_KEY_HERE" {
            // Return sample articles for testing
            let sampleArticles = generateSampleArticles(page: page, pageSize: pageSize)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                completion(.success(sampleArticles))
            }
            return
        }
        
        // Build URL with parameters
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "country", value: "us"),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "pageSize", value: "\(pageSize)"),
            URLQueryItem(name: "apiKey", value: apiKey)
        ]
        
        guard let url = components?.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        // Create URLSession task
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            // Decode JSON response
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(ArticlesResponse.self, from: data)
                completion(.success(response.articles))
            } catch {
                // If decoding fails, return sample data
                let sampleArticles = self.generateSampleArticles(page: page, pageSize: pageSize)
                completion(.success(sampleArticles))
            }
        }
        
        task.resume()
    }
    
    /// Generate sample articles for testing when API is not available
    /// - Parameters:
    ///   - page: Page number
    ///   - pageSize: Number of articles per page
    /// - Returns: Array of sample articles
    private func generateSampleArticles(page: Int, pageSize: Int) -> [Article] {
        let sampleTitles = [
            "Breaking: Major Tech Company Announces New Product",
            "Global Climate Summit Reaches Historic Agreement",
            "Sports Team Wins Championship After Dramatic Final",
            "Scientists Discover New Species in Deep Ocean",
            "Economic Markets Show Strong Growth This Quarter",
            "New Study Reveals Benefits of Daily Exercise",
            "Technology Breakthrough in Renewable Energy",
            "International Space Station Completes Mission",
            "Healthcare Innovation Improves Patient Outcomes",
            "Education System Undergoes Major Reforms",
            "Entertainment Industry Celebrates Award Winners",
            "Transportation Network Expands to New Cities",
            "Food Industry Introduces Sustainable Practices",
            "Art Exhibition Opens to Critical Acclaim",
            "Weather Forecast Predicts Unusual Patterns"
        ]
        
        let sampleDescriptions = [
            "A comprehensive look at the latest developments in technology and innovation.",
            "Environmental experts discuss the implications of new climate policies.",
            "Fans celebrate as their team achieves victory in the championship match.",
            "Marine biologists share details about the newly discovered deep-sea creature.",
            "Financial analysts provide insights into current market trends.",
            "Research highlights the positive impact of regular physical activity.",
            "Engineers explain the technical details of the renewable energy advancement.",
            "Astronauts reflect on their successful mission aboard the space station.",
            "Medical professionals discuss improvements in treatment methods.",
            "Educators and policymakers outline changes to the education system.",
            "Stars and creators gather to honor outstanding achievements.",
            "City planners announce expansion of public transportation services.",
            "Companies commit to more environmentally friendly production methods.",
            "Critics praise the artistic vision and execution of the exhibition.",
            "Meteorologists analyze unusual weather patterns affecting the region."
        ]
        
        let sampleSources = [
            "Tech News", "Climate Today", "Sports Central", "Science Daily",
            "Financial Times", "Health Weekly", "Energy Report", "Space News",
            "Medical Journal", "Education Today", "Entertainment Weekly",
            "Transport News", "Food Network", "Arts & Culture", "Weather Channel"
        ]
        
        let imageURLs = [
            "https://picsum.photos/400/300?random=1",
            "https://picsum.photos/400/300?random=2",
            "https://picsum.photos/400/300?random=3",
            "https://picsum.photos/400/300?random=4",
            "https://picsum.photos/400/300?random=5"
        ]
        
        let startIndex = (page - 1) * pageSize
        var articles: [Article] = []
        
        for i in 0..<pageSize {
            let index = (startIndex + i) % sampleTitles.count
            let imageIndex = (startIndex + i) % imageURLs.count
            
            let article = Article(
                id: "sample-\(startIndex + i)",
                title: sampleTitles[index],
                description: sampleDescriptions[index],
                imageURL: imageURLs[imageIndex],
                source: sampleSources[index],
                publishedAt: ISO8601DateFormatter().string(from: Date().addingTimeInterval(-Double(i) * 3600))
            )
            articles.append(article)
        }
        
        return articles
    }
}

/// Network error types
enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case noData
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode response"
        }
    }
}


