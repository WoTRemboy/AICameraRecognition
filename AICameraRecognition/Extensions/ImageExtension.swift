//
//  ImageExtension.swift
//  AICameraRecognition
//
//  Created by Roman Tverdokhleb on 4/4/25.
//

import SwiftUI

/// Provides centralized access to image assets used throughout the app.
extension Image {
    
    /// Images used in the onboarding module.
    enum Onboarding {
        /// App logo displayed on the splash screen.
        static let splashScreenLogo = Image("SplashScreenLogo")
        /// Illustration shown on the onboarding screen.
        static let onboardingImage = Image("OnboardingImage")
        
        /// System images used by the slide-to-confirm control.
        enum Slider {
            /// Chevron icon indicating the slide direction.
            static let chevron = Image(systemName: "chevron.right")
            /// Checkmark icon shown upon successful slide completion.
            static let checkmark = Image(systemName: "checkmark")
        }
    }
    
    /// Images used in the camera module.
    enum CameraView {
        /// Custom dismiss button icon for closing the camera screen.
        static let dismissButton = Image("DismissButton")
        /// Custom photo capture button icon.
        static let photoButton = Image("PhotoButton")
    }
}
