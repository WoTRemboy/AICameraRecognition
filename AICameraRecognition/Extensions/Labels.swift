//
//  Labels.swift
//  AICameraRecognition
//
//  Created by Roman Tverdokhleb on 4/4/25.
//

import Foundation

final class Texts {
    enum AppInfo {
        static let title = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "AI Recognition"
    }
    
    enum Onboarding {
        static let title = "AI Recognition"
        static let description = "Use your phone's camera to detect objects in real time."
        
        enum Slider {
            static let idleText = "Swipe to Start"
            static let onSwipeText = "Confirms Launch"
            static let confirmationText = "Launching..."
        }
    }
    
    enum NamespaceID {
        static let selectedImage = "SelectedImage"
    }
}

extension Notification.Name {
    static let cameraDidStop = Notification.Name("cameraDidStop")
}
