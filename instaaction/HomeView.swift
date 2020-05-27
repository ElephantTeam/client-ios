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
    @Published var scores: [Score] = []
    
    func start() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.scores = [
                Score(id: UUID(), userName: "Andrzej", points: 130),
                Score(id: UUID(), userName: "Rafał", points: 130),
                Score(id: UUID(), userName: "Krzyszof", points: 130),
                Score(id: UUID(), userName: "Władysław", points: 130),
                Score(id: UUID(), userName: "Szymon", points: 130),
                Score(id: UUID(), userName: "Robert", points: 130),
                Score(id: UUID(), userName: "Stanisław", points: 130)
            ]
        }
    }
}

struct HomeView: View {
    @ObservedObject var homeStore: HomeStore
    var body: some View {
        NavigationView {
            VStack {
                if !homeStore.scores.isEmpty {
                    List {
                        ForEach(homeStore.scores) { score in
                            HStack {
                                Text(score.userName)
                                Spacer()
                                Text("\(score.points)")
                            }
                            .padding(.vertical, 16)
                        }
                    }
                } else {
                    VStack {
                        ActivityIndicator(isAnimating: .constant(true), style: .large)
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

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
