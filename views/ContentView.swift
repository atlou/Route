import SwiftUI

enum DrawingMode: CaseIterable, Identifiable {
    case start
    case end
    case obstacle
    case erase
    
    var id: Self { self }
    
//    var description: String {
//            switch self {
//            case .start:
//                return "Start"
//            case .end:
//                return "Ask to Join"
//            case .automatic:
//                return "Automatic"
//            }
//        }
}

struct ContentView: View {
    @StateObject var grid = Grid(width: 26, height: 26)
    @State private var drawingMode: DrawingMode = .start

    var body: some View {
        ZStack {
            Color.gray.opacity(0.2)
                .ignoresSafeArea()
            HStack(spacing: 20) {
                PanelView(grid: grid, drawingMode: $drawingMode)
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
