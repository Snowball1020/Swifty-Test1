//
//  LoginController.swift
//  Swifty-3
//
//  Created by Yuki Miyazawa on 2020-07-12.
//  Copyright © 2020 Yuki Miyazawa. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginController: UIViewController {

    
    
    @IBOutlet weak var emailTextFirld: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func loginButtonTapped(_ sender: Any) {
        
        //validate fields,
        
        //create cleaned ver of the test field
        let email = emailTextFirld.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //log in
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }else{
                let mapViewController =
                    self.storyboard?.instantiateViewController(identifier: Contants.Storyboard.mapViewController) as? MapViewController
                
                self.view.window?.rootViewController = mapViewController
                self.view.window?.makeKeyAndVisible()

            }
        }
    }
    
}
