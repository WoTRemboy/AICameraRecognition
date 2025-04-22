//
//  Colors.swift
//  AICameraRecognition
//
//  Created by Roman Tverdokhleb on 4/4/25.
//

import SwiftUI

/// A namespace for application color assets, organized by usage context.
extension Color {
    
    /// Background colors used throughout the app.
    enum BackColors {
        static let backElevated = Color("BackElevated")
        static let backiOSPrimary = Color("BackiOSPrimary")
        static let backPrimary = Color("BackPrimary")
        static let backSecondary = Color("BackSecondary")
        static let backDefault = Color("BackDefault")
        static let backSplash = Color("BackSplash")
    }
    
    /// Text label colors used for different semantic purposes.
    enum LabelColors {
        static let labelDisable = Color("LabelDisable")
        static let labelDetails = Color("LabelDetails")
        static let labelPrimary = Color("LabelPrimary")
        static let labelSecondary = Color("LabelSecondary")
        static let labelTertiary = Color("LabelTertiary")
        static let labelReversed = Color("LabelReversed")
        static let labelBlack = Color("LabelBlack")
        static let labelWhite = Color("LabelWhite")
    }
    
    /// Tint colors used for interactive elements and highlights.
    enum TintColors {
        static let tintBlue = Color("TintBlue")
        static let tintGreen = Color("TintGreen")
        static let tintOrange = Color("TintOrange")
    }
}
