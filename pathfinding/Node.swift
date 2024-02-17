//
//  Node.swift
//  Pathfinding
//
//  Created by Xavier on 2024-02-14.
//

import Foundation

enum NodeState {
    case none
    case visited
    case path
}

enum NodeType {
    case walkable
    case start
    case target
}

class Node: Hashable, CustomStringConvertible, ObservableObject {
    let x: Int
    let y: Int
    private(set) var neighbors: Set<Node>
    @Published var walkable: Bool
    @Published var visited: Bool
    @Published var onPath: Bool
    @Published var start: Bool
    @Published var target: Bool

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
        self.neighbors = []
        self.walkable = true
        self.visited = false
        self.onPath = false
        self.start = false
        self.target = false
    }

    init(node: Node) {
        self.x = node.x
        self.y = node.y
        self.neighbors = node.neighbors
        self.walkable = node.walkable
        self.visited = node.visited
        self.onPath = node.onPath
    }

    func getDistance(from node: Node) -> Float {
        return Float(abs(node.x - x) + abs(node.y - y))
    }

    func addNeighbor(node: Node) {
        neighbors.insert(node)
    }

    func reset() {
        walkable = true
        visited = false
        onPath = false
    }

    func setWalkable(_ value: Bool) {
        walkable = value
    }

    func setVisited(_ value: Bool) {
        visited = value
    }

    func setOnPath() {
        onPath = true
        visited = false
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
