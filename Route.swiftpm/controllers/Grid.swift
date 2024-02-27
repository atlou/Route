//
//  Grid.swift
//  Route
//
//  Created by Xavier on 2024-02-14.
//

import Foundation

/// Model for GridView
/// Handles all functions that relate to displaying or interacting with the grid
class Grid: ObservableObject {
    /// Array containing all the nodes present on the grid
    @Published var nodes: [Node]
    /// Position of the current starting node
    @Published var startPos: (x: Int, y: Int)?
    /// Position of the current target node
    @Published var targetPos: (x: Int, y: Int)?
    
    /// Width of the grid, in nodes
    let width: Int
    /// Height of the grid, in nodes
    let height: Int
    
    /// Singleton
    static let shared = Grid(width: 29, height: 25)
    
    /// Private initializer for the singleton
    /// - Parameters:
    ///   - width: Sets the width of the grid
    ///   - height: Sets the height of the grid
    private init(width: Int, height: Int) {
        // initialize nodes
        var nodes: [Node] = []
        for y in 0..<height {
            for x in 0..<width {
                nodes.append(Node(x: x, y: y))
            }
        }
        self.nodes = nodes
        self.width = width
        self.height = height
        initializeNeighbors()
        setStart(x: 3, y: 13)
        setTarget(x: width - 4, y: 13)
    }
    
    /// For each, this function sets its adjacent nodes
    /// This prevents the pathfinding algorithm to have to get a node's neighbors from its coordinates each run
    func initializeNeighbors() {
        for node in nodes {
            if let left = getNode(x: node.x - 1, y: node.y) {
                node.addNeighbor(node: left)
            }
            if let right = getNode(x: node.x + 1, y: node.y) {
                node.addNeighbor(node: right)
            }
            if let top = getNode(x: node.x, y: node.y - 1) {
                node.addNeighbor(node: top)
            }
            if let bottom = getNode(x: node.x, y: node.y + 1) {
                node.addNeighbor(node: bottom)
            }
        }
    }
    
    /// Resets all nodes' `state` to `base`
    func clearPath() {
        for node in nodes {
            node.state = .base
        }
    }
    
    /// Get a node from coordinates
    /// - Parameters:
    ///   - x: horizontal coordinates
    ///   - y: vertical coordinates
    /// - Returns: The `Node` at these coordinates, if any
    func getNode(x: Int, y: Int) -> Node? {
        if y < 0 || y >= height { return nil }
        if x < 0 || x >= width { return nil }
        
        return nodes[y * width + x]
    }
    
    /// Get the start node using `startPos`
    /// - Returns: The `Node` at the `startPos` coordinates, if any
    func getStart() -> Node? {
        guard let pos = startPos else {
            return nil
        }
        return getNode(x: pos.x, y: pos.y)
    }
    
    /// Move the start node to a new location
    /// - Parameters:
    ///   - x: horizontal coordinates
    ///   - y: vertical coordinates
    func setStart(x: Int, y: Int) {
        if let new = getNode(x: x, y: y), new.type == .normal {
            getStart()?.type = .normal
            new.type = .start
            startPos = (x, y)
        }
    }
    
    /// Get the target node using `targetPos`
    /// - Returns: The `Node` at the `targetPos` coordinates, if any
    func getTarget() -> Node? {
        guard let pos = targetPos else {
            return nil
        }
        return getNode(x: pos.x, y: pos.y)
    }
    
    /// Move the target node to a new location
    /// - Parameters:
    ///   - x: horizontal coordinates
    ///   - y: vertical coordinates
    func setTarget(x: Int, y: Int) {
        if let new = getNode(x: x, y: y), new.type == .normal {
            getTarget()?.type = .normal
            new.type = .target
            targetPos = (x, y)
        }
    }
    
    /// Create a wall on a node using its coordinates
    /// - Parameters:
    ///   - x: horizontal coordinates
    ///   - y: vertical coordinates
    func setWall(x: Int, y: Int) {
        if let n = getNode(x: x, y: y), n.type == .normal {
            n.type = .wall
        }
    }
    
    /// Remove a wall from a node using its coordinates
    /// - Parameters:
    ///   - x: horizontal coordinates
    ///   - y: vertical coordinates
    func setNormal(x: Int, y: Int) {
        if let n = getNode(x: x, y: y), n.type == .wall {
            n.type = .normal
        }
    }
    
    /// Set a node's state to `visited`
    /// - Parameter node: The node to visit
    func setVisited(node: Node) {
        if node.type == .normal {
            node.state = .visited
        }
    }
    
    /// Reset all nodes
    func clearGrid() {
        for node in nodes {
            node.reset()
        }
    }
}
