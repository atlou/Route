//
//  GridView.swift
//  Pathfinding
//
//  Created by Xavier on 2024-02-06.
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

struct GridView: View {
    @ObservedObject var grid: Grid
    let size: Double

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<grid.height, id: \.self) { y in
                HStack(spacing: 0) {
                    ForEach(0..<grid.width, id: \.self) { x in
                        let node: Node = grid.getNode(x: x, y: y)!
                        NodeView(node: node, size: size)
                    }
                }
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0.0)
                .onChanged { drag in
                    let x = Int(drag.location.x / size)
                    let y = Int(drag.location.y / size)
                    grid.draw(x: x, y: y)
                }
        )
        .background(.gray.opacity(0.2))
    }
}
