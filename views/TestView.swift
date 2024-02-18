//
//  SwiftUIView.swift
//
//
//  Created by Xavier on 2024-02-17.
//

import SwiftUI

struct Wheel: View {
    @State private var value = 2.0
    var body: some View {
        Picker(selection: .constant(1), label: Text("Picker")) {
            Text("A-star").tag(1)
                .fontDesign(.monospaced)
                .foregroundStyle(.white)
                .fontWeight(.regular)
                .font(.title2)
            Text("Dijkstra")
                .fontDesign(.monospaced)
                .foregroundStyle(.white)
                .fontWeight(.regular)
                .font(.title2)
            Text("Depth-First Search")
                .fontDesign(.monospaced)
                .foregroundStyle(.white)
                .fontWeight(.regular)
                .font(.title2)
        }
        .pickerStyle(.wheel)
        .tint(.white)
        .brightness(1)
        .contrast(0.8)
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(.indigo.opacity(0.5))
            }
        }
        .frame(width: 300)
    }
}

#Preview {
    Wheel()
}
