//
//  ChallangeView.swift
//  instaaction
//
//  Created by Michał Apanowicz on 27/05/2020.
//  Copyright © 2020 Schibsted. All rights reserved.
//

import SwiftUI
import Combine

struct ChallengeView: View {

    let challange: Challenge

    var body: some View {
        NavigationView {
            VStack {
                Text("Szalendż")
            }.navigationBarTitle(challange.name)
        }
    }
}

struct ChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeView(challange: Challenge(name: "Test szalendż"))
    }
}
