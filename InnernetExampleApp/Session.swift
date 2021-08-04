//
//  Session.swift
//  InnernetExampleApp
//
//  Created by AJ Bartocci on 8/4/21.
//

import Foundation
import Alamofire
import Innernet

#if DEBUG
var session = URLSession.shared
var AF = Alamofire.AF

extension URLSession {
    static func interceptRequests() {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [Innernet.InterceptProtocol.self]
        session = URLSession(configuration: config)
    }
}

extension Session {
    static func interceptRequests() {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [Innernet.InterceptProtocol.self]
        AF = Session(configuration: config)
    }
}
#else
let session = URLSession.shared
let AF = Alamofire.AF
#endif
