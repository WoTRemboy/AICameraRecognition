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
            confidence: .zero,
            boundingBox: .zero
        )
        let second = Detection(
            label: "Second",
            confidence: .zero,
            boundingBox: .zero
        )
        let third = Detection(
            label: "Third",
            confidence: .zero,
            boundingBox: .zero
        )
        let fourth = Detection(
            label: "Fourth",
            confidence: .zero,
            boundingBox: .zero
        )
        return [first, second, third, fourth]
    }
}
