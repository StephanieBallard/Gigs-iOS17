//
//  LoginViewController.swift
//  Gigs_iOS17
//
//  Created by Stephanie Ballard on 5/5/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var UserTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var loginSignupButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var gigController: GigController?
    var loginType = LoginType.signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginSignupButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1.0)
        loginSignupButton.tintColor = .white
        loginSignupButton.layer.cornerRadius = 8.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        usernameTextField.becomeFirstResponder()
    }
    
    @IBAction func segmentedControlTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginType = .signUp
            loginSignupButton.setTitle("Sign Up", for: .normal)
        } else {
            loginType = .signIn
            loginSignupButton.setTitle("Sign In", for: .normal)
        }
    }
    
    @IBAction func loginSignUpButtonTapped(_ sender: UIButton) {
        
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
