//
//  EventSongListController.swift
//  MusePick-master
//
//  Created by Tal Mishaan on 03/02/2018.
//  Copyright © 2018 Tal Mishaan. All rights reserved.
//

import Foundation
import UIKit
class EventSongListController: UIViewController,UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    var event_id: String = ""
    var data = ["A","B","C","D","E","F","G"]

    
    @IBAction func AddSong(_ sender: Any) {
            let sb = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = sb.instantiateViewController(withIdentifier: "AddSongController")
            show(nextViewController, sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SongTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "song_cell") as! SongTableViewCell
        cell.ArtistSongName?.text = data[indexPath.row]

        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? AddSongController {
            destinationViewController.event_id = event_id
        }
    }
    
    override func viewDidLoad() {
//        self.tableView.tableHeaderView = "Tal";
        self.tableView.frame = CGRect(x:0,y:10, width:self.view.frame.width,height:self.view.frame.height - 40);
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 50
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.view.addSubview(self.tableView)
        
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}



