//
//  MazeGeneration.swift
//
//
//  Created by Xavier on 2024-02-18.
//

import Foundation

enum Orientation: CaseIterable {
    case vertical
    case horizontal
}

class MazeGeneration {
    let grid = Grid.shared
    let space = 1
    
    static let shared = MazeGeneration()
    
    private init() {}
    
    func generate() {
        // draw sides
        drawSquare()
        
        divide(x: 0, y: 0, width: grid.width - 1, height: grid.height - 1)
    }
    
    private func drawSquare() {
        drawHLine(x1: 0, x2: grid.width, y: 0)
        drawHLine(x1: 0, x2: grid.width - 1, y: grid.height - 1)
        drawVLine(y1: 0, y2: grid.height - 1, x: 0)
        drawVLine(y1: 0, y2: grid.height - 1, x: grid.width - 1)
    }
    
    private func getOrientation(width: Int, height: Int) -> Orientation {
        if width < height {
            return .horizontal
        } else if width > height {
            return .vertical
        }
        return Orientation.allCases.randomElement()!
    }
    
    private func divide(x: Int, y: Int, width: Int, height: Int) {
        print("divide")
        if width < 2 || height < 2 { return }
        
        let orientation = getOrientation(width: width, height: height)
        
        var wallX: Int
        var wallY: Int
        var holeX: Int
        var holeY: Int
        var length: Int
        
        if orientation == .horizontal {
            wallX = x
            wallY = Int.random(in: y..<height - 1)
            
            holeX = wallX + Int.random(in: 1..<width)
            holeY = wallY
            
            length = width
        } else {
            wallX = Int.random(in: x..<width - 1)
            wallY = y
            
            holeX = wallX
            holeY = wallY + Int.random(in: 1..<height)
            
            length = height
        }
        
        draw(x: wallX, y: wallY, length: length, orientation: orientation, holeX: holeX, holeY: holeY)
        
        if orientation == .horizontal {
            divide(x: x, y: y, width: width, height: wallY - y)
            divide(x: x, y: wallY, width: width, height: x + width - wallX)
        } else {
            divide(x: x, y: y, width: wallX - x + 1, height: height)
            divide(x: wallX, y: y, width: y + height - wallY - 1, height: height)
        }
    }
    
    private func drawHLine(x1: Int, x2: Int, y: Int) {
        if x1 > x2 {
            print("x1 > x2")
            return
        }
        for i in x1...x2 {
            grid.setWall(x: i, y: y)
        }
    }
    
    private func draw(x: Int, y: Int, length: Int, orientation: Orientation, holeX: Int, holeY: Int) {
        print("hole: \(holeX), \(holeY)")
        if orientation == .horizontal {
            for i in x...x + length {
                if i != holeX || y != holeY {
                    grid.setWall(x: i, y: y)
                }
            }
        } else {
            for i in y...y + length {
                if x != holeX || i != holeY {
                    grid.setWall(x: x, y: i)
                }
            }
        }
    }
    
    private func drawVLine(y1: Int, y2: Int, x: Int) {
        if y1 > y2 {
            print("y1 > y2")
            return
        }
        for i in y1...y2 {
            grid.setWall(x: x, y: i)
        }
    }
}
