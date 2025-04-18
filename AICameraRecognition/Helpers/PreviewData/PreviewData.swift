//
//  PreviewData.swift
//  AICameraRecognition
//
//  Created by Roman Tverdokhleb on 18/04/2025.
//

import Foundation

final class PreviewData {
    
    static internal var detectionResults: [Detection] {
        let first = Detection(label: "First", confidence: .zero, boundingBox: CGRect.zero)
        let second = Detection(label: "Second", confidence: .zero, boundingBox: CGRect.zero)
        let third = Detection(label: "Third", confidence: .zero, boundingBox: CGRect.zero)
        let fourth = Detection(label: "Fourth", confidence: .zero, boundingBox: CGRect.zero)
        
        return [first, second, third, fourth]
    }
}
