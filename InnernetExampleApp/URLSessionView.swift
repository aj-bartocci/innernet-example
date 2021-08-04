//
//  URLSessionView.swift
//  InnernetExampleApp
//
//  Created by AJ Bartocci on 8/4/21.
//

import SwiftUI

struct ExampleItem: Codable, Equatable {
    let id: String
    let value: String
}

struct URLSessionView: View {
    
    @StateObject var viewModel = URLSessionViewModel()
    
    var body: some View {
        List {
            if let error = viewModel.errorMessage {
                Text(error).foregroundColor(.red)
            }
            ForEach(viewModel.items, id: \.id) { item in
                Text(item.value)
            }
            Button(action: viewModel.download, label: {
                Text(viewModel.errorMessage != nil ? "Retry" : "Download items")
            })
        }
    }
}

#if DEBUG
import Innernet

struct URLSessionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Because the session is a singleton we can only render one configuration at a time
            // This could be avoided with proper dependency injection 
            retry()
//            success()
//            failure()
        }
    }
    
    static func success() -> some View {
        URLSession.interceptRequests()
        Innernet.intercept(.get, matching: "somefakedomain.com/items") { _, completion in
            let items: [ExampleItem] = [
                ExampleItem(id: "1", value: "Foo"),
                ExampleItem(id: "2", value: "Bar"),
                ExampleItem(id: "3", value: "Baz"),
            ]
            let data = try? JSONEncoder().encode(items)
            completion(.mock(status: 200, data: data, headers: nil, httpVersion: nil))
        }
        return URLSessionView()
    }
    
    static func retry() -> some View {
        URLSession.interceptRequests()
        var reqCount = 0
        Innernet.intercept(.get, matching: "somefakedomain.com/items") { _, completion in
            if reqCount == 0 {
                completion(.networkError(.timeout))
            } else {
                let items: [ExampleItem] = [
                    ExampleItem(id: "1", value: "Foo"),
                    ExampleItem(id: "2", value: "Bar"),
                    ExampleItem(id: "3", value: "Baz"),
                ]
                let data = try? JSONEncoder().encode(items)
                completion(.mock(status: 200, data: data, headers: nil, httpVersion: nil))
            }
            reqCount += 1
        }
        return URLSessionView()
    }
    
    static func failure() -> some View {
        URLSession.interceptRequests()
        Innernet.intercept(.get, matching: "somefakedomain.com/items") { _, completion in
            completion(.networkError(.timeout))
        }
        return URLSessionView()
    }
}
#endif
