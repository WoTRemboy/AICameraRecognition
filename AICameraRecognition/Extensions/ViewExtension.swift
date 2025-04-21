//
//  ViewExtension.swift
//  AICameraRecognition
//
//  Created by Roman Tverdokhleb on 4/9/25.
//

import SwiftUI
import OSLog

/// A logger for reporting errors within view extension.
private let logger = Logger(subsystem: "Extensions", category: "ViewExtension")

extension View {
    /// Checks if the device has a notch by evaluating the top safe area inset.
    /// - Returns: A Boolean value indicating whether the device has a notch.
    internal func hasNotch() -> Bool {
        // Attempt to locate the key UIWindow through the connected scenes
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let keyWindow = windowScene.windows.first(where: \.isKeyWindow) else {
            logger.error("Key window not found")
            return false
        }
        return keyWindow.safeAreaInsets.top > 20
    }
    
    /// Hides the on-screen keyboard, if it is currently presented.
    internal func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil)
    }
}
