//
//  ProductInfoViewController.swift
//  product-recommender-system
//
//  Created by Declan Holland on 21/03/2020.
//  Copyright © 2020 Declan Holland. All rights reserved.
//

import UIKit
import WebKit
import SwiftSoup
import Firebase
import FirebaseDatabase

class ProductInfoViewController: UIViewController {
    var productJsonObject : [String:String]!
    
    let regexHarveyNorman = "img[src]"
    let regexArgos = "img[data-original]"
    let regexCurrys = "ul[class='productDescription\']"//ul class=\"productDescription
    let regexSoundStore = "div[class='product description product-item-description\']" //div class=\"product description product-item-description\"
    
    let linkArgos = "div[class='skMob_productTitle sklistview\']" // attr('link')
    let linkHarveyNorman = "a[class='product-title\']" // attr('href')
    let linkSoundstore = "a[class='product photo product-item-photo\']"
    let linkCurrys = "a[class='imgC']"
    //<div class=\"product description product-item-description\"
    //<ul class=\"productDescription\”>
    //
    //<div class="ViewDetails" link="http://www.argos.ie/static/Product/partNumber/1954375/Trail/searchtext%3Emacbook.htm">
    //<div class="product-info"> <a href="//www.harveynorman.ie/computing/apple/macbook/macbook-pro-13.3-with-touch-bar-core-i5-512gb-space-grey-2019.html"
    //
    
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productInfo: UITextView!
    @IBOutlet weak var storeLabel: UILabel!
    @IBOutlet weak var findShop: UIButton!
    @IBOutlet weak var bookmark: UIButton!
    @IBOutlet weak var shopWebsite: UIButton!
    
    var storeWebsiteLink: String!
    
    
    let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(productJsonObject["html"])
        getHTML(html: productJsonObject["html"]!)
        storeLabel.text = productJsonObject["store"]
        productNameLabel.text = productJsonObject["product"]
        productPriceLabel.text = productJsonObject["price"]
        let imageString = self.cleanImageString(image: productJsonObject["image"]!)
        let imageURL = URL(string:imageString)!
        imageView.downloadImage(url: imageURL)
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //Bookmark Component 'Create Bookmark'
    @IBAction func bookmarkProduct(_ sender: Any) {
        //var ref: DatabaseReference!
        guard let uid = Auth.auth().currentUser?.uid else { return }
         print(uid)
        
        let productObject = ["product": productJsonObject["product"]!, "price" : productJsonObject["price"]!, "link": storeWebsiteLink!, "store": productJsonObject["store"]!]
        //Database.database().reference().child("Users").child(uid).child("Bookmarks").child(productObject["product"]!).setValue(productObject)
        let db = Firestore.firestore()
        db.collection("Users").document(uid as! String).collection("Bookmarks").addDocument(data: productObject)
        let alertController = UIAlertController(title: "Product Bookmarked!", message: "This product has been bookmarked for you to revisit later", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func shopWebsitePressed(_ sender: Any) {
        let destinationVC = storyboard?.instantiateViewController(identifier: "WebsiteViewController") as? WebsiteViewController
        destinationVC?.html = self.storeWebsiteLink
        self.navigationController?.pushViewController(destinationVC!, animated: true)
        
    }
    
  
    
    @IBAction func findShop(_ sender: Any) {
        let destinationVC = storyboard?.instantiateViewController(identifier: "StoreLocatorViewController") as? StoreLocatorViewController
        destinationVC?.storeName  = self.productJsonObject["store"]
        self.navigationController?.pushViewController(destinationVC!, animated: true)
    }
    
    
    func query(request: URLRequest, store: String){
        var contents: String?
        
        var item: URLRequest = request
        item.httpMethod = "GET"
        let session = URLSession.init(configuration: URLSessionConfiguration.default)
        session.dataTask(with: item) {data,response,error in
            if let data = data {
                contents = String(data: data, encoding: .ascii)
                self.scrapeLink(html: contents!, store: store)
            }
        }.resume()
        
        
    }
    
    func scrapeLink(html: String, store: String) {
        
        do{
            if store == "Soundstore"{
                let doc:Document = try SwiftSoup.parse(html)
                let match: Elements = try doc.select(linkSoundstore)
                print("here")
                print(try match.attr("href"))
                storeWebsiteLink = try match.attr("href")
                
            }
            else if store == "Currys"{
                let doc:Document = try SwiftSoup.parse(html)
                let match: Elements = try doc.select(linkCurrys)
                print("here")
                print(try match.attr("href"))
                storeWebsiteLink = try match.attr("href")
                
            }
            else if store == "Harvey Norman"{
                let doc:Document = try SwiftSoup.parse(html)
                let match: Elements = try doc.select(linkHarveyNorman)
                print("here")
                print(try match.attr("href"))
                storeWebsiteLink = cleanImageString(image: try match.attr("href"))
                
            }
            else if store == "Argos"{
                let doc:Document = try SwiftSoup.parse(html)
                let match: Elements = try doc.select("div[class='skMob_productTitle sklistview\']")
                print("here")
                print(try match.attr("link"))
                storeWebsiteLink = try match.attr("link")
               
            }
           
        }
        catch Exception.Error(let type, let message) {
            print("Error Message")
        } catch {
            
        }
        
    }
    
    func getHTML(html: String) -> String{
        do{
            if productJsonObject["store"] == "Currys"{
                let doc: Document = try SwiftSoup.parse(html)
                let match: Elements = try doc.select(regexCurrys)
                scrapeLink(html: html, store: productJsonObject["store"]!)
                productInfo.text = try match.text()
            }
            else if productJsonObject["store"] == "Soundstore"{
                let doc: Document = try SwiftSoup.parse(html)
                let match: Elements = try doc.select(regexSoundStore)
                scrapeLink(html: html, store: productJsonObject["store"]!)
                productInfo.text = try match.text()
            }
            else if productJsonObject["store"] == "Harvey Norman"{
                scrapeLink(html: html, store: productJsonObject["store"]!)
                productInfo.text = "More product information can be located online"
            }
            else if productJsonObject["store"] == "Argos"{
                scrapeLink(html: html, store: productJsonObject["store"]!)
                productInfo.text = "More product information can be located online"
                 
            }
            return ""
        }
        catch Exception.Error(let type, let message) {
            print("Error Message")
        } catch {
            
        }
        return ""
    }
    
    func cleanImageString(image: String) -> String{
        var imageString = String(image)
        while imageString.hasPrefix("/"){
            imageString = String(imageString.dropFirst())
            
        }
        if imageString.contains("https://") || imageString.contains("http://"){
            return imageString
            
        }
        else{
            imageString = "https://" + imageString
            
        }
        return imageString
    }
}
//extension UIImageView {
//
//   func downloadImage(url: URL) {
//    DispatchQueue.global().async { [weak self] in
//        if let data = try? Data(contentsOf: url){
//            if let image = UIImage(data: data){
//                DispatchQueue.main.async
//                    {
//                    self?.image = image
//                    }
//            }
//        }
//    }
//      }
//}
