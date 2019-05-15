//
//  SignInViewController.swift
//  DataSportsGuru
//
//  Created by Patricio Gutierrez on 5/7/19.
//  Copyright © 2019 Arturo González. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftyButton
import Firebase


class SignInViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var continueButton: FlatButton!
    @IBOutlet weak var usernameTF: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTF: SkyFloatingLabelTextField!
    @IBOutlet weak var pwTF: SkyFloatingLabelTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
         continueButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        // Do any additional setup after loading the view.
        emailTF.delegate = self
        pwTF.delegate = self
        
        
        
        
        
        
    }
    
    func setContinueButton(enabled:Bool){
        if enabled {
            continueButton.alpha = 1.0
            continueButton.isEnabled = true
        } else {
            continueButton.alpha = 0.5
            continueButton.isEnabled = false
        }
        
        
    }
    
    @objc func handleSignUp() {
        guard let email = emailTF.text else {return}
        guard let password = pwTF.text else {return}
        guard let username = usernameTF.text else {return}
        setContinueButton(enabled: false)
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            if error == nil && user != nil {
                print("User created!")
                let changeRequest  = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = username
                changeRequest?.commitChanges{ error in
                    if error == nil {
                      print("User display name changed")
                      self.navigationController?.popViewController(animated: true)
                    }
                }
                

            } else {
                print("Error: \(error!.localizedDescription)")
                self.emailTF.text = ""
                self.pwTF.text = ""
                self.usernameTF.text = ""
                
                let alert = UIAlertController(title: error!.localizedDescription, message: "Please try again.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                self.present(alert, animated: true)
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
