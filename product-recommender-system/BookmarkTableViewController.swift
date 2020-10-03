//
//  BookmarkTableViewController.swift
//  product-recommender-system
//
//  Created by Declan Holland on 25/03/2020.
//  Copyright © 2020 Declan Holland. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase


class bookmarkTableViewCell: UITableViewCell{
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeWebsite: UILabel!
    
    
    
    
}


class BookmarkTableViewController: UITableViewController {
    var databaseInfo: NSDictionary!
    var tableInfo = [[String:String]]()
    
    
    let dispatchGroup = DispatchGroup()
    override func viewDidLoad() {super.viewDidLoad()
        var listItems = [Any]()
       var JSONObjects = [[String:String]]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        db.collection("Users").document(uid as! String).collection("Bookmarks").getDocuments(){
            (querySnapshot, err) in

            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    let object = [
                        "link": document.data()["link"] as! String,
                        "store": document.data()["store"] as! String,
                        "product": document.data()["product"] as! String,
                        "price": document.data()["price"] as! String
                    ]
                    self.tableInfo.append(object)
                }
            }
             self.tableView.reloadData()
        }
       
        
     
        
       
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    

    // MARK: - Table view data source

    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let destinationVC = storyboard?.instantiateViewController(identifier: "WebsiteViewController") as? WebsiteViewController
            destinationVC?.html = tableInfo[indexPath.row]["link"]
           self.navigationController?.pushViewController(destinationVC!, animated: true)
           
       }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableInfo.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! bookmarkTableViewCell
        cell.productName.text = tableInfo[indexPath.row]["product"]
        cell.productPrice.text = tableInfo[indexPath.row]["price"]
        cell.storeName.text = tableInfo[indexPath.row]["store"]

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

