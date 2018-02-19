//
//  ViewController.swift
//  MusePick-master
//
//  Created by Tal Mishaan on 03/02/2018.
//  Copyright © 2018 Tal Mishaan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let lc = sb.instantiateViewController(withIdentifier: "LoginController")
     self.performSegue(withIdentifier: "ShowLoginSegue", sender: self)
    
       self.present(lc, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

