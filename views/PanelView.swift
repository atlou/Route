//
//  PanelView.swift
//  Pathfinding
//
//  Created by Xavier on 2024-02-14.
//

import SwiftUI

struct PanelView: View {
    @ObservedObject var grid: Grid

    var body: some View {
        VStack {
            Picker("Pathfinding", selection: $grid.algo) {
                ForEach(PathfindingAlgo.allCases) { algo in
                    Text(String(describing: algo).capitalized)
                }
            }
            Picker("Drawing Mode", selection: $grid.drawingMode) {
                ForEach(DrawingMode.allCases) { mode in
                    Text(String(describing: mode).capitalized)
                }
            }
            .pickerStyle(.segmented)
            Picker("Speed", selection: $grid.speed) {
                ForEach(Speed.allCases) { speed in
                    Text(String(describing: speed).capitalized)
                }
            }
            .pickerStyle(.segmented)
            .padding(12)
            HStack {
                Button("Reset") {
                    withAnimation(.default.speed(2)) {
                        grid.clear()
                    }
                }
                .buttonStyle(.bordered)

                Button("Run") {
                    Task {
                        await grid.run()
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
