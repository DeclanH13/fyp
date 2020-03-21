//
//  ResultsViewController.swift
//  product-recommender-system
//
//  Created by Declan Holland on 19/03/2020.
//  Copyright © 2020 Declan Holland. All rights reserved.
//

import UIKit
import WebKit


class testCell: UITableViewCell, WKUIDelegate{
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var label: UILabel!
    
    
}



class ResultsViewController: UIViewController, WKUIDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.append("This is a test 1")
        dataSource.append("This is a test 2")
        dataSource.append("This is a test 3")
        tableView.data = dataSource
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

extension ViewController: UITableViewDataSource {
    
    var data: [String] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Test") as! testCell
        cell.webView.loadHTMLString("<h1>This is a Test</h1>", baseURL: nil)
       // cell.label.text = dataSource[indexPath.row]
        return cell
    }
    
    
    
    
}
