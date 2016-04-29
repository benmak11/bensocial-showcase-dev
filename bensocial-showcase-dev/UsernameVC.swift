//
//  UsernameVC.swift
//  bensocial-showcase-dev
//
//  Created by Baynham Makusha on 4/28/16.
//  Copyright © 2016 Ben Makusha. All rights reserved.
//

import UIKit
import Firebase

class UsernameVC: UIViewController {

    var post: Post!
    
    @IBOutlet weak var userTextField: MaterialTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func submitUsername(sender: AnyObject) {
        
        if let user = userTextField.text where user != "" {
            
            let username = DataService.ds.REF_USER_CURRENT.childByAppendingPath("username")
            
            username.observeSingleEventOfType(.Value, withBlock: { snap in
            
                if let usernameDoesNotExist = snap.value as? NSNull {
                    
                    let currentUser = DataService.ds.REF_USER_CURRENT.childByAppendingPath("username")
                    
                    self.userTextField.text = user
                    
                    currentUser.setValue(user)
                }
            
            })
            
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            
            showAlert("Username Needed", msg: "Please choose a username")
        }
    }
    
    func showAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }

}
