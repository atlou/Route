//
//  GridView.swift
//  Pathfinding
//
//  Created by Xavier on 2024-02-06.
//

import SwiftUI

struct GridView: View {
    @ObservedObject var grid: Grid
    let size: Double

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<grid.height, id: \.self) { y in
                HStack(spacing: 0) {
                    ForEach(0..<grid.width, id: \.self) { x in
                        let node: Node = grid.getNode(x: x, y: y)!
                        RoundedRectangle(cornerRadius: 0)
                            .fill(.white)
                            .padding(1)
                            .frame(width: size, height: size)
                            .overlay {
                                ZStack {
                                    if !node.walkable {
                                        RoundedRectangle(cornerRadius: 0)
                                            .fill(.gray.opacity(0.8))
                                            .padding(0)
                                            .transition(.scale.combined(with: .opacity))
                                    }
//                                    Text("\(node.x):\(node.y)")
//                                        .font(.footnote)
                                }
                            }
                    }
                }
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0.0)
                .onChanged { drag in
                    let x = Int(drag.location.x / size)
                    let y = Int(drag.location.y / size)
                    withAnimation(.bouncy.speed(1.5)) {
                        grid.createObstacle(x: x, y: y)
                    }
                }
        )
        .background(.gray.opacity(0.2))
    }
}
