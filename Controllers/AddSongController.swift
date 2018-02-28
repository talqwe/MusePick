//
//  AddSongController.swift
//  MusePick-master
//
//  Created by Tal Mishaan on 22/02/2018.
//  Copyright © 2018 Tal Mishaan. All rights reserved.
//

import Foundation
import UIKit

class AddSongController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var ArtistNameInput: UITextField!
    @IBOutlet weak var SongNameInput: UITextField!
    @IBOutlet weak var SelfieButton: UIButton!
    var image_changed: Int = 0
    @IBAction func GalleryButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func CameraButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            SelfieButton.contentMode = .scaleAspectFit
            SelfieButton.setBackgroundImage(pickedImage, for: UIControlState.normal)
            SelfieButton.setImage(pickedImage, for: UIControlState.normal)
            image_changed = 1
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SendSong(_ sender: Any) {
//        var imageData = UIImageJPEGRepresentation(imagePicker., 0.6)
//        var compressedJPGImage = UIImage(data: imageData)
//        UIImageWriteToSavedPhotosAlbum(compressedJPGImage, nil, nil, nil)
        let song_name = SongNameInput.text!
        let artist = ArtistNameInput.text!

        if(song_name != "" && artist != "" && image_changed == 1){
            let s = Song(event_id: Model.this_event.id_code, song_name: song_name, artist_name: artist, image: "")
            
            let image = SelfieButton.backgroundImage(for: UIControlState.normal)
            
            Model.instance.saveImage(image: image!, name:"image_song_"+song_name+"_"+artist){(url) in
                s.image = url
                Model.instance.addSong(s: s, email: Model.this_user.email)
                
            }
            
            self.navigationController?.popToRootViewController(animated: true)
        }else{
            self.messageBox(messageTitle: "Error", messageAlert: "Please insert all details", messageBoxStyle: .alert, alertActionStyle: UIAlertActionStyle.default) {
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Add Muse!"
        
    }
}
