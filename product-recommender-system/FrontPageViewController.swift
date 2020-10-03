//
//  FrontPageViewController.swift
//  product-recommender-system
//
//  Created by Declan Holland on 28/01/2020.
//  Copyright © 2020 Declan Holland. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SwiftSoup
import WebKit

class FrontPageViewController: UIViewController, WKUIDelegate  {
    var webView: WKWebView!
    var resultMatches  = [[String:String]]()
     var JSONObjects = [[String:String]]()
    
//    var JsonObject :[String:String] = [
//        "product": "",
//        "price": "",
//        "image": "",
//        "match": ""
//    
//    
//    
//    ]
    
    
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
    
    
    

    
    
    
    
    let dispatchGroup = DispatchGroup()
    
    
    // WebScraper Component
    @IBAction func scrape(_ sender: Any) {
        resultMatches = []
        let search = product.text!
        
        var requests : [URLRequest ] = []
        
        let query = search.replacingOccurrences(of: " ", with: "_")
     
        var contents: String?
        //CLEAN EVERYTHING BELOW THIS
        
        
       
    
        let request_SoundStore = URLRequest(url: URL(string: "https://www.soundstore.ie/catalogsearch/result/?q=" + query)!)
        
        let request_HarveyNorman = URLRequest(url: URL(string: "https://www.harveynorman.ie/index.php?subcats=Y&status=A&pshort=N&pfull=N&pname=Y&pkeywords=Y&search_performed=Y&q=" + query +
            "&dispatch=products.search")!)
        
        let request_Currys = URLRequest(url: URL(string: "https://www.currys.ie/ieen/search-keywords/xx_xx_xx_xx_xx/" + query
            + "/xx-criteria.html")!)
        
        let request_Argos = URLRequest(url: URL(string:"https://www.argos.ie/webapp/wcs/stores/servlet/Search?storeId=10152&catalogId=15051&langId=111&searchTerms=" + query + "&authToken=-1002%252CTb6zd56kFOpztp1WPmC9rktuDxQ%253D")!)
            
        
        
        requests.append(request_HarveyNorman)
        requests.append(request_Currys)
        requests.append(request_Argos)
        requests.append(request_SoundStore)
        
        
        
        let htmlHarveyNorman = "form[method='post']"
        let htmlArgos = "div[class='productContainer']"
        //let htmlArgos = "div[class='skMob_productDetails']"
        let htmlCurrys = "article[class='product result-prd']"
        let htmlSoundStore = "li[class='item product product-item']"
  
        
        let imgHarveyNorman = "img[src]"
        let imgArgos = "img[data-original]"
        let imgCurrys = "picture[data-iesrc]"
        let imgSoundStore = "img[src]"
        
        
        let productHarveyNorman = "a[class='product-title']"
        let productCurrys = "header[class='productTitle']"
        let productArgos = "div[class='skMob_productTitle skgridview']"
        let productSoundstore = "a[class='product-item-link']"
        
        
        let priceHarveyNorman = "span[class='price-num']"
        let priceArgos = "div[class='skMob_productPrice skMob_product Sale skMob_price_sale']"
        let priceCurrys = "strong[class='price']"
        let priceSoundStore = "span[class='price']"
        
        
        
        let regex = [ [htmlHarveyNorman, priceHarveyNorman ,productHarveyNorman, imgHarveyNorman],  [  htmlCurrys, priceCurrys, productCurrys, imgCurrys], [ htmlArgos, priceArgos, productArgos, imgArgos],[htmlSoundStore, priceSoundStore, productSoundstore, imgSoundStore] ]
       
        
        for var item in requests{
            
            
            item.httpMethod = "GET"
            let session = URLSession.init(configuration: URLSessionConfiguration.default)
            session.dataTask(with: item) {data,response,error in
                if let data = data {
                    
                    self.dispatchGroup.enter()
                    for j in regex{
                        contents = String(data: data, encoding: .ascii)
                        
                        self.findMatches(query: search, document: contents!, tag: j[0], priceRegex: j[1], productRegex: j[2], imgSRC : j[3])
                       
                    }
                    self.dispatchGroup.leave()
                    
                }
            }.resume()
            
            
            
        
        }
        print("Sleep")
        sleep(1)
        
        
        dispatchGroup.notify(queue: .main) {
            print("FINISHED")
            if self.resultMatches.count == 0{
                let alertController = UIAlertController(title: "Error", message: "No Matches found", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
            else{
            self.moveToTableVC()
            }
        }
        
        }
            
    
    
    func moveToTableVC(){
        print("MOVING")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.results = resultMatches
        self.performSegue(withIdentifier: "getResults", sender: self)
        

        
        
        
    }
    
    @IBAction func viewBookmarks(_ sender: Any) {
          var object :[String:String] = [
                     "product": "",
                     "price": "",
                     "link": "",
                     "store": ""
                 
                 
                 
                 ]
        
             
                guard let uid = Auth.auth().currentUser?.uid else { return }
                let db = Firestore.firestore()
                dispatchGroup.enter()
                db.collection("Users").document(uid as! String).collection("Bookmarks").getDocuments(){
                    (querySnapshot, err) in
        
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        self.dispatchGroup.enter()
                        for document in querySnapshot!.documents {
                            
                            
                               object["link"] = document.data()["link"] as! String
                               object["store"] = document.data()["store"] as! String
                               object["product"] = document.data()["product"] as! String
                               object["price"] = document.data()["price"] as! String
                            
                           // print(object)
                            self.JSONObjects.append(object)
                            //print("Data")
                            print(self.JSONObjects)
                           
                        }
                        self.dispatchGroup.enter()
                    }
                }
                dispatchGroup.leave()
        print("sleep")
        sleep(2)
        dispatchGroup.notify(queue: .main) {
                   print("FINISHED")
            self.moveToBookmarkVC(object: self.JSONObjects)
               
      
        }
    }
    
    func moveToBookmarkVC(object: [[String:String]]){
        let destinationVC = storyboard?.instantiateViewController(identifier: "BookmarkTableViewController") as? BookmarkTableViewController
        print("Here")
        print(object.capacity)
        destinationVC?.tableInfo = object
        self.navigationController?.pushViewController(destinationVC!, animated: true)
        
    }
    
            
    func findMatches(query:String ,document:String , tag:String , priceRegex: String, productRegex:String ,imgSRC:String){
        self.dispatchGroup.enter()
        var JsonObject :[String:String] = [
            "product": "",
            "price": "",
            "image": "",
            "html": "",
            "store": ""
        
        
        
        ]
        do{
            
            let doc: Document = try SwiftSoup.parse(document)
            //print(try doc.html())
            let matches: Elements = try doc.select("" + tag + ":matches((?i)" + query + ")")
        
            for match in matches.array()
            {
                let priceSearch = try match.html()
                
                if let price = Double(price.text!){
                    let priceJSON = self.findPrice(price: price, search: priceSearch, tag: priceRegex, object: JsonObject)
                    if priceJSON.0 == true{
                        JsonObject["price"] = String(priceJSON.1)
                        //GET PRODUCT NAME FOR JSON OBJECT
                        let productMatch: Document = try SwiftSoup.parse(priceSearch)
                        let productName = try productMatch.select("" + productRegex + ":matches(.)")
                        
                        JsonObject["product"] = try productName.text()
//                        let productHarveyNorman = "a[class='product-title']"
//                        let productCurrys = "header[class='productTitle']"
//                        let productArgos = "div[class='skMob_productTitle skgridview']"
//                        let productSoundstore = "a[class='product-item-link']"
                        if productRegex == "a[class='product-title']"{
                            JsonObject["store"] = "Harvey Norman"
                        }
                        else if productRegex == "header[class='productTitle']"{
                            JsonObject["store"] = "Currys"
                        }
                        else if productRegex == "div[class='skMob_productTitle skgridview']"{
                            JsonObject["store"] = "Argos"
                        }
                        else if productRegex == "a[class='product-item-link']"{
                            JsonObject["store"] = "Soundstore"
                        }
                
                        //GET IMG SRC FOR JSON OBJECT
                        let imgMatch: Document = try SwiftSoup.parse(priceSearch)
                        let imgResult = try imgMatch.select("" + imgSRC  )
                        if imgSRC == "img[src]"{
//                            print("JSON IMGSRC")
//                            print(try imgResult.attr("src"))
                            JsonObject["image"] = try imgResult.attr("src")
                        }
                        else if imgSRC == "img[data-original]"{
//                            print("JSON IMGSRC")
//                            print(try imgResult.attr("data-original"))
                            JsonObject["image"] = try imgResult.attr("data-original")
                        }
                        else if imgSRC == "picture[data-iesrc]"{
//                            print("JSON IMGSRC")
//                            print(try imgResult.attr("data-iesrc"))
                            JsonObject["image"] = try imgResult.attr("data-iesrc")
                            if JsonObject["image"] == ""{
                                let imgMatch: Document = try SwiftSoup.parse(priceSearch)
                                let imgResult = try imgMatch.select("img[src]" )
                                JsonObject["image"] = try imgResult.attr("src")
                            }
                            
                        }
//                        let imgHarveyNorman = "img[src]"
//                           let imgArgos = "img[data-original]"
//                           let imgCurrys = "picture[data-ierc]"
//                           let imgSoundStore = "img[src]"
                        JsonObject["html"] = priceSearch
                        resultMatches.append(JsonObject)
//                        print("BREAK POINT")
//                        print(priceSearch)
                        //  print(resultMatches.count)
                        
                    }
                }
                
            }
            
            
            let output: String = try matches.html()
            
//            print("JSON HTMLMATCH")
            //self.findPrice(price: Double(price.text!)!, search: output)
            
            
            //add JsonObject to matchResults
           }
           catch Exception.Error(let type, let message) {
               print("Error Message")
           } catch {
               
           }
        
        self.dispatchGroup.leave()
            
    }
    
    func findPrice(price: Double, search: String, tag : String, object: [String:String]) -> (Bool,Double){
        do{
            let doc: Document = try SwiftSoup.parse(search)
            //print(doc)
            
            let matches: Elements = try doc.select("" + tag + ":matches(\\d{1,3}(?:[.,]d{3})*(?:[.,]\\d{2})) ")
            
            
            for match in matches.array(){
                //print(match.ownText())
                let encodedString = match.ownText()
                let decodedString = cleanString(uncleaned: encodedString)
                
                let foundPrice = convertFoundPricetoDouble(price: decodedString)
//                print("NEW PRICE ")
//                print(foundPrice)
                if foundPrice <= price + (price * 0.10) /*&&  foundPrice >= price - (price * 0.10)*/{
//                    print("JSON PRICE")

//                    print(foundPrice)
                    
                      
                    return (true, foundPrice)
                }
                return (false,0)
                
            }
            
            
        }
        catch Exception.Error(let type, let message){
            print("Error Message")
        }catch{
            
        }
        return (false,0)
        
        
    }
       
        
    func cleanString(uncleaned: String) -> String{
        let uncleaned = uncleaned.replacingOccurrences(of: "â¬", with: "")
        let cleaned = uncleaned.replacingOccurrences(of: "€", with: "")
        return cleaned
        
    }
    
    func convertFoundPricetoDouble(price: String) -> Double{
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale.current
        numberFormatter.numberStyle = .decimal
        return(numberFormatter.number(from: price) as! Double)
        
        
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
