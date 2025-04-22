//
//  Labels.swift
//  AICameraRecognition
//
//  Created by Roman Tverdokhleb on 4/4/25.
//

import Foundation

/// A centralized namespace for all static text constants used throughout the app.
final class Texts {
    
    /// App information values, loaded from the bundle’s Info.plist.
    enum AppInfo {
        static let title = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "AI Recognition"
    }
    
    /// Text strings related to the onboarding experience.
    enum Onboarding {
        static let title = "AI Recognition"
        static let description = "Use your phone's camera to detect objects in real time."
        
        /// Text strings used by the slide-to-confirm control.
        enum Slider {
            static let idleText = "Swipe to Start"
            static let onSwipeText = "Confirms Launch"
            static let confirmationText = "Launching..."
        }
        
        /// Text strings for the camera access-denied alert.
        enum Alert {
            static let title = "Camera is not allowed"
            static let content = "Please allow the app to access your camera."
            static let settings = "Settings"
            static let cancel = "Cancel"
        }
    }
    
    /// Identifiers used for matched-geometry transitions between views.
    enum NamespaceID {
        static let selectedImage = "SelectedImage"
    }
}

// MARK: - Notification.Name Extension

/// Custom notifications posted by the app.
extension Notification.Name {
    /// Notification posted when the camera session stops running.
    static let cameraDidStop = Notification.Name("cameraDidStop")
}
