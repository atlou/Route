//
//  Pathfinder.swift
//  Route
//
//  Created by Xavier on 2024-02-21.
//

import Foundation

/// Contains a few static functions that handle pathfinding
enum Pathfinder {
    /// Displays a visited node on the grid and sleeps for 0.015s to allow the pathfinding algorithm to be visualized slowly
    /// - Parameter node: The node to be displayed as visited
    private static func displayVisited(node: Node) async {
        // display the node
        DispatchQueue.main.async {
            Grid.shared.setVisited(node: node)
        }
        
        // sleep
        do {
            try await Task.sleep(nanoseconds: 15_000_000)
        } catch {
            print("sleep error")
        }
    }
    
    /// This function backtracks from the target node to the start node and returns the full path
    /// - Parameters:
    ///   - start: The start node
    ///   - target: The target node
    /// - Returns: The path from the target node to the start node
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
    
    /// Implementation of Dijkstra's algorithm
    /// This algorithm visits all possible nodes around the current explored nodes until it reaches the target node
    /// - Parameters:
    ///   - nodes: Array of all the grid's nodes
    ///   - start: Start node
    ///   - target: Target node
    /// - Returns: An array of nodes representing the path it found, and nil if it didn't find any
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
            
            // get neighbors that are walkable and unexplored
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
    
    /// Implementation of Greedy Best-First Search algorithm
    /// This algorithm visits the node that is the closest from the target node until it reaches the target node
    /// - Parameters:
    ///   - nodes: Array of all the grid's nodes
    ///   - start: Start node
    ///   - target: Target node
    /// - Returns: An array of nodes representing the path it found, and nil if it didn't find any
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
            let curr = toExplore.min(by: {
                $0.hCost < $1.hCost
            })!
            
            toExplore.remove(curr)
            explored.insert(curr)
            
            await displayVisited(node: curr)
            
            // path found
            if curr == target {
                return getPath(start: start, target: target)
            }
            
            // get neighbors that are walkable and unexplored
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
    
    /// Implementation of A-star algorithm
    /// This algorithm visits the node that is both the closest from the target node and the start node until it reaches the target node
    /// - Parameters:
    ///   - nodes: Array of all the grid's nodes
    ///   - start: Start node
    ///   - target: Target node
    /// - Returns: An array of nodes representing the path it found, and nil if it didn't find any
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
            
            // get neighbors that are walkable and unexplored
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
