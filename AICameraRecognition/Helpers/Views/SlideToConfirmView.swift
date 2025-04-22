//
//  SlideToConfirmView.swift
//  AICameraRecognition
//
//  Created by Roman Tverdokhleb on 4/9/25.
//

import SwiftUI

/// A customizable slide-to-confirm control that displays an idle state,
/// a moving knob, and a shimmering text effect.
struct SlideToConfirmView: View {
    
    // MARK: - State Properties
    
    /// Controls the shimmering animation of the idle text.
    @State private var animateText: Bool = false
    /// Tracks the horizontal offset of the draggable knob.
    @State private var offsetX: CGFloat = 0
    /// Indicates whether the slide action has completed.
    @State private var isCompleted: Bool = false
    
    // MARK: - Configuration & Callbacks
    
    /// Holds visual configuration such as text labels and colors.
    private var config: Config
    /// Closure invoked when the slide reaches the end position.
    private var onSwiped: () -> Void
    
    /// Initializes the slide-to-confirm view.
    ///
    /// - Parameters:
    ///   - config: A `Config` struct defining text strings, colors, and height.
    ///   - onSwiped: A callback executed when the user completes the slide gesture.
    init(config: Config, onSwiped: @escaping () -> Void) {
        self.config = config
        self.onSwiped = onSwiped
    }
    
    // MARK: - View Body
    
    internal var body: some View {
        GeometryReader { proxy in
            // Calculates dimensions and progress based on drag state
            let size = proxy.size
            let knobSize = size.height
            let maxLimit = size.width - knobSize
            let progress: CGFloat = isCompleted ? 1 : (offsetX / maxLimit)
            
            ZStack(alignment: .leading) {
                // Background capsule
                Capsule()
                    .fill(
                        .gray.opacity(0.25)
                        .shadow(.inner(
                            color: .black.opacity(0.2),
                            radius: 10))
                    )
                
                // Filled portion of the capsule indicating progress
                let extraCapsuleWidth = (size.width - knobSize) * progress
                Capsule()
                    .fill(config.tint)
                    .frame(width: knobSize + extraCapsuleWidth, height: knobSize)
                
                // Text that appears behind the knob
                leadingTextView(size, progress: progress)
                
                // Draggable knob and shimmer text
                HStack(spacing: 0) {
                    knobView(size, progress: progress, maxLimit: maxLimit)
                        .zIndex(1)
                    
                    shimmerTextView(size, progress: progress)
                }
            }
        }
        // Resets the slider when a camera stop notification is received
        .onReceive(NotificationCenter.default.publisher(for: .cameraDidStop)) { _ in
            withAnimation(.smooth) {
                isCompleted = false
                offsetX = 0
            }
        }
        // Adjusts the overall frame height based on completion state
        .frame(height: isCompleted ? 50 : config.height)
        // Center the slider horizontally with a width ratio
        .containerRelativeFrame(.horizontal) { value, _ in
            let ratio: CGFloat = isCompleted ? 0.5 : 0.8
            return value * ratio
        }
        .frame(maxWidth: 300)
        .allowsTightening(!isCompleted)
    }
    
    // MARK: - Knob View
    
