//
//  LoginController.swift
//  MusePick-master
//
//  Created by Tal Mishaan on 03/02/2018.
//  Copyright © 2018 Tal Mishaan. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookCore

class LoginController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func FacebookLogin(sender: UIButton) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                    Auth.auth().signIn(with: credential)
                    self.getFBUserData()
                }
            }
        }
    }
    
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error != nil){
                    print("Error occured")
                }
                else{
                    let data:[String:AnyObject] = result as! [String : AnyObject]
                    let email = data["email"]!
                    let first_name = data["first_name"]!
                    let last_name = data["last_name"]!

                    Model.instance.getUserById(id: email as! String) { (user) in
                        if(user != nil){
                            // save to sqlite
                            Model.instance.addNewUserToLocalDB(u: user!)
                            Model.this_user = User(u: user!)
                        }
                        else{
                            let encodedUserEmail=email.replacingOccurrences(of: ".", with: ",")


                            let user = User(email: encodedUserEmail, fn: first_name as! String, ln: last_name as! String, iu: "", lt: "FB") //register without image profile
                            Model.instance.addUser(u: User(u: user))
                            Model.this_user = User(u: user)


                            //get profile image
                            let FBid = data["id"] as? String
                            let url = NSURL(string: "https://graph.facebook.com/\(FBid!)/picture?type=large&return_ssl_resources=1")
                            let image = UIImage(data: NSData(contentsOf: url! as URL)! as Data)
                            Model.instance.saveImage(image: image!, name:"image:user:"+Model.this_user.email){(url) in
                                Model.this_user.image_url = url //save url to current Student
                                Model.instance.addUser(u: Model.this_user) //+imageUrl

                            }

                        }
//                        self.goToNextPage(page: "MoveToAfterFBSignIn")
                    }
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}


