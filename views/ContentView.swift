import SwiftUI

struct ContentView: View {
    @StateObject var grid = Grid.shared

    var body: some View {
        ZStack {
            Color.gray.opacity(0.2)
                .ignoresSafeArea()
            HStack(spacing: 20) {
                PanelView(grid: grid)
                    .frame(width: 300)
                    .frame(maxHeight: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.white)
                    }
                ZStack {
                    GridView(grid: grid, size: 30.0)
                        .padding(-2)
                        .clipShape(.rect(cornerRadius: 20))
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.white)
                        }
                    VStack {
                        Spacer()
                    }
                }
            }
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}
