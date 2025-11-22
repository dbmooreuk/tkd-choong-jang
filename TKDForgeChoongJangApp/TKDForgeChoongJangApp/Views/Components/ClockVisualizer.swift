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
    
    var body: some View {
        VStack {
            Text("\(hour)")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(.white.opacity(0.6))
            Spacer()
        }
        .frame(height: size / 2 - 20)
        .rotationEffect(.degrees(Double(hour) * 30))
        .offset(y: -size / 2 + 20)
        .rotationEffect(.degrees(-Double(hour) * 30))
    }
}

struct DirectionArrow: View {
    let hour: Int
    let color: Color
    let isDashed: Bool
    let size: CGFloat
    
    private var angle: Double {
        // Convert hour to degrees (12 o'clock = 0°, clockwise)
        return Double(hour) * 30 - 90
    }
    
    var body: some View {
        ZStack {
            // Arrow line
            if isDashed {
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: size / 2 - 30, y: 0))
                }
                .stroke(color, style: StrokeStyle(lineWidth: 3, dash: [8, 6]))
            } else {
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: size / 2 - 30, y: 0))
                }
                .stroke(color, lineWidth: 3)
            }
            
            // Arrow head
            Path { path in
                path.move(to: CGPoint(x: size / 2 - 30, y: 0))
                path.addLine(to: CGPoint(x: size / 2 - 45, y: -8))
                path.addLine(to: CGPoint(x: size / 2 - 45, y: 8))
                path.closeSubpath()
            }
            .fill(color)
        }
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

