//
//  CameraViewController.swift
//  AICameraRecognition
//
//  Created by Roman Tverdokhleb on 4/7/25.
//

import UIKit
import AVFoundation
import Vision
import CoreML
import OSLog

/// A UIViewController that manages the live camera feed and performs real-time
/// object detection using a CoreML model. Detection results are published
/// to a shared `DetectionResults` object, which can be observed.
final class CameraViewController: UIViewController {
    
    // MARK: - Public Properties
    
    /// An observable object to which detection results are published.
    internal var detectionResults: DetectionResults?
    
    // MARK: - Private Properties
    
    /// The AVFoundation capture session responsible for managing camera input and output.
    private let captureSession = AVCaptureSession()
    /// The layer displaying the camera preview.
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    /// A Vision request configured with the CoreML model for object detection.
    private lazy var detectionRequest: VNCoreMLRequest = {
        do {
            // Loads the ML model with default configuration
            let config = MLModelConfiguration()
            let yoloModel = try YOLOv3(configuration: config)
            let vnModel = try VNCoreMLModel(for: yoloModel.model)
            
            // Creates a Vision request with a completion handler
            let request = VNCoreMLRequest(model: vnModel, completionHandler: visionRequestDidComplete)
            request.imageCropAndScaleOption = .scaleFill
            CameraViewController.logger.info("CoreML model setup success")
            return request
        } catch {
            // Fatal error if model setup fails
            fatalError("CoreML model setup error: \(error)")
        }
    }()
    
    /// A logger instance for debug and error messages.
    private static let logger = Logger(subsystem: "CameraModule", category: "CameraViewController")
    
    // MARK: - View Lifecycle
    
    /// Sets up the camera session and preview.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }
    
    /// Ensures the preview layer fills the entire view bounds.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
    }
    
    /// Disables the idle timer so the screen does not dim during camera usage.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Disables screen idle timer
        DispatchQueue.main.async {
            UIApplication.shared.isIdleTimerDisabled = true
        }
    }
    
    /// Re-enables the idle timer, stops the capture session, and posts a notification.
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Re-enables screen idle timer
        DispatchQueue.main.async {
            UIApplication.shared.isIdleTimerDisabled = false
        }
        
        // Stops the capture session on a background queue
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let self, self.captureSession.isRunning {
                self.captureSession.stopRunning()
                CameraViewController.logger.info("Capture session stopped")
                
                // Notifies observers that the camera has stopped
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .cameraDidStop, object: nil)
                }
            }
        }
    }
    
    // MARK: - Camera Setup
    
    /// Configures the capture session with video input and output, sets up the preview layer,
    /// and starts the session after a brief delay.
    private func setupCamera() {
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .high
        
        // Attempt to obtain the back wide-angle camera device
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                        for: .video,
                                                        position: .back),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            CameraViewController.logger.warning("Camera is not allowed")
            return
        }
        
        // Adds the camera as an input to the session
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
            CameraViewController.logger.info("Added video input")
        } else {
            CameraViewController.logger.error("Can't add video input")
            captureSession.commitConfiguration()
            return
        }
        
        // Creates and configure the video data output
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        
        // Adds the output to the session
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
            CameraViewController.logger.info("Added video output")
        } else {
            CameraViewController.logger.error("Can't add video output")
            captureSession.commitConfiguration()
            return
        }
        
        // Finalizes the session configuration
        captureSession.commitConfiguration()
        
        // Sets up the preview layer to display the camera feed
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)
        
        // Starts the capture session after a brief delay to allow UI to settle
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.captureSession.startRunning()
            CameraViewController.logger.info("Camera started running")
        }
    }
    
    // MARK: - Vision Request Handling
    
    /// Called when the Vision request completes. Processes the results or logs errors.
    /// - Parameters:
    ///   - request: The completed `VNRequest`.
    ///   - error: An error if the request failed, otherwise nil.
    internal func visionRequestDidComplete(request: VNRequest, error: Error?) {
        if let error = error {
            CameraViewController.logger.error("Request completion failed: \(error)")
            return
        }
        
        // Extracts recognized object observations from the results
        guard let results = request.results as? [VNRecognizedObjectObservation] else { return }
        
        // Maps observations to the `Detection` model
        let detections: [Detection] = results.compactMap { observation in
            guard let topLabel = observation.labels.first else { return nil }
            return Detection(label: topLabel.identifier,
                             confidence: topLabel.confidence,
                             boundingBox: observation.boundingBox)
        }
        
        // Publishes on the main thread to update views
        DispatchQueue.main.async {
            self.detectionResults?.detections = detections
        }
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    /// Called for each captured video frame. Passes the frame to Vision for processing.
    internal func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        
        // Obtains the pixel buffer from the sample buffer
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        // Specifies orientation for correct image processing
        let orientation: CGImagePropertyOrientation = .right
        // Creates a Vision image request handler for the pixel buffer
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer,
                                            orientation: orientation,
                                            options: [:])
        do {
            // Performs the detection request
            try handler.perform([detectionRequest])
        } catch {
            CameraViewController.logger.error("Vision request competion failed: \(error)")
        }
    }
}
