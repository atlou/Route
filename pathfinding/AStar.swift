//
//  AStar.swift
//  Pathfinding
//
//  Created by Xavier on 2024-02-14.
//

import Foundation

extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Double) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}

class AStar {
    var map: [Node: AStarNode] = [:]
    
    init(nodes: [Node]) {
        for node in nodes {
            let astarNode = AStarNode(node: node)
            self.map[node] = astarNode
        }
    }
    
    public func findPath(start: Node, target: Node) async -> [Node]? {
        print("(A-star) start: \(start) target: \(target)")
        var toSearch: Set<AStarNode> = []
        var processed: Set<AStarNode> = []
        
        guard let start = map[start] else {
            print("can't map start node")
            return nil
        }
        guard let target = map[target] else {
            print("can't map target node")
            return nil
        }
        
        toSearch.insert(start)
        
        while !toSearch.isEmpty {
            var curr = toSearch.first!
            for t in toSearch {
                if t.f < curr.f || (t.f == curr.f && t.h < curr.h) {
                    curr = t
                }
            }
            
            toSearch.remove(curr)
            processed.insert(curr)
            
            do {
                try await Task.sleep(nanoseconds: 6_000_000)
            } catch {
                print("sleep error")
            }
            
            DispatchQueue.main.async {
                Grid.shared.drawVisited(visited: curr.node)
            }
            
            if curr == target {
                var currentPathTile = target
                var path: [Node] = []
                
                while currentPathTile != start {
                    path.append(currentPathTile.node)
                    print("added \(currentPathTile.node) to the path")
                    currentPathTile = currentPathTile.prev!
                }
                
                return path
            }
            
            let neighbors = curr.node.neighbors.filter {
                $0.walkable && !processed.contains(self.map[$0]!)
            }
            
            print("\(curr.node) has \(neighbors.count) neighbors")
            
            for neighborNode in neighbors {
                let neighbor = self.map[neighborNode]!
                let inSearch = toSearch.contains(neighbor)
                let cost = curr.g + neighborNode.getDistance(from: curr.node)
                
                if cost < neighbor.g || !inSearch {
                    neighbor.setG(value: cost)
                    neighbor.setPrev(node: curr)
                }
                
                if !inSearch {
                    neighbor.setH(value: neighbor.node.getDistance(from: target.node))
                    print("added neighbor \(neighbor.node)")
                    toSearch.insert(neighbor)
                }
            }
        }
        
        return nil
    }
}

class AStarNode: Hashable {
    private(set) var node: Node
    private(set) var prev: AStarNode?
    private(set) var g: Float
    private(set) var h: Float
    var f: Float {
        return self.g + self.h
    }
    
    init(node: Node) {
        self.node = node
        self.g = 0
        self.h = 0
    }
    
    func setPrev(node: AStarNode) {
        self.prev = node
    }
    
    func setG(value: Float) {
        self.g = value
    }
    
    func setH(value: Float) {
        self.h = value
    }
    
    static func == (lhs: AStarNode, rhs: AStarNode) -> Bool {
        lhs.node == rhs.node
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.node)
    }
}
