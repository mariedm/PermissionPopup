//
//  PermissionPopup.swift
//  Stwories
//
//  Created by Marie Denis-Massé on 11/11/2016.
//  Copyright © 2016 Many. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import Contacts

/***    DELEGATES  ***/
protocol DidAskCameraDelegate{
    func didAskForCamera(_ granted:Bool)
}
protocol DidAskMicDelegate{
    func didAskForMic(_ granted:Bool)
}
protocol DidAskLibraryDelegate{
    func didAskForLibrary(_ granted:Bool)
}
protocol DidAskContactsDelegate{
    func didAskForContacts(_ granted:Bool)
}
protocol DidAskNotificationsDelegate{
    func didAskForNotifications(_ granted:Bool)
}

/***    VIEW CONTROLLER  ***/
class PermissionPopup:UIViewController{
    //outlets
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    var popupType=PopupType.camera
    var micDelegate:DidAskMicDelegate?
    var camDelegate:DidAskCameraDelegate?
    var libraryDelegate:DidAskLibraryDelegate?
    var contactsDelegate:DidAskContactsDelegate?
    var notifDelegate:DidAskNotificationsDelegate?
    
    /***    INIT    ***/
    class func ofType(_ type:PopupType, from viewController:UIViewController)->PermissionPopup{
        let popup=UINib(nibName: "PermissionPopup", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PermissionPopup
        popup.popupType=type
        return popup
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initUi()
    }
    
    func initUi(){
        mainLabel.text=popupType.mainLabel
        mainImage.image=popupType.mainImage
        noButton.setTitle(popupType.no, for: .normal)
        yesButton.setTitle(popupType.yes, for: .normal)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    /***    SAID YES     ***/
    @IBAction func saidYes(_ sender: Any){
        //ask autho
        switch popupType{
        case .camera: askForCamera()
        case .mic: askForMic()
        case .contacts: askForContacts()
        case .libraryPickup, .librarySave: askForLibrary()
        case .notifications: askForNotifications()
        }
    }
    
    func askForCamera(){
        AVCaptureDevice.requestAccess(for: AVMediaType.video){granted in
            DispatchQueue.main.async{[weak self] in
                guard let weak=self else{return}
                weak.close{
                    weak.camDelegate?.didAskForCamera(granted)
                }
            }
        }
    }
    
    func askForContacts(){
        CNContactStore().requestAccess(for: .contacts){granted, error in
            DispatchQueue.main.async{[weak self] in
                guard let weak=self else{return}
                weak.close{
                    weak.contactsDelegate?.didAskForContacts(granted)
                }
            }
        }
    }
    
    func askForLibrary(){
        PHPhotoLibrary.requestAuthorization{status in
            DispatchQueue.main.async{[weak self] in
                guard let weak=self else{return}
                weak.close{
                    if status==PHAuthorizationStatus.authorized{
                        weak.libraryDelegate?.didAskForLibrary(true)
                    }else{
                        weak.libraryDelegate?.didAskForLibrary(false)
                    }
                }
            }
        }
    }
    
    func askForMic(){
        AVAudioSession.sharedInstance().requestRecordPermission(){granted in
            DispatchQueue.main.async{[weak self] in
                guard let weak=self else{return}
                weak.close{
                    weak.micDelegate?.didAskForMic(granted)
                }
            }
        }
    }
    
    func askForNotifications(){
        //print("ask_notifs")
        //notif_api.setup_notifications()
        close{}
    }
    
    
    /***    SAID NO   ***/
    @IBAction func saidNo(_ sender: Any){
        switch popupType{
        case .camera:
            close{
                self.camDelegate?.didAskForCamera(false)
            }
            
        case .contacts:
            close{
                self.contactsDelegate?.didAskForContacts(false)
            }
            
        case .libraryPickup, .librarySave:
            close{
                self.libraryDelegate?.didAskForLibrary(false)
            }
            
        case .mic:
            close{
                self.micDelegate?.didAskForMic(false)
            }
            
        case .notifications:
            close{
                self.notifDelegate?.didAskForNotifications(false)
            }
        }
        
    }
    
    /***    CLOSE   ***/
    func close(completion:@escaping ()->()){
        UIView.animate(withDuration: 0.2, animations: {
            self.view.alpha=0
        }, completion: {_ in
            self.dismiss(animated: false, completion: completion)
        })
    }
    
    override var prefersStatusBarHidden:Bool{
        return true
    }
    
}

/***    AUTHORIZATION TYPES    ***/
struct UIConfig{
    var main_label:String
    var image:UIImage
    var no:String
    var yes:String
}

enum PopupType:String{
    case camera="camera", mic="mic", libraryPickup="libraryPickup", librarySave="librarySave", contacts="contacts", notifications="notifications"
    var mainLabel:String{
        switch self{
        case .camera: return "Activate your camera to take a picture."
        case .mic: return "Activate your mic to record your voice."
        case .libraryPickup: return "Give access to your library to pick a nice pic."
        case .librarySave: return "Give access to your library so that we can save images."
        case .contacts: return "Share your contacts to invite them."
        case .notifications: return "Receive notifications to get the best experience."
        }
    }
    var mainImage:UIImage{
        switch self{
        case .camera: return UIImage(named: "popupCamera")!
        case .mic: return UIImage(named: "popupMic")!
        case .libraryPickup, .librarySave: return UIImage(named: "popupLibrary")!
        case .contacts: return UIImage(named: "popupContacts")!
        case .notifications: return UIImage(named: "popupNotifications")!
        }
    }
    var no:String{
        switch self{
        case .camera: return "I'm too shy"
        case .mic: return "Nope"
        case .libraryPickup, .librarySave: return "No thanks"
        case .contacts: return "I stay alone"
        case .notifications: return "Nevermind"
        }
    }
    var yes:String{
        switch self{
        case .camera: return "Let's do this"
        case .mic: return "Alright"
        case .libraryPickup, .librarySave: return "Lets' go"
        case .contacts: return "Lets' go"
        case .notifications: return "Yes, sure!"
        }
    }
}

