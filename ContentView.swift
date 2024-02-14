import SwiftUI

struct ContentView: View {
    @StateObject var grid = Grid(width: 20, height: 20)

    var body: some View {
        ZStack {
            Color.gray.opacity(0.2)
                .ignoresSafeArea()
            HStack(spacing: 20) {
                VStack(spacing: 20) {
                    Text("[pathfinding algo]")
                    Button("Reset") {
                        withAnimation(.default.speed(2)) {
//                            grid.clear()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(width: 300)
                .frame(maxHeight: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white)
                }
                GridView(grid: grid, size: 36.0)
                    .padding(-2)
                    .clipShape(.rect(cornerRadius: 20))
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.white)
                    }
            }
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}
