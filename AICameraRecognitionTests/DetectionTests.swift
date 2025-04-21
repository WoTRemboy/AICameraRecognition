//
//  DetectionTests.swift
//  AICameraRecognitionTests
//
//  Created by Roman Tverdokhleb on 21/04/2025.
//

import XCTest
@testable import AICameraRecognition

final class DetectionTests: XCTestCase {
    func testDetectionIDIsUnique() {
        let d1 = Detection(label: "A", confidence: 0.5, boundingBox: .zero)
        let d2 = Detection(label: "A", confidence: 0.5, boundingBox: .zero)
        XCTAssertNotEqual(d1.id, d2.id,
                          "Two different Detection instances must have different IDs.")
    }
}
