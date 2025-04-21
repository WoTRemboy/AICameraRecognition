//
//  DetectionResultsTests.swift
//  AICameraRecognitionTests
//
//  Created by Roman Tverdokhleb on 21/04/2025.
//

import XCTest
import Combine
@testable import AICameraRecognition

final class DetectionResultsTests: XCTestCase {
    var results: DetectionResults!
    var cancellable: Any?
    
    override func setUp() {
        super.setUp()
        results = DetectionResults()
    }
    
    override func tearDown() {
        if let c = cancellable as? AnyCancellable {
            c.cancel()
        }
        results = nil
        super.tearDown()
    }
    
    func testDetectionsPublishedOnChange() {
        let expectation = XCTestExpectation(description: "Publish new detections")
        cancellable = results.$detections.sink { detections in
            if !detections.isEmpty {
                expectation.fulfill()
            }
        }
        
        results.detections = [
            Detection(label: "Test", confidence: 1.0, boundingBox: .zero)
        ]
        wait(for: [expectation], timeout: 1.0)
    }
}
