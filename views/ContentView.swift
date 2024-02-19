import SwiftUI

struct ContentView: View {
    @StateObject var controller = Controller.shared
    @State private var showLaunch = false

    var body: some View {
        ZStack {
            MainView(controller: controller)

            Group {
                Color(.black)
                Color(.panel)
            }
            .ignoresSafeArea()
            .opacity(showLaunch ? 0.4 : 0)
            .animation(.default, value: showLaunch)
        }
        .sheet(isPresented: $showLaunch) {
            LaunchView(isShown: $showLaunch)
                .interactiveDismissDisabled()
        }
    }
}

#Preview {
    ContentView()
}
