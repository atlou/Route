//
//  LaunchView.swift
//  Route
//
//  Created by Xavier on 2024-02-19.
//

import SwiftUI

struct LaunchView: View {
    @Binding var isShown: Bool

    var body: some View {
        ZStack {
            Color(Color(.panel))

            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Route")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("In this app, you will learn about three **pathfinding algorithms**.")
                    Text("Here are some **tips**:")
                        .padding(.top, 24)
                }

                VStack(alignment: .leading, spacing: 16) {
                    Tip(text: "Select a **pathfinding algorithm**", icon: "filemenu.and.selection", color: Color(.gridWall))
                    Tip(text: "Move the **start** and **target** blocks to your desired locations", icon: "arrow.up.and.down.and.arrow.left.and.right", color: Color(.gridWall))
                    Tip(text: "Draw **walls** on the grid to create obstacles", icon: "hand.draw.fill", color: Color(.gridWall))
                    Tip(text: "Generate a **random maze** to try more complex paths", icon: "sparkles", color: Color(.gridWall))
                }
                .padding(.bottom, 60)

                HStack {
                    Spacer()
                    Button("Continue") {
                        withAnimation(.default.speed(0.3)) {
                            isShown.toggle()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(.grid).gradient)
                    Spacer()
                }
            }
            .frame(maxWidth: 460)
        }
        .foregroundStyle(.white)
        .fontDesign(.rounded)
    }
}

struct Tip: View {
    let text: LocalizedStringKey
    let icon: String
    let color: Color

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(color.gradient)
                .font(.title)
                .frame(width: 48, height: 48)
            Text(text)
                .lineLimit(.max)
                .frame(maxHeight: .infinity)
        }
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    LaunchView(isShown: .constant(true))
}
