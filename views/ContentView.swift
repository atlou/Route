import SwiftUI

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                self.action(UIDevice.current.orientation)
            }
    }
}

extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        modifier(DeviceRotationViewModifier(action: action))
    }
}

struct ContentView: View {
    @StateObject var controller = Controller.shared
    @State private var showLaunch = true // TODO: True to show launch screen
//    @State private var landscape = false
    @State private var orientation: UIDeviceOrientation = .unknown

    func isLandscape() -> Bool {
        return orientation == .landscapeLeft || orientation == .landscapeRight
    }

    var body: some View {
        ZStack {
            Color(.background)
                .ignoresSafeArea()

            // TODO: Uncomment to enable rotation screen

            if isLandscape() {
                MainView(controller: self.controller)
            } else {
                RotateView()
            }

            Group {
                Color(.black)
                Color(.panel)
            }
            .ignoresSafeArea()
            .opacity(self.showLaunch ? 0.4 : 0)
            .animation(.default, value: self.showLaunch)
        }
        .sheet(isPresented: $showLaunch) {
            LaunchView(isShown: self.$showLaunch)
                .interactiveDismissDisabled()
                .background(Color(.panel))
        }
        .onRotate { o in
            orientation = o
        }
        .onAppear {
            orientation = UIDevice.current.orientation
        }
    }
}

#Preview {
    ContentView()
}
