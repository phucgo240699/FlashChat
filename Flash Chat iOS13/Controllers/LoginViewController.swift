//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    

    @IBAction func loginPressed(_ sender: UIButton) {
        if let email=emailTextfield.text, let password=passwordTextfield.text{
            
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
              guard error==nil else{ // guard: Là 1 bác bảo vệ. Thoả điều kiện thì cho đi qua, else thì bị giữ lại
                  print(error!)
                  return
              }
                self!.performSegue(withIdentifier: "LoginToChat", sender: self)
                self!.passwordTextfield.text=""
            }
        }
        
    }
    
}
