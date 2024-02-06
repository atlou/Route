//
//  Grid.swift
//  Pathfinding
//
//  Created by Xavier on 2024-02-05.
//

import Foundation

enum CellType {
    case grass
    case water
    case wheat
}

class Grid: ObservableObject {
    @Published var cells: [[CellType]]

    init(size: Int) {
        self.cells = [[CellType]](repeating: [CellType](repeating: .grass, count: size), count: size)
    }

    func water(x: Int, y: Int) {
        self.cells[x][y] = .water
        self.objectWillChange.send()
    }

    func grass(x: Int, y: Int) {
        self.cells[x][y] = .grass
        self.objectWillChange.send()
    }
}
