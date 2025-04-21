//
//  SplashScreenView.swift
//  AICameraRecognition
//
//  Created by Roman Tverdokhleb on 4/4/25.
//

import SwiftUI

/// A view that displays the app’s splash screen with an animated logo and title,
/// then transitions to the onboarding flow after a short delay.
struct SplashScreenView: View {
    
    // MARK: - Properties
    
    /// Indicates whether the splash screen has finished and should transition.
    @State private var isActive = false
    /// Index to control that text is shown in the animation sequence.
    @State private var id = 0
    
    /// Sequence of texts to display: first an empty string, then the app title.
    private let texts = [
        String(),               // Initial empty placeholder
        Texts.AppInfo.title     // App title from label resources
    ]
    
    // MARK: - Body view
    
    internal var body: some View {
        if isActive {
            // Navigates to the onboarding screen once the splash completes
            OnboardingScreenView()
        } else {
            // Shows the splash screen content
            splashContent
                .onAppear {
                    // Schedule the transition to the next screen after 1 second
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
        }
    }
    
    // MARK: - Splash Content
    
    private var splashContent: some View {
        ZStack {
            // Full-screen background color for splash
            Color.BackColors.backSplash
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // App logo, scaled to fit a fixed height
                Image.Onboarding.splashScreenLogo
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                
                // Animated title text that appears after a short delay
                Text(texts[id])
                    .foregroundStyle(Color.LabelColors.labelWhite)
                    .font(.system(size: 55, weight: .medium))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .padding(.horizontal, 30)
            }
            .contentTransition(.numericText())
            .onAppear {
                // Animate the textIndex change to reveal the title after 0.2 seconds
                Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { timer in
                    withAnimation {
                        id += 1
                    }
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    SplashScreenView()
}
