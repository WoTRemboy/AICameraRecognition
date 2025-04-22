//
//  DetectionResultModel.swift
//  AICameraRecognition
//
//  Created by Roman Tverdokhleb on 4/7/25.
//

import CoreML
import Vision
import AVFoundation

/// Represents a single object detection result.
struct Detection: Identifiable {
    /// A unique identifier for a detection.
    let id = UUID()
    /// The class label assigned by the Vision framework.
    let label: String
    /// The confidence score of the detection, from 0 to 1.
    let confidence: VNConfidence
    /// The bounding rectangle of the detected object.
    let boundingBox: CGRect
}

/// Holds and publishes the current set of detections for observation.
///
/// Views can subscribe and automatically update whenever `detections` changes.
final class DetectionResults: ObservableObject {
    /// The array of active `Detection` objects.
    @Published internal var detections: [Detection] = []
}
