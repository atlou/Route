//
//  Node.swift
//  Route
//
//  Created by Xavier on 2024-02-14.
//

import Foundation

/// The node's state in regard to pathfinding
enum NodeState {
    case base
    case visited
    case path
}

/// The node's grid type
enum NodeType {
    case normal
    case wall
    case start
    case target
}

/// This class represents both a cell on the grid interface and a node for the pathfinding
/// It has attributes that serve the visual aspect of the grid, as well as attributes that serve the pathfinding algorithms
class Node: Hashable, ObservableObject {
    /// Horizontal coordinate
    let x: Int
    /// Vertical coordinate
    let y: Int

    /// A set containing all adjacent nodes (left, top, right, bottom)
    private(set) var neighbors: Set<Node>

    /// The node's current type
    @Published var type: NodeType
    /// The node's current state
    @Published var state: NodeState

    var hCost: Int
    var gCost: Int
    var fCost: Int {
        return hCost + gCost
    }

    /// The previous node in the path that got us to this node
    var parent: Node?

    /// Initializes all attributes
    /// - Parameters:
    ///   - x: Sets the node's horizontal coordinate
    ///   - y: Sets the node's vertical coordinate
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
        self.neighbors = []
        self.type = .normal
        self.state = .base
        self.hCost = 0
        self.gCost = 0
    }

    /// Can the node be walked on?
    /// - Returns: `True` if the node is not a wall, `False` otherwise
    func isWalkable() -> Bool {
        return type != .wall
    }

    /// Calculate the distance between this node and another node
    /// - Parameter node: The other node we want to know the distance from
    /// - Returns: The distance between the nodes
    func getDistance(from node: Node) -> Int {
        return abs(node.x - x) + abs(node.y - y)
    }

    /// Add a neighbor to the node's set of neighbors
    /// - Parameter node: The node to add
    func addNeighbor(node: Node) {
        neighbors.insert(node)
    }

    /// Resets the node's `state` and, if the node is wall, also resets its `type`
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
}
