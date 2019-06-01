//
//  LoginViewController.swift
//  Ecolec
//
//  Created by Nicolas on 6/1/19.
//  Copyright © 2019 Nicolas. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func openHome(_ sender: UITapGestureRecognizer) {
        let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        present(homeVC!, animated: true)
    }
}
