//
//  WebView.swift
//  Bona Puzzle Land
//
//  Created by Artur on 23.09.2024.
//

import Foundation
import WebKit
import SwiftUI
struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
