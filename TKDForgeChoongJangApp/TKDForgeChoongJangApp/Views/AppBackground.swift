import SwiftUI

public struct AppBackground: View {
    public init() {}

    public var body: some View {
        LinearGradient(
            colors: [
                Color("brandDark"),
                Color("brandDark")
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
