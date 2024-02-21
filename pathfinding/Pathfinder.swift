//
//  Pathfinder.swift
//  Route
//
//  Created by Xavier on 2024-02-21.
//

import Foundation

enum Pathfinder {
    private static func displayVisited(node: Node) async {
        // display visited node and sleep
        DispatchQueue.main.async {
            Grid.shared.setVisited(node: node)
        }
        
        do {
            try await Task.sleep(nanoseconds: UInt64(Controller.shared.speed.ns))
        } catch {
            print("sleep error")
        }
    }
    
    private static func getPath(start: Node, target: Node) -> [Node]? {
        var curr = target
        var path: [Node] = []
        
        while curr != start {
            path.append(curr)
            guard let parent = curr.parent else {
                print("backtracking error: \(curr) has no parent")
                return nil
            }
            curr = parent
        }
        
        return path
    }
    
    static func dijkstra(nodes: [Node], start: Node, target: Node) async -> [Node]? {
        var toExplore: Set<Node> = []
        var explored: Set<Node> = []
        
        // reset node attributes
        for node in nodes {
            node.hCost = Int.max
            node.parent = nil
        }
        
        start.hCost = 0
        
        toExplore.insert(start)
        
        while !toExplore.isEmpty {
            let curr = toExplore.min(by: { a, b in
                if a.hCost == b.hCost {
                    // when multiple nodes have the same distance, picking them using an arbitrary order gives a cleaner look to the visited nodes visualization
                    return a.x > b.x || (a.x == b.x && a.y < b.y)
                }
                return a.hCost < b.hCost
            })!
            
            toExplore.remove(curr)
            explored.insert(curr)
            
            await displayVisited(node: curr)
            
            // path found
            if curr == target {
                return getPath(start: start, target: target)
            }
            
            let neighbors = curr.neighbors.filter {
                $0.isWalkable() && !explored.contains($0)
            }
            
            for neighbor in neighbors {
                let hCost = curr.hCost + neighbor.getDistance(from: curr)
                
                if hCost < neighbor.hCost || !toExplore.contains(neighbor) {
                    neighbor.hCost = hCost
                    neighbor.parent = curr
                }
                
                toExplore.insert(neighbor)
            }
        }
        
        return nil
    }
    
    static func greedy(nodes: [Node], start: Node, target: Node) async -> [Node]? {
        var toExplore: Set<Node> = []
        var explored: Set<Node> = []
        
        // reset node attributes
        for node in nodes {
            node.gCost = 0
            node.hCost = 0
            node.parent = nil
        }
        
        toExplore.insert(start)
        
        while !toExplore.isEmpty {
            let curr = toExplore.min(by: { a, b in
                if a.hCost == b.hCost {
                    // when multiple nodes have the same distance, picking them using an arbitrary order gives a cleaner look to the visited nodes visualization
                    return a.x > b.x || (a.x == b.x && a.y < b.y)
                }
                return a.hCost < b.hCost
            })!
            
            toExplore.remove(curr)
            explored.insert(curr)
            
            await displayVisited(node: curr)
            
            // path found
            if curr == target {
                return getPath(start: start, target: target)
            }
            
            let neighbors = curr.neighbors.filter {
                $0.isWalkable() && !explored.contains($0)
            }
            
            for neighbor in neighbors {
                if !toExplore.contains(neighbor) {
                    neighbor.hCost = neighbor.getDistance(from: target)
                    neighbor.parent = curr
                    toExplore.insert(neighbor)
                }
            }
        }
        
        return nil
    }
    
    static func astar(nodes: [Node], start: Node, target: Node) async -> [Node]? {
        var toExplore: Set<Node> = []
        var explored: Set<Node> = []
        
        // reset node attributes
        for node in nodes {
            node.gCost = 0
            node.hCost = 0
            node.parent = nil
        }
        
        toExplore.insert(start)
        
        while !toExplore.isEmpty {
            let curr = toExplore.min(by: { a, b in
                if a.fCost == b.fCost {
                    if a.hCost == b.hCost {
                        // when multiple nodes have the same distance, picking them using an arbitrary order gives a cleaner look to the visited nodes visualization
                        return a.x > b.x || (a.x == b.x && a.y < b.y)
                    }
                    return a.hCost < b.hCost
                }
                return a.fCost < b.fCost
            })!
            
            toExplore.remove(curr)
            explored.insert(curr)
            
            await displayVisited(node: curr)
            
            // path found
            if curr == target {
                return getPath(start: start, target: target)
            }
            
            let neighbors = curr.neighbors.filter {
                $0.isWalkable() && !explored.contains($0)
            }
            
            for neighbor in neighbors {
                let gCost = curr.gCost + neighbor.getDistance(from: curr)
                
                if gCost < neighbor.gCost || !toExplore.contains(neighbor) {
                    neighbor.gCost = gCost
                    neighbor.parent = curr
                }
                
                if !toExplore.contains(neighbor) {
                    neighbor.hCost = neighbor.getDistance(from: target)
                    toExplore.insert(neighbor)
                }
            }
        }
        
        return nil
    }
}
