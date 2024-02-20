//
//  MainView.swift
//
//
//  Created by Xavier on 2024-02-19.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var controller: Controller
    @State private var gridSize: CGSize = .zero

    var body: some View {
            HStack(spacing: 20) {
                PanelView(controller: controller)
                    .frame(width: 240)
                    .frame(maxHeight: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color(.panel))
                    }
//                GridView(controller: controller, size: 30.0)
                GridView(controller: controller, size: $gridSize)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay {
                        GeometryReader { proxy in
//                            Text("\(gridSize.width) \(gridSize.height)")
                            Color.clear
                                .onAppear {
                                    gridSize = proxy.frame(in: .global).size
                                }
                                .onChange(of: proxy.frame(in: .global)) {
                                    gridSize = proxy.frame(in: .global).size
                                }
                        }
                    }
                    .padding(-1)
                    .clipShape(.rect(cornerRadius: 24))
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(30)
    }
}

#Preview {
    MainView(controller: Controller.shared)
}
