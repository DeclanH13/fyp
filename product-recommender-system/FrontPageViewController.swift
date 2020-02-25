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
    @IBOutlet weak var price: UITextField!
    
    
    
    
    
    
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
        
        var requests = [URLRequest : String]()
        
        let query = search.replacingOccurrences(of: " ", with: "")
        var contents: String?
        //CLEAN EVERYTHING BELOW THIS
        var request_LittleWoods = URLRequest(url: URL(string: "https://www.littlewoodsireland.ie/e/q/"  + query + ".end?_requestid=290586")!)
              
              
        var request_SoundStore = URLRequest(url: URL(string: "https://www.soundstore.ie/catalogsearch/result/?q=" + query)!)
                  
        var request_HarveyNorman = URLRequest(url: URL(string: "https://www.harveynorman.ie/index.php?subcats=Y&status=A&pshort=N&pfull=N&pname=Y&pkeywords=Y&search_performed=Y&q=" + query + "&dispatch=products.search")!)
              
        var request_Currys = URLRequest(url: URL(string: "https://www.currys.ie/ieen/search-keywords/xx_xx_xx_xx_xx/" + query + "/xx-criteria.html")!)
               
        var request_Argos = URLRequest(url: URL(string:"https://www.argos.ie/webapp/wcs/stores/servlet/Search?storeId=10152&catalogId=15051&langId=111&searchTerms=" + query + "&authToken=-1002%252CTb6zd56kFOpztp1WPmC9rktuDxQ%253D")!)
            
        
        
        
        
        
        
        requests[request_HarveyNorman] = "form[method='post']" // FIX
        //requests[request_Argos] = "div[class='skMob_productDetails']"
        //requests[request_Currys] = "article[class='product result-prd']"
        //requests[request_SoundStore] = "li[class='item product product-item']"
        //requests[request_LittleWoods] = "div[class='productInfo']"
        
        for var (query, tag) in requests{
            print(query)
            query.httpMethod = "GET"
            let session = URLSession.init(configuration: URLSessionConfiguration.default)
            session.dataTask(with: query) {data,response,error in
                if let data = data {
                    contents = String(data: data, encoding: .ascii)
                    self.findMatches(query: self.product.text!, document: contents!, tag: tag)
                    
                        
                }
            }.resume()
        }
       
       
 
        }
            
    
    
    
     
    
    
    
            
    func findMatches(query:String ,document:String , tag:String){
        do{
            
            let doc: Document = try SwiftSoup.parse(document)
            //print(try doc.html())
            let matches: Elements = try doc.select("" + tag + ":matches((?i)" + query + ")")
            
            let output: String = try matches.html()
            print(output)
            self.findPrice(price: Double(price.text!)!, search: output)
            
           }
           catch Exception.Error(let type, let message) {
               print("Error Message")
           } catch {
               
           }
        
        
    }
    
    func findPrice(price: Double, search: String){
        do{
            let doc: Document = try SwiftSoup.parse(search)
            
            let matches: Elements = try doc.select("span[class='price-num']:matches(d{1,3}(?:[.,]d{3})*(?:[.,]d{2})) ")
            print(try matches.html())
        }
        catch Exception.Error(let type, let message){
            print("Error Message")
        }catch{
            
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
