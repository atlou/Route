//
//  Model.swift
//  Pathfinding
//
//  Created by Xavier on 2024-02-14.
//

import Foundation

enum PathfindingAlgo: CaseIterable, Identifiable, CustomStringConvertible {
    case astar
    
    var id: Self { self }
    
    var description: String {
        switch self {
        case .astar: return "A-star"
        }
    }
}

enum DrawingMode: CaseIterable, Identifiable {
    case start
    case end
    case obstacle
    case erase
    
    var id: Self { self }
}

class Grid: ObservableObject {
    @Published var drawingMode: DrawingMode
    @Published var algo: PathfindingAlgo
    private var nodes: [Node]
    private(set) var startNode: Node?
    private(set) var endNode: Node?
    
    let width: Int
    let height: Int
    
    static let shared = Grid(width: 26, height: 26)
    
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
        self.drawingMode = .start
        self.algo = .astar
        
        initializeNeighbors()
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
    
    func run() {
        if startNode == nil || endNode == nil { return }
        switch algo {
        case .astar:
            let path = AStar.findPath(start: startNode!, target: endNode!)
        }
    }
    
    func getNode(x: Int, y: Int) -> Node? {
        if y < 0 || y >= height { return nil }
        if x < 0 || x >= width { return nil }
        
        return nodes[y * width + x]
    }
    
    func setVisited(node: Node) {
        node.setVisited(true)
        objectWillChange.send()
    }
    
    func clear() {
        for node in nodes {
            node.setWalkable(true)
            node.setVisited(false)
        }
        startNode = nil
        endNode = nil
        objectWillChange.send()
    }
    
    func setStartNode(x: Int, y: Int) {
        guard let n = getNode(x: x, y: y) else {
            return
        }
        n.setWalkable(true)
        startNode = n
        objectWillChange.send()
    }
    
    func setEndNode(x: Int, y: Int) {
        guard let n = getNode(x: x, y: y) else {
            return
        }
        n.setWalkable(true)
        endNode = n
        objectWillChange.send()
    }
    
    func createObstacle(x: Int, y: Int) {
        guard let n = getNode(x: x, y: y) else {
            return
        }
        if n != startNode && n != endNode {
            n.setWalkable(false)
        }
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
