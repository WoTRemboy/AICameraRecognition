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
    
    func testVisionRequestDidComplete_withError_doesNotUpdateDetections() {
        vc.visionRequestDidComplete(request: DummyRequest(results: nil),
                                    error: NSError(domain: "test", code: -1))
        XCTAssertTrue(results.detections.isEmpty)
    }
    
    func testVisionRequestDidComplete_withNoResults_doesNotUpdateDetections() {
        vc.visionRequestDidComplete(request: DummyRequest(results: []),
                                    error: nil)
        XCTAssertTrue(results.detections.isEmpty)
    }
}


private class DummyRequest: VNRequest {
    private let _results: [Any]?

    init(results: [Any]?) {
        self._results = results
        super.init(completionHandler: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
