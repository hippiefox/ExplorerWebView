//
//  ViewController.swift
//  ExplorerWebView
//
//  Created by HippieFox on 10/23/2023.
//  Copyright (c) 2023 HippieFox. All rights reserved.
//

import UIKit
import SnapKit
import ExplorerWebView

class ViewController: UIViewController {
    
    private lazy var button: UIButton = {
        let btn = UIButton()
        btn.setTitle("Go", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(tapGo), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.width.height.equalTo(100)
            $0.center.equalToSuperview()
        }
    }
    
    @objc private func tapGo(){
        let web = EPLWebViewController()
        web.originURL = URL(string: "https://baidu.com")
        
//        web.modalPresentationStyle = .fullScreen
        present(web, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

