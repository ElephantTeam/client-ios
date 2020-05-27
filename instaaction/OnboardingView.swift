//
//  OnboardingView.swift
//  instaaction
//
//  Created by Marcin Mucha on 27/05/2020.
//  Copyright © 2020 Schibsted. All rights reserved.
//

import Foundation
import SwiftUI

class OnboardingViewModel {
    func send(name: String) {
        print("Name: \(name)")
    }
}

struct OnboardingView: View {
    let viewModel = OnboardingViewModel()
    
    @State private var name: String = ""
    
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
        OnboardingView()
    }
}

