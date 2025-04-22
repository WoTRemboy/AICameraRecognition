//
//  CameraViewControllerTests.swift
//  AICameraRecognitionTests
//
//  Created by Roman Tverdokhleb on 21/04/2025.
//

import XCTest
import Vision
@testable import AICameraRecognition

final class CameraViewControllerTests: XCTestCase {
    var vc: CameraViewController!
    var results: DetectionResults!
    
    override func setUp() {
        super.setUp()
        vc = CameraViewController()
        results = DetectionResults()
        vc.detectionResults = results
    }
    
    override func tearDown() {
        vc = nil
        results = nil
        super.tearDown()
    }
    
    /// If an error is returned, the detections array must remain empty.
    func testVisionRequestDidComplete_withError_doesNotUpdateDetections() {
        vc.visionRequestDidComplete(
            request: DummyRequest(results: nil),
            error: NSError(domain: "test", code: -1)
        )
        XCTAssertTrue(results.detections.isEmpty)
    }
    
    /// If no results are returned, the detections array must remain empty.
    func testVisionRequestDidComplete_withNoResults_doesNotUpdateDetections() {
        vc.visionRequestDidComplete(
            request: DummyRequest(results: []),
            error: nil
        )
        XCTAssertTrue(results.detections.isEmpty)
    }
    
    /// When a `VNRecognizedObjectObservation` with a label and confidence is provided,
    /// it should produce a corresponding Detection in the results array.
    func testVisionRequestDidComplete_withRecognizedObjectObservation_updatesDetections() {
        // 1. Creates a classification and set its id & confidence
        let classification = VNClassificationObservation()
        classification.setValue("ObjectX", forKey: "identifier")
        classification.setValue(NSNumber(value: 0.75), forKey: "confidence")

        // 2. Creates a recognized‑object observation with a bounding box
        let bbox = CGRect(x: 0.1, y: 0.2, width: 0.3, height: 0.4)
        let observation = VNRecognizedObjectObservation(boundingBox: bbox)

        // 3. Injects the fake classification into the private `labels` array
        observation.setValue([classification], forKey: "labels")

        // 4. Calls the Vision completion handler
        vc.visionRequestDidComplete(
          request: DummyRequest(results: [observation]),
          error: nil
        )

        // 5. Waits for the async main‑thread update
        let exp = expectation(description: "Wait for main thread update")
        DispatchQueue.main.async { exp.fulfill() }
        wait(for: [exp], timeout: 0.1)

        // 6. Asserts that exactly one Detection with the right values
        XCTAssertEqual(results.detections.count, 1)
        let det = results.detections[0]
        XCTAssertEqual(det.label, "ObjectX")
        XCTAssertEqual(det.confidence, 0.75, accuracy: 0.001)
        XCTAssertEqual(det.boundingBox, bbox)
    }
}

// MARK: - DummyRequest

private class DummyRequest: VNRequest {
    
    /// Backing storage for fake results.
    private let _results: [VNObservation]?
    
    /// Override the `results` property to return injected observations.
    override var results: [VNObservation]? {
        _results
    }
    
    /// Designated initializer accepts an array of VNObservation.
    init(results: [VNObservation]?) {
        self._results = results
        super.init(completionHandler: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
