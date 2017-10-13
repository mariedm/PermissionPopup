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

    override func viewDidAppear(_ animated: Bool){
        let permissionPopup=PermissionPopup.forType(.contacts, from: self)
        permissionPopup.contactsDelegate=self
        present(permissionPopup, animated: true, completion: nil)
    }
    
    func didAskForContacts(_ granted: Bool){
        print("didAskForContacts, granted:", granted)
    }
}

