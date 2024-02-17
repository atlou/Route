//
//  NodeView.swift
//
//
//  Created by Xavier on 2024-02-17.
//

import SwiftUI

struct NodeView: View {
    @ObservedObject var node: Node
    let size: Double

    var body: some View {
        RoundedRectangle(cornerRadius: 0)
            .fill(.white)
            .padding(1)
            .frame(width: size, height: size)
            .overlay {
                ZStack {
                    switch node.type {
                    case .normal:
                        switch node.state {
                        case .base:
                            Rectangle()
                                .fill(.clear)
                        case .visited:
                            Rectangle()
                                .fill(.yellow.opacity(0.2))
                                .transition(.scale.combined(with: .opacity))
                        case .path:
                            Rectangle()
                                .fill(.yellow)
                                .transition(.opacity)
                        }
                    case .wall:
                        Rectangle()
                            .fill(.gray.opacity(0.8))
                            .transition(.scale.combined(with: .opacity))
                    case .start:
                        Rectangle()
                            .fill(.blue)
                            .transition(.scale.combined(with: .opacity))
                    case .target:
                        Rectangle()
                            .fill(.green.opacity(0.8))
                            .transition(.scale.combined(with: .opacity))
                    }
                }
            }
    }
}
