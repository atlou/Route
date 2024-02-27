//
//  GridView.swift
//  Route
//
//  Created by Xavier on 2024-02-06.
//

import SwiftUI

/// View that displays all the nodes objects in a grid
struct GridView: View {
    /// Controller object
    @ObservedObject var controller: Controller
    /// Size of the grid
    @Binding var size: CGSize
    /// True if there is currently a dragging gesture on the grid, false otherwise
    @State private var isDragging = false

    /// Translates a CGPoint location to the grid coordinates system
    /// - Parameter location: The location to translate
    /// - Returns: The x and y coordinates associated with that location
    func getCoordinates(_ location: CGPoint) -> (x: Int, y: Int) {
        return (Int(location.x / getCellSize()), Int(location.y / getCellSize()))
    }

    /// Computes the width of a cell from the grid's CGSize width and the grid's width in nodes
    /// - Returns: <#description#>
    func getCellSize() -> Double {
        return size.width / Double(Grid.shared.width)
    }

    var body: some View {
        let grid = controller.grid

        // display all nodes
        VStack(spacing: 0) {
            ForEach(0..<grid.height, id: \.self) { y in
                HStack(spacing: 0) {
                    let size = getCellSize()
                    ForEach(0..<grid.width, id: \.self) { x in
                        let node: Node = grid.getNode(x: x, y: y)!
                        RoundedRectangle(cornerRadius: 0)
                            .fill(Color(.gridBackground))
                            .padding(0.5)
                            .frame(width: size, height: size)
                            .overlay {
                                NodeView(node: node)
                            }
                    }
                }
            }
        }
        .gesture(DragGesture(minimumDistance: 0.0)
            .onChanged { drag in
                // set drawing mode
                if !isDragging {
                    let startLoc = getCoordinates(drag.startLocation)

                    if let node = grid.getNode(x: startLoc.x, y: startLoc.y) {
                        switch node.type {
                        case .normal: controller.drawingMode = .wall
                        case .start: controller.drawingMode = .start
                        case .wall: controller.drawingMode = .erase
                        case .target: controller.drawingMode = .target
                        }
                    }
                    isDragging = true
                }
                let size = getCellSize()
                let x = Int(drag.location.x / size)
                let y = Int(drag.location.y / size)
                controller.draw(x: x, y: y)
            }
            .onEnded { _ in
                isDragging = false
            })
        .background(Color(.grid))
    }
}
