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
        print("sadasd")
        let params = ["email": dniTextField.text ?? "nico@gmail.com",
                      "password": passwordTextField.text ?? "nico123"]
        Alamofire.request("http://api.sandbox.doapps.pe/ecolec/recolector/login", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success:
                let data = JSON(response.data!)
                print(data)
                Data.share.idUser = data["id"].intValue
                DispatchQueue.main.async {
                    let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                    self.present(homeVC!, animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
        
        
    }
    
    
}

extension UITextField {
   
    
    func addPaddingLeft() {
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: self.frame.height))
        self.leftViewMode = .always
    }
    
   
}
