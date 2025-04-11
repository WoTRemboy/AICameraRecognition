//
//  OnboardingViewModel.swift
//  AICameraRecognition
//
//  Created by Roman Tverdokhleb on 4/11/25.
//

import Foundation
import AVFoundation

final class OnboardingViewModel: ObservableObject {
    
    @Published internal var isActive = false
    @Published internal var isShowingCamera = false
    @Published internal var isShowingCameraAccessAlert = false
    
    internal func isActiveToggle() {
        isActive.toggle()
    }
    
    internal func isShowingCameraToggle() {
        isShowingCamera.toggle()
    }
    
    internal func isShowingCameraAccessAlertToggle() {
        isShowingCameraAccessAlert.toggle()
    }
    
    internal func cameraDidStopNotify() {
        NotificationCenter.default.post(name: .cameraDidStop, object: nil)
    }
    
    internal func cameraAccessCheck() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            isShowingCameraToggle()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.isShowingCameraToggle()
                    } else {
                        self.isShowingCameraAccessAlertToggle()
                    }
                }
            }
        case .restricted, .denied:
            isShowingCameraAccessAlertToggle()
        @unknown default:
            isShowingCameraAccessAlertToggle()
        }
    }
}
