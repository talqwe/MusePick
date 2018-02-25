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
    var user_email: String = ""
    
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
            self.messageBox(messageTitle: "Error", messageAlert: "Please insert Event Code", messageBoxStyle: .alert, alertActionStyle: UIAlertActionStyle.default) {
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? EventSongListController {
            destinationViewController.event_id = EventCode.text!
            destinationViewController.user_email = self.user_email
        }
    }
    
    @objc func songsListDidUpdate(notification:NSNotification){
        let songs = notification.userInfo?["songs"] as! [Song]
        for s in songs {
            print("name: \(s.artist_name) \(s.song_name)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
}

