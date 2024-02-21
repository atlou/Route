//
//  MazeGenerator.swift
//  Route
//
//  Created by Xavier on 2024-02-18.
//

import Foundation

enum MazeGenerator {
    private enum Orientation: CaseIterable {
        case vertical
        case horizontal
    }
    
    static func generate(grid: Grid) {
        // draw borders
        for x in 0...grid.width - 1 {
            grid.setWall(x: x, y: 0)
            grid.setWall(x: x, y: grid.height - 1)
        }
        for y in 0...grid.height - 1 {
            grid.setWall(x: 0, y: y)
            grid.setWall(x: grid.width - 1, y: y)
        }
        
        divide(x: 0, y: 0, width: grid.width, height: grid.height)
    }
    
    private static func getOrientation(width: Int, height: Int) -> Orientation {
        if width < height {
            return .horizontal
        } else if width > height {
            return .vertical
        }
        return Orientation.allCases.randomElement()!
    }
    
    private static func divide(x: Int, y: Int, width: Int, height: Int) {
        if width < 2 || height < 2 { return }
        
        let orientation = getOrientation(width: width, height: height)
        
        var wallX: Int
        var wallY: Int
        var holeX: Int
        var holeY: Int
        var length: Int
        
        if orientation == .horizontal {
            if width < 5 { return }
            wallX = x
            wallY = y + (1...height - 3).filter { $0 % 2 == 0 }.randomElement()!
            
            holeX = wallX + (1...width - 2).filter { $0 % 2 == 1 }.randomElement()!
            holeY = wallY
            
            length = width
        } else {
            if height < 5 { return }
            wallX = x + (1...width - 3).filter { $0 % 2 == 0 }.randomElement()!
            wallY = y
            
            holeX = wallX
            holeY = wallY + (1...height - 2).filter { $0 % 2 == 1 }.randomElement()!
            
            length = height
        }
        
        if orientation == .horizontal {
            for i in wallX..<wallX + length {
                if i != holeX || wallY != holeY {
                    Grid.shared.setWall(x: i, y: wallY)
                }
            }
        } else {
            for i in wallY..<wallY + length {
                if wallX != holeX || i != holeY {
                    Grid.shared.setWall(x: wallX, y: i)
                }
            }
        }
        
        if orientation == .horizontal {
            divide(x: x, y: y, width: width, height: wallY - y + 1)
            divide(x: x, y: wallY, width: width, height: height - wallY + y)
        } else {
            divide(x: x, y: y, width: wallX - x + 1, height: height)
            divide(x: wallX, y: y, width: width - wallX + x, height: height)
        }
    }
}
