//
//  OnboardingView.swift
//  AICameraRecognition
//
//  Created by Roman Tverdokhleb on 4/9/25.
//

import SwiftUI
import AVFoundation

struct OnboardingScreenView: View {
    
    @Namespace private var animation
    
    @State private var isActive = false
    @State private var isShowingCamera = false
    @State private var isShowingCameraAccessAlert = false
    
    // MARK: - Body
    
    internal var body: some View {
        VStack(spacing: 0) {
            content
            actionButton
        }
        .fullScreenCover(isPresented: $isShowingCamera) {
            ContentView(
                transitionID: Texts.NamespaceID.selectedImage,
                animation: animation) {
                    isShowingCamera.toggle()
                }
        }
        .alert(Texts.Onboarding.Alert.title,
               isPresented: $isShowingCameraAccessAlert) {
            Button(Texts.Onboarding.Alert.settings) {
                if let url = URL(string: UIApplication.openSettingsURLString),
                   UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
            Button(Texts.Onboarding.Alert.cancel, role: .cancel) {
                NotificationCenter.default.post(name: .cameraDidStop, object: nil)
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
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            switch status {
            case .authorized:
                isShowingCamera.toggle()
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    DispatchQueue.main.async {
                        if granted {
                            isShowingCamera.toggle()
                        } else {
                            isShowingCameraAccessAlert.toggle()
                        }
                    }
                }
            case .restricted, .denied:
                isShowingCameraAccessAlert.toggle()
            @unknown default:
                isShowingCameraAccessAlert.toggle()
            }
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
