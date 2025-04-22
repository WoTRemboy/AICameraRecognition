<div align="center">
  <img src="https://github.com/user-attachments/assets/aaec9962-2961-4a52-9636-210084c05af6" alt="Reconix Logo" width="200" height="200">
  <h1>Reconix: AI Object Recognition</h1>
</div>

**AI Camera Recognition** is a real‑time object detection iOS app that leverages a device camera, Vision, and CoreML to identify objects in the scene.
It displays bounding boxes and confidence labels over the live feed, shows detected object names in a scrollable header. Find it in [TestFlight](https://testflight.apple.com/join/4xadjzG9).

## Table of Contents 📋  

- [Features](#features)
- [Technologies](#technologies)
- [Architecture](#architecture)
- [Testing](#testing)
- [Documentation](#documentation)
- [Requirements](#requirements)

## Features 📸

### Real‑Time Object Detection
- **Vision/CoreML**: Runs a CoreML model on each frame to detect objects.  
- **Bounding‑Box Overlay**: Draws red boxes and labels showing object type and confidence.  
- **Background Processing**: Starts and stops the AVCaptureSession off the main thread to keep UI smooth.
- **Detected Titles List**: Displays the names of all currently detected objects at the top.

<img src="https://github.com/user-attachments/assets/c78cc650-97e6-4370-bb5d-b3a73db57b62" alt="App Demo" width="200" height="435">
<img src="https://github.com/user-attachments/assets/d01b1756-62ae-4b5e-9f50-aa946f0df7fa" alt="Camera View" width="200" height="435">

### Onboarding & Permissions
- **Animated Splash Screen**: Shows logo and app title with numeric “type‑on” effect.  
- **Slide‑to‑Confirm Control**: Custom draggable knob with shimmer and haptic feedback to start camera.  
- **Permission Alerts**: Detects denied or restricted camera access and prompts user to open Settings.

<img src="https://github.com/user-attachments/assets/f97da892-d457-4cce-8b0a-1419f22a9413" alt="Splash Screen" width="200" height="435">
<img src="https://github.com/user-attachments/assets/738febeb-49ee-42ff-a9e0-f5300437109d" alt="Onboarding Page" width="200" height="435">

## Technologies 💻
- **Swift & SwiftUI** for declarative UI and animations  
- **AVFoundation** for camera capture  
- **Vision & CoreML** for object detection  
- **Combine** for reactive state updates (`@Published`, `@StateObject`)  
- **OSLog** for structured logging

## Architecture 🏗️
Follows an **MVVM** pattern:

**Model**  
- `Detection` — stores label, confidence, boundingBox (normalized)  
- `DetectionResults` — `@Published` array of `Detection`

**ViewModel**  
- `OnboardingViewModel` — manages onboarding state, camera‑access logic, and notifications

**View / Controller**  
- SwiftUI views: `SplashScreenView`, `OnboardingScreenView`, `SlideToConfirmView`, `DetectionOverlayView`, `ContentView`  
- `CameraViewController` wrapped by `CameraView` for AVCapture + Vision integration

## Testing 🧪
**Unit Tests** (XCTest) in `AICameraRecognitionTests` target:  
- `DetectionTests` — uniqueness and property correctness  
- `DetectionResultsTests` — verifies `@Published` updates  
- `CameraViewControllerTests` — simulates `VNRequest` responses to test `visionRequestDidComplete`

## Documentation 📚
Reconix’s code is documented following Apple’s DocC format. This documentation covers:

- **Classes and Methods**: Detailed explanations of each class, method, and property.
- **Parameters and Returns**: Clear documentation of parameters and return types to aid in readability and debugging.

### Example:
```swift
/// Called when the Vision request completes. Processes the results or logs errors.
/// - Parameters:
///   - request: The completed `VNRequest`.
///   - error: An error if the request failed, otherwise nil.
internal func visionRequestDidComplete(request: VNRequest, error: Error?) {
    // Code implementation
}
```

## Requirements ✅
- Xcode 15.0+  
- Swift 5.8+  
- iOS 17.0+  
- Device with camera and CoreML support  
