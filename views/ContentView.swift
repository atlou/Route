import SwiftUI

struct ContentView: View {
    @StateObject var controller = Controller.shared

    var body: some View {
        ZStack {
            Color(.background)
                .ignoresSafeArea()
            HStack(spacing: 20) {
                PanelView(controller: controller)
                    .frame(width: 240)
                    .frame(maxHeight: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color(.panel))
                    }
                GridView(controller: controller, size: 30.0)
                    .padding(-1)
                    .clipShape(.rect(cornerRadius: 24))
                
            }
            .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    ContentView()
}
