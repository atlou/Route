//
//  Model.swift
//  Pathfinding
//
//  Created by Xavier on 2024-02-14.
//

import Foundation
import SwiftUI

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
    case target
    case wall
    case erase
    
    var id: Self { self }
}

enum Speed: Double, CaseIterable, Identifiable {
    case fast = 0.005
    case medium = 0.01
    case slow = 0.05
    
    var ms: Double {
        return rawValue * 1_000
    }
    
    var ns: Double {
        return rawValue * 1_000_000_000
    }
    
    var id: Self { self }
}

class Grid: ObservableObject {
    @Published var drawingMode: DrawingMode
    @Published var algo: PathfindingAlgo
    @Published var nodes: [Node]
    @Published var startNode: Node?
    @Published var endNode: Node?
    @Published var speed: Speed
    private(set) var isRunning: Bool
    private(set) var isPathDisplayed: Bool
    private let aStar: AStar
    
    let width: Int
    let height: Int
    
    static let shared = Grid(width: 26, height: 26)
    
    let PATH_DRAWING_SPEED = 0.01
    
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
        self.isRunning = false
        self.algo = .astar
        self.aStar = AStar(nodes: nodes)
        self.isPathDisplayed = false
        self.speed = .medium
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
        if isRunning { return }
        if startNode == nil || endNode == nil { return }
        
        isRunning = true
        clearPath()
        Task {
            await findPath()
        }
    }
    
    func findPath() async {
        switch algo {
        case .astar:
            let path = await aStar.findPath(start: startNode!, target: endNode!) ?? []
            await MainActor.run {
                displayPath(path: path) {
                    self.isRunning = false
                    self.isPathDisplayed = true
                }
            }
        }
    }

    func visit(node: Node) {
        withAnimation(.spring.speed(1.5)) {
            node.state = .visited
        }
    }
    
    func displayPath(path: [Node], completion: @escaping () -> Void) {
        var queue = path
        _ = Timer.scheduledTimer(withTimeInterval: PATH_DRAWING_SPEED, repeats: true) { timer in
            guard let node = queue.popLast() else {
                timer.invalidate()
                DispatchQueue.main.async { completion() }
                return
            }
            withAnimation(.default.speed(1.5)) {
                node.state = .path
            }
        }
    }
    
    func clearPath() {
        withAnimation(.default.speed(1.5)) {
            for node in nodes {
                node.state = .base
            }
        }
        isPathDisplayed = false
    }

    func getNode(x: Int, y: Int) -> Node? {
        if y < 0 || y >= height { return nil }
        if x < 0 || x >= width { return nil }
        
        return nodes[y * width + x]
    }
    
    func clear() {
        if isRunning { return }
        for node in nodes {
            node.reset()
        }
        startNode = nil
        endNode = nil
    }
    
    func draw(x: Int, y: Int) {
        if isPathDisplayed { clearPath() }
        switch drawingMode {
        case .start:
            setStartNode(x: x, y: y)
        case .target:
            setEndNode(x: x, y: y)
        case .wall:
            createObstacle(x: x, y: y)
        case .erase:
            removeObstacle(x: x, y: y)
        }
    }
    
    func setStartNode(x: Int, y: Int) {
        guard let n = getNode(x: x, y: y) else {
            return
        }
        startNode?.type = .normal
        n.type = .start
        startNode = n
    }
    
    func setEndNode(x: Int, y: Int) {
        guard let n = getNode(x: x, y: y) else {
            return
        }
        endNode?.type = .normal
        n.type = .target
        endNode = n
    }
    
    func createObstacle(x: Int, y: Int) {
        guard let n = getNode(x: x, y: y) else {
            return
        }
        if n != startNode && n != endNode {
            n.type = .wall
        }
    }
    
    func removeObstacle(x: Int, y: Int) {
        guard let n = getNode(x: x, y: y) else {
            return
        }
        if n != startNode && n != endNode {
            n.type = .normal
        }
    }
}
