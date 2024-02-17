//
//  Node.swift
//  Pathfinding
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

class Node: Hashable, CustomStringConvertible, ObservableObject {
    let x: Int
    let y: Int
    private(set) var neighbors: Set<Node>
//    @Published var walkable: Bool
//    @Published var visited: Bool
//    @Published var onPath: Bool
//    @Published var start: Bool
//    @Published var target: Bool

    @Published var type: NodeType
    @Published var state: NodeState

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
        self.neighbors = []
        self.type = .normal
        self.state = .base
    }

    init(node: Node) {
        self.x = node.x
        self.y = node.y
        self.neighbors = node.neighbors
        self.type = node.type
        self.state = node.state
    }

    func isWalkable() -> Bool {
        return type != .wall
    }

    func getDistance(from node: Node) -> Float {
        return Float(abs(node.x - x) + abs(node.y - y))
    }

    func addNeighbor(node: Node) {
        neighbors.insert(node)
    }

    func reset() {
        type = .normal
        state = .base
    }

//    func setWalkable() {
//        walkable = value
//    }
//
//    func setVisited(_ value: Bool) {
//        visited = value
//    }
//
//    func setOnPath() {
//        onPath = true
//        visited = false
//    }

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
