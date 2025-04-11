//
//  OnboardingView.swift
//  AICameraRecognition
//
//  Created by Roman Tverdokhleb on 4/9/25.
//

import SwiftUI
import AVFoundation

struct OnboardingScreenView: View {
    
    @StateObject private var viewModel = OnboardingViewModel()
    @Namespace private var animation
    
    // MARK: - Body
    
    internal var body: some View {
        VStack(spacing: 0) {
            content
            actionButton
        }
        .fullScreenCover(isPresented: $viewModel.isShowingCamera) {
            ContentView(
                transitionID: Texts.NamespaceID.selectedImage,
                animation: animation) {
                    viewModel.isShowingCameraToggle()
                }
        }
        .alert(Texts.Onboarding.Alert.title,
               isPresented: $viewModel.isShowingCameraAccessAlert) {
            Button(Texts.Onboarding.Alert.settings) {
                if let url = URL(string: UIApplication.openSettingsURLString),
                   UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
            Button(Texts.Onboarding.Alert.cancel, role: .cancel) {
                viewModel.cameraDidStopNotify()
            }
        } message: {
            Text(Texts.Onboarding.Alert.content)
        }
    }
    
    // MARK: - Content
    
    private var content: some View {
        VStack(spacing: 16) {
            Text(Texts.Onboarding.title)
                .font(.largeTitle())
            
            Image.Onboarding.onboardingImage
                .resizable()
                .scaledToFit()
                .clipShape(.rect(cornerRadius: 16))
                .navigationTransitionSource(
                    id: Texts.NamespaceID.selectedImage,
                    namespace: animation)
                .frame(maxWidth: .infinity)
            
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
            viewModel.cameraAccessCheck()
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
