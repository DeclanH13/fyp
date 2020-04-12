//
//  WebsiteViewController.swift
//  product-recommender-system
//
//  Created by Declan Holland on 24/03/2020.
//  Copyright © 2020 Declan Holland. All rights reserved.
//

import UIKit
import WebKit
class WebsiteViewController: UIViewController {
    var html:String!
    
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: html)
        webView.load(URLRequest(url: url!))
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
