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
        let params = ["email": "nico@gmail.com",
                      "password": "nico123"]
        Alamofire.request("http://api.sandbox.doapps.pe/ecolec/recolector/login", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success:
                let data = JSON(response.data!)
                Data.share.idUser = data["id"].intValue
            case .failure(let error):
                print(error)
            }
        }
        
        let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        present(homeVC!, animated: true)
    }
    
    
}

extension UITextField {
   
    
    func addPaddingLeft() {
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
        self.leftViewMode = .always
    }
    
   
}
