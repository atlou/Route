//
//  PathfindingAlgo.swift
//  Pathfinding
//
//  Created by Xavier on 2024-02-20.
//

import Foundation
import SwiftUI

enum PathfindingAlgo: CaseIterable, Identifiable, CustomStringConvertible {
    case dijkstra
    case greedy
    case astar

    var id: Self { self }

    var description: String {
        switch self {
        case .astar: return "A-Star"
        case .dijkstra: return "Dijkstra's"
        case .greedy: return "Greedy BFS"
        }
    }

    var detailedDescription: LocalizedStringKey {
        switch self {
        case .astar:
            return "**A-Star** is like a smart navigator who finds a balance between being careful and quick.\n\nIt's not as careful as **Dijkstra's**, which helps it move faster, but that also means it might not always pick the very best path.\n\nAt the same time, it's not as rushed as **Greedy Best-First Search**, allowing it to avoid big mistakes and often find a good path, even if it takes a bit longer."
        case .dijkstra:
            return "**Dijkstra's** algorithm is like a thorough explorer that methodically checks every possible path to find the shortest one.\n\nThe good part is that we are guaranteed to find the shortest route every time.\n\nHowever, this comes at the cost of speed and memory because it doesn't ignore any path, even ones that seem unlikely to be the shortest at first glance."
        case .greedy:
            return "**Greedy Best-First Search** is like an eager tourist trying to reach a landmark, always moving toward what looks closest on the map without worrying about obstacles in the way. It picks the path that seems closest to the goal at each step.\n\nThis makes it very fast because it doesn't wait before making decisions.\n\nOn the flip side, its eagerness can lead it to take longer routes. It might get stuck or go in less optimal directions because it doesn't consider the overall journey, just the next step."
        }
    }
}
