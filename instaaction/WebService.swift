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

    func load<A: Decodable>(request: URLRequest) -> Future<A, Error> {
        return Future { completion in
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let err = error {
                    completion(.failure(err))
                    return
                }
                guard let data = data else {
                    completion(.failure(WebServiceError.noData))
                    return
                }
                do {
                    let parsed = try JSONDecoder().decode(A.self, from: data)
                    print("Parsed: \(parsed)")
                    completion(.success(parsed))
                } catch {
                    completion(.failure(WebServiceError.cannotParse))
                }
            }
            task.resume()
        }
    }
}
