//
//  File.swift
//
//
//  Created by Xavier on 2024-02-17.
//

import Foundation

class Controller: ObservableObject {
    @Published var drawingMode: DrawingMode = .start
    @Published var algo: PathfindingAlgo = .astar
    @Published var speed: Speed = .medium
    @Published var isRunning = false
    private(set) var isPathDisplayed = false
    
    let PATH_DRAWING_DELAY = 0.03
    let grid = Grid.shared
    let maze = MazeGeneration.shared
    
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
        maze.generate()
    }
    
    func findPath() async {
        let start = grid.getStart()!
        let target = grid.getTarget()!
        switch algo {
        case .astar:
            let path = await AStar.shared.findPath(start: start, target: target) ?? []
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // delay before showing path
                self.displayPath(path: path) {
                    self.isRunning = false
                    self.isPathDisplayed = true
                }
            }
        default:
            return
        }
    }
    
    func displayPath(path: [Node], completion: @escaping () -> Void) {
        var queue = path
        _ = Timer.scheduledTimer(withTimeInterval: PATH_DRAWING_DELAY, repeats: true) { timer in
            guard let node = queue.popLast() else {
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                    // delay after showing path to let animations end
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
