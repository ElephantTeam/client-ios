//
//  ContentView.swift
//  instaaction
//
//  Created by Michał Apanowicz on 27/05/2020.
//  Copyright © 2020 Schibsted. All rights reserved.
//

import SwiftUI
import Combine

class HomeStore: ObservableObject {
    @Published var scores: [Score]?
    private var cancellables: Set<AnyCancellable> = []
    
    func start() {
        let request = URLRequest(url: URL(string: "https://desolate-spire-68065.herokuapp.com/leaderboard")!)
        WebService.load(request: request)
            .print()
            .replaceError(with: [])
            .assign(to: \.scores, on: self)
        .store(in: &cancellables)
    }
}

struct HomeView: View {
    @ObservedObject var homeStore: HomeStore
    var body: some View {
        NavigationView {
            VStack {
                if homeStore.scores != nil {
                    if homeStore.scores!.isEmpty {
                        Text("Error occurred.")
                    } else {
                        List {
                            ForEach(homeStore.scores!) { score in
                                HStack {
                                    Text(score.userName)
                                    Spacer()
                                    Text("\(score.points)")
                                }
                                .padding(.vertical, 16)
                            }
                        }
                    }
                } else {
                    VStack {
                        ActivityIndicator(isAnimating: .constant(true), style: .large, color: .gray)
                        Text("Loading...")
                    }
                }
            }.navigationBarTitle("InstaAction")
        }.onAppear { self.homeStore.start() }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(homeStore: HomeStore())
    }
}

struct ActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style
    let color: UIColor

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: style)
        view.color = color
        return view
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
