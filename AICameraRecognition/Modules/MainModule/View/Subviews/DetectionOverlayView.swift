//
//  DetectionOverlayView.swift
//  AICameraRecognition
//
//  Created by Roman Tverdokhleb on 4/7/25.
//

import SwiftUI

struct DetectionOverlayView: View {
    @ObservedObject var detectionResults: DetectionResults
    
    internal var body: some View {
        GeometryReader { proxy in
            ForEach(detectionResults.detections) { detection in
                let rect = detection.boundingBox
                let x = rect.origin.x * proxy.size.width
                let y = (1 - rect.origin.y - rect.size.height) * proxy.size.height
                
                let width = rect.size.width * proxy.size.width
                let height = rect.size.height * proxy.size.height
                
                ZStack {
                    Rectangle()
                        .stroke(Color.red, lineWidth: 2)
                        .frame(width: width, height: height)
                        .position(x: x + width / 2, y: y + height / 2)
                    
                    Text("\(detection.label) \(Int(detection.confidence * 100))%")
                        .font(.caption)
                        .foregroundStyle(Color.red)
                        .padding(4)
                        .background(Color.white.opacity(0.7))
                        .position(x: x + width, y: y)
                }
            }
        }
    }
}

#Preview {
    DetectionOverlayView(detectionResults: DetectionResults())
}
