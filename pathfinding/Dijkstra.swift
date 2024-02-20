//
//  Dijkstra.swift
//
//
//  Created by Xavier on 2024-02-19.
//

import Foundation

class Dijkstra {
    var map: [Node: DijkstraNode] = [:]
    
    static let shared = Dijkstra(nodes: Grid.shared.nodes)
    
    private init(nodes: [Node]) {
        for node in nodes {
            let dijkstraNode = DijkstraNode(node: node)
            self.map[node] = dijkstraNode
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
        
        self.resetNodes()
        
        var unexplored: Set<DijkstraNode> = []
        start.setDistance(distance: 0)
        
        for item in self.map {
            unexplored.insert(item.value)
        }
        
        while !unexplored.isEmpty {
            let curr: DijkstraNode = unexplored.min(by: {
                $0.distance < $1.distance
            })!
            
            print(curr.distance)
            
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
                $0.isWalkable() && unexplored.contains(self.map[$0]!)
            }
            
            print("neighbors: \(neighbors.count)")
            
            for neighbor in neighbors {
                let neighbor = self.map[neighbor]!
                let dist = curr.distance + Int(curr.node.getDistance(from: neighbor.node))
                
                if dist < neighbor.distance {
                    print("found neighbor")
                    neighbor.setDistance(distance: dist)
                    neighbor.setPrev(node: curr)
                }
            }
        }
        
        return nil
    }
    
    func resetNodes() {
        for item in self.map {
            item.value.reset()
        }
    }
}

class DijkstraNode: Hashable {
    private(set) var node: Node
    private(set) var prev: DijkstraNode?
    private(set) var distance: Int
    
    init(node: Node) {
        self.node = node
        self.distance = Int.max
    }
    
    func reset() {
        self.prev = nil
        self.distance = Int.max
    }
    
    func setPrev(node: DijkstraNode) {
        self.prev = node
    }
    
    func setDistance(distance: Int) {
        self.distance = distance
    }
    
    static func == (lhs: DijkstraNode, rhs: DijkstraNode) -> Bool {
        lhs.node == rhs.node
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.node)
    }
}
