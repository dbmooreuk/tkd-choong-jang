//
//  SplashView.swift
//  TKD Forge - Choong Jang
//
//  Created by TKD Forge
//

import SwiftUI

struct SplashView: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.15, green: 0.17, blue: 0.2)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Logo
                Image("logo_tkd_forge")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .scaleEffect(scale)
                    .opacity(opacity)
                
                // App Name
                VStack(spacing: 8) {
                    Text("TKD FORGE")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Choong-Jang")
                        .font(.system(size: 24, weight: .medium, design: .rounded))
                        .foregroundColor(.orange)
                }
                .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}

#Preview {
    SplashView()
}

