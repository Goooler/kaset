import SwiftUI

// MARK: - StaggeredAppearanceModifier

/// A view modifier that animates content appearance with a staggered delay.
@available(macOS 26.0, *)
struct StaggeredAppearanceModifier: ViewModifier {
    let index: Int
    let animation: Animation

    @State private var isVisible = false

    private var delay: Double {
        AppAnimation.stagger(for: index)
    }

    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 20)
            .onAppear {
                guard !NSWorkspace.shared.accessibilityDisplayShouldReduceMotion else {
                    isVisible = true
                    return
                }
                withAnimation(animation.delay(delay)) {
                    isVisible = true
                }
            }
    }
}

@available(macOS 26.0, *)
extension View {
    /// Applies a staggered appearance animation based on item index.
    /// - Parameters:
    ///   - index: The index of this item in the list.
    ///   - animation: The animation to use (default: smooth).
    /// - Returns: A view with staggered appearance animation.
    func staggeredAppearance(
        index: Int,
        animation: Animation = AppAnimation.smooth
    ) -> some View {
        modifier(StaggeredAppearanceModifier(index: index, animation: animation))
    }
}

// MARK: - HoverHighlightModifier

/// A view modifier that adds a hover highlight effect to a view.
@available(macOS 26.0, *)
struct HoverHighlightModifier: ViewModifier {
    var cornerRadius: CGFloat = 8
    var padding: CGFloat = 4

    @State private var isHovering = false

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(isHovering ? Color.primary.opacity(0.08) : Color.clear)
            )
            .padding(-padding)
            .animation(AppAnimation.quick, value: isHovering)
            .onHover { hovering in
                isHovering = hovering
            }
    }
}

@available(macOS 26.0, *)
extension View {
    /// Adds a hover highlight background effect.
    /// - Parameters:
    ///   - cornerRadius: The corner radius of the highlight.
    ///   - padding: Internal padding for the highlight background.
    /// - Returns: A view with hover highlight effect.
    func hoverHighlight(cornerRadius: CGFloat = 8, padding: CGFloat = 4) -> some View {
        modifier(HoverHighlightModifier(cornerRadius: cornerRadius, padding: padding))
    }
}

// MARK: - FadeInModifier

/// A view modifier for smooth fade-in transitions.
@available(macOS 26.0, *)
struct FadeInModifier: ViewModifier {
    @State private var opacity: Double = 0

    let duration: Double
    let delay: Double

    func body(content: Content) -> some View {
        content
            .opacity(opacity)
            .onAppear {
                guard !NSWorkspace.shared.accessibilityDisplayShouldReduceMotion else {
                    opacity = 1
                    return
                }
                withAnimation(.easeIn(duration: duration).delay(delay)) {
                    opacity = 1
                }
            }
    }
}

@available(macOS 26.0, *)
extension View {
    /// Fades in the view when it appears.
    /// - Parameters:
    ///   - duration: The fade duration (default: 0.3).
    ///   - delay: Delay before starting the fade (default: 0).
    /// - Returns: A view with fade-in animation.
    func fadeIn(duration: Double = 0.3, delay: Double = 0) -> some View {
        modifier(FadeInModifier(duration: duration, delay: delay))
    }
}

// MARK: - PulseModifier

/// A view modifier that applies a pulsing scale animation.
@available(macOS 26.0, *)
struct PulseModifier: ViewModifier {
    var minScale: CGFloat = 0.97
    var maxScale: CGFloat = 1.0
    var duration: Double = 1.0

    @State private var isPulsing = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? maxScale : minScale)
            .onAppear {
                guard !NSWorkspace.shared.accessibilityDisplayShouldReduceMotion else { return }
                withAnimation(
                    .easeInOut(duration: duration)
                        .repeatForever(autoreverses: true)
                ) {
                    isPulsing = true
                }
            }
    }
}

@available(macOS 26.0, *)
extension View {
    /// Applies a subtle pulsing animation.
    /// - Parameters:
    ///   - minScale: Minimum scale during pulse.
    ///   - maxScale: Maximum scale during pulse.
    ///   - duration: Duration of one pulse cycle.
    /// - Returns: A view with pulsing animation.
    func pulse(
        minScale: CGFloat = 0.97,
        maxScale: CGFloat = 1.0,
        duration: Double = 1.0
    ) -> some View {
        modifier(PulseModifier(minScale: minScale, maxScale: maxScale, duration: duration))
    }
}

// MARK: - BounceOnChangeModifier

/// A view modifier that bounces when a value changes.
@available(macOS 26.0, *)
struct BounceOnChangeModifier<V: Equatable>: ViewModifier {
    let value: V
    var scale: CGFloat = 1.2

    @State private var isBouncing = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isBouncing ? scale : 1.0)
            .animation(AppAnimation.bouncy, value: isBouncing)
            .onChange(of: value) { _, _ in
                guard !NSWorkspace.shared.accessibilityDisplayShouldReduceMotion else { return }
                isBouncing = true
                Task { @MainActor in
                    try? await Task.sleep(for: .seconds(0.15))
                    isBouncing = false
                }
            }
    }
}

@available(macOS 26.0, *)
extension View {
    /// Bounces the view when the specified value changes.
    /// - Parameters:
    ///   - value: The value to observe for changes.
    ///   - scale: The scale factor during bounce (default: 1.2).
    /// - Returns: A view that bounces on value change.
    func bounceOnChange(of value: some Equatable, scale: CGFloat = 1.2) -> some View {
        modifier(BounceOnChangeModifier(value: value, scale: scale))
    }
}

// MARK: - ShakeModifier

/// A view modifier that shakes when triggered.
@available(macOS 26.0, *)
struct ShakeModifier: ViewModifier {
    var isShaking: Bool
    var shakeAmount: CGFloat = 10
    var shakeDuration: Double = 0.5

    func body(content: Content) -> some View {
        content
            .offset(x: isShaking ? shakeAmount : 0)
            .animation(
                isShaking ?
                    .spring(response: 0.1, dampingFraction: 0.2)
                    .repeatCount(3, autoreverses: true) :
                    .default,
                value: isShaking
            )
    }
}

@available(macOS 26.0, *)
extension View {
    /// Shakes the view when the condition is true.
    /// - Parameters:
    ///   - isShaking: Whether to trigger the shake.
    ///   - amount: The horizontal shake distance.
    /// - Returns: A view that shakes when triggered.
    func shake(when isShaking: Bool, amount: CGFloat = 10) -> some View {
        modifier(ShakeModifier(isShaking: isShaking, shakeAmount: amount))
    }
}

// MARK: - Preview

@available(macOS 26.0, *)
#Preview {
    VStack(spacing: 24) {
        // Staggered appearance
        VStack(alignment: .leading) {
            ForEach(0 ..< 3, id: \.self) { index in
                Text("Item \(index)")
                    .padding()
                    .background(.quaternary)
                    .clipShape(.rect(cornerRadius: 8))
                    .staggeredAppearance(index: index)
            }
        }

        // Hover highlight
        Text("Hover me!")
            .hoverHighlight()

        // Pulse
        Circle()
            .fill(.blue)
            .frame(width: 50, height: 50)
            .pulse()
    }
    .padding()
}
