# PermissionPopup

PermissionPopup gracefully handle the boring task of asking the several device authorizations for you. 

First it shows a nice popup that asks the user if he’s willing to give access to his camera, mic, contacts, etc. If the user refuses, it just closes. If the user agrees, PermissionPopup then shows the Apple authorization popup.

This way, your app avoid to be blocked and the user doesn’t have to go to the settings if he changes his mind later.

## Limitations

For now, implemented authorizations are: mic, camera, contacts, library. More to come. 

## Usage
Create a PermissionPopup of the desired authorization type and implement the appropriate delegate.

## Example
    class ViewController: UIViewController, DidAskContactsDelegate{
        
        func showContactPopup(){
            let permissionPopup=PermissionPopup.ofType(.contacts, from: self)
            permissionPopup.contactsDelegate=self
            present(permissionPopup, animated: true, completion: nil)
        }
        
        func didAskForContacts(_ granted: Bool){
            print("didAskForContacts, granted:", granted)
            if granted{
                //do what you want
            }else{
                print("The user did not give access to his/her contacts")
            }
        }
    }

<img src="../master/popup_example.png" width="300">

## Requirements
Don’t forget to add a usage description in your Info.plist for each type of authorization you need to ask.

## Author
Mariedm

## License

PermissionPopup is available under the MIT license. See the LICENSE file for more info.
