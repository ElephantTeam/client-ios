//
//  WebService.swift
//  instaaction
//
//  Created by Michał Apanowicz on 27/05/2020.
//  Copyright © 2020 Schibsted. All rights reserved.
//

import Foundation
import Combine

final class WebService {
    enum WebServiceError: Error {
        case cannotParse
        case noData
    }

    static func load<A: Decodable>(request: URLRequest) -> Future<A, Error> {
        return Future { completion in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let err = error {
                    DispatchQueue.main.async {
                        completion(.failure(err))
                    }
                    return
                }
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(WebServiceError.noData))
                    }
                    return
                }
                do {
                    let parsed = try JSONDecoder().decode(A.self, from: data)
                    print("Parsed: \(parsed)")
                    DispatchQueue.main.async {
                        completion(.success(parsed))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(WebServiceError.cannotParse))
                    }
                }
            }
            task.resume()
        }
    }
}
