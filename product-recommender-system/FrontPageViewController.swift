//
//  FrontPageViewController.swift
//  product-recommender-system
//
//  Created by Declan Holland on 28/01/2020.
//  Copyright © 2020 Declan Holland. All rights reserved.
//

import UIKit
import FirebaseAuth
import SwiftSoup
import WebKit

class FrontPageViewController: UIViewController, WKUIDelegate  {
     var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
   
    @IBOutlet weak var product: UITextField!
    
    
    
    
    
    @IBAction func logOutAction(_ sender: Any) {
        do {
               try Auth.auth().signOut()
           }
        catch let signOutError as NSError {
               print ("Error signing out: %@", signOutError)
           }
           
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let initial = storyboard.instantiateInitialViewController()
           UIApplication.shared.keyWindow?.rootViewController = initial
    }
    
    @IBAction func scrape(_ sender: Any) {
        
        let search = product.text!
        
        var requests = [URLRequest]()
        
        let query = search.replacingOccurrences(of: " ", with: "")
        var contents: String?
        //CLEAN EVERYTHING BELOW THIS
        var request_LittleWoods = URLRequest(url: URL(string: "https://www.littlewoodsireland.ie/e/q/"  + query + ".end?_requestid=290586")!)
              
              
        var request_SoundStore = URLRequest(url: URL(string: "https://www.soundstore.ie/catalogsearch/result/?q=" + query)!)
                  
        var request_HarveyNorman = URLRequest(url: URL(string: "https://www.harveynorman.ie/index.php?subcats=Y&status=A&pshort=N&pfull=N&pname=Y&pkeywords=Y&search_performed=Y&q=" + query + "&dispatch=products.search")!)
              
        var request_Currys = URLRequest(url: URL(string: "https://www.currys.ie/ieen/search-keywords/xx_xx_xx_xx_xx/" + query + "/xx-criteria.html")!)
               
        var request_Argos = URLRequest(url: URL(string:"https://www.argos.ie/webapp/wcs/stores/servlet/Search?storeId=10152&catalogId=15051&langId=111&searchTerms=" + query + "&authToken=-1002%252CTb6zd56kFOpztp1WPmC9rktuDxQ%253D")!)
            
        
        
        let tags = ["div", "span", "img", "a"]
        
        
        
        requests.append(request_HarveyNorman)
        requests.append(request_Argos)
        requests.append(request_Currys)
        requests.append(request_SoundStore)
        requests.append(request_LittleWoods)
        
        for var request in requests{
            print(request)
            request.httpMethod = "GET"
            let session = URLSession.init(configuration: URLSessionConfiguration.default)
            session.dataTask(with: request) {data,response,error in
                if let data = data {
                    contents = String(data: data, encoding: .ascii)
                    for tag in tags{
                        self.findMatches(query: self.product.text!, document: contents!, tag: tag)
                    }
                        
                }
            }.resume()
        }
       
       
 
        }
            
    
    
    
     
    
    
    
            
    func findMatches(query:String ,document:String ,tag:String){
        do{
            
            let doc: Document = try SwiftSoup.parse(document)
            let matches: Elements = try doc.select("" + tag + ":matches((?i)" + query + ")")
            
            let output: String = try matches.html()
            print("Outputs")
            print(output)
           }
           catch Exception.Error(let type, let message) {
               print("Error Message")
           } catch {
               
           }
        
        
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
