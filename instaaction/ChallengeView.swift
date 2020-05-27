//
//  ChallengeView.swift
//  instaaction
//
//  Created by Michał Apanowicz on 27/05/2020.
//  Copyright © 2020 Schibsted. All rights reserved.
//

import SwiftUI
import Combine

final class ChallengesStore: ObservableObject {
    @Published var challenges: [Challenge] = []
    var cancelable: AnyCancellable?

    func start() {
        cancelable = PushCheckService.shared.subject
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
            self?.challenges = value.challenges
        }
    }
}

struct ChallengeView: View {
    @ObservedObject var challengesStore = ChallengesStore()
    var body: some View {
        NavigationView {
            VStack {
                if !challengesStore.challenges.isEmpty {
                    List {
                        ForEach(challengesStore.challenges) { challenge in
                            HStack {
                                Text(challenge.name)
                            }
                        }
                    }
                } else {
                    VStack {
                        Text("No active challanges")
                    }
                }
            }.navigationBarTitle("Current challanges")
        }.onAppear { self.challengesStore.start() }
    }
}

struct ChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeView()
    }
}
