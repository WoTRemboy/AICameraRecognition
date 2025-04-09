//
//  OnboardingView.swift
//  AICameraRecognition
//
//  Created by Roman Tverdokhleb on 4/9/25.
//

import SwiftUI

struct OnboardingScreenView: View {
    
    @State private var isActive = false
    
    // MARK: - Body
    
    internal var body: some View {
        if isActive {
            ContentView()
        } else {
            VStack(spacing: 0) {
                content
                actionButton
            }
        }
    }
    
    // MARK: - Content
    
    private var content: some View {
        VStack(spacing: 16) {
            Image.Onboarding.onboardingImage
                .resizable()
                .scaledToFit()
                .clipShape(.rect(cornerRadius: 16))
                .frame(maxWidth: .infinity)
            
            Text(Texts.Onboarding.title)
                .font(.largeTitle())
                .padding(.top)
            
            Text(Texts.Onboarding.description)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding(.top)
    }
    
    // MARK: - Action Button
    
    private var actionButton: some View {
        let config = SlideToConfirmView.Config(
            idleText: Texts.Onboarding.Slider.idleText,
            onSwipeText: Texts.Onboarding.Slider.onSwipeText,
            confirmationText: Texts.Onboarding.Slider.confirmationText,
            tint: Color.TintColors.tintOrange,
            foregroundColor: .white)
        
        return SlideToConfirmView(config: config) {
            // Confirm action
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
        }
        
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .minimumScaleFactor(0.4)
        
        .padding(.horizontal)
        .padding(.top, 50)
        .padding(.bottom, 30)
    }
}

// MARK: - Preview

#Preview {
    OnboardingScreenView()
}
