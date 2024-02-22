//
//  PanelView.swift
//  Route
//
//  Created by Xavier on 2024-02-14.
//

import SwiftUI

struct DescriptionView: View {
    let text: LocalizedStringKey
    var body: some View {
        ScrollViewReader { scroll in
            ScrollView {
                Text(text == "" ? "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum." : text)
                    .fontDesign(.rounded)
                    .foregroundStyle(.white)
                    .padding(14)
                    .padding(.bottom, 30)
                    .frame(maxWidth: .infinity)
                    .id(0)
            }
            .scrollIndicators(.visible)
            .mask {
                VStack(spacing: 0) {
                    Color.black
                    LinearGradient(gradient:
                        Gradient(
                            colors: [Color.clear, Color.black]),
                        startPoint: .bottom, endPoint: .top)
                        .frame(height: 50)
                }
            }
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.background))
            }
            .onChange(of: text) {
                withAnimation {
                    scroll.scrollTo(0, anchor: .top)
                }
            }
        }
    }
}

struct AlgorithmPickerButton: View {
    @Binding var selection: PathfindingAlgo
    let algo: PathfindingAlgo

    @State private var opacity = 1.0

    var body: some View {
        let selected = selection == algo
        HStack(spacing: 10) {
            Circle()
                .fill(Color(.grid))
                .frame(width: 16)
                .overlay {
                    if selected {
                        Circle()
                            .fill(.white)
                            .padding(5)
                    } else {
                        Circle()
                            .fill(Color(.background))
                            .padding(1.5)
                    }
                }
            Text(algo.description)
                .foregroundStyle(.white)
                .fontWeight(.medium)
                .fontDesign(.rounded)
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.leading, 14)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.background))
        }
        .opacity(opacity)
        .onTapGesture {
            selection = algo
        }
    }
}

struct PanelView: View {
    @ObservedObject var controller: Controller

    var body: some View {
        VStack(spacing: 20) {
            // algo picker
            VStack(alignment: .leading, spacing: 8) {
                ForEach(PathfindingAlgo.allCases) { algo in
                    AlgorithmPickerButton(selection: $controller.algo, algo: algo)
                }
            }

            // description scroll view
            DescriptionView(text: controller.algo.detailedDescription)
                .animation(.default.speed(2), value: controller.algo)

            // buttons
            VStack(spacing: 8) {
                Button {
                    withAnimation(.default.speed(2)) {
                        controller.generateMaze()
                    }
                } label: {
                    Text("Generate Maze")
                        .frame(maxWidth: .infinity)
                }
                .tint(Color(.background))

                Button {
                    withAnimation(.default.speed(2)) {
                        controller.clear()
                    }
                } label: {
                    Text("Clear Grid")
                        .frame(maxWidth: .infinity)
                }
                .tint(Color(.background))

                Button {
                    controller.run()
                } label: {
                    Text("Find Path")
                        .frame(maxWidth: .infinity)
                }
                .tint(Color(.grid))
            }
            .buttonStyle(.borderedProminent)
            .allowsHitTesting(!controller.isRunning)
            .opacity(controller.isRunning ? 0.3 : 1)
            .animation(.default, value: controller.isRunning)
            .fontDesign(.rounded)
            .fontWeight(.medium)
        }
        .padding(20)
    }
}

#Preview {
    PanelView(controller: Controller.shared)
        .background(Color(.panel))
        .frame(width: 300)
}
