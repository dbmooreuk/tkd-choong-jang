//
//  ClockVisualizer.swift
//  TKD Forge - Choong Jang
//
//  Created by TKD Forge
//

import SwiftUI

struct ClockVisualizer: View {
    let facing: Int
    let direction: Int?

    @AppStorage("clockFigureStyle") private var clockFigureStyle: String = "male"
    private let clockSize: CGFloat = 200

    private var figureImageName: String {
        clockFigureStyle == "female" ? "female" : "man"
    }

    private var facingRotationAngle: Double {
        Double(facing % 12) * 30
    }

    var body: some View {
        ZStack {
            // Clock face background
            Circle()
                .fill(Color("brandDark"))
//                .overlay(
//                    Circle()
////                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
//                )

            // Hour markers
            ForEach(1...12, id: \.self) { hour in
                HourMarker(hour: hour, size: clockSize)
            }

            // Center dot
            Circle()
                .fill(Color("brandYellow"))
                .frame(width: 12, height: 12)


            // Center figure (rotates with facing)
            Image(figureImageName)
                .resizable()
                .scaledToFit()
                .frame(width: clockSize * 0.4, height: clockSize * 0.4)
                .rotationEffect(.degrees(facingRotationAngle))

            // Direction arrow (Red Dashed)
            if let direction = direction {
                DirectionArrow(hour: direction, color: (Color.green), isDashed: false, size: clockSize)
            }

            // Facing arrow (Blue Solid)
//            DirectionArrow(hour: facing, color: Color("brandBlue"), isDashed: false, size: clockSize)

        }
        .frame(width: clockSize, height: clockSize)
    }
}

struct HourMarker: View {
    let hour: Int
    let size: CGFloat

    // Angle for this hour (12 = top, 3 = right, etc.)
    private var angleDegrees: Double { Double(hour) * 30 }
    private var angleRadians: CGFloat { CGFloat(angleDegrees * .pi / 180) }
    private var radius: CGFloat { size / 2 - 24 }

    var body: some View {
        ZStack {
            Text("\(hour)")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(.white.opacity(0.9))
                // Position the number on the circle using trig so it aligns
                .position(
                    x: size / 2 + radius * sin(angleRadians),
                    y: size / 2 - radius * cos(angleRadians)
                )
        }
        .frame(width: size, height: size)
    }
}

struct DirectionArrow: View {
    let hour: Int
    let color: Color
    let isDashed: Bool
    let size: CGFloat

    // Convert hour to degrees (12 o'clock = 0°, clockwise)
    private var angle: Double { Double(hour) * 30 - 90 }
    private var radius: CGFloat { size / 2 - 30 }

    // Small bobbing animation along the pointing direction
    @State private var bobOffset: CGFloat = 0

    var body: some View {
        ZStack {
            // Arrow head only (no stem), positioned near the edge of the clock
            Path { path in
                let tip = CGPoint(x: size / 2 + radius, y: size / 2)
                path.move(to: tip)
                path.addLine(to: CGPoint(x: tip.x - 15, y: tip.y - 8))
                path.addLine(to: CGPoint(x: tip.x - 15, y: tip.y + 8))
                path.closeSubpath()
            }
            .fill(color)
        }
        .frame(width: size, height: size)
        // Offset along the x‑axis, then rotate so the bobbing is along the
        // direction the arrow is pointing.
        .offset(x: bobOffset)
        .rotationEffect(.degrees(angle))
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                bobOffset = 6
            }
        }
    }
}

struct DashedLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return path
    }
}

#Preview {
    ZStack {
        Color.black
        ClockVisualizer(facing: 12, direction: 3)
    }
}

