//
//  Node.swift
//  Pathfinding
//
//  Created by Xavier on 2024-02-14.
//

import Foundation

class Node: Hashable {
    let x: Int
    let y: Int
    private(set) var neighbors: Set<Node>
    private(set) var walkable: Bool

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
        self.neighbors = []
        self.walkable = true
    }

    func addNeighbor(node: Node) {
        neighbors.insert(node)
    }

    func setWalkable(_ value: Bool) {
        walkable = value
    }

    static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine("\(x),\(y)")
    }
}
