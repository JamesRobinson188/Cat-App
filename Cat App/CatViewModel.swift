//
//  CatViewModel.swift
//  Cat App
//
//  Created by James Robinson on 15/10/2024.
//

import Foundation
import SwiftUI

class CatViewModel: ObservableObject {
    @Published var catImages: [CatImage] = []
    @Published var currentIndex: Int = 0
    private let apiKey = "live_2SFIq1tq1q8LS41asl84txsJNWVQM4UY8yabs3P2Ex4krqDoIilFNb0Acmh8jrnU"
    private var isLoading = false
    private let prefetchThreshold = 5

    init() {
        fetchMoreCats()
    }

    func fetchMoreCats() {
        guard !isLoading else { return }
        isLoading = true
        let limit = 10
        guard let url = URL(string: "https://api.thecatapi.com/v1/images/search?limit=\(limit)&size=full") else {
            isLoading = false
            return
        }
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            defer { DispatchQueue.main.async { self?.isLoading = false } }
            if let data = data {
                do {
                    let cats = try JSONDecoder().decode([CatImage].self, from: data)
                    DispatchQueue.main.async {
                        self?.catImages.append(contentsOf: cats)
                        // Preload images
                        cats.forEach { self?.preloadImage(urlString: $0.url) }
                    }
                } catch {
                    print("Decoding error: \(error)")
                }
            } else if let error = error {
                print("Network error: \(error)")
            }
        }.resume()
    }

    private func preloadImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { _, _, _ in }.resume()
    }
}
