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
                    if node == grid.startNode {
                        RoundedRectangle(cornerRadius: 0)
                            .fill(.blue.opacity(0.8))
                            .padding(0)
                            .transition(.scale.combined(with: .opacity))
                    } else if node == grid.endNode {
                        RoundedRectangle(cornerRadius: 0)
                            .fill(.green.opacity(0.8))
                            .padding(0)
                            .transition(.scale.combined(with: .opacity))
                    } else if !node.walkable {
                        RoundedRectangle(cornerRadius: 0)
                            .fill(.gray.opacity(0.8))
                            .padding(0)
                            .transition(.asymmetric(insertion: .scale.combined(with: .opacity), removal: .scale.combined(with: .opacity)))
                    } else if node.visited {
                        RoundedRectangle(cornerRadius: 0)
                            .fill(.yellow.opacity(0.2))
                            .padding(0)
                            .transition(.asymmetric(insertion: .scale.combined(with: .opacity), removal: .scale.combined(with: .opacity)))
                            .animation(.default, value: node.visited)
                    } else if node.onPath {
                        RoundedRectangle(cornerRadius: 0)
                            .fill(.yellow.opacity(1))
                            .padding(0)
                            .transition(.asymmetric(insertion: .scale.combined(with: .opacity), removal: .scale.combined(with: .opacity)))
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
                    }
                }
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0.0)
                .onChanged { drag in
                    let x = Int(drag.location.x / size)
                    let y = Int(drag.location.y / size)
                    switch grid.drawingMode {
                    case .start:
                        grid.setStartNode(x: x, y: y)
                    case .end:
                        grid.setEndNode(x: x, y: y)
                    case .obstacle:
//                        withAnimation(.bouncy.speed(1.5)) {
                        grid.createObstacle(x: x, y: y)
//                        }
                    case .erase:
//                        withAnimation(.default.speed(1.5)) {
                        grid.removeObstacle(x: x, y: y)
//                        }
                    }
                }
        )
        .background(.gray.opacity(0.2))
    }
}
