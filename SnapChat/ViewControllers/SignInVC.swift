//
//  ViewController.swift
//  SnapChat
//
//  Created by Can Kanbur on 6.04.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
class SignInVC: UIViewController {

    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signInClicked(_ sender: Any) {
        if passwordText.text != "" && emailText.text != "" {
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { data, error in
                if error != nil {
                    self.makeAlert(title: "error", message: error?.localizedDescription ?? "error")
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        }else{
            makeAlert(title: "error", message: "fields not empty")
        }
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if usernameText.text != "" && passwordText.text != "" && emailText.text != "" {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { data, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "error")
                }else{
                    let firestore = Firestore.firestore()
                    let userDic = ["email":self.emailText.text!,"username":self.usernameText.text!]
                    firestore.collection("UserInfo").addDocument(data: userDic) { error in
                        self.makeAlert(title: "Error", message: error?.localizedDescription ?? "error")
                    }
                    
                    
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }else{
            makeAlert(title: "Error", message: "fields not empty")
        }
        
        
        
    }
    
    func makeAlert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert,animated: true)
    }
}

