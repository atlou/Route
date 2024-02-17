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
    @Published var speed: Speed = .fast
    private(set) var isRunning = false
    private(set) var isPathDisplayed = false
    
    let PATH_DRAWING_DELAY = 0.03
    let grid = Grid.shared
    
    static let shared = Controller()
    
    private init() {}
    
    func run() {
        if isRunning { return }
        if !grid.isReady() { return }
        
        isRunning = true
        grid.clearPath()
        Task {
            await findPath()
        }
    }
    
    func findPath() async {
        let start = grid.getStart()!
        let target = grid.getTarget()!
        switch algo {
        case .astar:
            let path = await AStar.shared.findPath(start: start, target: target) ?? []
            await MainActor.run {
                displayPath(path: path) {
                    self.isRunning = false
                    self.isPathDisplayed = true
                }
            }
        }
    }
    
    func displayPath(path: [Node], completion: @escaping () -> Void) {
        var queue = path
        _ = Timer.scheduledTimer(withTimeInterval: PATH_DRAWING_DELAY, repeats: true) { timer in
            guard let node = queue.popLast() else {
                timer.invalidate()
                DispatchQueue.main.async { completion() }
                return
            }
            node.state = .path
        }
    }
    
    func draw(x: Int, y: Int) {
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
