//import SwiftUI
//import WebKit
//
//struct GifImageView: UIViewRepresentable {
//    private let name: String // The name of the GIF file (without .gif extension)
//
//    init(_ name: String) {
//        self.name = name
//    }
//
//    func makeUIView(context: Context) -> WKWebView {
//        let webView = WKWebView()
//        // Configure WebView appearance and behavior
//        webView.isOpaque = false // Make background transparent
//        webView.backgroundColor = UIColor.clear
//        webView.scrollView.backgroundColor = UIColor.clear
//        webView.scrollView.isScrollEnabled = false // Disable scrolling for a static GIF
//        webView.scrollView.bounces = false // Disable bouncing
//
//        // Attempt to load the GIF
//        loadGif(named: self.name, into: webView)
//        
//        return webView
//    }
//
//    func updateUIView(_ uiView: WKWebView, context: Context) {
//        // This method is called if the SwiftUI view struct gets re-created or its state changes.
//        // If the 'name' property could change and you want the GIF to update,
//        // you need to reload the content based on the new 'name'.
//        // The Coordinator pattern can be used to check if the name has actually changed.
//        // For simplicity here, we'll just try to reload the current 'name'.
//        // This isn't the most optimal if 'name' is always static for this view instance,
//        // but ensures it updates if 'name' *were* dynamic.
//        
//        // It's important to avoid unnecessary reloads if the content hasn't changed.
//        // A more advanced approach would involve a Coordinator to track the loaded GIF name.
//        // For now, if updateUIView is called, we re-evaluate loading.
//        // A simple uiView.reload() would just reload the last successful content,
//        // which might be an error page if the initial load failed.
//        
//        print("GifImageView: updateUIView called for '\(self.name).gif'")
//        loadGif(named: self.name, into: uiView)
//    }
//
//    private func loadGif(named gifName: String, into webView: WKWebView) {
//        guard let url = Bundle.main.url(forResource: gifName, withExtension: "gif") else {
//            print("❌ Error: GIF file '\(gifName).gif' not found in bundle.")
//            // Display an error message in the WebView
//            let htmlError = """
//            <html>
//            <body style="background-color:transparent; display:flex; justify-content:center; align-items:center; height:100vh; margin:0;">
//                <p style="color:red; font-family:sans-serif; font-size:12px; text-align:center;">
//                    Error: GIF <br>'\(gifName).gif'<br> not found.
//                </p>
//            </body>
//            </html>
//            """
//            webView.loadHTMLString(htmlError, baseURL: Bundle.main.bundleURL)
//            return
//        }
//
//        do {
//            let data = try Data(contentsOf: url)
//            // Load the GIF data into the WebView
//            // The baseURL is important for the WKWebView to correctly interpret the data.
//            webView.load(
//                data,
//                mimeType: "image/gif",
//                characterEncodingName: "UTF-8",
//                baseURL: url.deletingLastPathComponent() // Use the directory containing the GIF as the base URL
//            )
//            print("✅ GIF '\(gifName).gif' loaded successfully.")
//        } catch {
//            print("❌ Error loading data for GIF '\(gifName).gif': \(error.localizedDescription)")
//            // Display an error message in the WebView
//            let htmlError = """
//            <html>
//            <body style="background-color:transparent; display:flex; justify-content:center; align-items:center; height:100vh; margin:0;">
//                <p style="color:red; font-family:sans-serif; font-size:12px; text-align:center;">
//                    Error loading data for <br>'\(gifName).gif'.
//                </p>
//            </body>
//            </html>
//            """
//            webView.loadHTMLString(htmlError, baseURL: Bundle.main.bundleURL)
//        }
//    }
//}


import SwiftUI
import WebKit

struct GifImageView: UIViewRepresentable {
    private let name: String // The name of the GIF file (without .gif extension)
    private let width: CGFloat
    private let height: CGFloat

    // Updated initializer with optional width and height parameters
    init(_ name: String, width: CGFloat = 200, height: CGFloat = 200) {
        self.name = name
        self.width = width
        self.height = height
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        // Configure WebView appearance and behavior
        webView.isOpaque = false // Make background transparent
        webView.backgroundColor = UIColor.clear
        webView.scrollView.backgroundColor = UIColor.clear
        webView.scrollView.isScrollEnabled = false // Disable scrolling for a static GIF
        webView.scrollView.bounces = false // Disable bouncing

        // Attempt to load the GIF
        loadGif(named: self.name, into: webView)
        
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        print("GifImageView: updateUIView called for '\(self.name).gif'")
        loadGif(named: self.name, into: uiView)
    }

    private func loadGif(named gifName: String, into webView: WKWebView) {
        guard let url = Bundle.main.url(forResource: gifName, withExtension: "gif") else {
            print("❌ Error: GIF file '\(gifName).gif' not found in bundle.")
            // Display an error message in the WebView
            let htmlError = """
            <html>
            <body style="background-color:transparent; display:flex; justify-content:center; align-items:center; height:100vh; margin:0;">
                <p style="color:red; font-family:sans-serif; font-size:12px; text-align:center;">
                    Error: GIF <br>'\(gifName).gif'<br> not found.
                </p>
            </body>
            </html>
            """
            webView.loadHTMLString(htmlError, baseURL: Bundle.main.bundleURL)
            return
        }

        // Load the GIF using an HTML wrapper to control size
        let htmlString = """
        <html>
        <head>
        <style>
            body {
                margin: 0;
                background-color: transparent;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
            }
            img {
                width: \(Int(width))px;
                height: \(Int(height))px;
                object-fit: contain;
            }
        </style>
        </head>
        <body>
            <img src="\(url.lastPathComponent)" alt="GIF" />
        </body>
        </html>
        """

        webView.loadHTMLString(htmlString, baseURL: url.deletingLastPathComponent())
        print("✅ GIF '\(gifName).gif' loaded successfully with size \(width)x\(height).")
    }
}
