//
//  UIViewControllerExt.swift
//  MusePick-master
//
//  Created by Tal Mishaan on 18/02/2018.
//  Copyright © 2018 Tal Mishaan. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
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
}
