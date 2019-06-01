//
//  LoginViewController.swift
//  Ecolec
//
//  Created by Nicolas on 6/1/19.
//  Copyright © 2019 Nicolas. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {

    @IBOutlet weak var loginImageView: UIImageView!
    @IBOutlet weak var dniTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dniTextField.borderStyle = .none
        dniTextField.addPaddingLeft()
        passwordTextField.addPaddingLeft()
        passwordTextField.borderStyle = .none
    }
    
    @IBAction func openHome(_ sender: UITapGestureRecognizer) {
        if !dniTextField.text!.isEmpty, !passwordTextField.text!.isEmpty {
            let params = ["email": dniTextField.text!,
                         "password": passwordTextField.text!]
                Alamofire.request("http://api.sandbox.doapps.pe/ecolec/recolector/login", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
                switch response.result {
                case .success:
                let data = JSON(response.data!)
                print(data)
                Data.share.idUser = data["id"].intValue
                UserDefaults.standard.set(data["id"].intValue, forKey: "idUser")
                DispatchQueue.main.async {
                let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                self.present(homeVC!, animated: true)
                }
                case .failure(let error):
                print(error)
                }
            }
        }else {
            showAlert(title: "Error", message: "Campos vacíos")
        }
        
    }
    
    
}

extension UITextField {
   
    
    func addPaddingLeft() {
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
        self.leftViewMode = .always
    }
    
   
}

extension UIViewController {
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let accept = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        alert.addAction(accept)
        present(alert, animated: true)
    }
}
