//
//  FontExtension.swift
//  AICameraRecognition
//
//  Created by Roman Tverdokhleb on 4/9/25.
//

import SwiftUI

/// Defines a set of custom `Font` styles for the AICameraRecognition app.
extension Font {
    
    /// A large title font used for major headings.
    ///
    /// - Returns: A bold system font of size 35.
    static func largeTitle() -> Font? {
        Font.system(size: 35, weight: .bold)
    }
    
    /// The standard title font used in lists and forms.
    ///
    /// - Returns: A medium-weight system font of size 20.
    static func title() -> Font? {
        Font.system(size: 20, weight: .medium)
    }
    
    /// A headline font for short emphasis text.
    ///
    /// - Returns: A medium-weight system font of size 17.
    static func headline() -> Font? {
        Font.system(size: 17, weight: .medium)
    }
    
    /// A font style representing medium-weight body text.
    ///
    /// - Returns: A medium-weight system font of size 17.
    static func mediumBody() -> Font? {
        Font.system(size: 17, weight: .medium)
    }
    
    /// A font style representing regular-weight body text.
    ///
    /// - Returns: A regular-weight system font of size 17.
    static func regularBody() -> Font? {
        Font.system(size: 17, weight: .regular)
    }
    
    /// A font style representing light-weight body text.
    ///
    /// - Returns: A light-weight system font of size 17.
    static func body() -> Font? {
        Font.system(size: 17, weight: .light)
    }
    
    /// A subheadline font for secondary text or captions.
    ///
    /// - Returns: A light-weight system font of size 15.
    static func subhead() -> Font? {
        Font.system(size: 15, weight: .light)
    }
    
    /// A footnote font for tertiary or less prominent information.
    ///
    /// - Returns: A medium-weight system font of size 13.
    static func footnote() -> Font? {
        Font.system(size: 13, weight: .medium)
    }
    
    /// A lighter footnote font for subdued tertiary text.
    ///
    /// - Returns: A light-weight system font of size 13.
    static func lightFootnote() -> Font? {
        Font.system(size: 13, weight: .light)
    }
}
