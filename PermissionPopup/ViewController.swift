//
//  ViewController.swift
//  PermissionPopup
//
//  Created by Marie Denis-Massé on 11/10/2017.
//  Copyright © 2017 Many. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DidAskContactsDelegate{
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    @IBAction func popupButtonPushed(_ sender: Any){
        showContactPermissionPopup()
    }
    
    func showContactPermissionPopup(){
        let permissionPopup=PermissionPopup.ofType(.contacts, from: self)
        permissionPopup.contactsDelegate=self
        present(permissionPopup, animated: true, completion: nil)
    }
    
    func didAskForContacts(_ granted: Bool){
        print("didAskForContacts, granted:", granted)
    }
}

