//
//  Model.swift
//  Pathfinding
//
//  Created by Xavier on 2024-02-14.
//

import Foundation

class Grid: ObservableObject {
    @Published var nodes: [Node]
    @Published var startNode: Node?
    @Published var endNode: Node?
    
    let width: Int
    let height: Int
    
    init(width: Int, height: Int) {
        var nodes: [Node] = []
        for y in 0..<height {
            for x in 0..<width {
                nodes.append(Node(x: x, y: y))
            }
        }
        self.nodes = nodes
        
        self.width = width
        self.height = height
    }
    
    func getNode(x: Int, y: Int) -> Node? {
        if y < 0 || y >= height { return nil }
        if x < 0 || x >= width { return nil }
        
        return nodes[y * width + x]
    }
    
    func createObstacle(x: Int, y: Int) {
        guard let n = getNode(x: x, y: y) else {
            return
        }
        n.setWalkable(false)
        objectWillChange.send()
    }
    
    func removeObstacle(x: Int, y: Int) {
        guard let n = getNode(x: x, y: y) else {
            return
        }
        n.setWalkable(true)
        objectWillChange.send()
    }
}
