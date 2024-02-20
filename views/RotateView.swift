//
//  RotateView.swift
//
//
//  Created by Xavier on 2024-02-19.
//

import SwiftUI

struct RotateView: View {
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "rectangle.landscape.rotate")
                .font(.system(size: 70))
                .foregroundStyle(.white)
                .symbolEffect(.pulse.byLayer, isActive: true)
            Text("Please rotate your device into **landscape** mode.")
                .font(.title3)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
        }
        .fontDesign(.rounded)
    }
}

#Preview {
    RotateView()
}
