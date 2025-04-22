//
//  OnboardingViewModel.swift
//  AICameraRecognition
//
//  Created by Roman Tverdokhleb on 4/11/25.
//

import Foundation
import AVFoundation

/// The view model for the onboarding screen, handling camera permission logic
/// and controlling presentation state of the camera view and alerts.
final class OnboardingViewModel: ObservableObject {
    
    // MARK: - Published Properties

    /// Controls whether the full-screen camera view is presented.
    @Published internal var isShowingCamera = false
    /// Controls whether the alert about camera access denial is shown.
    @Published internal var isShowingCameraAccessAlert = false
    
    // MARK: - State Toggle Methods
    
    /// Toggles presentation of the camera view.
    internal func isShowingCameraToggle() {
        isShowingCamera.toggle()
    }
    
    /// Toggles the camera-access-denied alert.
    internal func isShowingCameraAccessAlertToggle() {
        isShowingCameraAccessAlert.toggle()
    }
    
    // MARK: - Notification
    
    /// Posts a `.cameraDidStop` notification to inform listeners
    /// that the camera session has been stopped.
    internal func cameraDidStopNotify() {
        NotificationCenter.default.post(name: .cameraDidStop, object: nil)
    }
    
    // MARK: - Camera Access
    
    /// Checks the current camera authorization status and either:
    ///  - Presents the camera if access is authorized,
    ///  - Requests access if the status is undetermined,
    ///  - Shows an access-denied alert if restricted or denied.
    internal func cameraAccessCheck() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            // Already authorized — shows camera
            isShowingCameraToggle()
        case .notDetermined:
            // First-time request — asks the user
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        // User granted access — shows camera
                        self.isShowingCameraToggle()
                    } else {
                        // User denied access — shows alert
                        self.isShowingCameraAccessAlertToggle()
                    }
                }
            }
        case .restricted, .denied:
            // Access is restricted or has been denied — shows alert
            isShowingCameraAccessAlertToggle()
        @unknown default:
            // Fallback — shows alert
            isShowingCameraAccessAlertToggle()
        }
    }
}
