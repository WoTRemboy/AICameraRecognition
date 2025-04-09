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

final class CameraViewController: UIViewController {
    var detectionResults: DetectionResults?
    
    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    private lazy var detectionRequest: VNCoreMLRequest = {
        do {
            let config = MLModelConfiguration()
            let yoloModel = try YOLOv3(configuration: config)
            let vnModel = try VNCoreMLModel(for: yoloModel.model)
            let request = VNCoreMLRequest(model: vnModel, completionHandler: visionRequestDidComplete)
            request.imageCropAndScaleOption = .scaleFill
            return request
        } catch {
            fatalError("YOLOv3 model setup error: \(error)")
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
    }
    
    private func setupCamera() {
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .high
        
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                        for: .video,
                                                        position: .back),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            print("Camera is not allowed")
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            print("Can't add video input")
            captureSession.commitConfiguration()
            return
        }
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        } else {
            print("Can't add video output")
            captureSession.commitConfiguration()
            return
        }
        
        captureSession.commitConfiguration()
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)
        
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.1) {
            self.captureSession.startRunning()
        }
    }
    
    private func visionRequestDidComplete(request: VNRequest, error: Error?) {
        if let error = error {
            print("Request completion failed: \(error)")
            return
        }
        
        guard let results = request.results as? [VNRecognizedObjectObservation] else { return }
        
        let detections: [Detection] = results.compactMap { observation in
            guard let topLabel = observation.labels.first else { return nil }
            return Detection(label: topLabel.identifier,
                             confidence: topLabel.confidence,
                             boundingBox: observation.boundingBox)
        }
        
        DispatchQueue.main.async {
            self.detectionResults?.detections = detections
        }
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let orientation: CGImagePropertyOrientation = .right
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer,
                                            orientation: orientation,
                                            options: [:])
        do {
            try handler.perform([detectionRequest])
        } catch {
            print("Vision request competion failed: \(error)")
        }
    }
}
