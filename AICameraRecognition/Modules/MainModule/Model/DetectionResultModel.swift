//
//  DetectionResultModel.swift
//  AICameraRecognition
//
//  Created by Roman Tverdokhleb on 4/7/25.
//

import CoreML
import Vision
import AVFoundation

struct Detection: Identifiable {
    let id = UUID()
    let label: String
    let confidence: VNConfidence
    let boundingBox: CGRect
}

final class DetectionResults: ObservableObject {
    @Published internal var detections: [Detection] = []
}
