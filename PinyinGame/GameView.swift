import SwiftUI
import WebKit

@main
struct PinyinGameApp: App {
    var body: some Scene {
        WindowGroup {
            GameView()
                .preferredColorScheme(.light)
                .statusBarHidden()
        }
    }
}

struct GameView: View {
    @StateObject private var vm = WebViewModel()

    var body: some View {
        WKWebViewWrapper(webView: vm.webView)
            .ignoresSafeArea()
            .onAppear { vm.loadGame() }
    }
}

struct WKWebViewWrapper: UIViewRepresentable {
    let webView: WKWebView
    func makeUIView(context: Context) -> WKWebView { webView }
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

final class WebViewModel: NSObject, ObservableObject, WKNavigationDelegate, WKUIDelegate {
    let webView: WKWebView

    override init() {
        let config = WKWebViewConfiguration()
        config.preferences.javaScriptEnabled = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = true
        config.mediaTypesRequiringUserActionForPlayback = []

        let wv = WKWebView(frame: .zero, configuration: config)
        wv.backgroundColor = .white
        self.webView = wv

        super.init()

        wv.navigationDelegate = self
        wv.uiDelegate = self
        wv.allowsBackForwardNavigationGestures = true
    }

    func loadGame() {
        guard let url = Bundle.main.url(forResource: "index", withExtension: "html"),
              let base = Bundle.main.resourceURL else { return }
        webView.loadFileURL(url, allowingReadAccessTo: base)
    }
}
