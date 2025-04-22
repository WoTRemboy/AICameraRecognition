//
//  OnboardingView.swift
//  AICameraRecognition
//
//  Created by Roman Tverdokhleb on 4/9/25.
//

import SwiftUI
import AVFoundation

/// The onboarding screen that introduces users to the app features
/// and provides a slide-to-confirm action to launch the camera.
struct OnboardingScreenView: View {
    
    // MARK: - State & Namespace
    
    /// The view model responsible for camera access logic and state management.
    @StateObject private var viewModel = OnboardingViewModel()
    /// Namespace for matched-geometry animations between onboarding and camera views.
    @Namespace private var animation
    
    // MARK: - Body
    
    internal var body: some View {
        VStack(spacing: 0) {
            content
            actionButton
        }
        // Presents the camera when permission is granted and the user swipes to confirm.
        .fullScreenCover(isPresented: $viewModel.isShowingCamera) {
            ContentView(
                transitionID: Texts.NamespaceID.selectedImage,
                animation: animation) {
                    // Toggle camera presentation off when dismissed
                    viewModel.isShowingCameraToggle()
                }
        }
        // Shows an alert if camera access is restricted or denied
        .alert(Texts.Onboarding.Alert.title,
               isPresented: $viewModel.isShowingCameraAccessAlert) {
            
            // Button to open app settings
            Button(Texts.Onboarding.Alert.settings) {
                if let url = URL(string: UIApplication.openSettingsURLString),
                   UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
            // Cancel button to dismiss the alert and notify the view model
            Button(Texts.Onboarding.Alert.cancel, role: .cancel) {
                viewModel.cameraDidStopNotify()
            }
        } message: {
            Text(Texts.Onboarding.Alert.content)
        }
    }
    
    // MARK: - Content View
    
    /// The main content of the onboarding screen: title, image, and description.
    private var content: some View {
        VStack(spacing: 16) {
            
            // Onboarding title
            Text(Texts.Onboarding.title)
                .font(.largeTitle())
            
            // Onboarding illustration with matched-geometry transition
            Image.Onboarding.onboardingImage
                .resizable()
                .scaledToFit()
                .clipShape(.rect(cornerRadius: 16))
                .navigationTransitionSource(
                    id: Texts.NamespaceID.selectedImage,
                    namespace: animation)
                .frame(maxWidth: .infinity)
            
            // Description text
            Text(Texts.Onboarding.description)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding(.top)
        
    }
    
    // MARK: - Action Button
    
    /// The slide-to-confirm control that initiates the camera access flow.
    private var actionButton: some View {
        let config = SlideToConfirmView.Config(
            idleText: Texts.Onboarding.Slider.idleText,
            onSwipeText: Texts.Onboarding.Slider.onSwipeText,
            confirmationText: Texts.Onboarding.Slider.confirmationText,
            tint: Color.TintColors.tintOrange,
            foregroundColor: .white)
        
        return SlideToConfirmView(config: config) {
            // Check to request camera permission when the user completes the slide
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
