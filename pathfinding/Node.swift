//
//  Node.swift
//  Pathfinding
//
//  Created by Xavier on 2024-02-14.
//

import Foundation

class Node: Hashable, CustomStringConvertible {
    let x: Int
    let y: Int
    private(set) var neighbors: Set<Node>
    private(set) var walkable: Bool
    private(set) var visited: Bool
    private(set) var onPath: Bool

    init(x: Int, y: Int) {
        self.x = x
        self.y = y
        self.neighbors = []
        self.walkable = true
        self.visited = false
        self.onPath = false
    }

    func getDistance(node: Node) -> Int {
        return abs(node.x - x) + abs(node.y - y)
    }

    func addNeighbor(node: Node) {
        neighbors.insert(node)
    }

    func setWalkable(_ value: Bool) {
        walkable = value
    }

    func setVisited(_ value: Bool) {
        visited = value
    }

    func setOnPath(_ value: Bool) {
        onPath = value
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
