//
//  ClockVisualizer.swift
//  TKD Forge - Choong Jang
//
//  Created by TKD Forge
//

import SwiftUI

struct ClockVisualizer: View {
    let facing: Int
    let direction: Int

    private let clockSize: CGFloat = 200


    private var facingRotationAngle: Double {
        Double(facing % 12) * 30
    }

    var body: some View {
        ZStack {
            // Clock face background
            Circle()
                .fill(Color.white.opacity(0.05))
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                )

            // Hour markers
            ForEach(1...12, id: \.self) { hour in
                HourMarker(hour: hour, size: clockSize)
            }

            // Center dot
            Circle()
                .fill(Color.white)
                .frame(width: 12, height: 12)


            // Center man figure (rotates with facing)
            Image("man")
                .resizable()
                .scaledToFit()
                .frame(width: clockSize * 0.4, height: clockSize * 0.4)
                .rotationEffect(.degrees(facingRotationAngle))

            // Direction arrow (Red Dashed)
            DirectionArrow(hour: direction, color: .red, isDashed: true, size: clockSize)

            // Facing arrow (Blue Solid)
            DirectionArrow(hour: facing, color: .blue, isDashed: false, size: clockSize)

            // Legend
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 30, height: 3)
                    Text("Facing")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }

                HStack(spacing: 8) {
                    DashedLine()
                        .stroke(Color.red, style: StrokeStyle(lineWidth: 3, dash: [5, 5]))
                        .frame(width: 30, height: 3)
                    Text("Direction")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
            }
            .offset(y: clockSize / 2 + 40)
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
                .foregroundColor(.white.opacity(0.6))
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

    var body: some View {
        ZStack {
            // Arrow line from the center of the clock outwards
            if isDashed {
                Path { path in
                    path.move(to: CGPoint(x: size / 2, y: size / 2))
                    path.addLine(to: CGPoint(x: size / 2 + radius, y: size / 2))
                }
                .stroke(color, style: StrokeStyle(lineWidth: 3, dash: [8, 6]))
            } else {
                Path { path in
                    path.move(to: CGPoint(x: size / 2, y: size / 2))
                    path.addLine(to: CGPoint(x: size / 2 + radius, y: size / 2))
                }
                .stroke(color, lineWidth: 3)
            }

            // Arrow head at the end of the line
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
        .rotationEffect(.degrees(angle))
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

