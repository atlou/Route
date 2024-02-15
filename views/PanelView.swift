//
//  PanelView.swift
//  Pathfinding
//
//  Created by Xavier on 2024-02-14.
//

import SwiftUI

struct PanelView: View {
    @ObservedObject var grid: Grid
    @Binding var drawingMode: DrawingMode

    var body: some View {
        VStack {
            Text("[pathfinding algo]")
            Picker("Drawing Mode", selection: $drawingMode) {
                ForEach(DrawingMode.allCases) { mode in
                    Text(String(describing: mode).capitalized)
                }
            }
            .pickerStyle(.segmented)
            .padding(12)
            Button("Reset") {
                withAnimation(.default.speed(2)) {
                    grid.clear()
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    ContentView()
}
