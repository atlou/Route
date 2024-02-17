//
//  NodeView.swift
//
//
//  Created by Xavier on 2024-02-17.
//

import SwiftUI

struct VisitedNodeView: View {
    @State private var animateColor = false
    var body: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(animateColor ? .teal : .indigo)
            .padding(4)
            .transition(.asymmetric(insertion: .scale, removal: .identity))
            .onAppear {
                withAnimation(.default.speed(0.3)) {
                    animateColor = true
                }
            }
    }
}

struct NodeView: View {
    @ObservedObject var node: Node
    let size: Double

    var body: some View {
        RoundedRectangle(cornerRadius: 0)
            .fill(.white)
            .padding(1)
            .frame(width: size, height: size)
            .overlay {
                switch node.type {
                case .normal:
                    if node.type == .normal && node.state != .base {
                        VisitedNodeView()
                            .opacity(0.6)
                        if node.state == .path {
                            Rectangle()
                                .fill(.green)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                case .wall:
                    Rectangle()
                        .fill(.gray)
                        .transition(.scale)
                case .start:
                    Circle()
                        .fill(.black)
                        .overlay {
                            Text("A")
                                .foregroundStyle(.white)
                                .fontDesign(.rounded)
                                .fontWeight(.semibold)
                        }
                        .transition(.scale)
                case .target:
                    Circle()
                        .fill(.black)
                        .overlay {
                            Text("B")
                                .foregroundStyle(.white)
                                .fontDesign(.rounded)
                                .fontWeight(.semibold)
                        }
                        .transition(.scale)
                }
            }
            .animation(.bouncy.speed(0.7), value: node.state)
    }

    private func nodeColor() -> Color {
        switch node.type {
        case .normal: return .clear
        case .wall: return .gray
        case .start: return .blue
        case .target: return .green
        }
    }
}
