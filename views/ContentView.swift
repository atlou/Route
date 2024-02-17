import SwiftUI

struct ContentView: View {
    @StateObject var controller = Controller.shared

    var body: some View {
        ZStack {
            Color.gray.opacity(0.2)
                .ignoresSafeArea()
            HStack(spacing: 20) {
                PanelView(controller: controller)
                    .frame(width: 300)
                    .frame(maxHeight: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.white)
                    }
                ZStack {
                    GridView(controller: controller, size: 30.0)
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

#Preview {
    ContentView()
}
