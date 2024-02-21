//
//  File.swift
//
//
//  Created by Xavier on 2024-02-17.
//

import Foundation

enum DrawingMode: CaseIterable, Identifiable {
    case start
    case target
    case wall
    case erase
    
    var id: Self { self }
}

enum Speed: Double, CaseIterable, Identifiable {
    case fast = 0.01
    case medium = 0.015
    case slow = 0.05
    
    var ms: Double {
        return rawValue * 1_000
    }
    
    var ns: Double {
        return rawValue * 1_000_000_000
    }
    
    var id: Self { self }
}

class Controller: ObservableObject {
    @Published var drawingMode: DrawingMode = .start
    @Published var algo: PathfindingAlgo = .dijkstra
    @Published var speed: Speed = .medium
    @Published var isRunning = false
    private(set) var isPathDisplayed = false
    
    let PATH_DRAWING_DELAY = 0.03
    let grid = Grid.shared
//    let maze = MazeGeneration.shared
    
    static let shared = Controller()
    
    private init() {}
    
    func run() {
        if isRunning { return }
        if !grid.isReady() { return }
        
        isRunning = true
        
        grid.clearPath()
        
        Task {
            await self.findPath()
        }
    }
    
    func generateMaze() {
        clear()
        
        // small delay to make sure the clearing animations are done
        MazeGenerator.generate(grid: grid)
    }
    
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
        // delay before showing path to let animations finish
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.displayPath(path: p) {
                self.isRunning = false
                self.isPathDisplayed = true
            }
        }
    }
    
    func displayPath(path: [Node], completion: @escaping () -> Void) {
        var queue = path
        _ = Timer.scheduledTimer(withTimeInterval: PATH_DRAWING_DELAY, repeats: true) { timer in
            guard let node = queue.popLast() else {
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                    // delay after showing path to let animation end
                    completion()
                }
                return
            }
            node.state = .path
        }
    }

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
    
    func clear() {
        if isRunning { return }
        grid.clearGrid()
    }
}
