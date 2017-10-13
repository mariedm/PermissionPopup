# PermissionPopup
PermissionPopup gracefully handle the boring task of asking the several device authorizations for you. 

First it shows a nice and customizable popup that asks the user if he’s willing to give access to his camera, mic, contacts, etc. If the user refuses, it just closes. If the user agrees, PermissionPopup then shows the Apple authorization popup.

This way, your app avoid to be blocked and the user doesn’t have to go to the settings if he changed his mind later.

For now, implemented authorizations are: mic, camera, contacts, library. More to come. 
