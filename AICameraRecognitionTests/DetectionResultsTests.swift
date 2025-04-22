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
        // Cancels any active subscription to avoid leaks
        if let c = cancellable as? AnyCancellable {
            c.cancel()
        }
        results = nil
        super.tearDown()
    }
    
    /// Verifies that assigning a non-empty array to `detections` publishes the change.
    func testDetectionsPublishedOnChange() {
        let expectation = XCTestExpectation(description: "Publish new detections")
        
        // Subscribes to the publisher, ignoring the initial empty value
        cancellable = results.$detections
            .dropFirst()
            .sink { detections in
                XCTAssertEqual(detections.count, 1)
                XCTAssertEqual(detections.first?.label, "Test")
                expectation.fulfill()
            }
        
        // Triggers a change
        results.detections = [
            Detection(label: "Test", confidence: 1.0, boundingBox: .zero)
        ]
        
        // Waits for the publisher to emit
        wait(for: [expectation], timeout: 1.0)
    }
}
