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
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess(_:)), name: Notification.Name("FYP.signedin"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginFailure(_:)), name: Notification.Name("FYP.failedsignin"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(registerSuccess(_:)), name: Notification.Name("FYP.registersuccess"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(registerFailure(_:)), name: Notification.Name("FYP.registerfailure"), object: nil)
        

        
        
    }
    
    @objc func loginSuccess(_ notification:Notification){
        performSegue(withIdentifier: "showFirstPage", sender: self)
    }
    
    @objc func loginFailure(_ notification:Notification){
        errorCode = notification.userInfo!["error"] as? Int
        performSegue(withIdentifier: "movetologin", sender: self)
    }

    @objc func registerSuccess(_ notification:Notification){
        performSegue(withIdentifier: "registerSuccess", sender: self)
        print("FUCK SAKE WHY")
    }
    
    @objc func registerFailure(_ notification:Notification){
        errorCode = notification.userInfo!["error"] as? Int
        performSegue(withIdentifier: "movetoregisterpage", sender: self)
        
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
