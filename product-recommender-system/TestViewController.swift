//
//  TestViewController.swift
//  product-recommender-system
//
//  Created by Declan Holland on 20/03/2020.
//  Copyright © 2020 Declan Holland. All rights reserved.
//

import UIKit
import WebKit
class TestViewController: UIViewController, WKUIDelegate{
    let webView = WKWebView()
    override func viewDidLoad() {
        super.viewDidLoad()
//        let url = URL(string: "http://www.google.com")!
//        let request = URLRequest(url:url)
        webView.frame = CGRect(x:0, y:0 ,width: 300, height:300)
        webView.loadHTMLString("<h1>Test</h1>", baseURL: nil )
        view.addSubview(webView)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
