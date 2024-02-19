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
        
        divide(x: 0, y: 0, width: grid.width - 1, height: grid.height - 1, orientation: Orientation.allCases.randomElement()!)
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
    
    private func divide(x: Int, y: Int, width: Int, height: Int, orientation: Orientation) {
        print("divide")
        if width < space * 2 || height < space * 2 { return }
        
        if orientation == .horizontal {
            let y2 = Int.random(in: y + space + 1...y + height - space - 1)
            let x2 = x + width - 1
            let hole = Int.random(in: x + 1 + (space / 2)...x2 - 1 - (space / 2))
            
            // drawHLine
            drawHLine(x1: x, x2: hole - 1 - (space / 2), y: y2)
            drawHLine(x1: hole + 1 + (space / 2), x2: x2, y: y2)
            
            // recursion
            divide(x: x, y: y, width: width, height: y2 - y, orientation: getOrientation(width: width, height: y2 - y))
            divide(x: x, y: y2, width: width, height: height - y2, orientation: getOrientation(width: width, height: height - y2))
        } else {
            let x2 = Int.random(in: x + space + 1...x + width - space - 1)
            let y2 = y + width - 1
            let hole = Int.random(in: y + 1 + (space / 2)...y2 - 1 - (space / 2))
            
            // drawVLine
            drawVLine(y1: y, y2: hole - 1 - (space / 2), x: x2)
            drawVLine(y1: hole + 1 + (space / 2), y2: y2, x: x2)
            
            // recursion
            divide(x: x, y: y, width: x2 - x, height: height, orientation: getOrientation(width: x2 - x, height: height))
            divide(x: x2, y: y, width: width - x2, height: height, orientation: getOrientation(width: width - x2, height: height))
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
