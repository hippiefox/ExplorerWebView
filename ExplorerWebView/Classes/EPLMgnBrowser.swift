//
//  EPLMgnBrowser.swift
//  ExplorerWebView
//
//  Created by pulei yu on 2023/10/23.
//

import Foundation
import UIKit
import WebKit

open class EPLMgnBrowser: EPLWebViewController, WKNavigationDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
    }

    open func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard navigationAction.targetFrame != nil else {
            webView.load(navigationAction.request)
            decisionHandler(.allow)
            return
        }

        guard let targetURL = navigationAction.request.url,
              let targetScheme = targetURL.scheme else {
            decisionHandler(.allow)
            return
        }

        if let mgnscheme = EPLMgnBrowserConfig.mgn_scheme,
           mgnscheme == targetScheme {
            decisionHandler(.cancel)
            hdlmgn(targetURL.absoluteString)
            return
        }

        if let wscheme = EPLMgnBrowserConfig.w_scheme,
           wscheme == targetScheme {
            decisionHandler(.cancel)
            hdlw(targetURL)
            return
        }

        var targetURLString = targetURL.absoluteString
        if let ascheme = EPLMgnBrowserConfig.a_scheme,
           targetURLString.hasPrefix(ascheme) {
            if let aschemeappkey = EPLMgnBrowserConfig.a_scheme_appkey,
               aschemeappkey.isEmpty == false,
               let appscheme = EPLMgnBrowserConfig.app_scheme {
                targetURLString = String.epl_setQuery(apurl: targetURLString, key: aschemeappkey, value: appscheme)
            }
            decisionHandler(.cancel)
            hdla(targetURLString)
            return
        }

        if let appscheme = EPLMgnBrowserConfig.app_scheme,
           appscheme == targetScheme {
            hdlapp(targetURLString)
        }
    }

    open func hdlmgn(_ urlString: String) {
        // void impl
    }

    open func hdlw(_ url: URL) {
        // stub impl
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    open func hdla(_ urlString: String) {
        // stub impl
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    open func hdlapp(_ urlString: String) {
        // void impl
    }
}

public extension String {
    static func epl_dicFrom(jsonString: String) -> [String: Any]? {
        guard jsonString.isEmpty == false,
              let data = jsonString.data(using: .utf8),
              let dic = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
        else {
            return nil
        }
        return dic
    }

    static func epl_setQuery(apurl: String, key: String, value: String) -> String {
        guard let urlComp = URLComponents(string: apurl),
              let q = urlComp.query,
              var rawDic = String.epl_dicFrom(jsonString: q)
        else {
            return apurl
        }

        rawDic[key] = value
        guard let dicStr = rawDic.epl_2JSONString() else { return apurl }

        let chs = "{}:!@#$^&%*+,\\='\""
        guard let percentCodeStr = dicStr.addingPercentEncoding(withAllowedCharacters: .init(charactersIn: chs).inverted) else { return apurl }

        var resultUrl = ""
        if let scheme = urlComp.scheme {
            resultUrl += "\(scheme)://"
        }
        if let host = urlComp.host {
            resultUrl += host
        }
        resultUrl += urlComp.path
        resultUrl += "?\(percentCodeStr)"
        return resultUrl
    }
}

public extension Dictionary {
    func epl_2JSONString() -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []),
              let jsonStr = String(data: data, encoding: .utf8)
        else { return nil }

        return jsonStr
    }
}
