//
//  PanelView.swift
//  Pathfinding
//
//  Created by Xavier on 2024-02-14.
//

import SwiftUI

struct DescriptionView: View {
    let text: String
    var body: some View {
        ScrollView {
            Text(text == "" ? "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum." : text)
                .fontDesign(.rounded)
                .foregroundStyle(.white)
                .padding(14)
//                .font(.subheadline)
                .frame(maxWidth: .infinity)
        }
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.background))
        }
        .frame(maxHeight: 360)
        .padding(.horizontal, 20)
    }
}

struct AlgorithmPicker: View {
    @Binding var selection: PathfindingAlgo
    var body: some View {
        Picker("Pathfinding", selection: $selection) {
            ForEach(PathfindingAlgo.allCases) { algo in
                Text(String(describing: algo).capitalized)
                    .fontDesign(.rounded)
                    .foregroundStyle(.white)
                    .fontWeight(.regular)
                    .font(.body)
            }
        }
        .pickerStyle(.wheel)
        .tint(.white)
        .brightness(1)
        .contrast(1)
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.background).opacity(1))
                    .saturation(1.05)
                    .brightness(-0.1)
                    .frame(height: 32)
                    .padding(.horizontal, 9)
            }
        }
        .padding(.horizontal, 11)
    }
}

struct PanelView: View {
    @ObservedObject var controller: Controller

    var body: some View {
        VStack {
            AlgorithmPicker(selection: $controller.algo)

            DescriptionView(text: "")

//            Picker("Drawing Mode", selection: $controller.drawingMode) {
//                ForEach(DrawingMode.allCases) { mode in
//                    Text(String(describing: mode).capitalized)
//                }
//            }
//            .pickerStyle(.segmented)
//            Picker("Speed", selection: $controller.speed) {
//                ForEach(Speed.allCases) { speed in
//                    Text(String(describing: speed).capitalized)
//                }
//            }
//            .pickerStyle(.segmented)
//            .padding(12)

            Spacer()
            VStack(spacing: 10) {
                Button {
                    withAnimation(.default.speed(2)) {
                        controller.clear()
                    }
                } label: {
                    Text("Generate Maze")
//                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(.background))

                Button {
                    withAnimation(.default.speed(2)) {
                        controller.clear()
                    }
                } label: {
                    Text("Clear Grid")
//                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(.background))

                Button {
                    withAnimation {
                        controller.run()
                    }
                } label: {
                    Text("Find Path")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
            .fontDesign(.rounded)
            .fontWeight(.medium)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .padding(.top, 14)
        }
    }
}

#Preview {
    ContentView()
}
