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
}
