//
//  TabView.swift
//  instaaction
//
//  Created by Michał Apanowicz on 27/05/2020.
//  Copyright © 2020 Schibsted. All rights reserved.
//

import SwiftUI
import Combine

struct AppView: View {
    let homeStore: HomeStore

    var body: some View {
        TabView {

            HomeView(homeStore: homeStore)
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Leader board")
                }

            ChallengesView()
                .tabItem {
                    Image(systemName: "bell.fill")
                    Text("Challenges")
                }
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        AppView(homeStore: HomeStore())
    }
}
