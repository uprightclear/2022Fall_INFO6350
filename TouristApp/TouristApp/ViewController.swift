//
//  ViewController.swift
//  TouristApp
//
//  Created by uprightclear on 9/24/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let touristNames = ["MountRainier", "AmazonSpheres", "GasWorksPark", "PikeMarket", "SpaceNeedle"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return touristNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TouristTableViewCell", owner: self)?.first as! TouristTableViewCell
        
        cell.imgTourist.image = UIImage(named: touristNames[indexPath.row])
        cell.lblTourist.text = touristNames[indexPath.row]
        
        return cell
    }

}

