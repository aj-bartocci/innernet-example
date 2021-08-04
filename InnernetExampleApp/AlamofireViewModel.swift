//
//  AlamofireViewModel.swift
//  InnernetExampleApp
//
//  Created by AJ Bartocci on 8/4/21.
//

import Alamofire
import Foundation

class AlamofireViewModel: ObservableObject {
    @Published var errorMessage: String?
    @Published var items: [ExampleItem] = []
    
    func download() {
        let url = URL(string: "https://somefakedomain.com/items")!
        let req = URLRequest(url: url)
        AF.request(req).responseDecodable { [weak self] (response: DataResponse<[ExampleItem], AFError>) in
            switch response.result {
            case let .success(items):
                self?.errorMessage = nil
                self?.items = items
            case let .failure(error):
                self?.errorMessage = error.localizedDescription
                self?.items = []
            }
        }
    }
}
