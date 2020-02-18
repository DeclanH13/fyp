//
//  RegisterViewController.swift
//  product-recommender-system
//
//  Created by Declan Holland on 28/01/2020.
//  Copyright © 2020 Declan Holland. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RegisterViewController: UIViewController {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var verifyPassword: UITextField!
   
    @IBOutlet weak var errorLabel: UILabel!
    
    var ref: DatabaseReference!
    
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func registerPressed(_ sender: Any) {
        if firstName.text == "" || lastName.text == ""{
            let alertController = UIAlertController(title: "Details not complete", message: "Please complete all text fields", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        if password.text != verifyPassword.text{
            let alertController = UIAlertController(title: "Passwords Do Not Match", message: "Please re-type password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            //Passwords Match
            Auth.auth().createUser(withEmail: emailAddress.text!, password: password.text!)
            {(user, error) in
                if error == nil {
                    
                    guard let uid = user?.user.uid else {return}
                    
                    let userInfo = ["userId": uid, "email": self.emailAddress.text!, "firstName": self.firstName.text!, "lastName": self.lastName.text!]
                    
                    Database.database().reference().child("users").updateChildValues(userInfo) { (error, ref) in
                       
                    }
                    self.performSegue(withIdentifier: "doRegister", sender: self)
                }
                else{
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
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
