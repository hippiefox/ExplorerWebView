//
//  EPLWebView.swift
//  ExplorerWebView
//
//  Created by pulei yu on 2023/10/23.
//

import Foundation
import SnapKit
import UIKit
import WebKit

public extension EPLWebViewController {
    enum SomeKeyPath: String, CaseIterable {
        case estimatedProgress
        case title
    }
}

open class EPLWebViewController: UIViewController {
    /// 初次加载的URL
    public var originURL: URL!

    /// 进度条加载颜色
    open var progressTintColor: UIColor = .blue {
        didSet {
            progressView.tintColor = progressTintColor
        }
    }

    /// 进度条背景颜色
    open var progressTrackColor: UIColor = .blue {
        didSet {
            progressView.trackTintColor = progressTrackColor
        }
    }

    open lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        view.tintColor = progressTintColor
        view.trackTintColor = progressTrackColor
        return view
    }()

    open lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences.preferredContentMode = .mobile
        let view = WKWebView(frame: .zero, configuration: config)
        view.scrollView.showsVerticalScrollIndicator = false
        view.scrollView.showsHorizontalScrollIndicator = false
        view.allowsBackForwardNavigationGestures = true
        return view
    }()

    override open func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        SomeKeyPath.allCases.forEach { webView.addObserver(self, forKeyPath: $0.rawValue, options: .new, context: nil) }
        loadUrl()
    }

    open func loadUrl() {
        guard let url = originURL else { return }
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        webView.load(request)
    }

    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == SomeKeyPath.estimatedProgress.rawValue {
            progressView.alpha = 1.0
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            if webView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.2, delay: 0.1, options: UIView.AnimationOptions.curveLinear, animations: {
                    self.progressView.alpha = 0
                }) { _ in
                    self.progressView.setProgress(0.0, animated: false)
                }
            }
        }
        if keyPath == SomeKeyPath.title.rawValue {
            title = webView.title
        }
    }

    deinit {
        webView.stopLoading()

        SomeKeyPath.allCases.forEach {
            webView.removeObserver(self, forKeyPath: $0.rawValue)
        }

        print("------>\(self.classForCoder.description()) deinit")
    }
}

extension EPLWebViewController {
    @objc open func configUI() {
        view.addSubview(progressView)
        progressView.snp.makeConstraints {
            $0.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            $0.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(2)
        }
        view.addSubview(webView)
        webView.snp.makeConstraints {
            $0.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            $0.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        view.bringSubview(toFront: progressView)
    }
}
