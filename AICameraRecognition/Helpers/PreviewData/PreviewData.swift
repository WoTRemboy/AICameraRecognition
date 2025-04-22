//
//  PreviewData.swift
//  AICameraRecognition
//
//  Created by Roman Tverdokhleb on 18/04/2025.
//

import Foundation

/// A utility class that supplies mock data for use in previews and testing.
final class PreviewData {
    
    /// A sample array of `Detection` instances to simulate real detections.
    ///
    /// Each `Detection` in this array has:
    /// - A placeholder label ("First", "Second", etc.)
    /// - A confidence value of zero
    /// - A zeroed `CGRect` for the bounding box
    static internal var detectionResults: [Detection] {
        let first = Detection(
            label: "First",
            confidence: 0.92,
            boundingBox: CGRect(x: 0.05, y: 0.10, width: 0.40, height: 0.30)
        )
        let second = Detection(
            label: "Second",
            confidence: 0.78,
            boundingBox: CGRect(x: 0.50, y: 0.15, width: 0.30, height: 0.25)
        )
        let third = Detection(
            label: "Third",
            confidence: 0.65,
            boundingBox: CGRect(x: 0.20, y: 0.60, width: 0.45, height: 0.35)
        )
        let fourth = Detection(
            label: "Fourth",
            confidence: 0.81,
            boundingBox: CGRect(x: 0.70, y: 0.50, width: 0.25, height: 0.30)
        )
        return [first, second, third, fourth]
    }
}
