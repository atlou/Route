//
//  GridView.swift
//  Pathfinding
//
//  Created by Xavier on 2024-02-06.
//

import SwiftUI

struct GridView: View {
    @ObservedObject var controller: Controller
    let size: Double

    var body: some View {
        let grid = controller.grid
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
                                NodeView(node: node)
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
                    controller.draw(x: x, y: y)
                }
        )
        .background(.gray.opacity(0.2))
    }
}
