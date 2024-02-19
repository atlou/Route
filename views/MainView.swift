//
//  MainView.swift
//
//
//  Created by Xavier on 2024-02-19.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var controller: Controller

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
    MainView(controller: Controller.shared)
}
