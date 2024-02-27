//
//  MazeGenerator.swift
//  Route
//
//  Created by Xavier on 2024-02-18.
//

import Foundation

/// Contains a few static functions that handle maze generation
enum MazeGenerator {
    /// Orientation of the line that will be drawn
    private enum Orientation: CaseIterable {
        case vertical
        case horizontal
    }
    
    /// Main function that draws the borders and starts the recursive division
    /// - Parameter grid: the grid where the maze will be generated
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
        
        // start recursion
        divide(x: 0, y: 0, width: grid.width, height: grid.height)
    }
    
    /// Determines which orientation should the division take, according to the dimensions of the area
    /// - Parameters:
    ///   - width: width of the area to divide
    ///   - height: height of the area to divide
    /// - Returns: the orientation the division should take
    private static func getOrientation(width: Int, height: Int) -> Orientation {
        if width < height {
            return .horizontal // if the rectangle is taller, divide it horizontally
        } else if width > height {
            return .vertical // if the rectangle is larger, divide it vertically
        }
        return Orientation.allCases.randomElement()! // if it's a square, divide it randomly
    }
    
    /// Recursive function that divides an area in two
    /// There is a recursive call for both parts of the divided area
    /// The lines are drawn on even coordinates, and the holes on odd coordinates
    /// - Parameters:
    ///   - x: horizontal coordinates of the top left corner of the area
    ///   - y: vertical coordinates of the top left corner of the area
    ///   - width: width of the area, in nodes
    ///   - height: height of the area, in nodes
    private static func divide(x: Int, y: Int, width: Int, height: Int) {
        if width < 2 || height < 2 { return }
        
        let orientation = getOrientation(width: width, height: height)
        
        /// horizontal coordinates of the division line starting point
        var wallX: Int
        /// vertical coordinates of the division line starting point
        var wallY: Int
        /// horizontal coordinates of the hole in the division line
        var holeX: Int
        /// vertical coordinates of the hole in the division line
        var holeY: Int
        /// length of the division line
        var length: Int
        
        if orientation == .horizontal {
            if width < 5 { return }
            
            wallX = x
            // random even number between the current y and the height
            wallY = y + (1...height - 3).filter { $0 % 2 == 0 }.randomElement()!
            
            // random odd number between the start and end of the line
            holeX = wallX + (1...width - 2).filter { $0 % 2 == 1 }.randomElement()!
            holeY = wallY
            
            length = width
        } else {
            if height < 5 { return }
            // random even number between the current x and the width
            wallX = x + (1...width - 3).filter { $0 % 2 == 0 }.randomElement()!
            wallY = y
            
            holeX = wallX
            // random even number between the current start and end of the line
            holeY = wallY + (1...height - 2).filter { $0 % 2 == 1 }.randomElement()!
            
            length = height
        }
        
        if orientation == .horizontal {
            // draw horizontal line
            for i in wallX..<wallX + length {
                if i != holeX || wallY != holeY {
                    Grid.shared.setWall(x: i, y: wallY)
                }
            }
        } else {
            // draw vertical line
            for i in wallY..<wallY + length {
                if wallX != holeX || i != holeY {
                    Grid.shared.setWall(x: wallX, y: i)
                }
            }
        }
        
        // recursive call with the divided subareas
        if orientation == .horizontal {
            divide(x: x, y: y, width: width, height: wallY - y + 1)
            divide(x: x, y: wallY, width: width, height: height - wallY + y)
        } else {
            divide(x: x, y: y, width: wallX - x + 1, height: height)
            divide(x: wallX, y: y, width: width - wallX + x, height: height)
        }
    }
}
