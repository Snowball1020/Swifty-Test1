//
//  SignUpViewController.swift
//  Swifty-3
//
//  Created by Yuki Miyazawa on 2020-07-12.
//  Copyright © 2020 Yuki Miyazawa. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    
    
    
    @IBOutlet weak var firstnameTextField: UITextField!
    
    
    @IBOutlet weak var lastnameTextField: UITextField!
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var signupButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func validateFields() -> String? {
        
        //check ifthe fieled filled in
        if firstnameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastnameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {

            return "Please fill in all fields."
        }
        
        //check if the password is secured enough
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isPasswordValid(cleanedPassword) == false {
            return "please make sure yur password is secured enough"
        }
        
        return nil
    }
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }

    
    @IBAction func signupButtonTapped(_ sender: Any) {
        
        
        //validate fieled
        let error = validateFields()
        
        if error != nil {
            showError(error!)
            print("This")
        }
        else {
            //create the user

            let firstname = self.firstnameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastname = self.lastnameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = self.emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = self.passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //store the user auth
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                //check for errors
                if error != nil {
                    //error
                    self.showError("Error Creating User")
                }
                else{
                    //user was created now store the fname and lname
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstname" : firstname, "lastname":lastname, "uid":result!.user.uid]) { (error) in
                        if error != nil{
                            self.showError("User data couldnt be created")
                        }
                    }
                    
                    //transition to map
                    self.transitionToMap()
                    
                }
            }
            
        }
        
    }
    
    func showError(_ message:String){
        errorLabel.text = message
        errorLabel.alpha = 1

    }
    
    func transitionToMap(){
    
        let mapViewController =
            storyboard?.instantiateViewController(identifier: Contants.Storyboard.mapViewController) as? MapViewController
        
        view.window?.rootViewController = mapViewController
        view.window?.makeKeyAndVisible()
    }
    
}
