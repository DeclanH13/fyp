//
//  WaitViewController.swift
//  product-recommender-system
//
//  Created by Declan Holland on 28/01/2020.
//  Copyright © 2020 Declan Holland. All rights reserved.
//

import UIKit

class WaitViewController: UIViewController {

    var errorCode:Int? = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(scrapeFinish(_:)), name: Notification.Name("FYP.scrapeFinished"), object: nil)
        

        
        
    }
    
    @objc func scrapeFinish(_ notification:Notification){
        performSegue(withIdentifier: "showTableVC", sender: self)
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
