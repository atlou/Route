//
//  CubeView.swift
//  Pathfinding
//
//  Created by Xavier on 2024-02-05.
//

import SwiftUI

extension Color {
    func darker(by percentage: CGFloat = 10.0) -> Color {
        let uiColor = UIColor(self)

        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        if uiColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            // lower brightness
            brightness = max(brightness - percentage / 100, 0)

            // shift hue
            hue = (hue + percentage / 500).truncatingRemainder(dividingBy: 1)

            return Color(UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha))
        }

        return self
    }
}

struct CubeView: View {
    let color: Color

    var body: some View {
        ZStack {
            ZStack {
                TopFace()
                    .fill(color)
                    .stroke(color.darker(by: 10))
                LeftFace()
                    .fill(color.darker(by: 10))
                    .stroke(color.darker(by: 20))
                RightFace()
                    .fill(color.darker(by: 20))
                    .stroke(color.darker(by: 30))
            }
            .frame(width: 100, height: 100)
            .border(.red)
        }
        
    }
}

struct TopFace: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        // draw square
        path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.closeSubpath()

        return path
    }
}

struct LeftFace: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        // draw left side
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.midY))
        path.closeSubpath()

        return path
    }
}

struct RightFace: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        // draw under
        path.move(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.midY))
        path.closeSubpath()

        return path
    }
}

#Preview {
    CubeView(color: .blue)
}
