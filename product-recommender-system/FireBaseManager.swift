//
//  FireBaseManager.swift
//  product-recommender-system
//
//  Created by Declan Holland on 04/02/2020.
//  Copyright © 2020 Declan Holland. All rights reserved.
//

import UIKit
import FirebaseAuth
class FireBaseManager: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func signin(with username:String, password:String){
        
        Auth.auth().signIn(withEmail: username, password:password){
            [weak self] authResult, error in
               
            if(authResult != nil){
                
            NotificationCenter.default.post(name:Notification.Name("FYP.signedin"), object:nil, userInfo:nil)
            }
                
            else{
                
                let errCode = ["error":error!._code]
                   
            NotificationCenter.default.post(name:Notification.Name("FYP.failedsignin"), object:nil, userInfo:errCode)
            }
            
            
        }
    }
    
        func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        
            Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if let user = authResult?.user {
                print(user)
                completionBlock(true)
            } else {
                completionBlock(false)
            }
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
