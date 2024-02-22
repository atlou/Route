//
//  PathfindingAlgo.swift
//  Route
//
//  Created by Xavier on 2024-02-20.
//

import Foundation
import SwiftUI

/// Pathfinding algorithm for user selection
enum PathfindingAlgo: CaseIterable, Identifiable, CustomStringConvertible {
    case dijkstra
    case greedy
    case astar

    var id: Self { self }

    /// The name of the algorithm as will be shown in UI
    var description: String {
        switch self {
        case .astar: return "A-Star"
        case .dijkstra: return "Dijkstra's"
        case .greedy: return "Greedy BFS"
        }
    }

    /// The description of the algorithm that explains the algorithm's characteristics
    var detailedDescription: LocalizedStringKey {
        switch self {
        case .astar:
            return "**A-Star** is like a smart navigator who finds a balance between being careful and quick.\n\nIt's not as careful as **Dijkstra's**, which helps it move faster. That also means it might not always pick the very best path.\n\nAt the same time, it's not as rushed as **Greedy Best-First Search**. This makes it a little slower, but big mistakes are less likely to happen."
        case .dijkstra:
            return "**Dijkstra's** algorithm is like a thorough explorer that methodically checks every possible path to find the shortest one.\n\nThe great thing is, it always finds the shortest path.\n\nHowever, this comes at the cost of speed and memory because it does not ignore any path, even the ones that don't seem promising."
        case .greedy:
            return "**Greedy Best-First Search** is like an eager tourist trying to reach a landmark. It's always moving toward what looks closest to the goal without worrying about obstacles in the way.\n\nThis makes it very fast because it doesn't wait to compare and evaluate other paths before going in.\n\nOn the flip side, its eagerness can lead it to take longer routes. It might get stuck or go in less optimal directions."
        }
    }
}
