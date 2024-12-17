//
//  Dictionary.swift
//  Hlthera
//
//  Created by Ahmed Hegzo on 05/09/1401 AP.
//  Copyright © 1401 AP Fluper. All rights reserved.
//

import Foundation
import Alamofire

//extension Dictionary where Key == String, Value == String {
//    func toHeader() -> HTTPHeaders {
//        var headers: HTTPHeaders = [:]
//        for (key, value) in self  {
//            headers.add(name: key, value: value)
//        }
//        return headers
//    }
//}

extension Dictionary {
    var jsonStringRepresentation: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,
                                                            options: [.prettyPrinted]) else {
            return nil
        }

        return String(data: theJSONData, encoding: .ascii)
    }
}
