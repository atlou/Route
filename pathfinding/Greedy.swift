//
//  DFS.swift
//
//
//  Created by Xavier on 2024-02-20.
//

import Foundation

class Greedy {
    var map: [Node: GreedyNode] = [:]
    
    static let shared = Greedy(nodes: Grid.shared.nodes)
    
    private init(nodes: [Node]) {
        for node in nodes {
            let greedyNode = GreedyNode(node: node)
            self.map[node] = greedyNode
        }
    }
    
    func findPath(start: Node, target: Node) async -> [Node]? {
        guard let start = map[start] else {
            print("can't map start node")
            return nil
        }
        guard let target = map[target] else {
            print("can't map target node")
            return nil
        }
        
        reset()
        
        var unexplored: Set<GreedyNode> = []
        var explored: Set<GreedyNode> = []
        
        for item in self.map {
            unexplored.insert(item.value)
        }
        
        start.setH(target: target.node)
        explored.insert(start)
        
        while !unexplored.isEmpty {
            let curr: GreedyNode = unexplored.min(by: { $0.h < $1.h })!
            
            unexplored.remove(curr)
            
            do {
                try await Task.sleep(nanoseconds: UInt64(Controller.shared.speed.ns))
            } catch {
                print("sleep error")
            }
            
            let visited = curr.node
            DispatchQueue.main.async {
                Grid.shared.setVisited(node: visited)
            }
            
            // is path found?
            if curr == target {
                // backtrack to start node
                var currentPathTile = target
                var path: [Node] = []
                
                while currentPathTile != start {
                    path.append(currentPathTile.node)
                    currentPathTile = currentPathTile.prev!
                }
                
                return path
            }
            
            let neighbors = curr.node.neighbors.filter {
                $0.isWalkable() && !explored.contains(self.map[$0]!)
            }
            
            print("neighbors: \(neighbors.count)")
            
            for neighbor in neighbors {
                let neighbor = self.map[neighbor]!
                neighbor.setH(target: target.node)
                neighbor.setPrev(node: curr)
                
                explored.insert(neighbor)
            }
        }
        
        return nil
    }
    
    func reset() {
        for item in map {
            item.value.reset()
        }
    }
}

class GreedyNode: Hashable {
    private(set) var node: Node
    private(set) var prev: GreedyNode?
    private(set) var h: Int
    
    init(node: Node) {
        self.node = node
        self.h = Int.max
    }
    
    func reset() {
        self.h = Int.max
    }
    
    func setH(target: Node) {
        self.h = Int(self.node.getDistance(from: target))
    }
    
    func setPrev(node: GreedyNode) {
        self.prev = node
    }
    
    static func == (lhs: GreedyNode, rhs: GreedyNode) -> Bool {
        lhs.node == rhs.node
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.node)
    }
}
