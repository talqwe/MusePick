//
//  EventLoginController.swift
//  MusePick-master
//
//  Created by Tal Mishaan on 03/02/2018.
//  Copyright © 2018 Tal Mishaan. All rights reserved.
//

import Foundation
import UIKit

class EventLoginController: UIViewController {
    
    @IBOutlet weak var EventCode: UITextField!
    @IBAction func LetsRock(_ sender: UIButton) {
        let input_code_id = EventCode.text!
        if(input_code_id != ""){
            Model.instance.getEventByCodeId(id: input_code_id.uppercased()) { (event) in
                if(event != nil){
                    Model.instance.addNewEventToLocalDB(e: event!)
                    Model.this_event = Event(e: event!)
                    self.performSegue(withIdentifier: "AfterEventLoginSegue", sender: self)
                }else{
                    self.messageBox(messageTitle: "Error", messageAlert: "Invalid Event Code", messageBoxStyle: .alert, alertActionStyle: UIAlertActionStyle.default) {
                    }
                }
        }
        }else{
            messageBox(messageTitle: "Error", messageAlert: "Please insert Event Code", messageBoxStyle: .alert, alertActionStyle: UIAlertActionStyle.default) {
            }
        }
        
    }
    
    func messageBox(messageTitle: String, messageAlert: String, messageBoxStyle: UIAlertControllerStyle, alertActionStyle: UIAlertActionStyle, completionHandler: @escaping () -> Void)
    {
        let alert = UIAlertController(title: messageTitle, message: messageAlert, preferredStyle: messageBoxStyle)
        
        let okAction = UIAlertAction(title: "Ok", style: alertActionStyle) { _ in
            completionHandler()
        }
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
}

