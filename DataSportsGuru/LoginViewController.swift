//
//  LoginViewController.swift
//  DataSportsGuru
//
//  Created by Patricio Gutierrez on 5/8/19.
//  Copyright © 2019 Arturo González. All rights reserved.
//

import UIKit
import Firebase
import SwiftyButton
import SkyFloatingLabelTextField

class LoginViewController: UIViewController {
    
    @IBOutlet weak var pwTF: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTF: SkyFloatingLabelTextField!
    @IBOutlet weak var continueButton: FlatButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        pwTF.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        continueButton.addTarget(self, action: #selector(handleSignIn), for: .touchUpInside)
         setContinueButton(enabled: false)
        // Do any additional setup after loading the view.
    }
    
    @objc func textFieldChanged(_ target:UITextField) {
        let email = emailTF.text
        let password = pwTF.text
        let formFilled = email != nil && email != "" && password != nil && password != ""
        setContinueButton(enabled: formFilled)
    }

    
    func setContinueButton(enabled:Bool) {
        if enabled {
            continueButton.alpha = 1.0
            continueButton.isEnabled = true
        } else {
            continueButton.alpha = 0.5
            continueButton.isEnabled = false
        }
    }
    
    @objc func handleSignIn() {
        guard let email = emailTF.text else { return }
        guard let pass = pwTF.text else { return }
        
        setContinueButton(enabled: false)
        continueButton.setTitle("", for: .normal)
        
        Auth.auth().signIn(withEmail: email, password: pass) { user, error in
            if error == nil && user != nil {
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Error logging in: \(error!.localizedDescription)")
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
