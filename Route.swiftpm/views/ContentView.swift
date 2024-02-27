//
//  ContentView.swift
//  Route
//
//  Created by Xavier on 2024-02-06.
//

import SwiftUI

/// Base view of the app
struct ContentView: View {
    @StateObject var controller = Controller.shared
    @State private var showLaunch = true

    var body: some View {
        ZStack {
            Color(.background)
                .ignoresSafeArea()

            MainView(controller: self.controller)

            Group {
                Color(.black)
                Color(.panel)
            }
            .ignoresSafeArea()
            .opacity(self.showLaunch ? 0.4 : 0)
            .animation(.default, value: self.showLaunch)
        }
        .sheet(isPresented: $showLaunch) {
            LaunchView(isShown: self.$showLaunch)
                .presentationDetents([ // 100 points
                    .height(100)
                ])
                .interactiveDismissDisabled()
                .background(Color(.panel))
        }
    }
}

#Preview {
    ContentView()
}
