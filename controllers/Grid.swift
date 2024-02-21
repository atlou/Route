//
//  Model.swift
//  Pathfinding
//
//  Created by Xavier on 2024-02-14.
//

import Foundation

class Grid: ObservableObject {
    @Published var nodes: [Node]
    @Published var startPos: (x: Int, y: Int)?
    @Published var targetPos: (x: Int, y: Int)?
    
    let width: Int
    let height: Int
    
    static let shared = Grid(width: 29, height: 25)
    
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
    
    func clearPath() {
        for node in nodes {
            node.state = .base
        }
    }
    
    func isReady() -> Bool {
        return startPos != nil && targetPos != nil
    }

    func getNode(x: Int, y: Int) -> Node? {
        if y < 0 || y >= height { return nil }
        if x < 0 || x >= width { return nil }
        
        return nodes[y * width + x]
    }
    
    func getStart() -> Node? {
        guard let pos = startPos else {
            return nil
        }
        return getNode(x: pos.x, y: pos.y)
    }
    
    func setStart(x: Int, y: Int) {
        if let new = getNode(x: x, y: y), new.type == .normal {
            getStart()?.type = .normal
            new.type = .start
            startPos = (x, y)
        }
    }
    
    func getTarget() -> Node? {
        guard let pos = targetPos else {
            return nil
        }
        return getNode(x: pos.x, y: pos.y)
    }
    
    func setTarget(x: Int, y: Int) {
        if let new = getNode(x: x, y: y), new.type == .normal {
            getTarget()?.type = .normal
            new.type = .target
            targetPos = (x, y)
        }
    }
    
    func setWall(x: Int, y: Int) {
        if let n = getNode(x: x, y: y), n.type == .normal {
            n.type = .wall
        }
    }
    
    func setNormal(x: Int, y: Int) {
        if let n = getNode(x: x, y: y), n.type == .wall {
            n.type = .normal
        }
    }
    
    func setVisited(node: Node) {
        if node.type == .normal {
            node.state = .visited
        }
    }
    
    func clearGrid() {
        for node in nodes {
            node.reset()
        }
    }
}
