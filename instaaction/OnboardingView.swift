//
//  OnboardingView.swift
//  instaaction
//
//  Created by Marcin Mucha on 27/05/2020.
//  Copyright © 2020 Schibsted. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class OnboardingViewModel {
    var didSaveName: () -> Void = {}
    var cancelable: AnyCancellable?
    func send(name: String) {
        let user = User(name: name)

        guard let request = try? URLRequest.makeRegisterRequest(with: user) else {
            // TODO handle error
            return
        }

        let future: Future<String, Error> = WebService.load(request: request)
        cancelable = future.sink(receiveCompletion: { completion in
            switch completion {
            case .failure:
                // TODO handle error
                return
            case .finished:
                return
            }
        }, receiveValue: { [weak self] value in
            UserDefaultsConfig.user = user
            self?.didSaveName()
        })

    }
}

extension URLRequest {
    static func makeRegisterRequest(with user: User) throws -> URLRequest {
        var request = URLRequest(url: URL(string: "https://desolate-spire-68065.herokuapp.com/register")!)
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(user)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        return request
    }
}

struct User: Encodable {
    let uuid = UUID.init()
    let name: String
    let token: String = {
        return "ios-" + String.randomString(length: 20)
    }()
}

extension String {
    static func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}

struct RegisterResponse: Decodable { }

struct OnboardingView: View {
    let viewModel: OnboardingViewModel
    
    @State private var name: String = ""
    
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Text("Hello, what's your name?")
            TextField("Name", text: $name)
                .frame(width: 200, height: nil, alignment: .center)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button(action: {
                self.viewModel.send(name: self.name)
            }, label: {
                HStack {
                    Image(systemName: "hand.thumbsup.fill")
                        .font(.title)
                    Text("Confirm")
                        .fontWeight(.semibold)
                        .font(.title)
                }
                .frame(minWidth: 0, maxWidth: 200)
                .padding()
                .foregroundColor(.white)
                .background(LinearGradient(gradient: Gradient(colors: [.init(.magenta), .purple]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(16)
                .padding(32)
            }).disabled(name.isEmpty)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(viewModel: OnboardingViewModel())
    }
}

