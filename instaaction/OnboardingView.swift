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

class OnboardingViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var didFail: Bool = false
    
    var didSaveName: () -> Void = {}
    var cancelable: AnyCancellable?
    func send(name: String) {
        let user = User(name: name)

        guard let request = try? URLRequest.makeRegisterRequest(with: user) else {
            didFail = true
            return
        }
        
        struct UserResponse: Decodable {}
        
        didFail = false
        isLoading = true
        let future: Future<UserResponse, Error> = WebService.load(request: request)
        cancelable = future.sink(receiveCompletion: { [weak self] completion in
            self?.isLoading = false
            switch completion {
            case .failure(let error):
                debugPrint(error)
                self?.didFail = true
                return
            case .finished:
                return
            }
        }, receiveValue: { [weak self] _ in
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

struct User: Codable {
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
    @ObservedObject var viewModel: OnboardingViewModel
    
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
                    if !viewModel.isLoading {
                        Image(systemName: "hand.thumbsup.fill")
                            .font(.title)
                    } else {
                        ActivityIndicator(isAnimating: $viewModel.isLoading, style: .medium, color: .white)
                    }
                    Text("Confirm")
                        .fontWeight(.semibold)
                        .font(.title)
                        .padding(.leading, 8)
                }
                .frame(minWidth: 0, maxWidth: 200)
                .padding()
                .foregroundColor(.white)
                .background(LinearGradient(gradient: Gradient(colors: [.init(.magenta), .purple]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(16)
                .padding(32)
                .alert(isPresented: $viewModel.didFail) {
                    Alert(title: Text("Error"), message: Text("An error occurred when registering a new user, try again later."), dismissButton: .default(Text("OK")))
                }
            }).disabled(name.isEmpty)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(viewModel: OnboardingViewModel())
    }
}

