//
//  ResultTableViewController.swift
//  product-recommender-system
//
//  Created by Declan Holland on 28/02/2020.
//  Copyright © 2020 Declan Holland. All rights reserved.
//

import UIKit
import WebKit
class resultTableViewCell: UITableViewCell{
   // var webView = WKWebView()

    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!

    var jsonObject : [String:String]!
    
    
    
}


class ResultTableViewController:UITableViewController, WKUIDelegate , WKNavigationDelegate{
    
    var matchResults = [[String:String]]()
    var contentHeights : [CGFloat] = [0.0, 0.0]
    var imageList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        matchResults = appDelegate.results
        print("RESULTS COUNT")
        print(matchResults.count)

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
   
    // MARK: - Table view data source

   
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return matchResults.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: "ProductInfoViewController") as? ProductInfoViewController
        print(matchResults[indexPath.row])
        destinationVC?.productJsonObject = matchResults[indexPath.row]
        self.navigationController?.pushViewController(destinationVC!, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! resultTableViewCell
        cell.productPriceLabel.text = matchResults[indexPath.row]["price"]
        cell.productTitleLabel.text = matchResults[indexPath.row]["product"]
        var imageString = String(matchResults[indexPath.row]["image"]!)
        while imageString.hasPrefix("/"){
            imageString = String(imageString.dropFirst())
            
        }
        if imageString.contains("https://") || imageString.contains("http://"){
            let imageURL = URL(string: imageString)!
            print(imageString)
            cell.productImage.downloadImage(url: imageURL)
        }
        else{
            imageString = "https://" + imageString
            let imageURL = URL(string: imageString)!
            cell.productImage.downloadImage(url: imageURL)
        }
//        print(imageString)
        cell.jsonObject = matchResults[indexPath.row]
        cell.jsonObject["image"] = imageString
//        print("JSON OBJECT")
       // print(cell.jsonObject["html"])
        return cell
    }
    
   


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIImageView {
 
   func downloadImage(url: URL) {
    DispatchQueue.global().async { [weak self] in
        if let data = try? Data(contentsOf: url){
            if let image = UIImage(data: data){
                DispatchQueue.main.async
                    {
                    self?.image = image
                    }
            }
        }
    }
      }
}

