import SwiftUI

struct ContentView: View {
    @StateObject var grid = Grid(size: 12)
    var body: some View {
        ZStack {
            GridView(grid: grid)
        }
    }
}

struct GridView: View {
    @ObservedObject var grid: Grid

    func color(_ ct: CellType) -> Color {
        switch ct {
        case .water: return .blue
        case .grass: return .green
        case .wheat: return .yellow
        }
    }

    var body: some View {
        HStack(spacing: -60) {
            ForEach(Array(grid.cells.enumerated()), id: \.offset) { i, row in
                VStack(spacing: -60) {
                    ForEach(Array(row.enumerated()), id: \.offset) { j, cell in
                        CubeView(color: color(cell))
                            .id("\(i * j) \(cell)")
                            .onTapGesture {
                                print("[\(i),\(j)]")
                                withAnimation(.bouncy) {
                                    grid.water(x: i, y: j)
                                }
                            }
                            .transition(.asymmetric(insertion: .scale, removal: .scale.combined(with: .opacity)))
//                            .border(.red)
                    }
                }
                .zIndex(Double(-i))
            }
        }
        .rotationEffect(.degrees(-45))
        .scaleEffect(y: 0.6)
    }
}