    /// Builds the draggable knob that the user can slide.
    ///
    /// - Parameters:
    ///   - size: The full size of the slider container.
    ///   - progress: The current slide progress (0...1).
    ///   - maxLimit: The maximum horizontal offset allowed.
    /// - Returns: A `View` representing the knob.
    @ViewBuilder
    private func knobView(_ size: CGSize, progress: CGFloat, maxLimit: CGFloat) -> some View {
        Circle()
            .fill(Color.BackColors.backDefault)
            .padding(6)
            .frame(width: size.height, height: size.height)
            .overlay {
                ZStack {
                    // Chevron icon fades out as progress increases
                    Image.Onboarding.Slider.chevron
                        .opacity(1 - progress)
                        .blur(radius: progress * 10)
                    
                    // Checkmark fades in upon completion
                    Image.Onboarding.Slider.checkmark
                        .opacity(progress)
                        .blur(radius: (1 - progress) * 10)
                }
                .font(.title3.bold())
            }
            .contentShape(.circle)
            .scaleEffect(isCompleted ? 0.6 : 1, anchor: .center)
            .offset(x: isCompleted ? maxLimit : offsetX)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        // Clamps the drag within allowable bounds
                        offsetX = min(max(value.translation.width, 0), maxLimit)
                    }).onEnded({ value in
                        if offsetX == maxLimit {
                            // Marks as completed and trigger confirmation
                            withAnimation(.smooth) {
                                isCompleted = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                onSwiped()
                            }
                            
                            // Provides haptic feedback
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                        } else {
                            // Snaps-back if not fully dragged
                            withAnimation(.smooth) {
                                offsetX = 0
                            }
                        }
                    })
            )
    }
    
    // MARK: - Shimmer Text View
    
    /// Builds the shimmering overlay effect on the idle text.
    ///
    /// - Parameters:
    ///   - size: The full size of the slider container.
    ///   - progress: The current slide progress (0...1).
    /// - Returns: A `View` with a shimmer animation.
    @ViewBuilder
    private func shimmerTextView(_ size: CGSize, progress: CGFloat) -> some View {
        Text(isCompleted ? config.confirmationText : config.idleText)
            .foregroundStyle(.gray.opacity(0.6))
            .overlay {
                Rectangle()
                    .frame(height: 20)
                    .rotationEffect(.init(degrees: 90))
                    .visualEffect { [animateText] content, proxy in
                        content
                            .offset(x: -proxy.size.width / 1.8)
                            .offset(x: animateText ? proxy.size.width * 1.2 : 0)
                    }
                    .mask(alignment: .leading) {
                        Text(config.idleText)
                    }
                    .blendMode(.softLight)
            }
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding(.trailing, size.height / 2)
            .mask {
                // Reveal the text proportionally to the knob progress
                Rectangle()
                    .scale(x: 1 - progress, anchor: .trailing)
            }
            .frame(height: size.height)
            .task {
                // Start continuous shimmer animation
                withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: false)) {
                    animateText = true
                }
            }
    }
    
    // MARK: - Leading Text View
    
    /// Builds the text that appears behind the knob, fading between two states.
    ///
    /// - Parameters:
    ///   - size: The full size of the slider container.
    ///   - progress: The current slide progress (0...1).
    /// - Returns: A `View` with crossfading text elements.
    @ViewBuilder
    private func leadingTextView(_ size: CGSize, progress: CGFloat) -> some View {
        ZStack {
            // Idle prompt text
            Text(config.onSwipeText)
                .opacity(isCompleted ? 0 : 1)
                .blur(radius: isCompleted ? 10 : 0)
            
            // Confirmation text after swipe
            Text(config.confirmationText)
                .opacity(!isCompleted ? 0 : 1)
                .blur(radius: !isCompleted ? 10 : 0)
        }
        .fontWeight(.semibold)
        .foregroundStyle(config.foregroundColor)
        .frame(maxWidth: .infinity)
        .padding(.trailing, (size.height * (isCompleted ? 0.6 : 1) / 2))
        .mask {
            // Reveal effect based on progress
            Rectangle()
                .scale(x: progress, anchor: .leading)
        }
    }
    
    // MARK: - Configuration Struct
    
    /// Configuration parameters for `SlideToConfirmView`.
    struct Config {
        /// Text shown when idle (before confirmation).
        var idleText: String
        /// Prompt text displayed initially.
        var onSwipeText: String
        /// Text shown after successful confirmation.
        var confirmationText: String
        /// Tint color for the filled capsule.
        var tint: Color
        /// Color for the on-swipe and confirmation text.
        var foregroundColor: Color
        /// Height of the slider control when not completed.
        var height: CGFloat = 70
    }
}

// MARK: - Preview

#Preview {
    OnboardingScreenView()
}
