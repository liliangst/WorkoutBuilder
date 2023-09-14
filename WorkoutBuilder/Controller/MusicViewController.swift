//
//  MusicViewController.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 07/09/2023.
//

import UIKit

class MusicViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapConnectToSpotify() {
        SpotifyHandler.shared.initiate()
    }
}
