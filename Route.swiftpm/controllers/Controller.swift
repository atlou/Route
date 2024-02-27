//
//  Controller.swift
//  Route
//
//  Created by Xavier on 2024-02-17.
//

import Foundation

/// User drawing mode
enum DrawingMode: CaseIterable, Identifiable {
    /// Moving the start block
    case start
    /// Moving the target block
    case target
    /// Drawing walls
    case wall
    /// Erasing walls
    case erase
    
    var id: Self { self }
}

/// Main controller of the app
/// Manages app flow and user input
class Controller: ObservableObject {
    /// Current drawing mode for the grid
    @Published var drawingMode: DrawingMode = .start
    /// Selected pathfinding algorithm
    @Published var algo: PathfindingAlgo = .dijkstra
    /// True if the pathfinding is in progress, false otherwise
    @Published var isRunning = false
    /// True if a path or visited nodes are currently disaplayed on the grid, false otherwise
    private(set) var isPathDisplayed = false
    
    /// Time delay between each node (seconds)
    let PATH_DRAWING_DELAY = 0.03
    /// Time delay after path is drawn (seconds)
    let AFTER_PATH_DELAY = 0.75
    /// Time delay before path is drawn (seconds)
    let BEFORE_PATH_DELAY = 0.3
    
    /// Grid singleton
    let grid = Grid.shared
    
    /// Singleton object
    static let shared = Controller()
    
    /// Private initializer to make Controller a singleton
    private init() {}
    
    /// Main function to run the pathfinding algorithm
    func run() {
        if isRunning { return }
        
        isRunning = true
        
        grid.clearPath()
        
        Task {
            await self.findPath()
        }
    }
    
    /// Uses MazeGenerator to generate a maze on the grid
    func generateMaze() {
        clear()
        
        // small delay to make sure the clearing animations are done
        MazeGenerator.generate(grid: grid)
    }
    
    /**
     Finds a path on the grid using the selected pathfinding algorithm
     The function runs asynchronously to allow the grid to be updated slowly.
     */
    func findPath() async {
        let start = grid.getStart()!
        let target = grid.getTarget()!
        var path: [Node] = []
        
        switch algo {
        case .astar:
            path = await Pathfinder.astar(nodes: grid.nodes, start: start, target: target) ?? []
        case .dijkstra:
            path = await Pathfinder.dijkstra(nodes: grid.nodes, start: start, target: target) ?? []
        case .greedy:
            path = await Pathfinder.greedy(nodes: grid.nodes, start: start, target: target) ?? []
        }
        
        let p = path
        // Small delay before displaying the path
        DispatchQueue.main.asyncAfter(deadline: .now() + BEFORE_PATH_DELAY) {
            self.displayPath(path: p)
        }
    }
    
    /// Displays a path on the grid
    /// Uses a Timer to display the path slowly
    /// - Parameter path: Node array that will be displayed in reversed order
    func displayPath(path: [Node]) {
        var queue = path
        _ = Timer.scheduledTimer(withTimeInterval: PATH_DRAWING_DELAY, repeats: true) { timer in
            guard let node = queue.popLast() else {
                timer.invalidate()
                // Small delay after displaying the path to allow the animations to finish
                DispatchQueue.main.asyncAfter(deadline: .now() + self.AFTER_PATH_DELAY) {
                    // Pathfinding is done
                    self.isRunning = false
                    self.isPathDisplayed = true
                }
                return
            }
            node.state = .path // Update node state
        }
    }

    /// Draws a node on the grid according to the current `drawingMode`
    /// - Parameters:
    ///   - x: horizontal position of the node on the grid
    ///   - y: vertical position of the node on the grid
    func draw(x: Int, y: Int) {
        if isRunning { return }
        if isPathDisplayed { grid.clearPath() }
        
        switch drawingMode {
        case .start:
            grid.setStart(x: x, y: y)
        case .target:
            grid.setTarget(x: x, y: y)
        case .wall:
            grid.setWall(x: x, y: y)
        case .erase:
            grid.setNormal(x: x, y: y)
        }
    }
    
    /// Clears the grid
    func clear() {
        if isRunning { return }
        grid.clearGrid()
    }
}
