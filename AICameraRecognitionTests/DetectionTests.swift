//
//  DetectionTests.swift
//  AICameraRecognitionTests
//
//  Created by Roman Tverdokhleb on 21/04/2025.
//

import XCTest
import Vision
@testable import AICameraRecognition

final class DetectionTests: XCTestCase {
    
    /// Verifies that each `Detection` instance gets its own unique `id`,
    /// even if all other properties are identical.
    func testDetectionIDIsUnique() {
        let d1 = Detection(label: "A", confidence: 0.5, boundingBox: .zero)
        let d2 = Detection(label: "A", confidence: 0.5, boundingBox: .zero)
        XCTAssertNotEqual(d1.id, d2.id,
                          "Two different Detection instances must have different IDs.")
    }
    
    /// Verifies that all stored properties are initialized correctly.
    func testDetectionStoresProperties() {
        let label = "Cat"
        let confidence: VNConfidence = 0.85
        let box = CGRect(x: 0.1, y: 0.2, width: 0.3, height: 0.4)
        let detection = Detection(label: label, confidence: confidence, boundingBox: box)
        
        XCTAssertEqual(detection.label, label, "Label should be stored correctly.")
        XCTAssertEqual(detection.confidence, confidence, accuracy: 0.0001,
                       "Confidence should be stored correctly.")
        XCTAssertEqual(detection.boundingBox, box, "Bounding box should be stored correctly.")
    }
}
