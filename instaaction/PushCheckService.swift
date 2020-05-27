//
//  PushCheckService.swift
//  instaaction
//
//  Created by Michał Apanowicz on 27/05/2020.
//  Copyright © 2020 Schibsted. All rights reserved.
//

import Foundation
import Combine

struct Challenges: Decodable, CustomStringConvertible {
    var description: String {
        challenges.compactMap { $0.description }.joined()
    }

    let challenges: [Challenge]
}

struct Challenge: Decodable, CustomStringConvertible {
    let name: String

    var description: String {
        name
    }
}

final class PuchCheckService {

    static let shared = PuchCheckService()

    var subject = PassthroughSubject<Challenges, Never>()

    private var timer: Timer?
    private let webService = WebService()
    private var cancelable: AnyCancellable?

    init() {
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let request = URLRequest(url: URL(string: "http://www.mocky.io/v2/5ece46f33000002a00ea0fe2")!)
            let future: Future<Challenges, Error> = self.webService.load(request: request)

            self.cancelable = future.sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error \(error)")
                    break
                }
            }) { [weak self] value in
                self?.subject.send(value)
            }
        }
    }
}