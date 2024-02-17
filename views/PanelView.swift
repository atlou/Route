//
//  PanelView.swift
//  Pathfinding
//
//  Created by Xavier on 2024-02-14.
//

import SwiftUI

struct PanelView: View {
    @ObservedObject var controller: Controller

    var body: some View {
        VStack {
            Picker("Pathfinding", selection: $controller.algo) {
                ForEach(PathfindingAlgo.allCases) { algo in
                    Text(String(describing: algo).capitalized)
                }
            }
            Picker("Drawing Mode", selection: $controller.drawingMode) {
                ForEach(DrawingMode.allCases) { mode in
                    Text(String(describing: mode).capitalized)
                }
            }
            .pickerStyle(.segmented)
            Picker("Speed", selection: $controller.speed) {
                ForEach(Speed.allCases) { speed in
                    Text(String(describing: speed).capitalized)
                }
            }
            .pickerStyle(.segmented)
            .padding(12)
            HStack {
                Button("Save") {
                    
                }
                .buttonStyle(.bordered)

                Button("Reset") {
                    withAnimation(.default.speed(2)) {
                        controller.clear()
                    }
                }
                .buttonStyle(.bordered)

                Button("Run") {
                    withAnimation {
                        controller.run()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

#Preview {
    ContentView()
}
