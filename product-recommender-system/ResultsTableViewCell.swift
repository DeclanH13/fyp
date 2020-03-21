//
//  ResultsTableViewCell.swift
//  product-recommender-system
//
//  Created by Declan Holland on 20/03/2020.
//  Copyright © 2020 Declan Holland. All rights reserved.
//

import UIKit
import WebKit

class ResultsTableViewCell: UITableViewCell , WKNavigationDelegate, WKUIDelegate{

    
    @IBOutlet weak var webView: WKWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        let url = URL(string:"http://www.google.com")!
//        let request = URLRequest(url: url)
//        webView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
//       // webView.frame = CGRect(x: 0, y: 0, width)
//        webView.load(request)
        
        }
        
        // Initialization code
    
    
   func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.frame.size.height = 1
        webView.frame.size = webView.scrollView.contentSize
    }

//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        if (contentHeights[webView.tag] != 0.0)
//               {
//                   // we already know height, no need to reload cell
//                   return
//               }
//                print("Here")
//               contentHeights[webView.tag] = webView.scrollView.contentSize.height
//               //tableView.reloadRows(at: [(NSIndexPath(row: webView.tag, section: 0) as IndexPath)], with: .automatic)
//    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
