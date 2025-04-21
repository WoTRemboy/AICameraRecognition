//
//  ZoomTransitionModifier.swift
//  AICameraRecognition
//
//  Created by Roman Tverdokhleb on 4/10/25.
//

import SwiftUI

/// A view modifier that applies a zoom-style navigation transition on iOS 18 and later.
struct NavigationTransitionModifier: ViewModifier {
    
    /// The unique identifier for the matched-geometry transition.
    private let id: String
    /// The namespace in which the matched-geometry transition occurs.
    private let namespace: Namespace.ID
    
    /// Creates a new `NavigationTransitionModifier`.
    /// - Parameters:
    ///   - id: A unique identifier matching the source and destination views.
    ///   - namespace: The shared namespace for matched-geometry transitions.
    init(id: String, namespace: Namespace.ID) {
        self.id = id
        self.namespace = namespace
    }
    
    /// Wraps the content in a zoom-style navigation transition on iOS 18 and later.
    /// - Parameter content: The original view content.
    /// - Returns: Either the zoom-transition-wrapped view or the original content.
    internal func body(content: Content) -> some View {
        if #available(iOS 18.0, *) {
            content
                .navigationTransition(
                    .zoom(sourceID: id,
                          in: namespace))
        } else {
            content
        }
    }
}

/// A view modifier that marks a view as the source of a matched-geometry transition
/// when navigating on iOS 18 and later.
struct NavigationTransitionSourceModifier: ViewModifier {
    
    /// The unique identifier for the matched-geometry transition.
    private let id: String
    /// The namespace in which the matched-geometry transition occurs.
    private let namespace: Namespace.ID
    
    /// Creates a new `NavigationTransitionSourceModifier`.
    /// - Parameters:
    ///   - id: A unique identifier matching the source and destination views.
    ///   - namespace: The shared namespace for matched-geometry transitions.
    init(id: String, namespace: Namespace.ID) {
        self.id = id
        self.namespace = namespace
    }
    
    /// Wraps the content in a matched-geometry source marker on iOS 18 and later.
    /// - Parameter content: The original view content.
    /// - Returns: Either the marked view or the original content.
    internal func body(content: Content) -> some View {
        if #available(iOS 18.0, *) {
            content
                .matchedTransitionSource(id: id, in: namespace)
        } else {
            content
        }
    }
}

extension View {
    /// Applies a zoom-style navigation transition when pushing or popping a view.
    /// - Parameters:
    ///   - id: A unique identifier to match source and destination.
    ///   - namespace: The namespace shared between views.
    /// - Returns: A view that participates in a zoom navigation transition.
    internal func navigationTransition(id: String, namespace: Namespace.ID) -> some View {
        self.modifier(NavigationTransitionModifier(id: id, namespace: namespace))
    }
    
    /// Marks this view as the source for a matched-geometry transition.
    /// - Parameters:
    ///   - id: A unique identifier to match source and destination.
    ///   - namespace: The namespace shared between views.
    /// - Returns: A view marked as the source of a navigation transition.
    internal func navigationTransitionSource(id: String, namespace: Namespace.ID) -> some View {
        self.modifier(NavigationTransitionSourceModifier(id: id, namespace: namespace))
    }
}
