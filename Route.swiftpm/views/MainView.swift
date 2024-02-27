//
//  MainView.swift
//  Route
//
//  Created by Xavier on 2024-02-19.
//

import SwiftUI

/// View containing the left panel and the grid
struct MainView: View {
    @ObservedObject var controller: Controller
    @State private var gridSize: CGSize = .zero

    var body: some View {
        HStack(spacing: 20) {
            PanelView(controller: controller)
                .frame(minWidth: 260)
                .frame(maxWidth: 300)
                .frame(maxHeight: gridSize.height)
                .background {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color(.panel))
                }
                .layoutPriority(-1)
            GridView(controller: controller, size: $gridSize)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay {
                    GeometryReader { proxy in
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
                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
        }
        .padding(40)
    }
}

#Preview {
    MainView(controller: Controller.shared)
}
