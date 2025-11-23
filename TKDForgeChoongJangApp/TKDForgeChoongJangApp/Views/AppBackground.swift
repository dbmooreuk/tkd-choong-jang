import SwiftUI

public struct AppBackground: View {
    public init() {}
    public var body: some View {
        LinearGradient(
            colors: [
                Color(red: 0.12, green: 0.14, blue: 0.17),
                Color(red: 0.18, green: 0.20, blue: 0.24)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

#Preview {
    ZStack {
        AppBackground()
        Text("Preview")
            .foregroundStyle(.white)
            .padding()
    }
}
