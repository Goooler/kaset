import SwiftUI

// MARK: - PersistentPlayerView

/// A SwiftUI view that displays the singleton WebView.
/// The WebView is created once and reused for all playback.
struct PersistentPlayerView: NSViewRepresentable {
    @Environment(WebKitManager.self) private var webKitManager
    @Environment(PlayerService.self) private var playerService

    let videoId: String
    let isExpanded: Bool

    private let logger = DiagnosticsLogger.player

    func makeNSView(context _: Context) -> NSView {
        logger.info("PersistentPlayerView.makeNSView for videoId: \(videoId)")

        let container = NSView(frame: .zero)
        container.wantsLayer = true

        // Get or create the singleton WebView
        let webView = SingletonPlayerWebView.shared.getWebView(
            webKitManager: webKitManager,
            playerService: playerService
        )

        // Remove from any previous superview and add to this container
        webView.removeFromSuperview()
        webView.frame = container.bounds
        webView.autoresizingMask = [.width, .height]
        container.addSubview(webView)

        // Load the video if needed
        if SingletonPlayerWebView.shared.currentVideoId != videoId {
            let url = URL(string: "https://music.youtube.com/watch?v=\(videoId)")!
            logger.info("Initial load: \(url.absoluteString)")
            webView.load(URLRequest(url: url))
            SingletonPlayerWebView.shared.currentVideoId = videoId
        }

        return container
    }

    func updateNSView(_ container: NSView, context _: Context) {
        logger.info("PersistentPlayerView.updateNSView for videoId: \(videoId)")

        // Ensure WebView is in this container
        let webView = SingletonPlayerWebView.shared.getWebView(
            webKitManager: webKitManager,
            playerService: playerService
        )

        if webView.superview !== container {
            logger.info("Re-parenting WebView to current container")
            webView.removeFromSuperview()
            webView.frame = container.bounds
            webView.autoresizingMask = [.width, .height]
            container.addSubview(webView)
        }

        webView.frame = container.bounds

        // Load new video if changed
        SingletonPlayerWebView.shared.loadVideo(videoId: videoId)
    }
}
