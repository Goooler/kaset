import SwiftUI

// MARK: - macOS Compatibility Layer

/// Provides compatibility shims for macOS 26 features when running on older versions.
/// This allows the app to compile and run on macOS 15+ while using macOS 26 features
/// when available.

// MARK: - Glass Effect Container Compatibility

/// A container view that wraps content with GlassEffectContainer on macOS 26+,
/// or just returns the content on older versions.
struct GlassEffectContainerCompatible<Content: View>: View {
    let spacing: CGFloat
    @ViewBuilder let content: () -> Content

    init(spacing: CGFloat = 0, @ViewBuilder content: @escaping () -> Content) {
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        if #available(macOS 26.0, *) {
            GlassEffectContainer(spacing: self.spacing) {
                self.content()
            }
        } else {
            self.content()
        }
    }
}

// MARK: - Glass Effect Transition

extension View {
    /// Applies glass effect on macOS 26+, or a translucent material background on older versions.
    @ViewBuilder
    func glassEffectCompatible() -> some View {
        if #available(macOS 26.0, *) {
            self.glassEffect()
        } else {
            self
                .background(.ultraThinMaterial)
        }
    }

    /// Applies glass effect with capsule shape on macOS 26+,
    /// or a translucent material background on older versions.
    @ViewBuilder
    func glassEffectCapsuleCompatible() -> some View {
        if #available(macOS 26.0, *) {
            self.glassEffect(.regular, in: .capsule)
        } else {
            self
                .background(.ultraThinMaterial, in: .capsule)
        }
    }

    /// Applies glass effect with rounded rect shape on macOS 26+,
    /// or a translucent material background on older versions.
    @ViewBuilder
    func glassEffectRoundedRectCompatible(cornerRadius: CGFloat) -> some View {
        if #available(macOS 26.0, *) {
            self.glassEffect(.regular, in: .rect(cornerRadius: cornerRadius))
        } else {
            self
                .background(.ultraThinMaterial, in: .rect(cornerRadius: cornerRadius))
        }
    }

    /// Applies interactive glass effect with capsule shape on macOS 26+,
    /// or a translucent material background on older versions.
    @ViewBuilder
    func glassEffectInteractiveCapsuleCompatible() -> some View {
        if #available(macOS 26.0, *) {
            self.glassEffect(.regular.interactive(), in: .capsule)
        } else {
            self
                .background(.ultraThinMaterial, in: .capsule)
        }
    }

    /// Applies glass effect transition (materialize) on macOS 26+, no-op on older versions.
    @ViewBuilder
    func glassEffectTransitionCompatible() -> some View {
        if #available(macOS 26.0, *) {
            self.glassEffectTransition(.materialize)
        } else {
            self
        }
    }

    /// Applies glass effect unselected style on macOS 26+, no-op on older versions.
    @ViewBuilder
    func glassEffectUnselectedCompatible() -> some View {
        if #available(macOS 26.0, *) {
            self.glassEffect(.regular.interactive(false))
        } else {
            self
        }
    }

    /// Applies glass effect ID for matched geometry on macOS 26+, no-op on older versions.
    @ViewBuilder
    func glassEffectIDCompatible(_ id: String, in namespace: Namespace.ID) -> some View {
        if #available(macOS 26.0, *) {
            self.glassEffectID(id, in: namespace)
        } else {
            self
        }
    }
}

// MARK: - Intelligence Modifier Compatibility

extension View {
    /// Marks view as requiring Apple Intelligence on macOS 26+, no-op on older versions.
    /// On macOS 15, views using this are simply hidden since AI is not available.
    @ViewBuilder
    func requiresIntelligenceCompatible(
        hideWhenUnavailable: Bool = true,
        message: String = "Requires Apple Intelligence",
        showSparkle: Bool = false
    ) -> some View {
        if #available(macOS 26.0, *) {
            self.requiresIntelligence(
                hideWhenUnavailable: hideWhenUnavailable,
                message: message,
                showSparkle: showSparkle
            )
        } else {
            // On older macOS, AI is never available, so hide if requested
            if hideWhenUnavailable {
                EmptyView()
            } else {
                self
                    .disabled(true)
                    .opacity(0.4)
                    .help(message)
            }
        }
    }
}

// MARK: - Foundation Models Service Compatibility

/// A placeholder for Foundation Models availability check on older macOS.
@MainActor
enum FoundationModelsCompatibility {
    /// Returns true if Foundation Models (Apple Intelligence) is available.
    static var isAvailable: Bool {
        if #available(macOS 26.0, *) {
            return FoundationModelsService.shared.isAvailable
        } else {
            return false
        }
    }
}
