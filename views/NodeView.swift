//
//  NodeView.swift
//
//
//  Created by Xavier on 2024-02-17.
//

import SwiftUI

struct NodeView: View {
    @ObservedObject var node: Node

    @State private var animateScale = false
    @State private var animateOpacity = false

    @State private var scale = 0.5
    @State private var opacity = 0.0
    @State private var color = Color.clear

    @State private var overlayColor = Color.clear
    @State private var overlayScale = 0.7
    @State private var overlayOpacity = 0.0

    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(color)
            .padding(3)
            .scaleEffect(scale)
            .opacity(opacity)
            .overlay {
                RoundedRectangle(cornerRadius: 4)
                    .fill(overlayColor)
                    .padding(3)
                    .scaleEffect(overlayScale)
                    .opacity(overlayOpacity)
            }
            .onChange(of: node.state) { _, new in
                if node.type == .normal {
                    if new == .base {
                        hide(anim: true)
                    }
                    if new == .visited {
                        setVisited()
                    }
                    if new == .path {
                        setPath()
                    }
                }
            }
            .onChange(of: node.type) { old, new in
                if old == .normal {
                    if new != .wall {
                        opacity = 1
                        scale = 0.7
                    }
                    show(anim: true)
                }
                if new == .normal {
                    print("hiding")
                    hide(anim: old == .wall)
                }
            }
            .onAppear {
                color = nodeColor()
                if node.type == .start || node.type == .target {
                    show(anim: false)
                }
            }
    }

    private func setPath() {
        // spawn overlay with new color
        overlayColor = Color(.gridPath)

        withAnimation(.default.speed(2)) {
            overlayOpacity = 1
            scale = 0.5
            opacity = 0
        }
        withAnimation(.bouncy) {
            overlayScale = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                opacity = 1
                self.color = Color(.gridPath)
                overlayOpacity = 0
                overlayScale = 0.7
                scale = 1
            }
        }
    }

    private func setVisited() {
        color = Color(.gridVisitedLight)
        withAnimation(.bouncy.speed(1)) {
            scale = 1
            opacity = 0.3
        } completion: {
            withAnimation(.bouncy.speed(1)) {
                opacity = 1
            }
        }
    }

    private func show(anim: Bool) {
        color = nodeColor()
        withAnimation(.bouncy.speed(2)) {
            scale = 1
            opacity = 1
        }
    }

    private func hide(anim: Bool) {
        if anim {
            withAnimation(.bouncy.speed(2)) {
                scale = 0.5
                opacity = 0
            } completion: {
                color = nodeColor()
            }
        } else {
            scale = 0.5
            opacity = 0
        }
    }

    private func nodeColor() -> Color {
        switch node.type {
        case .normal: return .clear
        case .wall: return Color(.gridWall)
        case .start: return Color(.gridPoint)
        case .target: return Color(.gridPoint)
        }
    }
}
