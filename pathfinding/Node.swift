//
//  Node.swift
//  Route
//
//  Created by Xavier on 2024-02-14.
//

import Foundation

enum NodeState {
    case base
    case visited
    case path
}

enum NodeType {
    case normal
    case wall
    case start
    case target
}

class Node: Hashable, ObservableObject {
    let x: Int
    let y: Int
    private(set) var neighbors: Set<Node>

    @Published var type: NodeType
    @Published var state: NodeState

    var hCost: Int
    var gCost: Int
    var fCost: Int {
        return hCost + gCost
    }

    var parent: Node?

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
        self.neighbors = []
        self.type = .normal
        self.state = .base
        self.hCost = 0
        self.gCost = 0
    }

    func isWalkable() -> Bool {
        return type != .wall
    }

    func getDistance(from node: Node) -> Int {
        return abs(node.x - x) + abs(node.y - y)
    }

    func addNeighbor(node: Node) {
        neighbors.insert(node)
    }

    func reset() {
        if type == .wall { type = .normal }
        state = .base
    }

    static func == (lhs: Node, rhs: Node) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine("\(x),\(y)")
    }

    var description: String {
        return "\(x):\(y)"
    }
}
