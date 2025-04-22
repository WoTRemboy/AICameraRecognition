//
//  DetectionOverlayView.swift
//  AICameraRecognition
//
//  Created by Roman Tverdokhleb on 4/7/25.
//

import SwiftUI

/// A View that draws bounding boxes and labels for each detected object over the live camera feed.
struct DetectionOverlayView: View {
    
    /// An observable object containing the current list of `Detection` items.
    @ObservedObject var detectionResults: DetectionResults
    
    // MARK: - View Body
    
    internal var body: some View {
        GeometryReader { proxy in
            // Iterates over each detection to draw its overlay
            ForEach(detectionResults.detections) { detection in
                // Converts normalized boundingBox (0...1) into view coordinates
                let rect = detection.boundingBox
                let x = rect.origin.x * proxy.size.width
                
                // Flips the origin’s y-coordinate because Vision’s origin is bottom-left
                let y = (1 - rect.origin.y - rect.size.height) * proxy.size.height
                
                let width = rect.size.width * proxy.size.width
                let height = rect.size.height * proxy.size.height
                
                ZStack {
                    // Draws the bounding box as a red rectangle
                    Rectangle()
                        .stroke(Color.red, lineWidth: 2)
                        .frame(width: width, height: height)
                        .position(x: x + width / 2, y: y + height / 2)
                    
                    // Draws the label and confidence percentage above the box
                    Text("\(detection.label) \(Int(detection.confidence * 100))%")
                        .font(.caption)
                        .foregroundStyle(Color.red)
                        .padding(4)
                        .background(Color.white.opacity(0.7))
                        .position(x: x + width / 2, y: y - 12)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    let results = DetectionResults()
    results.detections = PreviewData.detectionResults
    
    return DetectionOverlayView(detectionResults: results)
}
