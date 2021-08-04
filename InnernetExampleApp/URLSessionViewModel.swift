//
//  URLSessionViewModel.swift
//  InnernetExampleApp
//
//  Created by AJ Bartocci on 8/4/21.
//

import Foundation

// This example tightly couples URLSession to the view model
class URLSessionViewModel: ObservableObject {
    @Published var errorMessage: String?
    @Published var items: [ExampleItem] = []
    
    func download() {
        let url = URL(string: "https://somefakedomain.com/items")!
        let req = URLRequest(url: url)
        session.dataTask(with: req) { [weak self] data, _, error in
            DispatchQueue.main.async {
                if let data = data {
                    self?.errorMessage = nil
                    let items = try? JSONDecoder().decode([ExampleItem].self, from: data)
                    self?.items = items ?? []
                } else {
                    self?.errorMessage = error?.localizedDescription
                    self?.items = []
                }
            }
        }.resume()
    }
}
