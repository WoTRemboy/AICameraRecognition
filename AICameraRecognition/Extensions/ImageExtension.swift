//
//  ImageExtension.swift
//  AICameraRecognition
//
//  Created by Roman Tverdokhleb on 4/4/25.
//

import SwiftUI

extension Image {
    enum Onboarding {
        static let splashScreenLogo = Image("SplashScreenLogo")
        static let onboardingImage = Image("OnboardingImage")
        
        enum Slider {
            static let chevron = Image(systemName: "chevron.right")
            static let checkmark = Image(systemName: "checkmark")
        }
    }
    
    enum CameraView {
        static let dismissButton = Image("DismissButton")
    }
}
