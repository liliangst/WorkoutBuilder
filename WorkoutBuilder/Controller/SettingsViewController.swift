//
//  SettingsViewController.swift
//  WorkoutBuilder
//
//  Created by Lilian Grasset on 30/11/2023.
//

import UIKit
import SwiftUI

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let settingsView = SettingsView()
        let hostingSettingsView = UIHostingController(rootView: settingsView)
        
        addChild(hostingSettingsView)
        view.addSubview(hostingSettingsView.view)
        hostingSettingsView.didMove(toParent: self)
        
        hostingSettingsView.view.backgroundColor = nil
        
        hostingSettingsView.view.translatesAutoresizingMaskIntoConstraints = false
        hostingSettingsView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        hostingSettingsView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        hostingSettingsView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        hostingSettingsView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
