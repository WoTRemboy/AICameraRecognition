//
//  SlideToConfirmView.swift
//  AICameraRecognition
//
//  Created by Roman Tverdokhleb on 4/9/25.
//

import SwiftUI

struct SlideToConfirmView: View {
    var config: Config
    var onSwiped: () -> Void
    
    @State private var animateText: Bool = false
    @State private var offsetX: CGFloat = 0
    @State private var isCompleted: Bool = false
    
    internal var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let knobSize = size.height
            let maxLimit = size.width - knobSize
            let progress: CGFloat = isCompleted ? 1 : (offsetX / maxLimit)
            
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(
                        .gray.opacity(0.25)
                        .shadow(.inner(
                            color: .black.opacity(0.2),
                            radius: 10))
                    )
                
                let extraCapsuleWidth = (size.width - knobSize) * progress
                Capsule()
                    .fill(config.tint)
                    .frame(width: knobSize + extraCapsuleWidth, height: knobSize)
                
                leadingTextView(size, progress: progress)
                
                HStack(spacing: 0) {
                    knobView(size, progress: progress, maxLimit: maxLimit)
                        .zIndex(1)
                    
                    shimmerTextView(size, progress: progress)
                }
            }
        }
        .frame(height: isCompleted ? 50 : config.height)
        .containerRelativeFrame(.horizontal) { value, _ in
            let ratio: CGFloat = isCompleted ? 0.5 : 0.8
            return value * ratio
        }
        .frame(maxWidth: 300)
        .allowsTightening(!isCompleted)
    }
    
    @ViewBuilder
    private func knobView(_ size: CGSize, progress: CGFloat, maxLimit: CGFloat) -> some View {
        Circle()
            .fill(Color.BackColors.backDefault)
            .padding(6)
            .frame(width: size.height, height: size.height)
            .overlay {
                ZStack {
                    Image.Onboarding.Slider.chevron
                        .opacity(1 - progress)
                        .blur(radius: progress * 10)
                    
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
                        offsetX = min(max(value.translation.width, 0), maxLimit)
                    }).onEnded({ value in
                        if offsetX == maxLimit {
                            onSwiped()
                            animateText = false
                            
                            withAnimation(.smooth) {
                                isCompleted = true
                            }
                        } else {
                            withAnimation(.smooth) {
                                offsetX = 0
                            }
                        }
                    })
            )
    }
    
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
                Rectangle()
                    .scale(x: 1 - progress, anchor: .trailing)
            }
            .frame(height: size.height)
            .task {
                withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: false)) {
                    animateText = true
                }
            }
    }
    
    @ViewBuilder
    private func leadingTextView(_ size: CGSize, progress: CGFloat) -> some View {
        ZStack {
            Text(config.onSwipeText)
                .opacity(isCompleted ? 0 : 1)
                .blur(radius: isCompleted ? 10 : 0)
            
            Text(config.confirmationText)
                .opacity(!isCompleted ? 0 : 1)
                .blur(radius: !isCompleted ? 10 : 0)
        }
        .fontWeight(.semibold)
        .foregroundStyle(config.foregroundColor)
        .frame(maxWidth: .infinity)
        .padding(.trailing, (size.height * (isCompleted ? 0.6 : 1) / 2))
        .mask {
            Rectangle()
                .scale(x: progress, anchor: .leading)
        }
    }
    
    struct Config {
        var idleText: String
        var onSwipeText: String
        var confirmationText: String
        var tint: Color
        var foregroundColor: Color
        var height: CGFloat = 70
    }
}

#Preview {
    OnboardingScreenView()
}
