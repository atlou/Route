//
//  AStar.swift
//  Pathfinding
//
//  Created by Xavier on 2024-02-14.
//

import Foundation

class AStar {
    public static func findPath(start: Node, target: Node) -> [Node]? {
        print("(A-star) start: \(start) target: \(target)")
        var toSearch: Set<AStarNode> = [AStarNode(node: start)]
        var processed: Set<AStarNode> = []
        
        while !toSearch.isEmpty {
            var curr = toSearch.popFirst()!
            for t in toSearch {
                if t.f < curr.f || t.f == curr.f && t.h < curr.h {
                    curr = t
                }
            }
            
            processed.insert(curr)
            
            if curr.node == target {
                var currentPathTile = curr
                var path: [Node] = []
                
                while currentPathTile.node != start {
                    path.append(currentPathTile.node)
                    print("added \(currentPathTile.node) to the path")
                    currentPathTile = currentPathTile.prev!
                }
                
                return path
            }
            
            let neighbors = curr.node.neighbors.map {
                AStarNode(node: $0)
            }.filter {
                $0.node.walkable && !processed.contains($0)
            }
            
            for neighbor in neighbors {
                let cost = curr.g + Float(curr.node.getDistance(node: neighbor.node))
                
                if !toSearch.contains(neighbor) || cost < neighbor.g {
                    neighbor.setG(value: cost)
                    neighbor.setPrev(node: curr)
                    Grid.shared.setVisited(node: neighbor.node)
                    
                    if !toSearch.contains(neighbor) {
                        neighbor.setH(value: Float(neighbor.node.getDistance(node: target)))
                        toSearch.insert(neighbor)
                    }
                }
            }
        }
        
        return nil
    }
}

class AStarNode: Hashable {
    let node: Node
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
    
    static func == (lhs: AStarNode, rhs: AStarNode) -> Bool {
        return lhs.node == rhs.node
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.node)
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
}
