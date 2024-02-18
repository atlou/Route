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
    @State private var overlayScale = 0.5
    @State private var overlayOpacity = 0.0

    var body: some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(color)
            .padding(4)
            .scaleEffect(scale)
            .opacity(opacity)
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .fill(overlayColor)
                    .padding(4)
                    .scaleEffect(overlayScale)
                    .opacity(overlayOpacity)
            }
            .onChange(of: node.state) { _, new in
                if node.type == .normal {
                    if new == .base {
                        hide(anim: false)
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
                color = nodeColor()
                if old == .normal {
                    if new == .wall {
                        show(anim: true)
                    } else {
                        show(anim: false)
                    }
                }
                if new == .normal {
                    hide(anim: false)
                }
            }
    }

    private func setPath(color: Color = .yellow) {
        // spawn overlay with new color
        overlayColor = color

        withAnimation(.bouncy.speed(1)) {
            overlayScale = 1
            scale = 0.5
        } completion: {
            // once the animation is done, change the color and remove overlay
            self.color = color
            overlayOpacity = 0
            overlayScale = 0.5
            scale = 1
        }
        withAnimation(.default.speed(2)) {
            overlayOpacity = 1
        }
    }

    private func setVisited(color1: Color = .indigo, color2: Color = .cyan) {
        color = color1.opacity(0.5)
        withAnimation(.bouncy.speed(0.5)) {
            scale = 1
        }
        withAnimation(.default.speed(1)) {
            opacity = 1
        }
        withAnimation(.default.speed(0.5)) {
            color = color2.opacity(0.5)
        }
    }

    private func show(anim: Bool) {
        if anim {
            withAnimation(.bouncy.speed(1.5)) {
                scale = 1
            }
            withAnimation(.default.speed(3)) {
                opacity = 1
            }
        } else {
            scale = 1
            opacity = 1
        }
    }

    private func hide(anim: Bool) {
        if anim {
            withAnimation(.bouncy.speed(1.5)) {
                scale = 0.5
            }
            withAnimation(.default.speed(3)) {
                opacity = 0
            }
        } else {
            scale = 0.5
            opacity = 0
        }
    }

    private func nodeColor() -> Color {
        switch node.type {
        case .normal:
            switch node.state {
            case .base: return .clear
            case .path: return .yellow
            case .visited: return .teal
            }
        case .wall: return .gray
        case .start: return .blue
        case .target: return .green
        }
    }
}
